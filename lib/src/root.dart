import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/controller/bottom_nav_controller.dart';
import 'package:bamtol_market_app/src/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Root extends GetView<BottomNavController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: [
            const HomePage(),
            const Center(child: AppFont('동네생활')),
            const Center(child: AppFont('내 근처')),
            const Center(child: AppFont('채팅')),
            Center(
                child: GestureDetector(
                    onTap: () {
                      Get.find<AuthenticationController>().logout();
                    },
                    child: AppFont('나의 밤톨'))),
          ]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.menuIndex.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff212123),
          selectedItemColor: const Color(0xffffffff),
          unselectedItemColor: const Color(0xffffffff),
          selectedFontSize: 11.0,
          unselectedFontSize: 11.0,
          onTap: controller.changeBottomNav,
          items: [
            BottomNavigationBarItem(
              label: '홈',
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/home-off.svg'),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/home-on.svg'),
              ),
            ),
            BottomNavigationBarItem(
              label: '동네생활',
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    SvgPicture.asset('assets/svg/icons/arround-life-off.svg'),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/arround-life-on.svg'),
              ),
            ),
            BottomNavigationBarItem(
              label: '내 근처',
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/near-off.svg'),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/near-on.svg'),
              ),
            ),
            BottomNavigationBarItem(
              label: '채팅',
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/chat-off.svg'),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/chat-on.svg'),
              ),
            ),
            BottomNavigationBarItem(
              label: '나의 밤톨',
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/my-off.svg'),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('assets/svg/icons/my-on.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
