import 'package:cateract_detector/pages/user/doctors_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class UsersDetectionList extends StatelessWidget {
  UsersDetectionList({super.key, required this.itemNotEmptyFunctionCallback});
  Function(String) itemNotEmptyFunctionCallback;
  // Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async* {
  //   Stream<QuerySnapshot<Map<String, dynamic>>> snaps = FirebaseFirestore
  //       .instance
  //       .collection('ScanReport')
  //       .where('userId', isEqualTo: Constants.firebaseUser.uid)
  //       .snapshots();
  //   //   snaps.listen((event) async*{
  //   // yield event.docs
  //   //     .where((element) =>
  //   //         element.data()['userId'] == Constants.firebaseUser.uid)
  //   //     .toList();
  //   //   });
  //   // await snaps.forEach((element) async* {
  //   //   yield element.docs
  //   //       .where((element) =>
  //   //           element.data()['userId'] == Constants.firebaseUser.uid)
  //   //       .toList();
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ScanReport')
            .where('userId', isEqualTo: Constants.firebaseUser.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (_, index) {
                  if (snap.data!.docs.isNotEmpty) {
                    itemNotEmptyFunctionCallback(snap.data!.docs[0].id);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DoctorsListPage(
                                    lastDetectionId:
                                        snap.data!.docs[index].id)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              snap.data!.docs[index].data()['remarks'] != '...'
                                  ? Colors.amber.withOpacity(.4)
                                  : Colors.white.withOpacity(.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(20),
                        // height: 200,
                        width: double.infinity,
                        // margin: EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Image.network(
                                    snap.data!.docs[index].data()['image'],
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Text(snap.data!.docs[index]
                                  .data()['detection']
                                  .toString()
                                  .replaceAll('_', ' ')),
                              Text(
                                  'accuracy: ${((snap.data!.docs[index].data()['accuracy']) * 100).round()}%'),
                              if (snap.data!.docs[index].data()['remarks'] !=
                                  '...')
                                Text(snap.data!.docs[index].data()['remarks']),
                            ]),
                      ),
                    ),
                  );
                });
          }
        });
  }
}
