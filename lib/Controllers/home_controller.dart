import 'dart:convert';

import 'package:get/get.dart';
import '../Resources/strings.dart';

import '../Services/api_services.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';

class HomeController extends GetxController {
  bool isEdit = false;
  List villagelist = [];
  final PreferenceService prefs = Get.find<PreferenceService>();
  Utils utils = Utils();
  HomeController() {
    initialize();
  }

  Future<void> initialize() async {
    try {

    } catch (e) {
      e.printError();
    }
  }


}
