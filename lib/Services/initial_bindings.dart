import '../Services/preference_services.dart';
import 'package:get/get.dart';

import 'api_services.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PreferenceService());
    Get.put(ApiServices());
  }
}
