
import 'package:cateract_detector/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorsListPage extends StatelessWidget {
  DoctorsListPage({super.key, required this.lastDetectionId});

  String lastDetectionId;

  Future<List<Map>> getData() async {
    QuerySnapshot<Map<String, dynamic>> snaps =
        await FirebaseFirestore.instance.collection('Doctors').get();
    return snaps.docs.map(
      (e) {
        print(e.id);
        return {
          'name': e.data()['name'],
          'specialisation': e.data()['specialisation'],
          'doc_id': e.id,
        };
      },
    ).toList();
  }

  // sendReportToDoctor(String docId) async {
  //   FirebaseFirestore.instance.collection('ScanReport').add({
  //     'doc': docId,
  //     'report': 'asdf',
  //     'accuracy': '1',
  //     'patientId': Constants.firebaseUser!.uid
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Doctors'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap.hasData) {
              if (snap.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('empty.json'),
                      const Text('No data'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          print(
                              'sending scan report with docId: ${snap.data![index]['doc_id']} and reportId: $lastDetectionId');
                          FirebaseServices.sendScanReportToDoc(
                              docId: snap.data![index]['doc_id'],
                              scanReportId: lastDetectionId);
                          // sendReportToDoctor(snap.data![index]['doc_id']);
                        },
                        title: Text(snap.data![index]['name']),
                        subtitle: Text(snap.data![index]['specialisation']),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text('NO data'),
              );
            }
          }),
    );
  }
}
