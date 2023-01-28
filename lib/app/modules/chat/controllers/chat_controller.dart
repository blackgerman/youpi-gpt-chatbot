import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/app/Utils.dart';
import 'package:front_end/app/data/RestClient.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  var data = [].obs;

  var token;

  var logger = Logger();

  final dio = Dio(); // Provide a dio instance

  var error = false.obs;

  var isQuestionLoading = false.obs;

  var isPageLoading = false.obs;

  var isMoreLoading = false.obs;

  static var messageController = TextEditingController().obs;

  var listController = ScrollController().obs;

  var textfieldNode = FocusNode().obs;

  int pageSize = 10;

  int offset = 0;

  var lastTimeReachedTop = DateTime.now().add(const Duration(seconds: 30)).obs;

  @override
  void onInit() {
    super.onInit();
    try {
      token = Get.arguments["token"];
    } catch (_) {
      print(_);
      token = getRandomString(32);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("identity", token);
      });
    }
  }

  void clearData() {
    Get.dialog(
      AlertDialog(
        title: const Text('Alert'),
        content: const Text(
          'This action will clear all you questions and'
          ' answers. Are you sure you want to delete them?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              child: const Text("Yes",
                  style: TextStyle(fontSize: 16, color: Colors.red)),
              onPressed: () {
                Get.back();
                /* ==== FIREBASE LOG */
                FirebaseAnalytics analytics = FirebaseAnalytics.instance;
                analytics.logEvent(
                    name: "Clear All Data", parameters: {"token": token});
                /*  == FIREBASE LOG == */
                token = getRandomString(32);
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setString("identity", token);
                  /* reload data */
                  reload();
                });
              }),
          TextButton(
            child: const Text("NO", style: TextStyle(fontSize: 16)),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
    loadChatData();
    textfieldNode.value.addListener(() {
      if (textfieldNode.value.hasFocus) {
        scrollDown(delay: 800);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  // request to automatically generate objects
  // flutter pub run build_runner build

  void askQuestion(String languageCode, String question) {
    if (isQuestionLoading.value) return;
    isQuestionLoading.value = true;
    final client = RestClient(dio);
    Question q = Question(
        username: token,
        language: languageCode,
        question: question,
        createDateTime: DateTime.now());
    addQuestionWithoutAnswer(q);
    messageController.value.text = "";
    error.value = false;
    /* ==== FIREBASE LOG */
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics
        .logEvent(name: "Asking question", parameters: {"question": question});
    /*  == FIREBASE LOG == */
    client.askQuestion(q).then((value) {
      Answer answer = value;
      data.value.removeLast(); // remove temp
      //  message no more loading
      data.value.add(answer);
      data.refresh();
      isQuestionLoading.value = false;
      scrollDown();
    }).catchError((onError) {
      print(onError);
      /* ==== FIREBASE LOG */
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics.logEvent(name: "AQ Error", parameters: {"error": onError});
      /*  == FIREBASE LOG == */
      /* add error */
      Answer errorAnswer = Answer(
          question: q,
          answer: 'network_error'.tr,
          createDateTime: DateTime.now());
      data.value.removeLast(); // remove temp
      data.value.add(errorAnswer);
      data.refresh();
      isQuestionLoading.value = false;
    });
  }

  reload() {
    loadChatData();
  }

  Future<void> loadChatData() async {
    final client = RestClient(dio);
    if (isPageLoading.value) return;
    isPageLoading.value = true;
    error.value = false;
    // await Future.delayed(Duration(seconds: 5));
    client.getAnswers(pageSize, 0, token).then((it) {
      /* we can append later*/
      data.value = it;
      /**/
      isPageLoading.value = false;
      Future.delayed(Duration(milliseconds: 300), () {
        scrollDown();
      });
    }).catchError((onError) {
      /* ==== FIREBASE LOG */
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics
          .logEvent(name: "LoadChats Error", parameters: {"error": onError});
      /*  == FIREBASE LOG == */
      error.value = true;
      /* show error */
      isPageLoading.value = false;
    });
  }

  sendMessage() {
    var text = messageController.value.text;
    text = text.trim();
    if (text.length < 2) {
      return;
    }
    // debugPrint("ask -> $text");
    askQuestion(Get.deviceLocale!.languageCode, text);
  }

  void scrollDown({int delay = 0}) {
    try {
      if (listController.value.hasClients)
        Future.delayed(Duration(milliseconds: delay), () {
          listController.value.animateTo(
              listController.value.position.maxScrollExtent + 500,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
        });
    } catch (_) {
      print(_);
      /* try again one second later */
    }
  }

  void addQuestionWithoutAnswer(Question q) {
    Answer w = new Answer(
        id: -1, question: q, answer: "", createDateTime: DateTime.now());
    data.value.add(w);
    data.refresh();
    scrollDown();
  }
}
