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
                              Text(
                                'home_provide_pn'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 30,
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
                                  SizedBox(height: 100),
                                  controller.isLoading.value
                                      ? Container()
                                      : GestureDetector(
                                        onTap: () => controller.skip(),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.withAlpha(30),
                                                    borderRadius: BorderRadius.circular(10)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15, horizontal: 30),
                                                margin: EdgeInsets.only(bottom: 40),
                                                child: Text(
                                                  'home_skip'.tr,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
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
}
