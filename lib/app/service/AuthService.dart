import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class AuthService extends GetxService {
  Future<AuthService> init() async => this;

  final RxBool isAuthorized = false.obs;

  void setIsPremium(bool newValue) {
    isAuthorized.value = newValue;
  }
}
