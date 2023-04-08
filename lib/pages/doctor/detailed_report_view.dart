import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailedReportViewPage extends StatelessWidget {
  DetailedReportViewPage({super.key, required this.scanReportId});
  String scanReportId;

  Future<Map<String, dynamic>> getData() async {
    DocumentSnapshot<Map<String, dynamic>> reportData = await FirebaseFirestore
        .instance
        .collection('ScanReport')
        .doc(scanReportId)
        .get();

    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection('Patient')
        .doc(reportData['userId'])
        .get();

    final data = {...reportData.data()!, ...userData.data()!};

    return data;
  }

  TextEditingController remarksController = TextEditingController();
  FocusNode remarksNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: getData(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snap.hasData) {
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: Image.network(snap.data!['image'],
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Text(
                          'Detected ${snap.data!['detection']}'
                              .replaceAll('_', ' '),
                          style:const TextStyle(fontSize: 20)),
                      Text('Accuracy: ${snap.data!['accuracy']}',
                          style: const TextStyle(fontSize: 15)),
                      const Divider(),
                      const Text('User Details',
                          style: TextStyle(fontSize: 18)),
                      Text('name: ${snap.data!['name']}'),
                      Text('sex: ${snap.data!['gender']}'),
                      Text('age: ${snap.data!['age']}'),
                      const Expanded(child: SizedBox()),
                      TextField(
                        focusNode: remarksNode,
                        controller: remarksController
                          ..text = snap.data!['remarks'] == '...'
                              ? ''
                              : snap.data!['remarks'],
                        maxLines: 4,
                        decoration:const InputDecoration(
                          border:  OutlineInputBorder(),
                          label: Text('remarks'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: MaterialButton(
                          
                          color: Colors.blue.withOpacity(.5),
                          onPressed: () async {
                            if (remarksController.text.trim() == '') {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text(
                                            'Are you sure, leave without remarks?'),
                                        content: const Text(
                                            'This detection will be remain as unvisited if you left without any remarks.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                remarksNode.requestFocus();
                                              },
                                              child: const Text('dismiss')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('leave anyway'))
                                        ],
                                      ));
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('ScanReport')
                                  .doc(scanReportId)
                                  .update({'remarks': remarksController.text});
                              Fluttertoast.showToast(msg: 'remarks added');
                              Navigator.pop(context);
                            }
                          },
                          height: 50,
                          minWidth: double.infinity,
                          child: const Text('Done'),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('No requests yet'),
                );
              }
            }),
      ),
    );
  }
}
