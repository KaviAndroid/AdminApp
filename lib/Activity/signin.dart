import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.secondaryColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Get.height * 0.35,
                color: AppColors.secondaryColor,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Get.width * 0.45,
                      padding: EdgeInsets.all(30),
                      decoration: UIHelper.circledecorationWithColor(AppColors.white, AppColors.secondaryLiteColor),
                      child: Image.asset(ImagePath.login, fit: BoxFit.cover),
                    ),
                    UIHelper.verticalSpaceMedium,
                    ResponsiveFonts(text: "signin".tr, size: 18, fontWeight: FontWeight.w500, color: AppColors.white)
                  ],
                )),
              ),
              Container(
                  height: Get.height * 0.65,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 30),
                  child: FormBuilder(
                    child: Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          CustomInput(
                            onEnter: (val) {
                              controller.username.text=val.toString();
                              print(val);
                              print("controller.username.text"+controller.username.text);
                            },
                            hintText: "mobile".tr,
                            fieldname: "mobile",
                            fieldType: FieldType.number,
                            validating: (value) {
                              return null;
                            },
                          ),
                          UIHelper.verticalSpaceMedium,
                          Obx(
                            () => CustomInput(
                              hintText: "password".tr,
                              fieldname: "password",
                              fieldType: FieldType.password,
                              showpassword: controller.isShowPassword.value,
                              suffixWidget: GestureDetector(
                                  onTap: () {
                                    if (controller.isShowPassword.value) {
                                      controller.isShowPassword.value = false;
                                    } else {
                                      controller.isShowPassword.value = true;
                                    }
                                  },
                                  child: Icon(controller.isShowPassword.value ? Icons.visibility : Icons.visibility_off, color: AppColors.grey2)),
                              onEnter: (val) {
                                print(val);
                                controller.password.text=val.toString();
                              },
                              validating: (value) {
                                return null;
                              },
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      elevation: 3,
                                      showDragHandle: true,
                                      enableDrag: true,
                                      isScrollControlled: true,
                                      builder: (builder) => bottomSheet(context, controller),
                                    ).whenComplete(
                                      () {
                                        controller.forgotMobileNo.value = '';
                                        controller.initialChildSize.value = 0.4;
                                      },
                                    );
                                  },
                                  child: ResponsiveFonts(text: "forgot_password".tr, size: 13, fontWeight: FontWeight.w500))),
                          UIHelper.verticalSpaceLarge,
                          UIHelper().actionButton(AppColors.primaryColor, "signin".tr, radius: 25, onPressed: () {
                            controller.login(context);
                          }, reducewidth: 1.35),
                          UIHelper.verticalSpaceMedium,
                          InkWell(
                            onTap: () {
                              controller.fetchDropDownLists();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ResponsiveFonts(text: "signupText".tr, size: 13, fontWeight: FontWeight.w500),
                                UIHelper.horizontalSpaceSmall,
                                ResponsiveFonts(text: "Sign Up".tr, size: 15, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
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
                ResponsiveFonts(
                  text: "forgot_your_password".tr,
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
                UIHelper.verticalSpaceMedium,
                ResponsiveFonts(
                  text: "enter_no_to_get_pass".tr,
                  size: 13,
                ),
                UIHelper.verticalSpaceMedium,
                CustomInput(
                  onEnter: (val) {
                    controller.forgotMobileNo.value = val;
                  },
                  onTap: () {
                    controller.initialChildSize.value = 0.5;
                  },
                  hintText: "mobile".tr,
                  fieldname: "mobile",
                  fieldType: FieldType.number,
                  validating: (value) {
                    return null;
                  },
                  onSubmitted: (val) {
                    controller.initialChildSize.value = 0.4;
                    controller.forgotMobileNo.value = val;
                    print('controller.forgotMobileNo.value: ${controller.forgotMobileNo.value}');
                  },
                ),
                UIHelper.verticalSpaceLarge,
                UIHelper().actionButton(AppColors.green, "submit".tr, radius: 15, onPressed: () {
                  controller.otpController.clearAll();

                  if (controller.utils.isNumberValid(controller.forgotMobileNo.value)) {
                    Get.back();

                    controller.forgotPassword();
                  } else {
                    controller.utils.showSnackBar("${"please".tr} ${"enter_mobile".tr}");
                  }
                }, reducewidth: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
