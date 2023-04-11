import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('Doctors').get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasData) {
            if (snap.data!.docs.isEmpty) {
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
            return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundImage: NetworkImage(
                      //     snap.data!.docs[index].data()['image'],
                      //   ),
                      // ),
                      title: Text(
                        snap.data!.docs[index].data()['name']
                            
                      ),
                      subtitle: Text(
                        snap.data!.docs[index].data()['specialisation'],
                      ),
                      trailing: Text(
                          '${snap.data!.docs[index].data()['experience']} years'),
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        });
  }
}
