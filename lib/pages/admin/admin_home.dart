import 'package:cateract_detector/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/all_scan_reports_list.dart';
import '../../widgets/doctors_list.dart';
import '../../widgets/users_list.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            icon: const Icon(Icons.logout),
          ),
          PopupMenuButton(
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: const Text('clear all scan reports'),
                      onTap: () async {
                       
                        QuerySnapshot<Map<String, dynamic>> reportCollection =
                            await FirebaseFirestore.instance
                                .collection('ScanReport')
                                .get();

                       

                        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                            in reportCollection.docs) {
                          doc.reference.delete();
                        }
                      },
                    ),
                  ])
        ]),
        body: const TabBarView(children: [
          AllScanReports(),
          UsersList(),
          DoctorsList(),
        ]),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.visibility),
              text: 'reports',
            ),
            Tab(
              icon: Icon(Icons.groups),
              text: 'users',
            ),
            Tab(
              icon: Icon(Icons.medical_services),
              text: 'Doctors',
            ),
          ],
        ),
      ),
    );
  }
}
