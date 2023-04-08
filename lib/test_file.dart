// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class TestFile extends StatelessWidget {
//   const TestFile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: ElevatedButton(
//               onPressed: () async {
//                 File? image;
// //pick image first

//                 String imageName =
//                     '${DateTime.now()}'; //creating a unique name for image
//                 Reference ref = FirebaseStorage.instance
//                     .ref('image')
//                     .child(imageName); //creating ref

//                 UploadTask task =
//                     ref.putFile(image!); //uploading image to firebase

//                 task.whenComplete(() async {
//                   String imageUrl =
//                       await ref.getDownloadURL(); //getting image url

//                   FirebaseFirestore.instance.collection('vehicles').add({
//                     'name': 'BMW',
//                     'image': imageUrl,
//                   }); //updating data to firestore
//                 });
//               },
//               child: Text(''))),
//     );
//   }
// }
