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
  final OtpController otpController = Get.put(OtpController());

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool isShowPassword = false.obs;
  RxBool otpPostionedAnimation = false.obs;
  RxBool otpFadeInAnimation = false.obs;
  RxBool btnBtnClicked = false.obs;

  bool versionErrorFlag = false;
  bool otpVerifiedFlag = false;
  bool forgotPasswordFlag = false;

  String flag = '';
  String finalOTP = '';
  String mobile_no = '';

  RxString otpText = ''.obs;
  RxString selectedGender = ''.obs;
  RxString selectedLevel = ''.obs;
  RxString selectedDesignation = ''.obs;
  RxString selectedDistrict = ''.obs;
  RxString selectedBlock = ''.obs;
  RxString selectedVillage = ''.obs;
  RxString profileImagePath = ''.obs;
  RxString titleText = ''.obs;
  RxString forgotMobileNo = ''.obs;

  List genderList = [];

  RxList levelList = [].obs;
  RxList designationList = [].obs;
  RxList districtList = [].obs;
  RxList blockList = [].obs;
  RxList villageList = [].obs;

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
            selectedGender = ''.obs;
            selectedDistrict = ''.obs;
            selectedBlock = ''.obs;
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

  Future<void> forgotPassword() async {
    btnBtnClicked.value = false;
    if (!btnBtnClicked.value) {
      btnBtnClicked.value = true;

      mobile_no = forgotMobileNo.value; //mobile_no Common

      var request = {
        AppStrings.key_service_id: AppStrings.service_key_sendOTP_for_forgot_password,
        AppStrings.key_mobile: mobile_no,
      };
      var decodedData;
      try {
        utils.showProgress();
        decodedData = await ApiServices().openServiceFunction("FORGOT PASSWORD", request);
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
          btnBtnClicked.value = false;
          forgotPasswordFlag = true;
          otpPostionedAnimation.value = true;

          otpText.value = pref.selectedLanguage == 'ta'
              ? " ${utils.getOTPSecuredText(forgotMobileNo.value)}${"otp_sent_message".tr} "
              : " ${"otp_sent_message".tr} ${utils.getOTPSecuredText(forgotMobileNo.value)} ";
          Future.delayed(
            Durations.long4,
            () {
              otpFadeInAnimation.value = true;
            },
          );

          utils.showSnackBar(message, type: AlertType.success, durations: Duration(seconds: 3));
          Get.toNamed(Routes.registration, arguments: {"is_registration": false});
        } else {
          utils.showSnackBar(message);
        }
      }
    }
  }

  Future<void> verifyPersonalDetails(bool isRegister) async {
    if (!btnBtnClicked.value) {
      btnBtnClicked.value = true;

      finalOTP = otpController.submitOtp();

      if (finalOTP.isNotEmpty && finalOTP.length == 6) {
        var request = {
          AppStrings.key_service_id: forgotPasswordFlag ? AppStrings.service_key_forgotPasswordverifyOtp : AppStrings.service_key_verifyOtp,
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
            forgotPasswordFlag = false;
            otpController.clearAll();
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
      AppStrings.key_service_id: forgotPasswordFlag ? AppStrings.service_key_resendOtpForgotPassword : AppStrings.service_key_resendOtp,
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
    if (username.text.isNotEmpty) {
      if (password.text.isNotEmpty) {
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
        Utils().showSnackBar('password_empty'.tr, type: AlertType.warning);
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
        AppStrings.key_user_name: username.text.trim(),
        AppStrings.key_user_password: utils.getSha256(random_char, password.text.trim())
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

          var userPassKey = utils.textToMd5(password.text);
          decryptedKey = utils.decryption(KEY, userPassKey);

          userDataDecrypt = utils.decryption(user_data, userPassKey);
          var userData = jsonDecode(userDataDecrypt);
          print("userData" + userData.toString());

          await pref.setString(AppStrings.key_user_name, username.text.toString().trim());
          await pref.setString(AppStrings.key_user_password, password.text.toString().trim());
          await pref.setString(AppStrings.key_user_key, decryptedKey.toString());
          pref.userName = username.text.toString().trim();
          pref.userPassKey = decryptedKey.toString();

          await pref.setString(AppStrings.key_statecode, userData[AppStrings.key_statecode].toString());
          await pref.setString(AppStrings.key_dcode, userData[AppStrings.key_dcode].toString());
          await pref.setString(AppStrings.key_dname, userData[AppStrings.key_dname].toString());
          await pref.setString(AppStrings.key_bcode, userData[AppStrings.key_bcode].toString());
          await pref.setString(AppStrings.key_bname, userData[AppStrings.key_bname].toString());
          await pref.setString(AppStrings.key_pvcode, userData[AppStrings.key_pvcode].toString());
          await pref.setString(AppStrings.key_pvname, userData[AppStrings.key_pvname].toString());
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

  Future<void> fetchDropDownLists() async {
    bool flag = true;
    if (genderList.isEmpty && districtList.isEmpty) {
      utils.showProgress();
      final result = await Future.wait([
        getGenderList(),
        getLevels(),
      ]);
      utils.hideProgress();
      update();

      for (var element in result) {
        if (!element) {
          flag = false;
          utils.showSnackBar("Something Went Wrong");
          break;
        } else {
          flag = true;
        }
      }
    }
    if (flag) {
      Get.toNamed(Routes.registration, arguments: {"is_registration": true});
    }
  }

  Future<bool> getGenderList() async {
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_get_profile_gender,
      };
      var decodedData = await ApiServices().openServiceFunction("GENDER_LIST", jsonRequest);
      if (decodedData != null && decodedData != "") {
        var status = decodedData[AppStrings.key_status];
        var responseValue = decodedData[AppStrings.key_response];

        if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
          genderList.clear();
          genderList = decodedData[AppStrings.key_json_data];
          if (genderList.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        }
      }
    } catch (e) {
      e.printError();
      return false;
    }
    return false;
  }

  Future<bool> getLevels() async {
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_get_profile_level,
      };

      var decodedData = await ApiServices().openServiceFunction("PROFILE_LEVEL", jsonRequest);
      if (decodedData != null && decodedData != "") {
        var status = decodedData[AppStrings.key_status];
        var responseValue = decodedData[AppStrings.key_response];

        if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
          List<dynamic> sort_level = decodedData[AppStrings.key_json_data];
          sort_level.sort((a, b) {
            return a[AppStrings.key_localbody_code].compareTo(b[AppStrings.key_localbody_code]);
          });
          levelList.clear();
          levelList.addAll(sort_level);
          return true;
        }
      }
    } catch (e) {
      e.printError();
      return false;
    }
    return false;
  }

  Future<void> getDesignationList() async {
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_get_mobile_designation,
        AppStrings.key_level_id: selectedLevel.value,
      };

      var decodedData;
      try {
        utils.showProgress();
        decodedData = await ApiServices().openServiceFunction("DESIGNATION_LIST", jsonRequest);
      } catch (e) {
        Utils().showSnackBar("Unable to fetch response");
      } finally {
        utils.hideProgress();
      }

      if (decodedData != null && decodedData != "") {
        var status = decodedData[AppStrings.key_status];
        var responseValue = decodedData[AppStrings.key_response];

        if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
          List<dynamic> sort_desig = decodedData[AppStrings.key_json_data];
          sort_desig.sort((a, b) {
            return a[AppStrings.key_desig_name].compareTo(b[AppStrings.key_desig_name]);
          });
          designationList.clear();
          designationList.addAll(sort_desig);
        }
      }
    } catch (e) {
      e.printError();
    }
  }

  Future<void> getDistrictList() async {
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_district_list_all,
      };

      var decodedData;
      try {
        utils.showProgress();
        decodedData = await ApiServices().openServiceFunction("DISTRICT_LIST", jsonRequest);
      } catch (e) {
        Utils().showSnackBar("Unable to fetch response");
      } finally {
        utils.hideProgress();
      }

      if (decodedData != null && decodedData != "") {
        var status = decodedData[AppStrings.key_status];
        var responseValue = decodedData[AppStrings.key_response];

        if (status == AppStrings.key_ok && responseValue == AppStrings.key_ok) {
          List<dynamic> sort_dist = decodedData[AppStrings.key_json_data];
          String sortName = pref.selectedLanguage == 'ta' ? AppStrings.key_dname_ta : AppStrings.key_dname;

          sort_dist.sort((a, b) {
            return a[sortName].compareTo(b[sortName]);
          });

          districtList.clear();
          districtList.addAll(sort_dist);
        }
      }
    } catch (e) {
      e.printError();
    }
  }

  Future<void> getBlockList() async {
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_block_list_district_wise,
        AppStrings.key_dcode: selectedDistrict.value,
      };

      var decodedData;
      try {
        utils.showProgress();
        decodedData = await ApiServices().openServiceFunction("BLOCK_LIST", jsonRequest);
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
            List<dynamic> sort_block = decodedData[AppStrings.key_json_data];
            String sortName = pref.selectedLanguage == 'ta' ? AppStrings.key_bname_ta : AppStrings.key_bname;

            sort_block.sort((a, b) {
              return a[sortName].compareTo(b[sortName]);
            });
            blockList.clear();
            blockList.addAll(sort_block);
          }
        } else if (status == AppStrings.key_ok && responseValue == AppStrings.key_noRecord) {
          Utils().showSnackBar(decodedData[AppStrings.key_message] ?? "No Block Found");
        }
      }
    } catch (e) {
      e.printError();
    }
  }

  Future<void> getVillageList() async {
    try {
      Map jsonRequest = {
        AppStrings.key_service_id: AppStrings.service_key_village_list_district_block_wise,
        AppStrings.key_dcode: selectedDistrict.value,
        AppStrings.key_bcode: selectedBlock.value,
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
            String sortName = pref.selectedLanguage == 'ta' ? AppStrings.key_pvname_ta : AppStrings.key_pvname;

            sort_village.sort((a, b) {
              return a[sortName].compareTo(b[sortName]);
            });
            villageList.clear();
            villageList.addAll(sort_village);
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
