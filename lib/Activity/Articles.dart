import 'dart:convert';
import 'dart:io';

import 'package:admin_app/Activity/AddNewArticle.dart';
import 'package:admin_app/Activity/view_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../../Layouts/custom_alert.dart';
import '../../Services/routes_services.dart';
import '../../Services/utils.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/view_image_controller.dart';
import '../Layouts/ReadMoreLess.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Resources/strings.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  Utils utils = Utils();
  final HomeController homecontroller = Get.find<HomeController>();
  final ViewImageController viewImageController = Get.find<ViewImageController>();

  String profile = "";
  String art = "A proper article indicates that its noun is proper, and refers to a unique entity. It may be the name of a person, the name of a place, the name of a planet, etc. The Māori language has the proper article a, which is used for personal nouns; so, 'a Pita' means 'Peter'. In Māori, when the personal nouns have the definite or indefinite article as an important part of it, both articles are present; for example, the phrase 'a Te Rauparaha', which contains both the proper article a and the definite article Te refers to the person name Te Rauparaha.";
  String ss = String.fromCharCodes(Runes('\u0024'));

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
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                UIHelper.verticalSpaceSmall,
                Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          padding: EdgeInsets.all(5),
                          decoration: UIHelper.circledecorationWithColor(AppColors.secondaryColor, AppColors.primaryColor),
                          height: Get.width / 7 ,
                          width: Get.width / 7 ,
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
                                      child: profile != "" && profile != "null"&& profile != null ? Image.memory(base64Decode(profile),)
                                          : Image.asset(ImagePath.admin),
                                    ),
                                  ),
                                  context: context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(ImagePath.admin, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        UIHelper.horizontalSpaceTiny,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIHelper.verticalSpaceSmall,
                              ResponsiveFonts(text: 'Hi Admin!', size: 20,color: AppColors.primaryColor,fontWeight: FontWeight.bold,),
                              UIHelper.verticalSpaceSmall,

                            ],
                          ),
                        ),
                      ],
                    )),
                UIHelper.verticalSpaceSmall,
                Container(decoration: UIHelper.roundedBorderWithColor(10, AppColors.white,borderWidth: 2,borderColor: AppColors.primaryColor,),
                  padding: EdgeInsets.all(10),
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveFonts(text: 'Welcome!', size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,),
                      UIHelper.verticalSpaceSmall,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(ImagePath.location, fit: BoxFit.cover,height: 20,width: 20,),
                          UIHelper.horizontalSpaceTiny,
                          Expanded(child: ResponsiveFonts(text: 'K. AIYAPPAN, (SECRETARY). 21, Sabari Street, Nesapakkam,. K.K. Nagar West, Chennai - 600 078.', size: 13,color: AppColors.primaryColor,fontWeight: FontWeight.normal,)),
                        ],
                      ),                    ],),),
                UIHelper.verticalSpaceSmall,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 5),
                  decoration: UIHelper.roundedBorderWithColor(30, AppColors.primaryLiteColor_4),
                  child: Center(
                    child: TextField(
                      cursorColor: AppColors.grey2,
                      maxLines: null,
                      onChanged: (String value) async {
                        onSearchQueryChanged(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        hintStyle: TextStyle(color: AppColors.grey2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                Align(alignment: Alignment.centerLeft,child: ResponsiveFonts(text: "Articles", size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
                Expanded(
                  child: Obx(()=>
                     ListView.builder(
                        itemCount: viewImageController.articleList.length,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var currentItem = viewImageController.articleList[index];
                          print("currentItem"+currentItem.toString());

                          return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: UIHelper.roundedBorderWithColor(10, AppColors.white,isShadow: true),
                          child: Stack(
                            children: [
                              Column(children: [
                                InkWell(onTap: (){
                                  /*showDialog(
                                    builder: (BuildContext context) => AlertDialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.all(5),
                                      title: Container(
                                        decoration: BoxDecoration(),
                                        width: Get.width,
                                        height: Get.height / 2,
                                        child: profile != "" && profile != "null"&& profile != null ? Image.memory(base64Decode(profile),)
                                            : Image.asset(ImagePath.admin),
                                      ),
                                    ),
                                    context: context);*/
                                  currentItem[AppStrings.key_image_list].isNotEmpty?showStageImage(currentItem[AppStrings.key_image_list],0):null;

                                },child:currentItem[AppStrings.key_image_list].isNotEmpty ?ClipRRect(
                                    borderRadius: BorderRadius.circular(0),child: Image.file(width: Get.width,height: Get.width/2,fit: BoxFit.fill,File(currentItem[AppStrings.key_image_list][0][AppStrings.key_image]))):
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(0),child: Image.asset(ImagePath.admin,height: Get.width/2,fit: BoxFit.fill,))),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  alignment: Alignment.centerLeft,
                                  child: ExpandableText(/*art*/currentItem[AppStrings.key_content],trimLines: 5,txtcolor: AppColors.txtclr,)
                                ),UIHelper.verticalSpaceMedium,
                              ],),
                              /*Positioned(
                                  top: 10,
                                  left: 10,
                                  child: buildBlur(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      color: Colors.black.withOpacity(0.40),
                                      child: ResponsiveFonts(text: "${1} / ${currentItem[AppStrings.key_image_list].length}",fontWeight: FontWeight.bold, size: 13, color: AppColors.white, decoration: TextDecoration.none),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  )),*/
                              Positioned(
                                right: 0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(decoration: UIHelper.roundedBorderWithColor(10, AppColors.primaryLiteColor),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  margin: EdgeInsets.all(8),
                                    child: ResponsiveFonts(text:currentItem[AppStrings.key_license_type]==1? "Free":("$ss ${currentItem[AppStrings.key_amount].toString()}"), size: 14,color: AppColors.white,fontWeight: FontWeight.bold,),),
                                  InkWell(
                                    onTap: (){
                                      Get.to(() => AddNewArticle(flag: "edit",arguments:currentItem));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.all(5),
                                      decoration: UIHelper.circledecorationWithColor(AppColors.secondaryColor, AppColors.secondaryColor2),
                                      child: Icon(Icons.edit,size: 25,color: AppColors.white,),),
                                  )

                                ],
                              )),
                              Positioned(
                                right: 0,
                                  bottom: 0,
                                  child: InkWell(
                                    onTap: (){
                                       utils.showAlert(AlertType.warning, hintText: "Are you sure to delete!", buttons: [UIHelper().actionButton(reducewidth: 3,btnheight: 35, AppColors.red, 'No', onPressed: () => Get.back()),
                                         UIHelper().actionButton(reducewidth: 3,btnheight: 35, AppColors.green, 'Yes', onPressed: () {
                                           viewImageController.articleList.removeAt(index);
                                           Get.back();
                                         })]);;

                                    },
                                      child: Icon(Icons.delete,size: 25,color: AppColors.red,))),
                            ],
                          ),

                        );
                        }),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
              ],),
          ),
        ),
      ],
    );
  }
  Future<void> onSearchQueryChanged(String query) async {
    homecontroller.doctorslist.clear();
    homecontroller.searchenabled = true;
    for (var data in homecontroller.doctorslist) {
      String name = data["name"].toString().toLowerCase();
      String specialist = data["specialist"].toString().toLowerCase();
      if (name.contains(query.toLowerCase()) ||
          specialist.contains(query.toLowerCase())) {
        homecontroller.filteredDoctorslist.add(data);
      }
    }
    setState(() {
    });
  }
}
