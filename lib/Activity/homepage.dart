import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/home_controller.dart';
import '../Layouts/custom_dropdown.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/strings.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../../Layouts/appbar.dart';
import '../../Layouts/custom_alert.dart';
import '../../Services/routes_services.dart';
import '../../Services/utils.dart';
import '../Resources/image_path.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Utils utils = Utils();
  String langText = 'English';
  final HomeController homecontroller = Get.find<HomeController>();
  String profile = "";
  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    profile = await homecontroller.prefs.getString(AppStrings.key_profile_image);
    await homecontroller. getVillageList();
    homecontroller.prefs.selectedLanguage = "en";
    var locale = const Locale('en', 'US');
    Get.updateLocale(locale);
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body:Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            PopupMenuButton<String>(
              color: AppColors.white,
              onSelected: ((value) {
                if (value != langText) {
                  langText = value;
                  utils.languageChange(value);
                }
                setState(() {});
              }),
              itemBuilder: (BuildContext context) {
                return {'தமிழ்', 'English'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: ResponsiveFonts(text: choice, color: AppColors.black, size: 14),
                  );
                }).toList();
              },
              child: Row(
                children: [
                  Container(padding: EdgeInsets.only(left: 10), child: ResponsiveFonts(text: langText, color: AppColors.white, size: 14)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_downward_rounded, size: 15, color:AppColors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: (){
                utils.showAlert(AlertType.warning,hintText: "logout_msg".tr,buttons: [
                  UIHelper().actionButton(reducewidth:4,AppColors.red, "cancel".tr,onPressed: (){
                    Get.back();
                  }),
                  UIHelper().actionButton(reducewidth: 4,AppColors.green, "ok".tr,onPressed: (){
                    Get.toNamed(Routes.signin);
                  })
                ]);

              },
              icon: Icon(Icons.power_settings_new,color:AppColors.white),
            )
          ],),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                  margin: EdgeInsets.only(top: Get.height/16,left: 10,right: 10),
                  padding: EdgeInsets.only(top: Get.height/12,left: 10,right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLiteColor_2,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child:Column(
                    children: [
                      ResponsiveFonts(text: 'user_name'.tr, size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,),
                      UIHelper.verticalSpaceSmall,
                      ResponsiveFonts(text: "("+"designation".tr+")", size: 14,color: AppColors.primaryColor,textalignment: TextAlign.center,),
                      UIHelper.verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 1,child: ResponsiveFonts(text:  "district".tr+"\n"+"Kancheepuram".tr, size: 14,color: AppColors.primaryColor,textalignment: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                          UIHelper.horizontalSpaceSmall,
                          Expanded(flex: 1,child: ResponsiveFonts(text: "block".tr+"\n"+"Angambakkam".tr, size: 14,color: AppColors.primaryColor,textalignment: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                        ],
                      ),
                      UIHelper.verticalSpaceMedium,
                      // ResponsiveFonts(text: "village_name".tr, size: 14,color: AppColors.primaryColor,),
                    ],
                  )
              ),
/*              Container(
                width: Get.width/4,
                height: Get.height/8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      width: 2,
                      color: AppColors.primaryColor.withOpacity(0.4)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: profile != "" && profile != "null"&& profile != null
                    ? InkWell(
                  onTap: () => showDialog(
                      builder: (BuildContext context) => AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(5),
                        title: Container(
                          decoration: BoxDecoration(),
                          width: Get.width,
                          height: Get.height / 2,
                          child: Image.asset(ImagePath.logo,fit: BoxFit.fill,),
                        ),
                      ),
                      context: context),
                  child: Image.memory(
                    base64Decode(profile),
                    fit: BoxFit.fill,
                  ),
                )
                    : Image.asset(ImagePath.logo,fit: BoxFit.fill,),
              ),*/
              InkWell(
                onTap: () => showDialog(
                    builder: (BuildContext context) => AlertDialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(5),
                      title: Container(
                        decoration: BoxDecoration(),
                        width: Get.width,
                        height: Get.height / 2,
                        child: profile != "" && profile != "null"&& profile != null ? Image.memory(base64Decode(profile),)
                            : Image.asset(ImagePath.logo),
                      ),
                    ),
                    context: context),
              child: Container(
                width: Get.width/4,
                height: Get.height/8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      width: 2,
                      color: AppColors.primaryColor.withOpacity(0.4)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: profile != "" && profile != "null"&& profile != null ? MemoryImage(base64Decode(profile),)
                        : AssetImage(ImagePath.logo),
                  ),
                ),
              ),
            )
            ],),
          UIHelper.verticalSpaceMedium,
          ResponsiveFonts(text: "village_list".tr+(" ("+(homecontroller.villagelist.length.toString())+")"), size: 16,color: AppColors.white,fontWeight: FontWeight.bold,),
          UIHelper.verticalSpaceSmall,
          Expanded(
            child: ListView.builder(
              itemCount: homecontroller.villagelist.length,
              itemBuilder: (context, index) => Container(
                decoration: UIHelper.roundedBorderWithColor(10, AppColors.secondaryLiteColorTrans),
                margin: EdgeInsets.fromLTRB(20,10,20,10),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: AppColors.white,
                            child: Container(
                              padding: EdgeInsets.all(0),
                              child:ResponsiveFonts(text: (index+1).toString(), size: 14,color: AppColors.grey7,fontWeight: FontWeight.bold,),),
                            radius: 15.0),
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                          child: ResponsiveFonts(text: (homecontroller.prefs.selectedLanguage=="en"?homecontroller.villagelist[index][AppStrings.key_pvname]??"":
                          homecontroller.villagelist[index][AppStrings.key_pvname_ta]??""), size: 15,color: AppColors.white,fontWeight: FontWeight.bold,),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: Get.width/1.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: (){Get.toNamed(Routes.clusters,arguments: {AppStrings.key_pvname:(homecontroller.prefs.selectedLanguage=="en"?homecontroller.villagelist[index][AppStrings.key_pvname]??"":
                                homecontroller.villagelist[index][AppStrings.key_pvname_ta]??""),AppStrings.key_pvcode:homecontroller.villagelist[index][AppStrings.key_pvcode].toString(),"flag":"view"});},
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  decoration: UIHelper.roundedBorderWithColor(5, AppColors.white),
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_red_eye_sharp,color: AppColors.grey2,size: 18,),
                                      UIHelper.horizontalSpaceTiny,
                                      Flexible(child: ResponsiveFonts(text: "view_data".tr, size: 12,color: AppColors.grey7,fontWeight: FontWeight.bold,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            UIHelper.horizontalSpaceSmall,
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: (){Get.toNamed(Routes.clusters,arguments: {AppStrings.key_pvname:(homecontroller.prefs.selectedLanguage=="en"?homecontroller.villagelist[index][AppStrings.key_pvname]??"":
                                homecontroller.villagelist[index][AppStrings.key_pvname_ta]??""),AppStrings.key_pvcode:homecontroller.villagelist[index][AppStrings.key_pvcode].toString(),"flag":"entry"});},
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  decoration: UIHelper.roundedBorderWithColor(5, AppColors.white),
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_note_sharp,color: AppColors.grey2,size: 18,),
                                      UIHelper.horizontalSpaceTiny,
                                      Flexible(child: ResponsiveFonts(text: "enter_data".tr, size: 12,color: AppColors.grey7,fontWeight: FontWeight.bold)),
                                    ],
                                  ),

                                ),
                              ),
                            ),
                          ],),
                      ),
                    )
                  ],
                ),),

            ),
          ),
        ],),
      ),
    );
  }

}
