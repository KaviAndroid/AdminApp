import 'package:admin_app/Controllers/authendication_controller.dart';
import 'package:admin_app/Controllers/home_controller.dart';

import '../Services/preference_services.dart';
import 'package:get/get.dart';

import 'api_services.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PreferenceService());
    Get.put(ApiServices());

    Get.put(AuthendicationController());
    Get.put(HomeController());
  }
}
