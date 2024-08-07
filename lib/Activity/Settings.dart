import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // UIHelper.bgDesign2(),
        Scaffold(
          backgroundColor: Colors.white,
          body:Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.all( 20),
                  decoration: UIHelper.roundedBorderWithGradientColor(0, AppColors.primaryColor, AppColors.secondaryColor),
                    alignment: Alignment.center,child: ResponsiveFonts(text: 'Settings', size: 16,color: AppColors.white,fontWeight: FontWeight.bold,textalignment: TextAlign.center,)),
                UIHelper.verticalSpaceLarge,
                Container(
                  /*padding: EdgeInsets.all( 10),
                  margin: EdgeInsets.all(20),*/
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
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
                      Container(
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
                      )

                    ],
                  ),
                ),
              ],),
          ),
        ),
      ],
    );
  }
}
