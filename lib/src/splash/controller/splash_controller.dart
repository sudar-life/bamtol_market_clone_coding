import 'package:bamtol_market_app/src/splash/enum/step_type.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.init.obs;

  void changeStep(StepType type) {
    loadStep(type);
  }
}
