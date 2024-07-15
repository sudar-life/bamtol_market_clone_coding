import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import 'package:bamtol_market_app/src/user/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});
  Widget _logoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 99,
          height: 116,
          child: Image.asset(
            'assets/images/logo_simbol.png',
          ),
        ),
        const SizedBox(height: 40),
        const AppFont(
          '당신 근처의 밤톨마켓',
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        const SizedBox(height: 15),
        AppFont(
          '중고 거래부터 동네 정보까지, \n지금 내 동네를 선택하고 시작해보세요!',
          align: TextAlign.center,
          size: 18,
          color: Colors.white.withOpacity(0.6),
        )
      ],
    );
  }

  Widget _textDivier() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
            child: AppFont(
              '회원가입/로그인',
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _snsLoginBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: [
          Btn(
            color: Colors.white,
            onTap: controller.googleLogin,
            child: Row(
              children: [
                Image.asset('assets/images/google.png'),
                const SizedBox(width: 30),
                const AppFont(
                  'Google로 계속하기',
                  color: Colors.black,
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Btn(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onTap: controller.appleLogin,
            child: Row(
              children: [
                Image.asset('assets/images/apple.png'),
                const SizedBox(width: 17),
                const AppFont(
                  'Apple로 계속하기',
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _logoView(),
          _textDivier(),
          _snsLoginBtn(),
        ],
      ),
    );
  }
}
