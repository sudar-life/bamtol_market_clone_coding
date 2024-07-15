import 'package:bamtol_market_app/src/chat/model/chat_group_model.dart';
import 'package:bamtol_market_app/src/chat/model/chat_model.dart';
import 'package:bamtol_market_app/src/chat/repository/chat_repository.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final ProductRepository _productRepository;

  ChatController(
      this._chatRepository, this._userRepository, this._productRepository);

  late String ownerUid;
  late String customerUid;
  late String productId;
  late String myUid;

  Rx<Product> product = const Product.empty().obs;
  Rx<UserModel> opponentUser = const UserModel().obs;
  Rx<ChatGroupModel> chatGroupModel = const ChatGroupModel().obs;
  late Stream<List<ChatModel>> chatStream;

  @override
  void onInit() {
    super.onInit();
    ownerUid = Get.parameters['ownerUid'] as String;
    customerUid = Get.parameters['customerUid'] as String;
    productId = Get.parameters['docId'] as String;
    myUid = Get.find<AuthenticationController>().userModel.value.uid ?? '';
    _loadProductInfo();
    _loadChatInfoStream(productId, customerUid);
    _loadChatInfo();
    _loadOpponentUser(ownerUid == myUid ? customerUid : ownerUid);
  }

  _loadChatInfoStream(String productId, String customUid) async {
    chatStream = _chatRepository.loadChatInfoOneStream(productId, customUid);
  }

  _loadChatInfo() async {
    var result = await _chatRepository.loadChatInfo(productId);
    if (result != null) {
      chatGroupModel(
          result.copyWith(chatters: [...result.chatters ?? [], myUid]));
    } else {
      chatGroupModel(
        ChatGroupModel(
          chatters: [ownerUid, customerUid],
          owner: ownerUid,
          productId: productId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  _loadOpponentUser(String oppenentUid) async {
    var userMode = await _userRepository.findUserOne(oppenentUid);
    if (userMode != null) {
      opponentUser(userMode);
    }
  }

  Future<void> _loadProductInfo() async {
    var result = await _productRepository.getProduct(productId);
    if (result != null) {
      product(result);
    }
  }

  submitMessage(String message) async {
    textController.text = '';
    chatGroupModel(chatGroupModel.value.copyWith(updatedAt: DateTime.now()));
    var newMessage =
        ChatModel(uid: myUid, text: message, createdAt: DateTime.now());

    await _chatRepository.submitMessage(
      customerUid,
      chatGroupModel.value,
      newMessage,
    );
  }
}
