import 'package:cateract_detector/constants.dart';
import 'package:cateract_detector/models/scan_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../pages/admin/admin_home.dart';
import '../pages/doctor/doctor_home_page.dart';
import '../pages/loading_splash.dart';
import '../pages/user/user_home.dart';

class FirebaseServices {
  // static emailAuthentication(
  //     {required String email,
  //      UserType? user,
  //     required String password,
  //     String? specialisation,
  //     required BuildContext context}) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(email: email, password: password);
  //   } on FirebaseAuthException catch (err) {
  //     print(err.message);
  //     print('err code :  ${err.code}');

  //     if (err.message ==
  //         'There is no user record corresponding to this identifier. The user may have been deleted.') {
  //       // showDialog(
  //       //     context: context,
  //       //     builder: (_) => AlertDialog(
  //       //           title: const Text('New User?'),
  //       //           content: const Text(
  //       //               'There is no user with given credentials, create new one?'),
  //       //           actions: [
  //       //             TextButton(
  //       //                 onPressed: () async {
  //       //                   UserCredential userCredential = await FirebaseAuth
  //       //                       .instance
  //       //                       .createUserWithEmailAndPassword(
  //       //                           email: email, password: password);
  //       //                   storeUserInDataBase(
  //       //                       user: UserType.admin,
  //       //                       uid: userCredential.user!.uid,
  //       //                       email: email,
  //       //                       name: userCredential.user!.displayName ?? 'user',
  //       //                       specialisation: specialisation);
  //       //                   Navigator.pop(context);
  //       //                 },
  //       //                 child: const Text('Yes')),
  //       //             TextButton(
  //       //                 onPressed: () {
  //       //                   Navigator.pop(context);
  //       //                 },
  //       //                 child: const Text('Dismiss'))
  //       //           ],
  //       //         ));
  //     } else {
  //       Fluttertoast.showToast(msg: '${err.message}');
  //     }
  //     return err.code;
  //   }
  // }

  static Future<void> storeUserInDataBase({
    required UserType user,
    required Map<String, dynamic> data,
    required String uid,
  }) async {
    if (user == UserType.patient) {
      await FirebaseFirestore.instance.collection('Patient').doc(uid).set(data);
    } else if (user == UserType.doctor) {
      await FirebaseFirestore.instance.collection('Doctors').doc(uid).set(data);
    }
  }

  // static googleAuth(
  //     {required UserType userType, String? specialisation}) async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //   if (userType == UserType.patient) {
  //     storeUserInDataBase(
  //       user: userType,
  //       uid: userCredential.user!.uid,
  //       email: userCredential.user!.email ?? 'email',
  //       name: userCredential.user!.displayName ?? 'user',
  //     );
  //   } else if (userType == UserType.doctor && specialisation == null) {
  //     throw Exception('tried to login as doctor without specialisation');
  //   } else {
  //     storeUserInDataBase(
  //         user: userType,
  //         uid: userCredential.user!.uid,
  //         email: userCredential.user!.email ?? 'email',
  //         name: userCredential.user!.displayName ?? 'user',
  //         specialisation: specialisation);
  //   }
  //   return userCredential;
  // }

  // static storeEmail(User user) async {
  //   FirebaseFirestore.instance.collection('UserData').doc(user.uid).set({
  //     'email': user.email,
  //     'name': user.displayName == "" ? 'user' : user.displayName,
  //   });
  // }

  static signOut() async {
    FirebaseAuth.instance.signOut();
    // GoogleSignIn().signOut();
  }

  // getFirebaseDocs(CollectionReference ref)async{
  //   ref.get();
  // }

  static Stream<double> uploadScanResult(
      ScanReport testResult, BuildContext context) async* {
    String imageName = '${DateTime.now()}';
    Reference ref = FirebaseStorage.instance.ref('image').child(imageName);
    UploadTask task = ref.putFile(testResult.image);

    final stream = task.snapshotEvents;

    String uuid = '';

    await for (TaskSnapshot snapshot in stream) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      if (progress == 1.0) {
        if (uuid != imageName) {
          uuid = imageName;
          await storeScanReport(ref, imageName, testResult);
        }
      }
      yield progress;
    }
  }

  static Future<void> storeScanReport(
      Reference ref, String imageName, ScanReport testResult) async {
    String downloadUrl = await ref.getDownloadURL();
    String imageUrl = '$downloadUrl/$imageName';
    print('>>>>>>>>$imageUrl');
    DocumentReference<Map<String, dynamic>> docRef =
        await FirebaseFirestore.instance.collection('ScanReport').add({
      'image': imageUrl,
      'detection': testResult.detection,
      'accuracy': testResult.accuracy,
      'remarks': testResult.remarks,
      'timestamp': imageName,
      'docId': '',
      'userId': Constants.firebaseUser.uid,
      'username': Constants.username,
    });
    print('uploaded report with id ${docRef.id}');
    Constants.lastScanResultId = docRef.id;
  }

  static sendScanReportToDoc(
      {required String scanReportId, required String docId}) {
    FirebaseFirestore.instance
        .collection('ScanReport')
        .doc(scanReportId)
        .update({'docId': docId});
    Fluttertoast.showToast(msg: 'request sent');
  }

  static Future<UserType> getUserType(String uid) async {
    print('getting user type for id: $uid');
    // QueryDocumentSnapshot<Map<String, dynamic>> element;
    QuerySnapshot<Map<String, dynamic>> docsSnap =
        await FirebaseFirestore.instance.collection('Doctors').get();
    QuerySnapshot<Map<String, dynamic>> userSnap =
        await FirebaseFirestore.instance.collection('Patient').get();
    UserType? user;
    try {
      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in docsSnap.docs) {
        if (element.id == uid) {
          Constants.username = element.data()['name'];
          user = UserType.doctor;
        }
      }
      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in userSnap.docs) {
        if (element.id == uid) {
          Constants.username = element.data()['name'];
          user = UserType.patient;
        }
      }
    } on Exception catch (err) {
      print('exceptio caught: $err');
      user = UserType.admin;
    }

    // print('detected username: ${Constants.username}');

    if (user != null) {
      return user;
    } else {
      return UserType.admin;
    }
  }

  static Future<void> loginByePass(BuildContext context) async {
    late Widget targetPage;
    UserType userType =
        await FirebaseServices.getUserType(Constants.firebaseUser.uid);
    if (userType == UserType.doctor) {
      targetPage = const DoctorHomePage();
    } else if (userType == UserType.patient) {
      targetPage = const UserHomePage();
    } else if (userType == UserType.admin) {
      targetPage = const AdminHome();
    } else {
      targetPage = const LoadingSplash();
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => targetPage));
  }
}
