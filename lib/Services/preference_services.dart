import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class PreferenceService {
  // ****************** //

  String selectedLanguage = 'en';
  String userName = "";
  String userPassKey = "";

  bool isLocal = true;
  RxBool showCommonProgress = false.obs;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  //Set User Info
  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

// Get User Info

  Future<String> getString(String key) async {
    String getStr = await _storage.read(key: key) ?? '';
    if (getStr != '') {
      return getStr;
    }
    return '';
  }

  //Remove all Data
  Future cleanAllPreferences() async {
    _storage.deleteAll();
  }
}
