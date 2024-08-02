import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  String tag="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tag=Get.arguments["tag"];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
              padding: EdgeInsets.all(20),
              height: Get.height,
              width: Get.width,
              child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            UIHelper.verticalSpaceSmall,
            Container(
              decoration: UIHelper.roundedBorderWithGradientColor(10, AppColors.primaryColor,AppColors.secondaryColor),
              child: Column(
                children: [
                  UIHelper.verticalSpaceSmall,
                  Hero(
                    tag:tag,
                    child: Container(
                      width:Get.width,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor,AppColors.secondaryColor),
                      child: Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(ImagePath.admin, fit: BoxFit.cover,height: 80,width: 80,),
                        ),
                      ),),

                  ),
                  UIHelper.verticalSpaceTiny,
                  ResponsiveFonts(text: 'Dr.Test User', size: 15,color: AppColors.white,fontWeight: FontWeight.normal,decoration: TextDecoration.none,),
                  UIHelper.verticalSpaceTiny,
                  ResponsiveFonts(text: 'Cardiologist', size: 13,color: AppColors.white,fontWeight: FontWeight.normal,decoration: TextDecoration.none,),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.verticalSpaceMedium,
                ],
              ),
            ),
            UIHelper.verticalSpaceMedium,
            ResponsiveFonts(text: 'Cardiology Specialist', size: 13,color: AppColors.primaryColor,fontWeight: FontWeight.bold,decoration: TextDecoration.none,),
              UIHelper.verticalSpaceSmall,
            ResponsiveFonts(text: 'What is a Cardiologist? Cardiologists are doctors who have extra education and training in preventing, diagnosing and treating heart conditions. They are experts on the heart muscle itself and the arteries and veins that carry blood.', size: 13,color: AppColors.black,fontWeight: FontWeight.normal,decoration: TextDecoration.none,),

          ],),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UIHelper().actionButton(AppColors.red, "Reject".tr, radius: 25, onPressed: () {
              // controller.login(context);
            }, reducewidth: 3),
            UIHelper().actionButton(AppColors.green, "Approve".tr, radius: 25, onPressed: () {
              // controller.login(context);
            }, reducewidth: 3),

          ],
        ),
      ],
              ),
            ),
    );
  }
}
