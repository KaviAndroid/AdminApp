import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Layouts/custom_alert.dart';
import '../Resources/colors.dart';
import '../Services/preference_services.dart';
import 'package:responsive_fonts/responsive_fonts.dart';
import 'package:intl/intl.dart';

import '../Layouts/ui_helper.dart';

class Utils {
  int keyLength = 32;
  PreferenceService preferencesService = Get.find<PreferenceService>();

  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  String decryption(String plainText, String ENCRYPTION_KEY) {
    final dateList = plainText.split(":");
    final key = encrypt.Key.fromUtf8(fixKey(ENCRYPTION_KEY));
    final iv = encrypt.IV.fromBase64(dateList[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ctr, padding: null));
    final decrypted = encrypter.decrypt(encrypt.Encrypted.from64(dateList[0]), iv: iv);
    // print("Final Result: " + decrypted);

    return decrypted;
  }

  String fixKey(String key) {
    if (key.length < keyLength) {
      int numPad = keyLength - key.length;

      for (int i = 0; i < numPad; i++) {
        key += "0"; //0 pad to len 16 bytes
      }

      return key;
    }

    if (key.length > keyLength) {
      return key.substring(0, keyLength); //truncate to 16 bytes
    }

    return key;
  }

  String getSha256(String value1, String user_password) {
    String value = textToMd5(user_password) + value1;
    var bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  String textToMd5(String text) {
    var bytes = utf8.encode(text);
    Digest md5Result = md5.convert(bytes);
    return md5Result.toString();
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final randomString = List.generate(length, (index) => _availableChars[_random.nextInt(_availableChars.length)]).join();

    return randomString;
  }

  String generateHmacSha256(String message, String S_key, bool flag) {
    String hashData = "";
    var key = utf8.encode(S_key);
    var jsonData = utf8.encode(message);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(jsonData);

    hashData = digest.toString();

    if (flag) {
      String encodedhashData = base64.encode(utf8.encode(hashData));
      return encodedhashData;
    }

    return hashData;
  }

  String jwt_Encode(String secretKey, String userName, String encodedhashData) {
    String token = "";

    DateTime currentTime = DateTime.now();

    DateTime expirationTime = currentTime.add(const Duration(seconds: 20));

    String exp = (expirationTime.millisecondsSinceEpoch / 1000).toString();

    Map payload = {
      "exp": exp,
      "username": userName,
      "signature": encodedhashData,
    };

    final jwt = JWT(payload, issuer: "tnrd.tn.gov.in");

    token = jwt.sign(SecretKey(secretKey));

    // print('Signed token: Bearer $token\n');

    return token;
  }

  String jwt_Decode(String secretKey, String jwtToken) {
    String signature = "";

    try {
      // Verify a token
      final jwt = JWT.verify(jwtToken, SecretKey(secretKey));

      Map<String, dynamic> headerJWT = jwt.payload;

      String head_sign = headerJWT['signature'];

      List<int> bytes = base64.decode(head_sign);

      signature = utf8.decode(bytes);
    } on Exception catch (e) {
      // print(e);
    }

    return signature;
  }

  Future<void> showAlert(AlertType alerttype, {List<Widget> buttons = const <Widget>[], String hintText = ""}) async {
    await Get.dialog<void>(
        barrierDismissible: false,
        Dialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: CustomDialog(
            alertType: alerttype,
            hintText: hintText,
            action: buttons,
          ),
        ));
  }

  Future<void> showProgress() async {
    preferencesService.showCommonProgress.value ? null : Get.dialog(barrierColor: Colors.grey.withOpacity(0.4), barrierDismissible: false, Center(child: CircularProgressIndicator()));
  }

  Future<void> hideProgress() async {
    preferencesService.showCommonProgress.value ? null : Get.back();
  }

// ********** Language Selection Function ***********\\
  void languageChange(String value) {
    switch (value) {
      case 'தமிழ்':
        preferencesService.selectedLanguage = "ta";
        var locale = const Locale('ta', 'IN');
        Get.updateLocale(locale);
        break;
      case 'English':
        preferencesService.selectedLanguage = "en";
        var locale = const Locale('en', 'US');
        Get.updateLocale(locale);
        break;
    }
  }

  Future<dynamic> invokeMethoedChannel(AppSetings channel, {dynamic arguments}) async {
    const MethodChannel callChannel = MethodChannel('com.nic.nrega');
    try {
      var res = await callChannel.invokeMethod(channel.methodChannelName, arguments);
      return res;
    } on PlatformException catch (e) {
      e.printError();
    }
  }

  SnackbarController showSnackBar(String message,
      {AlertType type = AlertType.fail, SnackPosition snackPostion = SnackPosition.TOP, Duration durations = const Duration(seconds: 2), Color? snackbar_color, String? title}) {
    String titleText = "fail".tr;
    Color color = AppColors.red;

    if (type == AlertType.success) {
      titleText = title ?? "success".tr;
      color = snackbar_color ?? AppColors.green;
    } else if (type == AlertType.warning) {
      titleText = title ?? "warning".tr;
      color = snackbar_color ?? AppColors.yellow;
    } else if (type == AlertType.others) {
      titleText = title ?? "warning".tr;
      color = snackbar_color ?? AppColors.blue;
    }
    return Get.snackbar(
      "",
      "",
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: snackPostion,
      duration: durations,
      backgroundColor: color,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      colorText: AppColors.white,
      // padding: EdgeInsets.symmetric(vertical: 1500),
      messageText: ResponsiveFonts(
        text: message,
        size: 14,
        color: AppColors.white,
      ),
      titleText: ResponsiveFonts(
        text: titleText,
        size: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
    );
  }

  void closeKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future<void> customDialog(Widget customWidgets) async {
    await Get.dialog<void>(
      barrierDismissible: false,
      Dialog(
        insetPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: customWidgets,
      ),
    );
  }

  String getOTPSecuredText(String num) {
    if (num.length <= 5) {
      return num;
    }

    int maskLength = (num.length - 5).clamp(0, num.length - 2);

    String maskedPart = '*' * maskLength;
    String securedNumber = num.replaceRange(2, 2 + maskLength, maskedPart);

    return securedNumber;
  }

  bool isEmailValid(value) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);
  }

  bool isNumberValid(value) {
    return RegExp(r'^[6789]\d{9}$').hasMatch(value);
  }

  bool isNameValid(value) {
    return RegExp(r"([a-zA-Z',.-]+( [a-zA-Z',.-]+)*){2,30}").hasMatch(value);
  }

  checkTime() async {
    if (await isAutoDatetimeisEnable()) {
      DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");
      DateFormat format2 = new DateFormat("yyyy-MM-dd");
      String start = format.format(DateTime.now());
      print("start" + start);
      String end = (format2.format(DateTime.now())) + " 12:00:00";
      print("end" + end);
      DateTime startDateDateTime = DateTime.parse(start);
      DateTime endDateDateTime = DateTime.parse(end);
   /*   if (startDateDateTime.isBefore(endDateDateTime)) {
        return true;
      } else {
        return false;
      }*/
      if(startDateDateTime.isBefore(endDateDateTime) ){
    return true; // for testing
    }else{
    return true;
    }
    } else {
      showAlert(AlertType.warning, hintText: "Please Enable Network Provided Time", buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: () => Get.back())]);
      ;
    }
  }
}

Future<bool> isAutoDatetimeisEnable() async {
  bool isAutoDatetimeisEnable = false;

  if (Platform.isAndroid) {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
    timezoneAuto && timeAuto ? isAutoDatetimeisEnable = true : isAutoDatetimeisEnable = false;
  } else if (Platform.isIOS) {
    isAutoDatetimeisEnable = true;
  }
  // return true;
  return isAutoDatetimeisEnable;
}

enum AppSetings {
  makeCall,
  launchUrl,
  getAndroidVersion,
  camera,
  settings,
  locationsettings,
  appsettings,
}

extension AppSettingsExtension on AppSetings {
  String get methodChannelName {
    return name;
  }
}
