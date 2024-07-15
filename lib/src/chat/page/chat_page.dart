import 'package:bamtol_market_app/src/chat/controller/chat_controller.dart';
import 'package:bamtol_market_app/src/chat/model/chat_model.dart';
import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/user_temperature_widget.dart';
import 'package:bamtol_market_app/src/common/layout/common_layout.dart';
import 'package:bamtol_market_app/src/common/utils/data_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppFont(
                controller.opponentUser.value.nickname ?? '',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 6),
              UserTemperatureWidget(
                temperature: controller.opponentUser.value.temperature ?? 0,
                isSimpled: true,
              )
            ],
          ),
        ),
        actions: const [
          SizedBox(width: 50),
        ],
      ),
      body: Column(
        children: [
          _HeaderItemInfo(),
          Expanded(
            child: _ChatBody(),
          ),
          _TextFieldWidget(),
          KeyboardVisibilityBuilder(builder: (context, visible) {
            return SizedBox(
                height: visible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : Get.mediaQuery.padding.bottom);
          }),
        ],
      ),
    );
  }
}

class _ChatBody extends GetView<ChatController> {
  const _ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: StreamBuilder<List<ChatModel>>(
        stream: controller.chatStream,
        builder: (context, snapshot) {
          var useProfileImage = false;
          String lastDateYYYYMMDD = '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              snapshot.data?.length ?? 0,
              (index) {
                var chat = snapshot.data![index];
                var isMine = chat.uid == controller.myUid;
                var messageGroupWidget = <Widget>[];
                var currentDateYYYMMDD =
                    DateFormat('yyyyMMdd').format(chat.createdAt!);
                if (!useProfileImage && !isMine) {
                  useProfileImage = true;
                  messageGroupWidget.add(CircleAvatar(
                    backgroundImage:
                        Image.asset('assets/images/default_profile.png').image,
                    backgroundColor: Colors.black,
                    radius: 18,
                  ));
                } else if (!isMine) {
                  messageGroupWidget.add(const SizedBox(
                    width: 36,
                  ));
                }
                messageGroupWidget.add(_MessageBox(
                  date: chat.createdAt ?? DateTime.now(),
                  isMine: isMine,
                  message: chat.text ?? '',
                ));
                useProfileImage = !isMine;
                return Column(
                  children: [
                    Builder(
                      builder: (context) {
                        if (lastDateYYYYMMDD == '' ||
                            lastDateYYYYMMDD != currentDateYYYMMDD) {
                          lastDateYYYYMMDD = currentDateYYYMMDD;
                          return _ChatDateView(dateTime: chat.createdAt!);
                        }
                        return Container();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: messageGroupWidget),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ChatDateView extends StatelessWidget {
  final DateTime dateTime;
  const _ChatDateView({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 15),
      child: Center(
        child: AppFont(
          DateFormat('yyyy년 MM월 dd일').format(dateTime),
          size: 13,
          color: const Color(0xff6D7179),
        ),
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  final bool isMine;
  final String message;
  final DateTime date;
  const _MessageBox({
    super.key,
    this.isMine = false,
    required this.date,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMine)
            SizedBox(
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppFont(
                    DateFormat('HH:mm').format(date),
                    color: const Color(0xff6D7179),
                    size: 12,
                  )
                ],
              ),
            ),
          const SizedBox(width: 10),
          Container(
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: Get.width * 0.7),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isMine ? const Color(0xffED7738) : const Color(0xff2B2E32),
            ),
            child: AppFont(
              message,
              maxLine: null,
            ),
          ),
          const SizedBox(width: 10),
          if (!isMine)
            SizedBox(
                width: 50,
                child: Row(
                  children: [
                    AppFont(
                      DateFormat('HH:mm').format(date),
                      color: const Color(0xff6D7179),
                      size: 12,
                    ),
                  ],
                )),
        ],
      ),
    );
  }
}

class _TextFieldWidget extends GetView<ChatController> {
  const _TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xff696D75)),
                hintText: '메세지 보내기',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                fillColor: Color(0xff2B2E32),
              ),
              maxLines: null,
              onSubmitted: controller.submitMessage,
            ),
          ),
          GestureDetector(
            onTap: () async {
              controller.submitMessage(controller.textController.text);
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
                padding: const EdgeInsets.all(7),
                child: SvgPicture.asset('assets/svg/icons/icon_sender.svg')),
          )
        ],
      ),
    );
  }
}

class _HeaderItemInfo extends GetView<ChatController> {
  const _HeaderItemInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: controller.product.value.imageUrls?.first == null
                  ? Container()
                  : CachedNetworkImage(
                      imageUrl: controller.product.value.imageUrls?.first ?? '',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppFont(
                        controller.product.value.status!.name,
                        size: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 5),
                      AppFont(
                        controller.product.value.title ?? '',
                        size: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  AppFont(
                    controller.product.value.productPrice == 0
                        ? '무료나눔'
                        : '${NumberFormat('###,###,###,###').format(controller.product.value.productPrice ?? 0)}원',
                    size: 16,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
