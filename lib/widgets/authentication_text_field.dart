import 'package:flutter/material.dart';

class AuthenticationTextField extends StatelessWidget {
  AuthenticationTextField({
    required this.controller,
    super.key,
    required this.validatorFuction,
    this.kbType,
    required this.label,
    this.password,
    this.suffixFunction,
    this.icon,
  });
  Function()? suffixFunction;
  IconData? icon;
  TextEditingController controller;
  bool? password;
  String label;
  String? Function(String?)? validatorFuction;
  TextInputType? kbType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validatorFuction,
        keyboardType: kbType,
        obscureText: password ?? false,
        decoration: InputDecoration(
        suffixIcon: suffixFunction!=null? IconButton(onPressed: suffixFunction!, icon:  Icon(icon!)):null,
          filled: true,
          label: Text(label),
          border: OutlineInputBorder(
            borderSide:const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Colors.black.withOpacity(.2),
        ),
      ),
    );
  }
}
