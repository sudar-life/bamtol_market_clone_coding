import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategorySelector extends StatelessWidget {
  final ProductCategoryType? initType;
  const ProductCategorySelector({super.key, this.initType});

  @override
  Widget build(BuildContext context) {
    var types = ProductCategoryType.values
        .where((element) => element.code != '')
        .toList();
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                behavior: HitTestBehavior.translucent,
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                height: Get.height * 0.7,
                color: const Color(0xff212123),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      types.length,
                      (index) => GestureDetector(
                        onTap: () {
                          Get.back(result: types[index]);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: AppFont(
                            types[index].name,
                            color: initType == null
                                ? Colors.white
                                : initType?.code == types[index].code
                                    ? const Color(0xffFD6F1F)
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
