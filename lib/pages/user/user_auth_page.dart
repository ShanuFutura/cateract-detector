import 'package:cateract_detector/constants.dart';
import 'package:cateract_detector/pages/user/user_home.dart';
import 'package:cateract_detector/services/firebase_services.dart';
import 'package:cateract_detector/widgets/authentication_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<UserAuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  String gender = '';

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
                  height: 200,
                  child: Lottie.asset('assets/user.json')),
                AuthenticationTextField(
                    controller: nameController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter name';
                      }
                    },
                    label: 'name'),
                AuthenticationTextField(
                    controller: ageController,
                    kbType: TextInputType.number,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter age';
                      }
                    },
                    label: 'age'),
                AuthenticationTextField(
                    controller: placeController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter place';
                      }
                    },
                    label: 'place'),
                AuthenticationTextField(
                    kbType: TextInputType.phone,
                    controller: phoneController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter phone number';
                      }
                    },
                    label: 'phone'),
                AuthenticationTextField(
                  kbType: TextInputType.emailAddress,
                    controller: emailController,
                    validatorFuction: (v) {
                      if (v!.isEmpty) {
                        return 'enter email';
                      }
                    },
                    label: 'email'),
                RadioListTile(
                    title: Text('male'),
                    value: 'male',
                    groupValue: gender,
                    onChanged: (v) {
                      setState(() {
                        gender = v!;
                      });
                    }),
                RadioListTile(
                    title: Text('female'),
                    value: 'female',
                    groupValue: gender,
                    onChanged: (v) {
                      setState(() {
                        gender = v!;
                      });
                    }),
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
                   
                    color: Colors.blue.withOpacity(.5),
                    onPressed: () async {
                      try {
                        UserCredential user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        await FirebaseServices.storeUserInDataBase(
                            user: UserType.patient,
                            data: {
                              'name': nameController.text,
                              'age': ageController.text,
                              'place': placeController.text,
                              'gender': gender,
                              'email': emailController.text,
                              'phone': phoneController.text
                            },
                            uid: user.user!.uid);
                            if(user.user!=null){
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => UserHomePage()));}
                      } on FirebaseAuthException catch (err) {
                        Fluttertoast.showToast(msg: '${err.message}');
                      }
                    },
                    height: 50,
                    minWidth: double.infinity,
                     child:const  Text('create account'),
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
