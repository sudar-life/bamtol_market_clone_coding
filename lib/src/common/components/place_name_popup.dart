import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceNamePopup extends StatefulWidget {
  const PlaceNamePopup({super.key});

  @override
  State<PlaceNamePopup> createState() => _PlaceNamePopupState();
}

class _PlaceNamePopupState extends State<PlaceNamePopup> {
  bool possible = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Align(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: const Color(0xff212123),
                  height: 230,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppFont(
                        '선택한 곳의 장소명을 입력해주세요',
                        fontWeight: FontWeight.bold,
                        size: 16,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        autofocus: true,
                        controller: controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: '예) 강남역 1번 출구, 당근빌딩 앞',
                          hintStyle:
                              TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            possible = value != '';
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Btn(
                        child: const AppFont(
                          '거래 장소 등록',
                          align: TextAlign.center,
                        ),
                        disabled: !possible,
                        onTap: () {
                          Get.back(result: controller.text);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
