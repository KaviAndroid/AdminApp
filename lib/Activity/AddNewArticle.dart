import 'dart:convert';
import 'dart:io';

import 'package:admin_app/Activity/view_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../../Layouts/custom_alert.dart';
import '../../Services/routes_services.dart';
import '../../Services/utils.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/view_image_controller.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Resources/strings.dart';

class AddNewArticle extends StatefulWidget {
  const AddNewArticle({super.key});

  @override
  State<AddNewArticle> createState() => _AddNewArticleState();
}

class _AddNewArticleState extends State<AddNewArticle> {
  Utils utils = Utils();
  final ViewImageController viewImageController = Get.find<ViewImageController>();

  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    viewImageController.imageList.value=[];
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
                  child: ResponsiveFonts(text: 'Create New Article', size: 18,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
                UIHelper.verticalSpaceSmall,
                Container(
                  width: Get.width,
                  margin: EdgeInsets.all(10),
                  decoration: UIHelper.roundedBorderWithColor(10, AppColors.white,isShadow: true),
                  child: Stack(
                    children: [
                      Column(children: [
                        InkWell(onTap: (){
                          viewImageController.imageList.value.isNotEmpty?showStageImage(viewImageController,0):null;
                        },child:
                        Container(
                          width: Get.width,
                          height: Get.width/1.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: viewImageController.imageList.value.isNotEmpty ? FileImage(File(viewImageController.imageList.value[0][AppStrings.key_image])) : AssetImage(ImagePath.gallery),
                            ),
                          ),
                        ),
                        ),
                      ],),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: buildBlur(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              color: Colors.black.withOpacity(0.40),
                              child: ResponsiveFonts(text: "${1} / ${viewImageController.imageList.length}",fontWeight: FontWeight.bold, size: 13, color: AppColors.white, decoration: TextDecoration.none),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ],
                  ),

                ),
                UIHelper.verticalSpaceMedium,
            ],),
          ),
          floatingActionButton: _floatingBtn(),
        ),
      ],
    );
  }
  Widget _floatingBtn() {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.only(bottom: Get.width/5),
      alignment: Alignment.center,
      child: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          selectImage(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.camera,
          size: 28,
        ),
      ),
    );
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
                            await viewImageController.captureImage(ImageSource.gallery);
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
                            await viewImageController.captureImage(ImageSource.camera);
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

}
