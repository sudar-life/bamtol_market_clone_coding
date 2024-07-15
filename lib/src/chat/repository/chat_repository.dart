import 'dart:async';

import 'package:bamtol_market_app/src/chat/model/chat_group_model.dart';
import 'package:bamtol_market_app/src/chat/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRepository extends GetxService {
  late FirebaseFirestore db;
  ChatRepository(this.db);

  Future<ChatGroupModel?> loadChatInfo(String productId) async {
    var doc = await db
        .collection('chats')
        .where('productId', isEqualTo: productId)
        .get();
    if (doc.docs.isNotEmpty) {
      return ChatGroupModel.fromJson(doc.docs.first.data());
    }
    return null;
  }

  Future<void> submitMessage(String hostUid, ChatGroupModel chatGroupModel,
      ChatModel chatModel) async {
    var doc = await db
        .collection('chats')
        .where('chatters', arrayContains: chatModel.uid)
        .get();
    var results = doc.docs.where((data) {
      return data.id == chatGroupModel.productId;
    });
    if (results.isEmpty) {
      await db
          .collection('chats')
          .doc(chatGroupModel.productId)
          .set(chatGroupModel.toMap());
    } else {
      var chatters = results.first.data()['chatters'] as List<dynamic>;
      chatters.add(chatModel.uid!);
      await db.collection('chats').doc(chatGroupModel.productId).update({
        'chatters': chatters.toSet().toList(),
      });
    }
    db
        .collection('chats')
        .doc(chatGroupModel.productId)
        .collection(hostUid)
        .add(chatModel.toMap());
  }

  Stream<List<ChatModel>> loadChatInfoOneStream(
      String productDocId, String targetUid) {
    return db
        .collection('chats')
        .doc(productDocId)
        .collection(targetUid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .transform<List<ChatModel>>(
            StreamTransformer.fromHandlers(handleData: (docSnap, sink) {
      if (docSnap.docs.isNotEmpty) {
        var chatModels = docSnap.docs
            .map<ChatModel>((item) => ChatModel.fromJson(item.data()))
            .toList();
        sink.add(chatModels);
      }
    }));
  }

  Future<ChatGroupModel?> loadAllChats(String docId) async {
    var doc = await db.collection('chats').doc(docId).get();
    if (doc.exists) {
      return ChatGroupModel.fromJson(doc.data()!);
    }
    return null;
  }
}
