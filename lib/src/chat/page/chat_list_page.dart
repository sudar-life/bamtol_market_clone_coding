import 'package:bamtol_market_app/src/chat/controller/chat_list_controller.dart';
import 'package:bamtol_market_app/src/chat/model/chat_play_info.dart';
import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/layout/common_layout.dart';
import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListPage extends StatefulWidget {
  final bool useBackBtn;
  const ChatListPage({super.key, this.useBackBtn = false});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    String? productId;
    if (Get.arguments != null) {
      productId = Get.arguments['productId'] as String?;
    }
    Get.find<ChatListController>().load(productId: productId);
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        title: const AppFont(
          '채팅',
          size: 20,
        ),
        leading: widget.useBackBtn
            ? GestureDetector(
                onTap: Get.back,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset('assets/svg/icons/back.svg'),
                ),
              )
            : Container(),
      ),
      body: const ChatScrollWidget(),
    );
  }
}

class ChatScrollWidget extends GetView<ChatListController> {
  const ChatScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: List.generate(
            controller.chatStreams.length,
            (index) => StreamBuilder<List<ChatDisplayInfo>>(
              stream: controller.chatStreams[index],
              builder: (context, snapshot) {
                var chats = snapshot;
                if (chats.hasData) {
                  return ChatSingleView(
                      message: chats.data?.last.chatModel!.text ?? '',
                      userUid: chats.data?.last.customerUid ?? '',
                      productId: chats.data?.last.productId ?? '',
                      time: chats.data?.last.chatModel!.createdAt ??
                          DateTime.now(),
                      onTap: () {
                        Get.toNamed(
                            '/chat/${chats.data?.last.productId}/${chats.data?.last.ownerUid}/${chats.data?.last.customerUid}');
                      });
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ChatSingleView extends GetView<ChatListController> {
  final String userUid;
  final String message;
  final String productId;
  final DateTime time;
  final Function() onTap;
  const ChatSingleView({
    super.key,
    required this.userUid,
    required this.message,
    required this.productId,
    required this.time,
    required this.onTap,
  });

  String timeagoValue(DateTime timeAt) {
    var value = timeago.format(
        DateTime.now().subtract(DateTime.now().difference(timeAt)),
        locale: 'ko');
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  Image.asset('assets/images/default_profile.png').image,
              backgroundColor: Colors.black,
              radius: 23,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<UserModel?>(
                    future: controller.loadUserInfo(userUid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            AppFont(
                              snapshot.data?.nickname ?? '',
                              size: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(width: 7),
                            AppFont(
                              timeagoValue(time),
                              size: 12,
                              color: const Color(0xffABAEB6),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  AppFont(
                    message,
                    size: 16,
                    maxLine: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            FutureBuilder<Product?>(
              future: controller.loadProductInfo(productId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      snapshot.data?.imageUrls?.first ?? '',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
