
import 'package:cateract_detector/pages/doctor/doc_auth_page.dart';
import 'package:cateract_detector/pages/user/user_auth_page.dart';
import 'package:cateract_detector/widgets/authentication_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<LoginPage> {
  bool showPassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  toggleVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  // bool adminLogin = false;
  final fkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: fkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Lottie.asset('assets/eye_doc.json')),
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
                suffixFunction: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon:showPassword?Icons.visibility_off: Icons.visibility,
                password: showPassword ? false : true,
                controller: passwordController,
                validatorFuction: (v) {
                  if (v!.isEmpty) {
                    return 'enter password';
                  } else if (v.length < 6) {
                    return 'password too short';
                  }
                },
                label: 'password'),
            Padding(
              padding: const EdgeInsets.all(15),
              child: MaterialButton(
               
                color: Colors.blue.withOpacity(.5),
                onPressed: () async {
                  if (fkey.currentState!.validate()) {
                    try {
                      UserCredential user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      if (user.user != null) {
                        setState(() {});
                      }
                    } on FirebaseAuthException catch (err) {
                     
                      print('err code :  ${err.code}');
                      if (err.code == 'user-not-found') {
                        Fluttertoast.showToast(
                            msg: 'No user found, try signing up');
                      } else {
                        Fluttertoast.showToast(msg: '${err.message}');
                      }
                    }
                  }
                },
                height: 50,
                minWidth: double.infinity,
                 child: const Text('Login'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Don\'t have an account?'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: MaterialButton(
               
                color: Colors.blue.withOpacity(.5),
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Create account as?',
                                    style: TextStyle(fontSize: 25)),
                              ),
                            const  SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DocAuthPage(),
                                          ),
                                        );
                                      },
                                      child: const Chip(
                                        label: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Doctor',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      )),
                                  MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => UserAuthPage(),
                                          ),
                                        );
                                      },
                                      child: const Chip(
                                        label: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Patient',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 150,
                              )
                            ],
                          ));
                },
                height: 50,
                minWidth: double.infinity,
                 child: const Text('Signup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
