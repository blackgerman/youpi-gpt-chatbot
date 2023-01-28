import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:front_end/constant.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 40,
              left: 10,
              child: InkWell(
                onTap: () => contactDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(30),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'contact'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Obx(() => controller.isLoading.value
                      ? Container(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                              color: AColors.primaryColor))
                      : Container(
                          width: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image:
                                              Image.asset(ImageAsset.app_icon)
                                                  .image))),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 300.0,
                                    child: Center(
                                      child: DefaultTextStyle(
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Lato',
                                          color: Colors.orange,
                                        ),
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                                'youpi_home_page_presentation_1'
                                                    .tr),
                                            TypewriterAnimatedText(
                                                'youpi_home_page_presentation_2'
                                                    .tr),
                                            TypewriterAnimatedText(
                                                'youpi_home_page_presentation_3'
                                                    .tr),
                                          ],
                                          repeatForever: true,
                                          pause: Duration(seconds: 2),
                                          onTap: () {
                                            print("Tap Event");
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 20,
                                        bottom: 20),
                                    child: Center(
                                      child: TextField(
                                          controller: controller
                                              .phoneNumberController.value,
                                          decoration: InputDecoration.collapsed(
                                              hintText: 'home_pn'.tr),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          color: AColors.primaryColor,
                                          width: 300,
                                          padding: const EdgeInsets.only(
                                              left: 40,
                                              right: 40,
                                              top: 20,
                                              bottom: 20),
                                          child: Center(
                                              child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'home_confirm'.tr,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.white,
                                              )
                                            ],
                                          )),
                                        ),
                                        onTap: () =>
                                            controller.confirmPhoneNumber(),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'home_provide_pn'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  controller.isLoading.value
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () => controller.skip(),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withAlpha(30),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 30),
                                                  margin: EdgeInsets.only(
                                                      bottom: 40),
                                                  child: Text(
                                                    'home_skip'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              /*  Text(
                                'Token is \n\n ${controller.identityToken}',
                                style: TextStyle(fontSize: 20),
                              ),*/
                            ],
                          ),
                        )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  contactDialog() {
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
