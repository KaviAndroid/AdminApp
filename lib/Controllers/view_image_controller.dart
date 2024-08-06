import 'dart:convert';

import 'package:admin_app/Resources/strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Layouts/custom_alert.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';

class ViewImageController extends GetxController {
  Utils utils = Utils();
  final PreferenceService prefs = Get.find<PreferenceService>();

  RxBool shimmerLoading = false.obs;
  List imageList = [];
  RxList articleList = [].obs;

  Map arguments = {};
  String description="";
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
      imageList.add({AppStrings.key_image:file.path});
    }
  }

}
