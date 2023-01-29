import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:front_end/app/modules/chat/controllers/chat_controller.dart';
import 'package:front_end/constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatBubbleWidget extends StatelessWidget {
  String message;

  DateTime time = DateTime.now();

  bool isCustomerMessage;

  bool isLoading;

  ChatBubbleWidget(
      {this.message = "",
      required this.time,
      this.isCustomerMessage = true,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    //  check if message is message contains a string that matches a regex
    return GestureDetector(
      onTap: () => ChatController.messageController.value.text = message,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: Random().nextBool()
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              this.isCustomerMessage
                  ? Expanded(flex: 3, child: Container())
                  : Expanded(flex: 0, child: Container()),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: this.isCustomerMessage
                            ? AColors.userMessageLight
                            : AColors.botMessageLight,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        this.isLoading
                            ? const CardLoading(
                                cardLoadingTheme: CardLoadingTheme(
                                    colorOne: Color(0x11E5E5E5),
                                    colorTwo: Color(0x22AAAAAA)),
                                height: 30,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                margin: EdgeInsets.only(bottom: 10),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: SelectableText(
                                    "${this.message}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: this.isCustomerMessage
                                            ? Colors.black
                                            : Colors.black),
                                  )),
                                ],
                              ),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                  child: SelectableText(
                                "${convertDateTimeToString(this.time)}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: this.isCustomerMessage
                                        ? Colors.grey
                                        : Colors.grey),
                              )),
                            ])
                      ],
                    ),
                  ),
                ),
              ),
              this.isCustomerMessage
                  ? Expanded(flex: 0, child: Container())
                  : Expanded(flex: 2, child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  convertDateTimeToString(DateTime time) {
    /* this is utc time, take phone time to work with. */
    time = time.toLocal();

    // var format = DateFormat.yMEd().format(time);
    String formattedDate = "";
    var now = DateTime.now();
    if (time.month == now.month && time.year == now.year) {
      if (time.day == now.day) {
        formattedDate = 'chat_today'.tr;
      } else if (time.day + 1 == now.day) {
        formattedDate = 'chat_yesterday'.tr;
      }
    } else {
      formattedDate = DateFormat('yyyy-MM-d').format(time);
    }

    String formattedTime = DateFormat().add_jm().format(time);
    return "$formattedDate $formattedTime";
  }
}
