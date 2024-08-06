import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Layouts/custom_alert.dart';
import '../Resources/strings.dart';

import '../Services/api_services.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';

class HomeController extends GetxController {
  bool isEdit = false;
  List doctorslist = [];
  List filteredDoctorslist = [];
  bool searchenabled = false;
  final PreferenceService prefs = Get.find<PreferenceService>();
  Utils utils = Utils();


}
