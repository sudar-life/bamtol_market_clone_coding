import 'package:bamtol_market_app/src/common/components/loading.dart';
import 'package:bamtol_market_app/src/common/controller/common_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonLayout extends GetView<CommonLayoutController> {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavBar;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  const CommonLayout({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.useSafeArea = false,
    this.bottomNavBar,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: appBar,
              backgroundColor: const Color(0xff212123),
              body: useSafeArea ? SafeArea(child: body) : body,
              bottomNavigationBar: bottomNavBar ?? const SizedBox(height: 1),
              floatingActionButton: floatingActionButton,
            ),
            controller.isLoading.value ? const Loading() : Container(),
          ],
        ),
      ),
    );
  }
}
