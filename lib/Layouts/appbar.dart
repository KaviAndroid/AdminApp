import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Resources/colors.dart';
import 'package:responsive_fonts/responsive_fonts.dart';
import '../Services/preference_services.dart';
import '../Services/utils.dart';

class CommonAppBar extends StatefulWidget {
  const CommonAppBar({super.key, required this.title, this.onBackPressCheck});
  final String title;
  final VoidCallback? onBackPressCheck;
  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  Utils utils = Utils();
  String langText = 'தமிழ்';
  final PreferenceService pref = Get.find<PreferenceService>();
  @override
  void initState() {
    super.initState();
    if (pref.selectedLanguage == "en") {
      langText = 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      padding: EdgeInsets.fromLTRB((widget.title == "home_page".tr ? 10 : 16), 10, 16, 10),
      child: Row(
        children: [
          if (widget.title == "home_page".tr)
            PopupMenuButton<String>(
              color: AppColors.white,
              onSelected: ((value) {
                if (value != langText) {
                  langText = value;
                  utils.languageChange(value);
                }
                setState(() {});
              }),
              itemBuilder: (BuildContext context) {
                return {'தமிழ்', 'English'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: ResponsiveFonts(text: choice, color: AppColors.black, size: 14),
                  );
                }).toList();
              },
              child: Row(
                children: [
                  Container(padding: EdgeInsets.only(left: 10), child: ResponsiveFonts(text: langText, color: AppColors.white, size: 14)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_downward_rounded, size: 15, color: AppColors.white),
                  ),
                ],
              ),
            ),
          if (widget.title != "home_page".tr)
            GestureDetector(
              onTap: widget.onBackPressCheck != null
                  ? widget.onBackPressCheck
                  : () {
                      Get.back();
                    },
              child: Icon(Icons.arrow_back_ios, color: AppColors.white),
            ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: widget.title == "home_page".tr ? 50 : 0),
                  alignment: widget.title == "home_page".tr ? Alignment.centerLeft : Alignment.center,
                  child: ResponsiveFonts(text: widget.title, size: 16, color: AppColors.white, fontWeight: FontWeight.w600))),
          if (widget.title == "home_page".tr)
            GestureDetector(
              onTap: () {
                gotoLogout();
              },
              child: Icon(Icons.logout_rounded, color: AppColors.white, size: 22),
            ),
        ],
      ),
    );
  }

  Future<void> gotoLogout() async {}
}
