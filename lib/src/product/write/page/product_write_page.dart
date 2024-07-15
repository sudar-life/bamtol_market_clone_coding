import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/checkbox.dart';
import 'package:bamtol_market_app/src/common/components/multiful_image_view.dart';
import 'package:bamtol_market_app/src/common/components/product_category_selector.dart';
import 'package:bamtol_market_app/src/common/components/textfield.dart';
import 'package:bamtol_market_app/src/common/components/trade_location_map.dart';
import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/common/layout/common_layout.dart';
import 'package:bamtol_market_app/src/product/write/controller/product_write_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class ProductWritePage extends GetView<ProductWriteController> {
  const ProductWritePage({super.key});
  Widget get _divder => const Divider(
        color: Color(0xff3C3C3E),
        indent: 25,
        endIndent: 25,
      );

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/svg/icons/close.svg'),
          ),
        ),
        centerTitle: true,
        title: const AppFont(
          '내 물건 팔기',
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                if (controller.isPossibleSubmit.value) {
                  controller.submit();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, right: 25),
                child: AppFont(
                  '완료',
                  color: controller.isPossibleSubmit.value
                      ? const Color(0xffED7738)
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                  size: 16,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _PhotoSelectedView(),
                  _divder,
                  _ProductTitleView(),
                  _divder,
                  _CategorySelectView(),
                  _divder,
                  _PriceSettingView(),
                  _divder,
                  _ProductDescription(),
                  Container(
                    height: 5,
                    color: Color(0xff3C3C3E),
                  ),
                  _HopeTradeLocationMap(),
                ],
              ),
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xff3C3C3E),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svg/icons/photo_small.svg'),
                    const SizedBox(width: 10),
                    const AppFont(
                      '0/10',
                      size: 13,
                      color: Colors.white,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  behavior: HitTestBehavior.translucent,
                  child: SvgPicture.asset('assets/svg/icons/keyboard-down.svg'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HopeTradeLocationMap extends GetView<ProductWriteController> {
  const _HopeTradeLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          var result = await Get.to<Map<String, dynamic>?>(
            TradeLocationMap(
              label: controller.product.value.wantTradeLocationLabel,
              location: controller.product.value.wantTradeLocation,
            ),
          );
          if (result != null) {
            controller.changeTradeLocationMap(result);
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppFont(
              '거래 희망 장소',
              size: 16,
              color: Colors.white,
            ),
            Obx(
              () => controller.product.value.wantTradeLocationLabel == null ||
                      controller.product.value.wantTradeLocationLabel == ''
                  ? Row(
                      children: [
                        const AppFont(
                          '장소 선택',
                          size: 13,
                          color: Color(0xff6D7179),
                        ),
                        SvgPicture.asset('assets/svg/icons/right.svg'),
                      ],
                    )
                  : Row(
                      children: [
                        AppFont(
                            controller.product.value.wantTradeLocationLabel ??
                                '',
                            size: 13,
                            color: Colors.white),
                        GestureDetector(
                          onTap: () {
                            controller.clearWantTradeLocation();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                SvgPicture.asset('assets/svg/icons/delete.svg'),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDescription extends GetView<ProductWriteController> {
  const _ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: CommonTextField(
        hintColor: Color(0xff6D7179),
        hintText: '아라동에 올릴 게시글 내용을 작성해주세요.\n(판매 금지 물품은 게시가 제한될 수 있어요.)',
        textInputType: TextInputType.multiline,
        maxLines: 10,
        onChange: controller.changeDescription,
      ),
    );
  }
}

class _PriceSettingView extends GetView<ProductWriteController> {
  const _PriceSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => CommonTextField(
                  hintColor: const Color(0xff6D7179),
                  hintText: '₩ 가격 (선택사항)',
                  textInputType: TextInputType.number,
                  initText: controller.product.value.productPrice.toString(),
                  onChange: controller.changePrice,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$'))
                  ]),
            ),
          ),
          Obx(
            () => CheckBox(
              label: '나눔',
              isChecked: controller.product.value.isFree ?? false,
              toggleCallBack: controller.changeIsFreeProduct,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelectView extends GetView<ProductWriteController> {
  const _CategorySelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          var selectedCategoryType = await Get.dialog<ProductCategoryType?>(
            ProductCategorySelector(
              initType: controller.product.value.categoryType,
            ),
          );
          controller.changeCategoryType(selectedCategoryType);
        },
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => AppFont(
                controller.product.value.categoryType!.name,
                size: 16,
                color: Colors.white,
              ),
            ),
            SvgPicture.asset('assets/svg/icons/right.svg'),
          ],
        ),
      ),
    );
  }
}

class _ProductTitleView extends GetView<ProductWriteController> {
  const _ProductTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CommonTextField(
        hintText: '글 제목',
        onChange: controller.changeTitle,
        hintColor: const Color(0xff6D7179),
      ),
    );
  }
}

class _PhotoSelectedView extends GetView<ProductWriteController> {
  const _PhotoSelectedView({super.key});

  Widget _photoSelectIcon() {
    return GestureDetector(
      onTap: () async {
        var selectedImages = await Get.to<List<AssetEntity>?>(
          MultifulImageView(
            initImages: controller.selectedImages,
          ),
        );
        controller.changeSelectedImages(selectedImages);
      },
      child: Container(
        width: 77,
        height: 77,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xff42464E)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/icons/camera.svg'),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => AppFont(
                    '${controller.selectedImages.length}',
                    size: 13,
                    color: const Color(0xff868B95),
                  ),
                ),
                const AppFont(
                  '/10',
                  size: 13,
                  color: Color(0xff868B95),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _selectedImageList() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      height: 77,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 67,
                      height: 67,
                      child: FutureBuilder(
                        future: controller.selectedImages[index].file,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.file(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      controller.deleteImage(index);
                    },
                    child: SvgPicture.asset('assets/svg/icons/remove.svg'),
                  ),
                )
              ],
            );
          },
          itemCount: controller.selectedImages.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Row(children: [
        _photoSelectIcon(),
        Expanded(child: _selectedImageList()),
      ]),
    );
  }
}
