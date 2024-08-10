import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../Controllers/home_controller.dart';
import '../Layouts/custom_alert.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Resources/strings.dart';
import '../Services/preference_services.dart';
import '../Services/routes_services.dart';
import '../Services/utils.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String profile = "";
  String profileEdit = "";
  final HomeController homecontroller = Get.find<HomeController>();
  Utils utils = Utils();
  final PreferenceService prefs = Get.find<PreferenceService>();
  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    profile = await homecontroller.prefs.getString(AppStrings.key_profile_image);
    setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // UIHelper.bgDesign2(),
        Scaffold(
          backgroundColor: Colors.white,
          body:Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -(Get.width/2), 0),
                    height: Get.width ,
                    width: Get.width ,
                    padding: EdgeInsets.all( 20),
                  decoration: UIHelper.circledecorationWithColor( AppColors.primaryColor, AppColors.secondaryColor),
                    alignment: Alignment.center),
                UIHelper.verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ResponsiveFonts(text: 'Settings', size: 16,color: AppColors.white,fontWeight: FontWeight.bold,
                    textalignment: TextAlign.center,),
                ),
                UIHelper.verticalSpaceSmall,
                Container(
                  /*padding: EdgeInsets.all( 10),
                  margin: EdgeInsets.all(20),*/
                  margin: EdgeInsets.only(top:  Get.width / 4),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        padding: EdgeInsets.all(5),
                        decoration: UIHelper.circledecorationWithColor(AppColors.primaryColorDark, AppColors.secondaryColorLite),
                        height: Get.width / 2.5 ,
                        width: Get.width / 2.5 ,
                        margin: EdgeInsets.all(3),
                        child: InkWell(
                          onTap: (){
                            showDialog(
                                builder: (BuildContext context) => AlertDialog(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  insetPadding: EdgeInsets.all(5),
                                  title: Container(
                                    decoration: BoxDecoration(),
                                    width: Get.width,
                                    height: Get.height / 2,
                                    child: profileEdit != "" && profileEdit != "null"&& profileEdit != null ? Image.file(File(profileEdit),fit: BoxFit.fill):
                                    profile != "" && profile != "null"&& profile != null ? Image.memory(base64Decode(profile),fit: BoxFit.fill):
                                         Image.asset(ImagePath.admin),
                                  ),
                                ),
                                context: context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: profileEdit != "" && profileEdit != "null"&& profileEdit != null ? Image.file(File(profileEdit),fit: BoxFit.fill,):
                            profile != "" && profile != "null"&& profile != null ? Image.memory(base64Decode(profile),fit: BoxFit.fill):
                            Image.asset(ImagePath.admin),
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpaceTiny,
                  InkWell(
                    onTap: () async {
                      await selectImage(context);
                    },
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.all( 20),
                      margin: EdgeInsets.all(20),
                      decoration: UIHelper.roundedBorderWithColor(30, AppColors.primaryLiteColor_4),
                    child:Row(
                      children: [
                        Expanded(child: ResponsiveFonts(text: 'Edit Profile', size: 14,color: AppColors.primaryColorDark,fontWeight: FontWeight.bold,)),
                        Icon(Icons.edit_sharp,color: AppColors.primaryColor,)
                      ],
                    ),
                        ),
                  ),
                      InkWell(
                        onTap: () {
                          gotoLogout();
                        },
                        child: Container(
                                            width: Get.width,
                                            padding: EdgeInsets.all( 20),
                                            margin: EdgeInsets.all(20),
                                            decoration: UIHelper.roundedBorderWithColor(30, AppColors.primaryLiteColor_4),
                                          child:Row(
                                            children: [
                        Expanded(child: ResponsiveFonts(text: 'Logout', size: 14,color: AppColors.primaryColorDark,fontWeight: FontWeight.bold,)),
                        Icon(Icons.logout_rounded,color: AppColors.primaryColor,)
                                            ],
                                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],),
          ),
        ),
      ],
    );
  }
  Future<void> gotoLogout() async {
    utils.showAlert(AlertType.warning, hintText: "Are you sure to logout?".tr, buttons: [
      UIHelper().actionButton(btnheight: 35, Colors.black, "ok".tr, btntextcolor: Colors.white, reducewidth: 3, onPressed: () {
        prefs.cleanAllPreferences();
        Get.offNamedUntil(Routes.signin, (route) => false);
      }),
      UIHelper().actionButton(btnheight: 35, Colors.black, "cancel".tr, btntextcolor: Colors.white, reducewidth: 3, onPressed: () {
        Get.back();
      })
    ]);

  }

  Future selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: Get.width * 0.9,
              height: Get.height * 0.25,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ResponsiveFonts(
                      text: "select_image".tr,
                      size: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await captureImage(ImageSource.gallery);
                            setState(() {});
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImagePath.gallery,
                                      height: 60,
                                      width: 60,
                                    ),
                                    ResponsiveFonts(
                                      text: "Gallery",
                                      size: 12,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await captureImage(ImageSource.camera);
                            setState(() {});
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImagePath.camera,
                                      height: 60,
                                      width: 60,
                                    ),
                                    ResponsiveFonts(
                                      text: "Camera",
                                      size: 12,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future<void> captureImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);
    Get.back();

    if (file == null) {
      utils.showSnackBar("User Cancelled Opeartion", type: AlertType.warning);
    } else {
      profileEdit=file.path;
    }
    print("profileEdit"+profileEdit);
  }

}
