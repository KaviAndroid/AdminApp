import 'dart:convert';
import 'dart:developer';

import 'package:admin_app/Activity/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Layouts/custom_alert.dart';
import '../Layouts/otp_structure.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/strings.dart';
import '../Services/api_services.dart';
import '../Services/preference_services.dart';
import '../Services/routes_services.dart';
import '../Services/utils.dart';
import '../models/registration_model.dart';

class AuthendicationController extends GetxController {
  final PreferenceService pref = Get.find<PreferenceService>();
  final GlobalKey<FormBuilderState> formkey = GlobalKey<FormBuilderState>();

  TextEditingController mobile = TextEditingController();

  RxBool isShowPassword = false.obs;
  RxBool otpPostionedAnimation = false.obs;
  RxBool otpFadeInAnimation = false.obs;
  RxBool btnBtnClicked = false.obs;

  bool versionErrorFlag = false;
  bool otpVerifiedFlag = false;

  String flag = '';
  String finalOTP = '';
  String mobile_no = '';

  RxString otpText = ''.obs;
  RxString profileImagePath = ''.obs;
  RxString titleText = ''.obs;
  RxString forgotMobileNo = ''.obs;


  RxDouble initialChildSize = 0.4.obs;

  Utils utils = Utils();

  AuthendicationController() {
    titleText.value = "registration".tr;
  }

  Future<bool> reBuildUI() async {
    bool flag = true;
    if (otpFadeInAnimation.value) {
      if (otpVerifiedFlag)
        flag = true;
      else
        await utils.showAlert(AlertType.warning, hintText: 'otp_quit'.tr, buttons: [
          UIHelper().actionButton(AppColors.black, "Yes", reducewidth: 4, onPressed: () {

            profileImagePath = ''.obs;

            isShowPassword = false.obs;
            otpPostionedAnimation = false.obs;
            btnBtnClicked = false.obs;
            otpFadeInAnimation = false.obs;
            Get.back();
            flag = true;
          }),
          UIHelper().actionButton(AppColors.black, "No", reducewidth: 4, onPressed: () {
            Get.back();
            flag = false;
          })
        ]);
    }
    return flag;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if (GetPlatform.isAndroid) {
      var sdkInt = await utils.invokeMethoedChannel(AppSetings.getAndroidVersion);
      sdkInt < 28 ? versionErrorFlag = true : versionErrorFlag = false;
    }
  }


  Future<void> verifyPersonalDetails(bool isRegister) async {
    if (!btnBtnClicked.value) {
      btnBtnClicked.value = true;

      if (finalOTP.isNotEmpty && finalOTP.length == 6) {
        var request = {
          AppStrings.key_service_id:  AppStrings.service_key_verifyOtp,
          AppStrings.key_mobile_otp: finalOTP,
          AppStrings.key_mobile: mobile_no,
        };
        var decodedData = await ApiServices().openServiceFunction("VERIFY OTP", request);

        if (decodedData != null && decodedData != "") {
          var status = decodedData[AppStrings.key_status];
          var responseValue = decodedData[AppStrings.key_response];
          var message = decodedData[AppStrings.key_message];

          if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
            otpVerifiedFlag = true;
            btnBtnClicked.value = false;
            if (isRegister) {
              Get.back();
            } else {
              Get.to(() => Homepage());
            }

            utils.showSnackBar(message, type: AlertType.success, durations: Duration(seconds: 3));
          } else {
            utils.showSnackBar(message);
          }
        }
      }
      btnBtnClicked.value = false;
    }
  }

  Future<void> resendOTP() async {
    var request = {
      AppStrings.key_service_id:  AppStrings.service_key_resendOtp,
      AppStrings.key_mobile: mobile_no,
    };
    var decodedData;
    try {
      utils.showProgress();
      decodedData = await ApiServices().openServiceFunction("RESEND OTP", request);
    } catch (e) {
      Utils().showSnackBar("Unable to fetch response");
    } finally {
      utils.hideProgress();
    }
    if (decodedData != null && decodedData != "") {
      var status = decodedData[AppStrings.key_status];
      var responseValue = decodedData[AppStrings.key_response];
      var message = decodedData[AppStrings.key_message];

      if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
        utils.showSnackBar(message, type: AlertType.success);
      } else {
        utils.showSnackBar(message);
      }
    }
  }

  Future<void> updatePassword(String pass) async {
    var request = {AppStrings.key_service_id: "forgotPassword", AppStrings.key_mobile: mobile_no, AppStrings.key_mobile_otp: finalOTP, "new_password": pass, "confirm_password": pass};
    var decodedData;
    try {
      utils.showProgress();
      decodedData = await ApiServices().openServiceFunction("UPDATE PASSWORD", request);
    } catch (e) {
      Utils().showSnackBar("Unable to fetch response");
    } finally {
      utils.hideProgress();
    }
    if (decodedData != null && decodedData != "") {
      var status = decodedData[AppStrings.key_status];
      var responseValue = decodedData[AppStrings.key_response];
      var message = decodedData[AppStrings.key_message];

      if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
        utils.showSnackBar(message, type: AlertType.success);
        Get.offNamedUntil(Routes.signin, (p) => false);
      } else {
        utils.showSnackBar(message);
      }
    }
  }

  Future<void> savePersonalDetails() async {
    if (!btnBtnClicked.value) {
      btnBtnClicked.value = true;
      formkey.currentState!.saveAndValidate();
      Map<String, Object?> postParams = Map.from(formkey.currentState!.value);
      RegistrationModel modelList = RegistrationModel.fromMap(postParams).copyWith(profile_path: profileImagePath.value);

      if (modelList.profile_path == '' || modelList.profile_path == 'null') {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"capture_image".tr}");
        return;
      } else if (modelList.name.trim() == '' || modelList.name.trim() == 'null' || !utils.isNameValid(modelList.name.trim())) {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"enter_name".tr}");
        return;
      } else if (modelList.gender_code == '' || modelList.gender_code == 'null') {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"select_gender".tr}");
        return;
      } else if (modelList.mobile.trim() == '' || modelList.mobile.trim() == 'null' || !utils.isNumberValid(modelList.mobile.trim())) {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"enter_mobile".tr}");
        return;
      } else if (modelList.email.trim() == '' || modelList.email.trim() == 'null' || !utils.isEmailValid(modelList.email.trim())) {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"enter_email".tr}");
        return;
      } else if (modelList.localbody_code == '' || modelList.localbody_code == 'null') {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"enter_level".tr}");
        return;
      } else if (modelList.desig_code == '' || modelList.desig_code == 'null') {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"enter_designation".tr}");
        return;
      } else if ((modelList.dcode == '' || modelList.dcode == 'null') && (modelList.localbody_code == "D" || modelList.localbody_code == "B")) {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"select_district".tr}");
        return;
      } else if ((modelList.bcode == '' || modelList.bcode == 'null') && modelList.localbody_code == "B") {
        btnBtnClicked.value = false;
        utils.showSnackBar("${"please".tr} ${"select_block".tr}");
        return;
      } else {
        var decodedData = await ApiServices().openServiceFunction("REGISTER", modelList.toUpload());

        if (decodedData != null && decodedData != "") {
          var status = decodedData[AppStrings.key_status];
          var responseValue = decodedData[AppStrings.key_response];
          var message = decodedData[AppStrings.key_message];
          btnBtnClicked.value = false;

          if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
            otpText.value =
                pref.selectedLanguage == 'ta' ? " ${utils.getOTPSecuredText(modelList.mobile)}${"otp_sent_message".tr} " : " ${"otp_sent_message".tr} ${utils.getOTPSecuredText(modelList.mobile)}";
            mobile_no = modelList.mobile;
            otpPostionedAnimation.value = true;
            Future.delayed(
              Durations.medium4,
              () => utils.showSnackBar(message, type: AlertType.success, durations: Duration(seconds: 3)),
            );
            Future.delayed(
              Durations.extralong1,
              () => otpFadeInAnimation.value = true,
            );
          } else if (status == AppStrings.key_fail || responseValue == AppStrings.key_fail) {
            utils.showSnackBar(message, type: AlertType.fail, durations: Duration(seconds: 3));
          }
        }
        btnBtnClicked.value = false;
      }
    }
  }

  Future<void> login(BuildContext context) async {
    String ss = String.fromCharCodes(Runes('\u0024'));
    /*username.text = "nursery14";
    password.text = "test123#$ss";*/
    if (mobile.text.isNotEmpty) {
    if (await utils.isOnline()) {
      if (!versionErrorFlag) {
        loginApi(context);
      } else {
        utils.showAlert(AlertType.fail, hintText: 'this_App_is_working_only_on_android_version_9_above'.tr, buttons: [UIHelper().actionButton(AppColors.black, "OK")]);
      }
    } else {
      Utils().showSnackBar("no_internet".tr, type: AlertType.warning);
    }
    } else {
      Utils().showSnackBar('user_name_empty'.tr, type: AlertType.warning);
    }
  }

  Future<void> captureImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);
    Get.back();

    if (file == null) {
      utils.showSnackBar("User Cancelled Opeartion", type: AlertType.warning);
    } else {
      profileImagePath.value = file.path;
    }
  }

  Future<dynamic> loginApi(BuildContext context) async {
    try {
      String random_char = utils.generateRandomString(15);
      var request = {
        AppStrings.key_service_id: AppStrings.service_key_login,
        AppStrings.key_user_login_key: random_char,
        AppStrings.key_user_name: mobile.text.trim(),
      };
      var decodedData;
      try {
        utils.showProgress();
        decodedData = await ApiServices().loginServiceFunction("login", request);
      } catch (e) {
        Utils().showSnackBar("Unable to fetch response");
      } finally {
        utils.hideProgress();
      }
      if (decodedData != null && decodedData != "") {
        var STATUS = decodedData[AppStrings.key_status];
        var RESPONSE = decodedData[AppStrings.key_response];
        dynamic KEY;
        dynamic user_data;
        String decryptedKey;
        String userDataDecrypt;
        if (STATUS.toString() == AppStrings.key_ok && RESPONSE.toString() == "LOGIN_SUCCESS") {
          KEY = decodedData[AppStrings.key_user_key];
          user_data = decodedData[AppStrings.key_user_data];

          var userPassKey = utils.textToMd5("password.text");
          decryptedKey = utils.decryption(KEY, userPassKey);

          userDataDecrypt = utils.decryption(user_data, userPassKey);
          var userData = jsonDecode(userDataDecrypt);
          print("userData" + userData.toString());

          await pref.setString(AppStrings.key_user_name, mobile.text.toString().trim());
          await pref.setString(AppStrings.key_user_key, decryptedKey.toString());
          pref.userName = mobile.text.toString().trim();
          pref.userPassKey = decryptedKey.toString();


          Get.offNamedUntil(Routes.home, (route) => false);
        } else if (STATUS.toString() == AppStrings.key_ok && RESPONSE.toString() == "LOGIN_FAILED") {
          Utils().showSnackBar("signin_failed".tr);
        } else {}
        return decodedData;
      } else {
        throw Exception('Failed');
      }
    } catch (e) {}
  }

}
