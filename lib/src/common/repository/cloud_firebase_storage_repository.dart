import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CloudFirebaseRepository extends GetxService {
  final Reference storageRef;
  CloudFirebaseRepository(FirebaseStorage storage) : storageRef = storage.ref();

  Future<String> uploadFile(String mainPath, File file) async {
    var uuid = Uuid();
    final uploadTask =
        storageRef.child("products/$mainPath/${uuid.v4()}.jpg").putFile(file);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
