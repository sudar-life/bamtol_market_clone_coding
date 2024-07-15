import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/getx_listener.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/controller/data_load_controller.dart';
import 'package:bamtol_market_app/src/splash/controller/splash_controller.dart';
import 'package:bamtol_market_app/src/splash/enum/step_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetxListener<bool>(
          listen: (bool isLogined) {
            if (isLogined) {
              Get.offNamed('/home');
            } else {
              Get.offNamed('/login');
            }
          },
          stream: Get.find<AuthenticationController>().isLogined,
          child: GetxListener<bool>(
            listen: (bool value) {
              if (value) {
                controller.loadStep(StepType.authCheck);
              }
            },
            stream: Get.find<DataLoadController>().isDataLoad,
            child: GetxListener<StepType>(
              initCall: () {
                controller.loadStep(StepType.dataLoad);
              },
              listen: (StepType? value) {
                if (value == null) return;
                switch (value) {
                  case StepType.init:
                  case StepType.dataLoad:
                    Get.find<DataLoadController>().loadData();
                    break;
                  case StepType.authCheck:
                    Get.find<AuthenticationController>().authCheck();
                    break;
                }
              },
              stream: controller.loadStep,
              child: const _SplashView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Expanded(
          child: Column(
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
          ),
        ),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Obx(
                () {
                  return Text(
                    '${controller.loadStep.value.name}중 입니다.',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                  strokeWidth: 1, color: Colors.white)
            ],
          ),
        )
      ],
    );
  }
}
