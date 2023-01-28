import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../routes/app_pages.dart';
import '../service/AuthService.dart';

class ChatGuard extends GetMiddleware {
  final authService = Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    return authService.isAuthorized.value
        ? null
        : const RouteSettings(name: Routes.HOME);
  }
}
