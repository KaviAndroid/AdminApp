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
     Future.delayed(Duration.zero, () {
       getVillageList();
     },);

    } catch (e) {
      e.printError();
    }
  }
  Future<void> getVillageList() async {
    villagelist.clear();
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_village_list_district_block_wise,
        AppStrings.key_dcode: await prefs.getString(AppStrings.key_dcode),
        AppStrings.key_bcode: await prefs.getString(AppStrings.key_bcode) ,
      };
      var decodedData;
      try {
        utils.showProgress();
        decodedData = await ApiServices().openServiceFunction("Village_LIST", jsonRequest);
      } catch (e) {
        Utils().showSnackBar("Unable to fetch response");
      } finally {
        utils.hideProgress();
      }
      if (decodedData != null && decodedData != "") {
        var status = decodedData[AppStrings.key_status];
        var responseValue = decodedData[AppStrings.key_response];

        if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
          if (decodedData[AppStrings.key_json_data].length > 0) {
            List<dynamic> sort_village = decodedData[AppStrings.key_json_data];
            sort_village.sort((a, b) {
              return a[AppStrings.key_pvname].compareTo(b[AppStrings.key_pvname]);
            });
            villagelist.addAll(sort_village);
          }
        } else if (status == AppStrings.key_ok && responseValue == AppStrings.key_noRecord) {
          Utils().showSnackBar(decodedData[AppStrings.key_message] ?? "No Village Found");
        }
      }
    } catch (e) {
      e.printError();
    }
  }


}
