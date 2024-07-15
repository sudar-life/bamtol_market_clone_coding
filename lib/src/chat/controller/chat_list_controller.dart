import 'dart:async';

import 'package:bamtol_market_app/src/chat/model/chat_group_model.dart';
import 'package:bamtol_market_app/src/chat/model/chat_play_info.dart';
import 'package:bamtol_market_app/src/chat/repository/chat_repository.dart';
import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  final ChatRepository _chatRepository;
  final ProductRepository _productRepository;
  final UserRepository _userRepository;
  final String myUid;
  ChatListController(
    this._chatRepository,
    this._productRepository,
    this._userRepository,
    this.myUid,
  );

  final RxList<Stream<List<ChatDisplayInfo>>> chatStreams =
      <Stream<List<ChatDisplayInfo>>>[].obs;

  void load({String? productId}) {
    chatStreams.clear();
    if (productId == null) {
      _loadMyAllChatList();
    } else {
      _loadAllProductChatList(productId);
    }
  }

  void _loadMyAllChatList() async {
    var results = await _chatRepository.loadAllChatGroupModelWithMyUid(myUid);
    if (results != null) {
      chatStreams.clear();
      results.forEach(
        (result) {
          loadChatInfoStream(result);
        },
      );
    }
  }

  void _loadAllProductChatList(String productId) async {
    var result = await _chatRepository.loadChatInfo(productId);
    if (result != null) {
      loadChatInfoStream(result);
    }
  }

  void loadChatInfoStream(ChatGroupModel info) async {
    info.chatters?.forEach((chatDoc) {
      var chatStreamData = _chatRepository
          .loadChatInfoOneStream(info.productId ?? '', chatDoc)
          .transform<List<ChatDisplayInfo>>(
        StreamTransformer.fromHandlers(
          handleData: (docSnap, sink) {
            if (docSnap.isNotEmpty) {
              var chatModels = docSnap
                  .map<ChatDisplayInfo>((item) => ChatDisplayInfo(
                        ownerUid: info.owner,
                        customerUid: chatDoc,
                        isOwner: info.owner == myUid,
                        productId: info.productId,
                        chatModel: item,
                      ))
                  .toList();
              sink.add(chatModels);
            }
          },
        ),
      );
      chatStreams.add(chatStreamData);
    });
  }

  Future<UserModel?> loadUserInfo(String uid) async {
    return await _userRepository.findUserOne(uid);
  }

  Future<Product?> loadProductInfo(String productId) async {
    return await _productRepository.getProduct(productId);
  }
}
