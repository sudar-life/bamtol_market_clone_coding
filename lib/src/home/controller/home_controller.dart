import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/common/model/product_search_option.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  ProductRepository _productRepository;
  HomeController(this._productRepository);
  RxList<Product> productList = <Product>[].obs;
  ScrollController scrollController = ScrollController();
  ProductSearchOption searchOption = ProductSearchOption(
    status: const [
      ProductStatusType.sale,
      ProductStatusType.reservation,
    ],
  );
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProductList();
    _event();
  }

  void _event() {
    scrollController.addListener(() {
      if (scrollController.offset >
              scrollController.position.maxScrollExtent - 100 &&
          searchOption.lastItem != null &&
          !isLoading.value) {
        _loadProductList();
      }
    });
  }

  void _initData() {
    searchOption = searchOption.copyWith(lastItem: null);
    productList.clear();
  }

  void refresh() async {
    _initData();
    await _loadProductList();
  }

  Future<void> _loadProductList() async {
    isLoading(true);
    var result = await _productRepository.getProducts(searchOption);
    if (result.lastItem != null) {
      searchOption = searchOption.copyWith(lastItem: result.lastItem);
    } else {
      searchOption = searchOption.copyWith(lastItem: null);
    }
    productList.addAll(result.list);
    isLoading(false);
  }
}
