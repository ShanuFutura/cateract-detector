// import 'package:cateract_detector/constants.dart';
// import 'package:cateract_detector/services/firebase_services.dart';
// import 'package:cateract_detector/services/shared_preferences_services.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../widgets/authentication_text_field.dart';

// class AuthenticationPage extends StatefulWidget {
//   const AuthenticationPage({super.key});

//   @override
//   State<AuthenticationPage> createState() => _AuthenticationPageState();
// }

// class _AuthenticationPageState extends State<AuthenticationPage> {
//   bool isDoctor = false;

//   TextEditingController emailController = TextEditingController();

//   TextEditingController passwordController = TextEditingController();
//   TextEditingController specialisationController = TextEditingController();
//   TextEditingController specialisationForEmailAuthenticationController =
//       TextEditingController();

//   final fkey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     // double kbHeight = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       body: Form(
//         key: fkey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             AuthenticationTextField(
//               controller: emailController,
//               kbType: TextInputType.emailAddress,
//               label: 'email',
//               validatorFuction: (v) {
//                 SharedPreferencesServices.emailInfo().then((infoGiven) {
//                   if (!infoGiven) {
//                     Fluttertoast.showToast(
//                         msg: 'the same email will be used for sending mails');
//                   }
//                 });
//                 if (v!.isEmpty) {
//                   return 'email cannot be empty';
//                 } else if ((!v.contains('@') || !v.contains('.'))) {
//                   return 'email is badly formated';
//                 }
//               },
//             ),
//             AuthenticationTextField(
//               controller: passwordController,
//               label: 'password',
//               validatorFuction: (v) {
//                 if (v!.isEmpty) {
//                   return 'password cannot be empty';
//                 } else if (v.length < 6) {
//                   return 'password too short';
//                 }
//               },
//             ),
//           if(isDoctor)  AuthenticationTextField(
//               controller: specialisationForEmailAuthenticationController,
//               label: 'specialisation',
//               validatorFuction: (v) {
//                 if (v!.isEmpty) {
//                   return 'specialisation cannot be empty';
//                 }
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 height: 50,
//                 width: double.infinity,
//                 child: MaterialButton(
//                   onPressed: () {
//                     if (fkey.currentState!.validate()) {
//                       FirebaseServices.emailAuthentication(
//                           user: isDoctor ? UserType.doctor : UserType.patient,
//                           email: emailController.text,
//                           password: passwordController.text,
//                           specialisation: isDoctor
//                               ? specialisationForEmailAuthenticationController
//                                   .text
//                               : null,
//                           context: context);
//                     }
//                   },
//                   color: Colors.primaries.last,
//                   child:const  Text(
//                     'Sign in',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               children: const [
//                 Expanded(child: Divider()),
//                 Text('OR'),
//                 Expanded(child: Divider()),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 height: 50,
//                 width: double.infinity,
//                 child: MaterialButton(
//                     onPressed: () {
//                       docAuth(context);
//                     },
//                     color: Colors.primaries.last,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset('assets/google.png'),
//                          const  SizedBox(
//                             width: 20,
//                           ),
//                          const  Text(
//                             'Sign in with Google',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     )),
//               ),
//             ),
//             if (!isDoctor)
//               Row(
//                 children: const [
//                   Expanded(child: Divider()),
//                   Text('Are you a doctor?'),
//                   Expanded(child: Divider()),
//                 ],
//               ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 height: 50,
//                 width: double.infinity,
//                 child: MaterialButton(
//                   onPressed: () {
//                     setState(() {
//                       isDoctor = !isDoctor;
//                     });
//                   },
//                   color: Colors.primaries.last,
//                   child: Text(
//                     isDoctor ? 'Sign in as Patient' : 'Sign in as Doctor',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void docAuth(BuildContext context) {
//     if (isDoctor) {
//       showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//                 title: Text('Create account?'),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         showModalBottomSheet(
//                           isScrollControlled: true,
//                           context: context,
//                           builder: (_) => Padding(
//                             padding: EdgeInsets.fromLTRB(8, 8, 8,
//                                 MediaQuery.of(context).viewInsets.bottom),
//                             child: SingleChildScrollView(
//                               child: IntrinsicHeight(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       'enter your specialisation',
//                                       style: TextStyle(fontSize: 20),
//                                     ),
//                                     AuthenticationTextField(
//                                       controller: specialisationController,
//                                       label: 'specialisation',
//                                       validatorFuction: (v) {
//                                         if (v!.isEmpty) {
//                                           return 'specialisation cannot be empty';
//                                         }
//                                       },
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: SizedBox(
//                                         height: 50,
//                                         width: double.infinity,
//                                         child: MaterialButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                             FirebaseServices.googleAuth(
//                                                 userType: UserType.doctor,
//                                                 specialisation:
//                                                     specialisationController
//                                                         .text);
//                                           },
//                                           color: Colors.primaries.last,
//                                           child: Text('Continue'),
//                                         ),
//                                       ),
//                                     ),
//                                     // SizedBox(height: kbHeight,)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: Text('Yes')),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         FirebaseServices.googleAuth(
//                           userType: UserType.doctor,
//                         );
//                       },
//                       child: Text('Already have'))
//                 ],
//               ));
//     } else {
//       FirebaseServices.googleAuth(
//         userType: UserType.patient,
//       );
//     }
//   }
// }
