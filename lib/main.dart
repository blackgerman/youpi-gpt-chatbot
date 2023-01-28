import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:front_end/app/intl/messages.dart';
import 'package:front_end/app/service/AuthService.dart';

import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /* add auth service */
  await Get.putAsync(() => AuthService().init());

  runApp(
    GetMaterialApp(
      title: "Youpi GPT",
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', "EN"),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      builder: (context, widget) => ResponsiveWrapper.builder(
          Stack(
            children: [widget!, DropdownAlert()],
          ),
          maxWidth: 480,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            // ResponsiveBreakpoint.autoScale(800, name: TABLET),
            // ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
    ),
  );
}
