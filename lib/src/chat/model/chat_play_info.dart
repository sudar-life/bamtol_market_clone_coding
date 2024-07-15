import 'package:bamtol_market_app/src/chat/model/chat_model.dart';

class ChatDisplayInfo {
  final String? ownerUid;
  final String? customerUid;
  final bool? isOwner;
  final String? productId;
  final ChatModel? chatModel;
  const ChatDisplayInfo({
    this.chatModel,
    this.isOwner,
    this.productId,
    this.customerUid,
    this.ownerUid,
  });
}
