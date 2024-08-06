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
import '../Layouts/custom_input.dart';
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
  final HomeController homecontroller = Get.find<HomeController>();
  int _radioSelected = 0;
  String _radioVal="";
  int imgIndex=0;
  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    viewImageController.description="";
    viewImageController.amount="";
    viewImageController.imageList=[];
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // UIHelper.bgDesign2(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body:Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
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
                            viewImageController.imageList.isNotEmpty?showStageImage(viewImageController.imageList,0):null;
                          },
                            child:
                          /*GestureDetector(
                            onPanUpdate: (DragUpdateDetails details){
                              if(details.delta.dx>0){
                                print('right swipe');
                                //right scroll
                                //increment counter
                                setState(() {
                                  imgIndex=(imgIndex-1)>=0?(imgIndex-1):0;
                                  print('imgIndex'+imgIndex.toString());

                                });
                              }
                              else if(details.delta.dx<0){
                                print('left swipe');
                                //left scroll
                                //decrement counter
                                setState(() {
                                  imgIndex=(imgIndex+1)<=(viewImageController.imageList.length-1)?(imgIndex+1):(viewImageController.imageList.length-1);

                                  print('imgIndex>>'+imgIndex.toString());
                                });
                              }
                            },
                            child:*/ Container(
                              width: Get.width,
                              height: Get.width/1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: AppColors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: viewImageController.imageList.isNotEmpty ? FileImage(File(viewImageController.imageList[imgIndex][AppStrings.key_image])) : AssetImage(ImagePath.capturing),
                                ),
                              ),
                            ),
                          // ),
                          ),

                        ],),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: buildBlur(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                color: Colors.black.withOpacity(0.40),
                                child: ResponsiveFonts(text: "${viewImageController.imageList.isNotEmpty?imgIndex+1:0} / ${viewImageController.imageList.length}",fontWeight: FontWeight.bold, size: 13, color: AppColors.white, decoration: TextDecoration.none),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ],
                    ),

                  ),
                  UIHelper.verticalSpaceMedium,
                  Align(alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () async {
                      await selectImage(context);
                      setState(() {
                        imgIndex=(viewImageController.imageList.length-1);
                        print('imgIndex>>>>'+imgIndex.toString());
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: UIHelper.circledecorationWithColor(AppColors.primaryLiteColor, AppColors.secondaryColor),
                    child: Icon(Icons.camera,color: AppColors.white,size: 30,),),
                  ),),
                  UIHelper.verticalSpaceMedium,
                  Align(alignment: Alignment.centerLeft,child: ResponsiveFonts(text: "Enter Description", size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
                  UIHelper.verticalSpaceSmall,
                  CustomInput(
                    onEnter: (val) {
                      viewImageController.description=val.toString();
                    },
                    hintText: "Description",
                    fieldname: "description",
                    fieldType: FieldType.text,
                    validating: (value) {
                      return null;
                    },
                  ),
                  UIHelper.verticalSpaceSmall,
                  Align(alignment: Alignment.centerLeft,child: ResponsiveFonts(text: "License", size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _radioSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            viewImageController.amount="";
                            _radioSelected = value!;
                            _radioVal = 'free';
                          });
                        },
                      ),
                      Text('Free'),
                      Radio(
                        value: 2,
                        groupValue: _radioSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            viewImageController.amount="";
                            _radioSelected = value!;
                            _radioVal = 'premium';
                          });
                        },
                      ),
                      Text('Premium'),
                    ],
                  ),
                  Visibility(
                    visible: _radioVal=="premium",
                      child: Column(children: [
                    UIHelper.verticalSpaceSmall,
                    Align(alignment: Alignment.centerLeft,child: ResponsiveFonts(text: "Enter Amount", size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
                    UIHelper.verticalSpaceSmall,
                    CustomInput(
                      onEnter: (val) {
                        viewImageController.amount=val.toString();
                      },
                      hintText: "Amount",
                      fieldname: "amount",
                      fieldType: FieldType.number,
                      validating: (value) {
                        return null;
                      },
                    ),
                  ],)),

                  UIHelper.verticalSpaceMedium,
                  UIHelper().actionButton(AppColors.primaryColor, "Submit".tr, radius: 25, onPressed: () async {
                    if(viewImageController.imageList.isNotEmpty){
                      if(viewImageController.description.trim().isNotEmpty){
                        if(_radioVal.isNotEmpty){
                          if(_radioVal=="free" || (_radioVal=="premium" && viewImageController.amount.trim() !="")){
                            List imgList=[];
                            imgList.addAll(viewImageController.imageList);
                            Map map={
                              AppStrings.key_description:viewImageController.description.trim(),
                              AppStrings.key_image_list:imgList
                            };
                            viewImageController.articleList.add(map);
                            print("viewImageController.articleList"+viewImageController.articleList.value.toString());
                            await utils.showAlert(AlertType.success, hintText: "Article Posted Successfully!", buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: () => Get.back())]);;
                            viewImageController.description="";
                            viewImageController.imageList.clear();
                            viewImageController.amount="";
                            _radioSelected = 0;
                            _radioVal = "";
                            setState(() {homecontroller.page.value=0;});
                          }else{
                            utils.showAlert(AlertType.warning, hintText: "Please Enter Amount", buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: () => Get.back())]);;
                          }
                        }else{
                          utils.showAlert(AlertType.warning, hintText: "Please Select License Mode", buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: () => Get.back())]);;
                        }
                      }else{
                        utils.showAlert(AlertType.warning, hintText: "Please Enter Description", buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: () => Get.back())]);;
                      }
                    }else{
                      utils.showAlert(AlertType.warning, hintText: "Add Article Photo", buttons: [UIHelper().actionButton(btnheight: 35, AppColors.black, 'ok'.tr, onPressed: () => Get.back())]);;
                    }
                  }, reducewidth: 2),
                  UIHelper.verticalSpaceVeryLarge,
              ],),
            ),
          ),
        ),
      ],
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
