import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Services/utils.dart';

class OtpController extends GetxController {
  // Create a TextEditingController for each OTP field
  List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());

  // Current active index
  var activeIndex = 0.obs;

  // Method to handle input from custom keyboard
  void handleInput(int value) {
    if (activeIndex.value < otpControllers.length) {
      otpControllers[activeIndex.value].text = value.toString();
      moveFocus(activeIndex.value);
    }
  }

  void clearAll() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    activeIndex.value = 0;
  }

  void handleBackspace() {
    if (activeIndex.value > 0) {
      otpControllers[activeIndex.value - 1].text = '';
      activeIndex.value = activeIndex.value - 1;
    }
  }

  void moveFocus(int index) {
    if (index < otpControllers.length - 1) {
      activeIndex.value = index + 1;
    } else {
      activeIndex.value = otpControllers.length; // All fields filled
    }
  }

  submitOtp() {
    for (var controller in otpControllers) {
      if (controller.text.isEmpty) {
        Utils().showSnackBar("Please enter all the OTP fields.");
        return '';
      }
    }

    String otp = otpControllers.map((controller) => controller.text).join();
    return otp;
  }
}

class OtpDesign extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: UIHelper.roundedBorderWithColor(
        8,
        Colors.transparent,
        borderColor: AppColors.white,
        borderWidth: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return Obx(() => Container(
                width: 45,
                height: 45,
                margin: EdgeInsets.all(2),
                decoration: UIHelper.roundedBorderWithColor(
                  8,
                  controller.activeIndex.value == index ? Colors.white : AppColors.primaryLiteColor.withOpacity(0.5),
                ),
                child: Center(
                  child: Text(
                    controller.otpControllers[index].text,
                    style: TextStyle(
                      color: controller.activeIndex.value == index ? AppColors.primaryColor : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
