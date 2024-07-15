import 'package:get/get.dart';

class CommonLayoutController extends GetxController {
  static CommonLayoutController get to => Get.find();
  RxBool isLoading = false.obs;

  void loading(bool state) {
    isLoading(state);
  }
}
