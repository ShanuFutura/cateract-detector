import 'dart:io';

import 'package:cateract_detector/pages/login_page.dart';
import 'package:cateract_detector/pages/user/doctors_list.dart';
import 'package:cateract_detector/services/firebase_services.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/scan_report.dart';
import '../../services/http_services.dart';
import '../../widgets/users_detections_list.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  late Stream<double> uploadStream;

  bool uploading = false;

  bool isListEmpty = true;

  bool refreshed = false;
  String lastScanResultId = '';

  listIsNotEmpty(String id) {
    lastScanResultId = id;
    // setState(() {
    isListEmpty = false;
    // });
    if (!refreshed) {
      refreshed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseServices.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
              // GoogleSignIn().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent detections,',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
              child: UsersDetectionList(
            itemNotEmptyFunctionCallback: listIsNotEmpty,
          )),
          InkWell(
            onTap: isListEmpty
                ? null
                : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DoctorsListPage(
                                  lastDetectionId: lastScanResultId,
                                )));
                  },
            child: AnimatedContainer(
              duration:const  Duration(milliseconds: 300),
              color: isListEmpty
                  ? Colors.white.withOpacity(0)
                  : Colors.white.withOpacity(.5),
              height: 50,
              width: double.infinity,
              child: isListEmpty
                  ? null
                  : const Center(
                      child: Text('send last detection to doctor'),
                    ),
            ),
          ),
          if (uploading)
            StreamBuilder(
                stream: uploadStream,
                builder: (context, snapshot) {
                  if (snapshot.data == 1.0) {
                    return uploadButton();
                  }
                  return snapshot.data != 1.0
                      ? Stack(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(.5),
                              highlightColor: Colors.transparent,
                              child: const Center(
                                child: Text(
                                  'uploading',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                color: Colors.white.withOpacity(.5),
                                minHeight: 50,
                                value: snapshot.data),
                          ],
                        )
                      : const SizedBox();
                }),
          if (!uploading) uploadButton()
        ],
      ),
    );
  }

  Widget uploadButton() {
    return MaterialButton(
        color: Colors.transparent,
        onPressed: () async {
          // File? image = await Utils.pickImage();
          // if (image != null) {
          //   Map res = await HttpServices.postData(
          //       endPoint: 'detect',
          //       image: image,
          //       imageParameter: 'file');
          // }
          XFile? pickedFile = await ImagePicker()
              .pickImage(source: ImageSource.gallery, imageQuality: 10);
          if (pickedFile != null) {
            File image = File(pickedFile.path);
            var res = await HttpServices.postData(
                endPoint: 'predict', image: image, imageParameter: 'file');
            print('>>>>>>>>>>>>>>>>>>>>>>>>>>>.................$res');
            setState(() {
              uploadStream = FirebaseServices.uploadScanResult(
                  ScanReport(
                    accuracy: double.parse('${res['confidence']}'),
                    detection: res['class'],
                    image: image,
                    remarks: '...',
                  ),
                  context);
              uploading = true;
            });
            // uploadStream.listen((event) {}).onDone(() {

            // });
          }
        },
        child: const SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(child: Text('Upload image'))));
  }
}
