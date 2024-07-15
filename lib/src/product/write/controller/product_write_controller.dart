import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/controller/common_layout_controller.dart';
import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/common/model/asset_value_entity.dart';
import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/common/repository/cloud_firebase_storage_repository.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class ProductWriteController extends GetxController {
  final UserModel owner;
  final Rx<Product> product = const Product().obs;
  final ProductRepository _productRepository;
  final CloudFirebaseRepository _cloudFirebaseRepository;
  RxBool isPossibleSubmit = false.obs;
  bool isEditMode = false;
  RxList<AssetValueEntity> selectedImages = <AssetValueEntity>[].obs;
  ProductWriteController(
    this.owner,
    this._productRepository,
    this._cloudFirebaseRepository,
  );

  @override
  void onInit() {
    super.onInit();
    var productDocId = Get.parameters['product_doc_id'];
    if (productDocId != null) {
      isEditMode = true;
      _loadProductDetail(productDocId);
    }
    product.stream.listen((event) {
      _isValidSubmitPossible();
    });
  }

  _loadProductDetail(String docId) async {
    var productValue = await _productRepository.getProduct(docId);
    if (productValue != null) {
      product(productValue);
      if (productValue.imageUrls != null) {
        selectedImages.addAll(productValue.imageUrls!
            .map<AssetValueEntity>((e) => AssetValueEntity(thumbnail: e))
            .toList());
      }
    }
  }

  _isValidSubmitPossible() {
    if (selectedImages.isNotEmpty &&
        (product.value.productPrice ?? 0) >= 0 &&
        product.value.title != '') {
      isPossibleSubmit(true);
    } else {
      isPossibleSubmit(false);
    }
  }

  changeSelectedImages(List<AssetValueEntity>? images) {
    selectedImages(images);
  }

  deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  changeTitle(String value) {
    product(product.value.copyWith(title: value));
  }

  changeCategoryType(ProductCategoryType? type) {
    product(product.value.copyWith(categoryType: type));
  }

  changePrice(String price) {
    if (!RegExp(r'^[0-9]+$').hasMatch(price)) return;
    product(product.value.copyWith(
        productPrice: int.parse(price), isFree: int.parse(price) == 0));
  }

  changeIsFreeProduct() {
    product(product.value.copyWith(isFree: !(product.value.isFree ?? false)));
    if (product.value.isFree!) {
      changePrice('0');
    }
  }

  changeDescription(String value) {
    product(product.value.copyWith(description: value));
  }

  changeTradeLocationMap(Map<String, dynamic> mapInfo) {
    product(product.value.copyWith(
        wantTradeLocationLabel: mapInfo['label'],
        wantTradeLocation: mapInfo['location']));
  }

  clearWantTradeLocation() {
    product(product.value
        .copyWith(wantTradeLocationLabel: '', wantTradeLocation: null));
  }

  Future<List<String>> uploadImages(List<AssetValueEntity> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      var downloadUrl = image.thumbnail ?? '';
      if (image.id != '') {
        var file = await image.file;
        if (file == null) return [];
        downloadUrl =
            await _cloudFirebaseRepository.uploadFile(owner.uid!, file);
      }

      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  submit() async {
    CommonLayoutController.to.loading(true);
    product(product.value.copyWith(
      owner: owner,
      imageUrls: selectedImages.map((e) => e.thumbnail ?? '').toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    if (selectedImages
        .where((selectedImage) => selectedImage.id != '')
        .toList()
        .isNotEmpty) {
      var downloadUrls = await uploadImages(selectedImages);
      product(product.value.copyWith(imageUrls: downloadUrls));
    }

    String resultMessage = '';
    if (isEditMode) {
      await _productRepository.editProduct(product.value);
      resultMessage = '물건이 수정되었습니다.';
    } else {
      await _productRepository.saveProduct(product.value.toMap());
      resultMessage = '물건이 등록되었습니다.';
    }
    CommonLayoutController.to.loading(false);
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          content: AppFont(
            resultMessage,
            color: Colors.black,
            size: 16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const AppFont(
                '확인',
                size: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
    Get.back(result: true);
  }
}
