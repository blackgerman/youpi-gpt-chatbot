import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:front_end/app/data/RestClient.dart';
import 'package:front_end/app/widget/ChatBubbleWidget.dart';
import 'package:front_end/constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetWidget<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.clear_all, color: Colors.white),
              onPressed: () => controller.clearData()),
          automaticallyImplyLeading: false,
          backgroundColor: AColors.primaryColor,
          title: Text('chat_title'.tr),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  accountInfo();
                },
                icon: Icon(
                  Icons.info,
                  color: Colors.white,
                )),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () => controller.reload(),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset(ImageAsset.bg).image, fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Obx(() => controller.isPageLoading.value
              ? LoadingPage()
              : controller.error.value
                  ? ErrorPage(() => controller.reload())
                  : Stack(children: [
                      /* list of chats */
                      Obx(() => controller.data.value.length == 0
                          ? NoMessagePage()
                          : NotificationListener(
                              child: ListView.builder(
                                  controller: controller.listController.value,
                                  itemCount: controller.data.value.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    /* if new day break, then insert a date */
                                    if (index == controller.data.value.length)
                                      return Container(height: 80);
                                    return ChatDialogWidget(
                                        controller.data.value[index]);
                                  }),
                              onNotification: (ScrollNotification t) {
                                if (t.metrics.atEdge) {
                                  if (t.metrics.pixels == 0) {
                                    // print('At top');
                                    if (controller.data.value.length > 5) {
                                      if (DateTime.now()
                                              .difference(controller
                                                  .lastTimeReachedTop.value)
                                              .inSeconds <
                                          30) {
                                        return true;
                                      }
                                      controller.lastTimeReachedTop.value =
                                          DateTime.now();
                                      AlertController.show(
                                          'chat_alert'.tr,
                                          'chat_latest_history_reached'.tr,
                                          TypeAlert.warning,
                                          null);
                                    }
                                  } else {
                                    // print('At bottom');
                                  }
                                }
                                return true;
                              })),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: controller.error.value ||
                                controller.isPageLoading.value
                            ? Container()
                            : Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            /*  height: 80,*/
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.only(
                                                  left: 8,
                                                  right:
                                                      (25 /*bcs of button */ +
                                                              8 +
                                                              20)
                                                          .toDouble(),
                                                  top: 14,
                                                  bottom: 14 /*16*/),
                                              child: TextField(
                                                  controller: ChatController
                                                      .messageController.value,
                                                  focusNode: controller
                                                      .textfieldNode.value,
                                                  maxLines: 5,
                                                  minLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                    hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                    hintText:
                                                        'chat_pls_insert_message'
                                                            .tr,
                                                  )),
                                            )),
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () => controller.sendMessage(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AColors.primaryColor,
                                                shape: BoxShape.circle),
                                            padding: const EdgeInsets.all(20),
                                            child: Center(
                                              child: controller
                                                      .isQuestionLoading.value
                                                  ? const SizedBox(
                                                      height: 15,
                                                      width: 15,
                                                      child: CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors
                                                                      .white)))
                                                  : const Icon(Icons.send,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 15,
                                      right: 90,
                                      child: InkWell(
                                        onTap: () {
                                          ChatController.messageController.value
                                              .text = "";
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withAlpha(40),
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.clear_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                      )
                    ])),
        ));
  }

  void accountInfo() {
    /* load account info and show it in a dialog */
    Get.dialog(
      AlertDialog(
        title: Text('info'.tr.capitalize!),
        content: Text(
          'contact_presentation'.tr,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              child:   Text('ok'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.red)),
              onPressed: () {
                Get.back();
                /* ==== FIREBASE LOG */
                FirebaseAnalytics analytics = FirebaseAnalytics.instance;
                analytics.logEvent(name: "Contact");
              }),
        ],
      ),
    );
  }
}

class NoMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(LottieAsset.ask_question)),
                SizedBox(
                  height: 20,
                ),
                Text('chat_info'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(LottieAsset.loading_pacman)),
                SizedBox(
                  height: 10,
                ),
                Text('chat_loading_history'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  Function refresh;

  ErrorPage(this.refresh);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(LottieAsset.robot_error)),
                SizedBox(
                  height: 20,
                ),
                Text('chat_pls_refresh'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                SizedBox(height: 20),
                GestureDetector(
                    onTap: () => refresh(),
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text(
                          'refresh'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5)))),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDialogWidget extends StatelessWidget {
  Answer value;

  ChatDialogWidget(this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatBubbleWidget(
            message: value.question!.question!,
            time: value.question!.createDateTime!,
            isCustomerMessage: true),
        value.id != -1
            ? Column(children: [
                ChatBubbleWidget(
                    message: value.answer!,
                    time: value.createDateTime!,
                    isCustomerMessage: false),
              ])
            : ChatBubbleWidget(
                isLoading: true,
                isCustomerMessage: false,
                time: DateTime.now(),
              )
      ],
    );
  }
}
