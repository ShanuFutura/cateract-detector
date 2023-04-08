import 'package:cateract_detector/constants.dart';
import 'package:cateract_detector/pages/doctor/doctor_home_page.dart';
import 'package:cateract_detector/services/firebase_services.dart';
import 'package:cateract_detector/widgets/authentication_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class DocAuthPage extends StatefulWidget {
  const DocAuthPage({super.key});

  @override
  State<DocAuthPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<DocAuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController specialisationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final fkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // double kbHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: fkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    height: 300, child: Lottie.asset('assets/doctor.json')),
                AuthenticationTextField(
                    controller: nameController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter name';
                      }
                    },
                    label: 'name'),
                AuthenticationTextField(
                    controller: specialisationController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter specialisation';
                      }
                    },
                    label: 'specialisation'),
                AuthenticationTextField(
                    controller: experienceController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter experience';
                      }
                    },
                    label: 'experience'),
                AuthenticationTextField(
                    controller: hospitalController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter hospital name';
                      }
                    },
                    label: 'hospital'),
                AuthenticationTextField(
                    kbType: TextInputType.emailAddress,
                    controller: emailController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter email';
                      }
                    },
                    label: 'email'),
                AuthenticationTextField(
                    password: true,
                    controller: passwordController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter password';
                      } else if (v.length < 8) {
                        return 'password too short';
                      }
                    },
                    label: 'password'),
                     AuthenticationTextField(
                      password: true,
                    controller: confirmPasswordController,
                    
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter password';
                      } else if (v.length < 8) {
                        return 'password too short';
                      }else if(v!=passwordController.text){
                        return 'password mismatch';
                      }
                    },
                    label: 'retype password'),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: MaterialButton(
                    child: Text('create account'),
                    color: Colors.blue.withOpacity(.5),
                    onPressed: () async {
                      try {
                        UserCredential user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        await FirebaseServices.storeUserInDataBase(
                            user: UserType.doctor,
                            data: {
                              'name': nameController.text,
                              'specialisation': specialisationController.text,
                              'experience': experienceController.text,
                              'hospital': hospitalController.text,
                              'email': emailController.text,
                            },
                            uid: user.user!.uid);
                        if (user.user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DoctorHomePage()));
                        }
                      } on FirebaseAuthException catch (err) {
                        Fluttertoast.showToast(msg: '${err.message}');
                      }
                    },
                    height: 50,
                    minWidth: double.infinity,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
