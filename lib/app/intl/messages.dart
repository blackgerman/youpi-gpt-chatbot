import 'package:get/get.dart';

import 'languages.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": En().messages,
        "zh_CN": Zh().messages,
        "fr_FR": Fr().messages,
      };
}
