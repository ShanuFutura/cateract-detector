import 'package:cateract_detector/constants.dart';
import 'package:cateract_detector/pages/doctor/detailed_report_view.dart';
import 'package:cateract_detector/pages/login_page.dart';
import 'package:cateract_detector/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  Future<List<Map>> getScanReports() async {
    QuerySnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection('ScanReport').get();
    QuerySnapshot<Map<String, dynamic>> userSnap =
        await FirebaseFirestore.instance.collection('Patient').get();

    List<Map> reports = [];

    Map tempMap = {};

    snap.docs
        .where(
            (element) => element.data()['docId'] == Constants.firebaseUser.uid)
        .toList()
        .forEach((reportCollectionElement) {
      tempMap['detection'] = reportCollectionElement.data()['detection'];
      tempMap['remarks'] = reportCollectionElement.data()['remarks'];
      tempMap['image'] = reportCollectionElement.data()['image'];
      tempMap['id'] = reportCollectionElement.id;
      userSnap.docs.forEach((userColloectionElement) {
        if (userColloectionElement.id ==
            reportCollectionElement.data()['userId']) {
          tempMap['user'] = userColloectionElement.data()['name'];
          // reportCollectionElement.data()['username'] =
          //     userColloectionElement.data()['name'];
        }
      });
      reports.add(tempMap);
    });

    print(snap.docs.first.data());
    print(reports);

    return reports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Requests'),
        actions: [
          IconButton(
            onPressed: () async{
              await FirebaseServices.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));
              
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getScanReports(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasData) {
            if (snap.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/empty.json'),
                    const Text('No requests yet'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      tileColor: snap.data![index]['remarks'] == '...'
                          ? Colors.amber.withOpacity(.6)
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailedReportViewPage(
                              scanReportId: snap.data![index]['id'],
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(snap.data![index]['image']),
                      ),
                      title: Text(snap.data![index]['user']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const  SizedBox(
                            height: 5,
                          ),
                          Text(snap.data![index]['detection']
                              .toString()
                              .replaceAll('_', ' ')),
                          Text(snap.data![index]['remarks'] == '...'
                              ? ''
                              : 'remarks: ${snap.data![index]['remarks']}'),
                        ],
                      ),
                      trailing: snap.data![index]['remarks'] == '...'
                          ? TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailedReportViewPage(
                                      scanReportId: snap.data![index]['id'],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Consult'))
                          : const Text('Consulted'),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('no data'),
            );
          }
        },
      ),
    );
  }
}
