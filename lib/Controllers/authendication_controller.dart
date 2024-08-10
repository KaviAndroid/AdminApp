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

  String finalOTP = '';
  String mobile_no = '';
  RxString profileImagePath = ''.obs;
  Utils utils = Utils();

  AuthendicationController() {
  }


  Future<void> resendOTP() async {
    var request = {
      AppStrings.key_service_id:  AppStrings.service_key_resendOtp,
      AppStrings.key_mobile: mobile_no,
    };
    var decodedData;
    try {
      utils.showProgress();
      decodedData = await ApiServices().MainServiceFunction("RESEND OTP", request,"");
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
      decodedData = await ApiServices().MainServiceFunction("UPDATE PASSWORD", request,"");
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


  Future<void> login(BuildContext context) async {
    String ss = String.fromCharCodes(Runes('\u0024'));
    /*username.text = "nursery14";
    password.text = "test123#$ss";*/
    if (mobile.text.isNotEmpty) {
    if (await utils.isOnline()) {
        loginApi(context);
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
        decodedData = await ApiServices().MainServiceFunction("login", request, "");
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
