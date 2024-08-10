import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import '../Resources/strings.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as FormData1;
import 'package:dio/src/multipart_file.dart' as MP1;


class ApiServices extends GetConnect {
  final PreferenceService prefs = Get.find<PreferenceService>();
  Utils utils = Utils();
  Dio client = Dio();
  var encodingType = Encoding.getByName('utf-8');
  var headerType = {'Content-Type': 'application/json'};


  static String main_service = "https://afyacampass-api.onrender.com/api/admin";

  ApiServices() {
    initialize();
  }

  Future<void> initialize() async {
  }
  Future<dynamic> MainServiceFunction(String type, Map<String, dynamic> postdata, String filepath) async {
    try {
      log("$type- url>>$main_service");
      log("$type- request_json>>$postdata");
      if (filepath.isNotEmpty) {
        String filename = filepath.split('/').last;
        postdata['file'] = await MP1.MultipartFile.fromFile(filepath, filename: filename);
      }
      var formData = FormData1.FormData.fromMap(postdata);
      log("****************************************");
      var response = await client.post(main_service, data: formData);
      log("$type-response : $response");
      log("$type-responseData : ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
    }
    return {};
  }

}
