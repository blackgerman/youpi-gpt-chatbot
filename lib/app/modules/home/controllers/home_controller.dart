import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:front_end/app/Utils.dart';
import 'package:front_end/app/intl/messages.dart';
import 'package:front_end/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var identityToken = "".obs;

  final isLoading = true.obs;

  var phoneNumberController = TextEditingController().obs;

  var translations = Messages().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    /* load from sps if exists */
    isLoading.value = true;
    loadSharedPreferences().then((value) {
      /* is ok */
      identityToken.value = value!;
      /* show chat gpt animation */
      /* go the next page, */
      if (identityToken.value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed("/chat", arguments: {"token": identityToken.value});
        });
      } else {
        isLoading.value = false;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<String?> loadSharedPreferences() async {
    try {
      // await Future.delayed(Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("identity")!;
      return token;
    } catch (_) {
      return "";
    }
  }

  skip() async {
    // create random number and pass
    /* generate and save */
    /* ==== FIREBASE LOG */
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(name: "Skip phone number");
    /*  == FIREBASE LOG == */
    SharedPreferences.getInstance().then((prefs) {
      String token = getRandomString(32);
      prefs.setString("identity", token);
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed("/chat", arguments: {"token": identityToken.value});
      });
    });
  }

  confirmPhoneNumber() {
    var phoneNumber = phoneNumberController.value.text;
    /* confirm as number and save locally */
    /* ==== FIREBASE LOG */
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.logEvent(
        name: "Providing phone number", parameters: {"pn": phoneNumber});
    /*  == FIREBASE LOG == */
    SharedPreferences.getInstance().then((prefs) {
      if (phoneNumber.length < 6) phoneNumber = getRandomString(32);
      prefs.setString("identity", phoneNumber);
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed("/chat", arguments: {"token": identityToken.value});
      });
    });
  }
}
