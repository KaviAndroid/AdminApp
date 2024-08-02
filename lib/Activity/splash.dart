import 'package:admin_app/Resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Services/routes_services.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isAnimation = false;

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      isAnimation = true;
      setState(() {});
    });
    Future.delayed(
      Duration(seconds: 2),
      () => Get.toNamed(Routes.signin),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          UIHelper.bgDesign(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  padding: EdgeInsets.all(10),
                  decoration: UIHelper.circledecorationWithColor(AppColors.secondaryColor, AppColors.primaryColor),
                  height: isAnimation ? Get.width / 2.5 : 0,
                  width: isAnimation ? Get.width / 2.5 : 0,
                  margin: EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(ImagePath.admin, fit: BoxFit.cover),
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                if (isAnimation) ResponsiveFonts(text: AppStrings.appname, size: 25, color: AppColors.black, fontWeight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
