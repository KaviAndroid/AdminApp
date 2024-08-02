import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Services/preference_services.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

class UIHelper {
  static PreferenceService pref = Get.put(PreferenceService());

  // Vertically Space Provider
  static const Widget verticalSpaceTiny = SizedBox(height: 4.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 20.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 60.0);
  static const Widget verticalSpaceVeryLarge = SizedBox(height: 130.00);

// Horizontal Space provider
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 20.0);
  static const Widget horizontalSpaceLarge = SizedBox(width: 40.0);

// Input Box Style Provider
  static OutlineInputBorder getInputBorder(double width, {double radius = 15, Color borderColor = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

// Form builder Input Fields Decoration
  static InputDecoration inputDecorateWidget(String hintText, {Widget? prefixwidget, Widget? suffixWidget}) {
    return InputDecoration(
      prefixIcon: prefixwidget,
      suffixIcon: suffixWidget,
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.grey9, fontSize: 12),
      label: ResponsiveFonts(
        text: hintText,
        color: AppColors.grey9,
        size: 12,
      ),
      counterText: "",
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: AppColors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 15,
      ),
      enabledBorder: UIHelper.getInputBorder(0, borderColor: AppColors.grey1, radius: 10),
      focusedBorder: UIHelper.getInputBorder(0, borderColor: AppColors.primaryColor.withOpacity(0.6), radius: 10),
      errorBorder: UIHelper.getInputBorder(2, borderColor: AppColors.red, radius: 10),
      focusedErrorBorder: UIHelper.getInputBorder(2, borderColor: AppColors.red, radius: 10),
    );
  }

  GestureDetector actionButton(Color color, String btnText,
      {Function? onPressed, bool isClicked = false, double radius = 8, double reducewidth = 2, Color btntextcolor = Colors.white, double btnheight = 40, double txtSize = 12}) {
    return GestureDetector(
      onTap: () {
        onPressed != null ? onPressed() : null;
      },
      child: Container(
        decoration: UIHelper.roundedBorderWithColor(radius, color),
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        height: btnheight,
        width: Get.width / reducewidth,
        alignment: Alignment.center,
        child: isClicked
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3,
                ),
              )
            : ResponsiveFonts(
                text: btnText,
                size: txtSize,
                fontWeight: FontWeight.bold,
                color: btntextcolor,
                textalignment: TextAlign.center,
              ),
      ),
    );
  }

  ///******** Container BOX Decoration with baackground image **********///
  static BoxDecoration roundedBorderWithBackround(double radius, String imageurl) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      image: DecorationImage(
        image: AssetImage(imageurl),
        fit: BoxFit.cover,
      ),
    );
  }

  ///******** Container BOX Decoration **********///
  static BoxDecoration roundedBorderWithColor(double radius, Color backgroundColor,
      {Color borderColor = Colors.transparent, double borderWidth = 0, bool isShadow = false, Color shadowcolor = Colors.black45}) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(width: borderWidth, color: borderColor),
        color: backgroundColor,
        boxShadow: isShadow
            ? [
                BoxShadow(
                  color: shadowcolor,
                  offset: const Offset(2, 2),
                  blurRadius: 3.0,
                )
              ]
            : []);
  }
  static BoxDecoration roundedBorderWithGradientColor(double radius, Color bg1,Color bg2,
      {Color borderColor = Colors.transparent, double borderWidth = 0, bool isShadow = false, Color shadowcolor = Colors.black45}) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(width: borderWidth, color: borderColor),
        gradient:LinearGradient(
            colors: [bg1, bg2],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: isShadow
            ? [
                BoxShadow(
                  color: shadowcolor,
                  offset: const Offset(2, 2),
                  blurRadius: 3.0,
                )
              ]
            : []);
  }

  ///******** Container BOX Decoration **********///
  static BoxDecoration customEdgeBorderWithColor(double tlradius, double trradius, double blradius, double brradius, Color backgroundColor,
      {Color borderColor = Colors.transparent, double borderWidth = 0, bool isShadow = false, Color shadowcolor = Colors.black45}) {
    return BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(tlradius), topRight: Radius.circular(trradius), bottomLeft: Radius.circular(blradius), bottomRight: Radius.circular(brradius)),
        border: Border.all(width: borderWidth, color: borderColor),
        color: backgroundColor,
        boxShadow: isShadow
            ? [
                BoxShadow(
                  color: shadowcolor,
                  offset: const Offset(2, 2),
                  blurRadius: 3.0,
                )
              ]
            : []);
  }

  ///******** Circle Container Decoration Widgets **********///
  static BoxDecoration circledecorationWithColor(Color bg1, Color bg2, {Color borderColor = Colors.transparent, double borderWidth = 1, bool applayShadow = true}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: borderWidth, color: borderColor),
      gradient: RadialGradient(
        colors: [bg1, bg2],
        radius: 0.75,
      ),
      boxShadow: [
        applayShadow
            ? BoxShadow(
                color: AppColors.light_black.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, 5),
              )
            : BoxShadow()
      ],
      // color: backgroundColor,
    );
  }

  ///******** Custom Button with style Widgets **********///
  Widget customButton(String title, Function press, {Color bgclr = AppColors.primaryColor, Color textclr = AppColors.white, double btnWidth = 100}) {
    return GestureDetector(
        onTap: () {
          press();
        },
        child: Container(
            width: btnWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: roundedBorderWithColor(10, bgclr, borderColor: AppColors.primaryColor, borderWidth: 2),
            child: ResponsiveFonts(text: title, size: 16, fontWeight: FontWeight.bold, color: textclr)));
  }
  static Widget bgDesign() {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppColors.white,
      child: Stack(children: [
        Positioned(
          top: -50,left: -20,child:  Container(
          width: Get.width * 0.40,
          height: Get.width * 0.40,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
        ),),
        Positioned(
          top: -90,right: -40,child:  Container(
          width: Get.width * 0.90,
          height: Get.width * 0.80,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
        ),),
        Positioned(
          bottom: -20,left: -20,child:  Container(
          width: Get.width * 0.35,
          height: Get.width * 0.35,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
        ),),
        Positioned(
          bottom: Get.width * 0.25,left: Get.width * 0.25,child:  Container(
          width: Get.width * 0.15,
          height: Get.width * 0.15,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
        ),),
      ],),
    );
  }
  static Widget bgDesign2() {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppColors.white,
      child: Stack(children: [
        Positioned(
          bottom: -20,left: -20,child:  Container(
          width: Get.width * 0.35,
          height: Get.width * 0.35,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
        ),),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
          width: Get.width * 0.350,
          height: Get.width * 0.35,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
                  ),
        ),
        Positioned(
          bottom: Get.width * 0.25,left: Get.width * 0.25,child:  Container(
          width: Get.width * 0.15,
          height: Get.width * 0.15,
          padding: EdgeInsets.all(30),
          decoration: UIHelper.circledecorationWithColor(AppColors.primaryColor, AppColors.primaryLiteColor),
        ),),
      ],),
    );
  }

  Container NoDataTile({double height = 0}) {
    if (height == 0) {
      height = Get.height * 0.8;
    }
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Get.width * 0.95,
            height: Get.width * 0.75,
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle, image: DecorationImage(image: AssetImage(ImagePath.empty), fit: BoxFit.fill)),
          ),
          SizedBox(
            height: 15,
          ),
          ResponsiveFonts(
            text: "no_data".tr,
            size: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
