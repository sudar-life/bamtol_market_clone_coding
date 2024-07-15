import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxService {
  late CollectionReference products;
  ProductRepository(FirebaseFirestore db) {
    products = db.collection("products");
  }

  Future<String?> saveProduct(Map<String, dynamic> data) async {
    try {
      var docs = await products.add(data);
      return docs.id;
    } catch (e) {
      return null;
    }
  }
}
