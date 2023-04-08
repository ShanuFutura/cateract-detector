import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingSplash extends StatelessWidget {
  const LoadingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset('assets/iris.json')),
    );
  }
}
