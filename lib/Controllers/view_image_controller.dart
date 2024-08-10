import 'dart:convert';

import 'package:admin_app/Resources/strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Layouts/custom_alert.dart';
import '../Services/api_services.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';

class ViewImageController extends GetxController {
  Utils utils = Utils();
  final PreferenceService prefs = Get.find<PreferenceService>();

  RxBool shimmerLoading = false.obs;
  List imageList = [];
  RxList articleList = [].obs;

  Map arguments = {};
  String content="";
  String title="";
  String amount="";

  void updateShimmer() {
    shimmerLoading.value = !shimmerLoading.value;
  }
  Future<void> captureImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);
    Get.back();

    if (file == null) {
      utils.showSnackBar("User Cancelled Opeartion", type: AlertType.warning);
    } else {
      imageList.clear();
      imageList.add({AppStrings.key_image:file.path});
    }
  }

  Future<void> addArticleApi(Map<String, dynamic> map) async {
    var decodedData;
    try {
      utils.showProgress();
      decodedData = await ApiServices().MainServiceFunction("addArticleApi", map, "");
      if (decodedData != null && decodedData != "") {
        var STATUS = decodedData[AppStrings.key_status];
        var RESPONSE = decodedData[AppStrings.key_response];
        dynamic KEY;
        dynamic user_data;
      }
    } catch (e) {
      Utils().showSnackBar("Unable to fetch response");
    } finally {
      utils.hideProgress();
    }
  }

}
