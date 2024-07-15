import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/common/model/product_search_option.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepository;
  final UserModel myUser;
  ProductDetailController(
    this._productRepository,
    this.myUser,
  );
  late String docId;
  Rx<Product> product = const Product.empty().obs;
  RxList<Product> ownerOtherProducts = <Product>[].obs;

  bool get isMine => myUser.uid == product.value.owner?.uid;
  bool isEdited = false;

  @override
  void onInit() async {
    super.onInit();
    docId = Get.parameters['docId'] ?? '';
    await _loadProductDetailData();
    await _loadOtherProducts();
  }

  Future<void> _loadProductDetailData() async {
    var result = await _productRepository.getProduct(docId);
    if (result == null) return;
    product(result.copyWith(viewCount: (result.viewCount ?? 0) + 1));
    _updateProductInfo();
  }

  Future<void> _loadOtherProducts() async {
    var searchOption = ProductSearchOption(
      ownerId: product.value.owner?.uid ?? '',
      status: const [
        ProductStatusType.sale,
        ProductStatusType.reservation,
      ],
    );
    var results = await _productRepository.getProducts(searchOption);
    ownerOtherProducts.addAll(results.list);
  }

  void _updateProductInfo() async {
    await _productRepository.editProduct(product.value);
  }

  void onLikedEvent() {
    var likers = product.value.likers ?? [];
    if (likers.contains(myUser.uid)) {
      likers = likers.toList()..remove(myUser.uid);
    } else {
      likers = likers.toList()..add(myUser.uid!);
    }
    product(product.value.copyWith(likers: List.unmodifiable([...likers])));
    _updateProductInfo();
  }

  Future<bool> deleteProduct() async {
    return await _productRepository.deleteProduct(product.value.docId!);
  }

  void refresh() async {
    isEdited = true;
    await _loadProductDetailData();
  }
}
