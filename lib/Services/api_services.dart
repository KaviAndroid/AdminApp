import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/io_client.dart';
import '../Resources/strings.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';

class ApiServices extends GetConnect {
  // Utils utils = Utils();
  final PreferenceService prefs = Get.find<PreferenceService>();
  Uri? login_service;
  Uri? master_service;
  Uri? main_service;
  Uri? open_service;
  Utils utils = Utils();

  // static String END_POINT_URL_LOCAL = "http://164.100.167.197:8080/tnrd/project/webservices_forms";
  static String END_POINT_URL_LOCAL = "http://10.163.19.137:8090/tnrd/project/webservices_forms";
  static String END_POINT_URL_LIVE = "https://tnrd.tn.gov.in/project/webservices_forms";

  ApiServices() {
    initialize();
  }

  Future<void> initialize() async {
    String mainUrl = (prefs.isLocal ? END_POINT_URL_LOCAL : END_POINT_URL_LIVE);
    login_service = Uri.parse("$mainUrl/login_service/login_services_v_1_2.php");
    master_service = Uri.parse("$mainUrl/master_services/master_services_v_1_7.php");
    open_service = Uri.parse("$mainUrl/open_services/open_services_mgnrega.php");
    main_service = Uri.parse("$mainUrl/nrega/nrega_services.php");
  }

  Future loginServiceFunction(String type, dynamic request) async {
    log("$type- url>>$login_service");
    log("$type- request>>$request");

    IOClient ioClient = IOClient();
    //   utils.showProgress();
    var response = await ioClient.post(login_service!, body: request);
    //  utils.hideProgress();
    if (response.statusCode == 200) {
      String data = response.body;
      log("$type- response>>$data");
      var decodedData = json.decode(data);
      if (decodedData != null) {
        return decodedData;
      } else {
        return false;
      }
    }
  }

  Future openServiceFunction(String type, dynamic jsonRequest) async {
    log("$type- url>>$open_service");
    log("$type- request_json>>${jsonEncode(jsonRequest)}");
    IOClient ioClient = IOClient();
    var response = await ioClient.post(open_service!, body: json.encode(jsonRequest));

    if (response.statusCode == 200) {
      String data = response.body;
      log("$type - response>>$data");
      var jsonData = jsonDecode(data);
      if (jsonData != null) {
        return jsonData;
      } else {
        return false;
      }
    }
  }

  Future MainServiceFunction(String type, dynamic jsonRequest, dynamic encryptedRequest) async {
    String? key = prefs.userPassKey;
    String? userName = prefs.userName;
    String jsonString = jsonEncode(encryptedRequest);

    String headerSignature = utils.generateHmacSha256(jsonString, key, true);

    String headerToken = utils.jwt_Encode(key, userName, headerSignature);
    Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer $headerToken"};
    log("***************************************** $type REQUEST LOGGER START *****************************************");

    log("$type- url>>$main_service");
    log("$type- request_json>> ${jsonEncode(jsonRequest)}");
    log("$type- request_encrpt>>  ${jsonEncode(encryptedRequest)}");
    log("$type- headerToken>>  $headerToken");

    log("***************************************** $type REQUEST LOGGER END *****************************************");
    /*HttpClient _client = HttpClient(context: await Utils().globalContext);
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);*/
    IOClient ioClient = IOClient();
    var response = await ioClient.post(main_service!, body: jsonEncode(encryptedRequest), headers: header);
    log("$type- response.body>>${response.body}");
    log("$type- response.statusCode>>${response.statusCode}");

    if (response.statusCode == 200) {
      log("***************************************** $type RESPONSE LOGGER START *****************************************");

      String data = response.body;
      log("$type- response>>$data");
      String? authorizationHeader = response.headers['authorization'];
      log("$type- authorizationHeader -  $authorizationHeader");

      String? token = authorizationHeader?.split(' ')[1];
      log("$type- Authorization Token -  $token");
      String responceSignature = utils.jwt_Decode(key, token!);
      String responceData = utils.generateHmacSha256(data, key, false);

      log("***************************************** $type RESPONSE LOGGER END *****************************************");

      if (responceSignature == responceData) {
        log("$type- responceSignature - Token Verified");
        var userData = jsonDecode(data);
        return userData;
      } else {
        log("$type- responceSignature - Token Not Verified");
        return false;
      }
    }
  }
}
