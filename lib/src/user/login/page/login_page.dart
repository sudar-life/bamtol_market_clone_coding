import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppFont('로그인'),
      ),
    );
  }
}
