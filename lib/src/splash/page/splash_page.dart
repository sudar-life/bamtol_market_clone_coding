import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'splash 페이지',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
