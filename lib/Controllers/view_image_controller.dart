import 'dart:convert';

import 'package:admin_app/Resources/strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Layouts/custom_alert.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
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
  String flag="";

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
      decodedData = await ApiServices().MainServiceFunction(flag=="edit"?"EditArticleApi":"AddArticleApi", map, "");
      if (decodedData != null && decodedData != "") {
        var msg = decodedData[AppStrings.key_msg];
        var message = decodedData[AppStrings.key_message];
        if (msg != null && msg ==true) {
          await getArticleApi();
        await utils.showAlert(AlertType.success, hintText: message, buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: (){
          Get.back();
          if(flag=="edit"){
            Get.back();
          }
        } )]);
      }
      }
    } catch (e) {
      Utils().showSnackBar("Unable to fetch response");
    } finally {
      utils.hideProgress();
    }
  }
  Future<void> getArticleApi() async {
    articleList.clear();
    Map<String, dynamic> map={
      AppStrings.key_service_id:AppStrings.service_key_get_articles,
    };
    var decodedData;
    try {
      utils.showProgress();
      decodedData = await ApiServices().MainServiceFunction("GetArticleApi", map, "");
      if (decodedData != null && decodedData != "") {
        var msg = decodedData[AppStrings.key_msg];
        var message = decodedData[AppStrings.key_message];
        if (msg != null && msg ==true) {
          articleList.assignAll(decodedData[AppStrings.key_json_data]);
      }
      }
    } catch (e) {
      Utils().showSnackBar("Unable to fetch response");
    } finally {
      utils.hideProgress();
    }
  }

}
