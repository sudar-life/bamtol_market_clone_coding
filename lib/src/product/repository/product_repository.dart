import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/common/model/product_search_option.dart';
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

  Future<({List<Product> list, QueryDocumentSnapshot<Object?>? lastItem})>
      getProducts(ProductSearchOption searchOption) async {
    try {
      Query<Object?> query = searchOption.toQuery(products);
      QuerySnapshot<Object?> snapshot;
      if (searchOption.lastItem == null) {
        snapshot = await query.limit(7).get();
      } else {
        snapshot = await query
            .startAfterDocument(searchOption.lastItem!)
            .limit(7)
            .get();
      }

      if (snapshot.docs.isNotEmpty) {
        return (
          list: snapshot.docs.map<Product>((product) {
            return Product.fromJson(
                product.id, product.data() as Map<String, dynamic>);
          }).toList(),
          lastItem: snapshot.docs.last
        );
      }
      return (list: <Product>[], lastItem: null);
    } catch (e) {
      print(e);
      return (list: <Product>[], lastItem: null);
    }
  }

  Future<Product?> getProduct(String docId) async {
    try {
      DocumentReference docRef = products.doc(docId);
      var product = await docRef.get();
      return Product.fromJson(docId, product.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<void> editProduct(Product product) async {
    try {
      await products.doc(product.docId).update(product.toMap());
    } catch (e) {
      return;
    }
  }

  Future<bool> deleteProduct(String docId) async {
    try {
      DocumentReference docRef = products.doc(docId);
      await docRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
