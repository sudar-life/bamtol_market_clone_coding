import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  FirebaseFirestore db;
  UserRepository(this.db);

  Future<UserModel?> findUserOne(String uid) async {
    try {
      var doc = await db.collection('users').where('uid', isEqualTo: uid).get();
      if (doc.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(doc.docs.first.data());
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkDuplicationNickName(String nickname) async {
    try {
      var doc = await db
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .get();
      return doc.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String?> signup(UserModel user) async {
    try {
      var result = await db.collection('users').add(user.toJson());
      return result.id;
    } catch (e) {
      return null;
    }
  }
}
