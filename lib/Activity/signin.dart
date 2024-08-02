import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import '../Controllers/authendication_controller.dart';
import '../Layouts/custom_input.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Services/routes_services.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthendicationController>(builder: (controller) {
      return Stack(
        children: [
          UIHelper.bgDesign(),
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Container(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.width* 0.60,),
                    ResponsiveFonts(text: "Sign In", size: 18, fontWeight: FontWeight.w500, color: AppColors.primaryColorDark),
                    UIHelper.verticalSpaceMedium,
                    CustomInput(
                      onEnter: (val) {
                        controller.mobile.text=val.toString();
                        print(val);
                      },
                      hintText: "Mobile No",
                      fieldname: "mobile",
                      fieldType: FieldType.number,
                      validating: (value) {
                        return null;
                      },
                    ),
                    UIHelper.verticalSpaceLarge,
                    UIHelper().actionButton(AppColors.primaryColor, "Get OTP".tr, radius: 25, onPressed: () {
                      if (controller.utils.isNumberValid(controller.mobile.text)) {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          elevation: 3,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          builder: (builder) => Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: bottomSheet(context, controller),
                          ),
                        ).whenComplete(
                              () {
                            controller.forgotMobileNo.value = '';
                            controller.initialChildSize.value = 0.4;
                          },
                        );
                      } else {
                        controller.utils.showSnackBar("Pleas Enter Valid Mobile Number");
                      }
                      // controller.login(context);
                    }, reducewidth: 1.35),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget bottomSheet(context, AuthendicationController controller) {
    return Obx(
      () => DraggableScrollableSheet(
        expand: false,
        initialChildSize: controller.initialChildSize.value,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(ImagePath.phone_vibration,height: 25,width: 25,),
                    UIHelper.horizontalSpaceTiny,
                    ResponsiveFonts(
                      text: "Otp sent to your  mobile number",
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                UIHelper.verticalSpaceMedium,
                ResponsiveFonts(
                  text: "Enter OTP",
                  size: 13,
                ),
                UIHelper.verticalSpaceMedium,
              OtpTextField(
                numberOfFields: 6,
                borderColor: AppColors.primaryColor,
                focusedBorderColor: AppColors.secondaryColor,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  controller.finalOTP=code;
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode){
                  controller.finalOTP=verificationCode;
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      }
                  );
                }, // end onSubmit
              ),
                UIHelper.verticalSpaceMedium,
                Container(
                  margin: EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () {

                        },
                        child: ResponsiveFonts(text: "Rend Otp", size: 13, fontWeight: FontWeight.w500,color: AppColors.primaryColor,))),
                UIHelper.verticalSpaceMedium,
                UIHelper().actionButton(AppColors.secondaryColor, "Submit", radius: 15, onPressed: () {
                  if (controller.finalOTP.isNotEmpty && controller.finalOTP.length==6) {
                    Get.back();

                  } else {
                    controller.utils.showSnackBar("Pleas Enter Valid OTP");
                  }
                }, reducewidth: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
