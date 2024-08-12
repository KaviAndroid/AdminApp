import 'dart:convert';
import 'dart:io';

import 'package:admin_app/Activity/splash.dart';
import 'package:admin_app/Controllers/view_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../../Layouts/custom_alert.dart';
import '../../Services/routes_services.dart';
import '../../Services/utils.dart';
import '../Controllers/home_controller.dart';
import '../Layouts/CurvedNavigationBar.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Resources/strings.dart';
import 'AddNewArticle.dart';
import 'Articles.dart';
import 'PendingDoctors.dart';
import 'RejectedDoctors.dart';
import 'Settings.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Utils utils = Utils();
  final HomeController homecontroller = Get.find<HomeController>();
  final ViewImageController viewImageController = Get.find<ViewImageController>();
  String profile = "";
  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    profile = await homecontroller.prefs.getString(AppStrings.key_profile_image);
    homecontroller.page.value=0;
    await viewImageController.getArticleApi();
    setState(() {});

  }
  Future<bool> showExitPopup({isLogout = false}) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ResponsiveFonts(text:isLogout ? 'Logout' : 'Exit App',color:  AppColors.black,size: 13

          ,),
        content: ResponsiveFonts(text:isLogout ? 'Are you sure to logout' : 'Do you want to exit from app',color:  AppColors.black,size: 12,),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text(
              'No',
            ),
          ),
          ElevatedButton(
            onPressed: isLogout
                ? () {
              homecontroller.prefs.cleanAllPreferences();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Splash()), (route) => false);
            }
                : () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: Text(
              'Yes',
            ),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
  List<Widget> pageList = [
    Articles(),
    PendingDoctors(),
    AddNewArticle(flag: "new",),
    RejectedDoctors(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Obx(()=>
         Scaffold(
          backgroundColor: AppColors.white,
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
            index: homecontroller.page.value,
            buttonBackgroundColor: AppColors.primaryColorDark,
            backgroundColor: Colors.transparent,
            color: AppColors.primaryColorDark,
            items: [
              CurvedNavigationBarItem(
                  child: Image.asset(
                    height: 25,
                    width: 25,
                    ImagePath.article,
                    color: Colors.white,
                  ),
                  label: 'Articles',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis
                  )),
              CurvedNavigationBarItem(
                  child: Image.asset(
                    ImagePath.doctor,
                    height: 25,
                    width: 25,
                    color: Colors.white,
                  ),
                  label: 'Doctors',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis
                  )),
              CurvedNavigationBarItem(
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                  label: 'Add',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis
                  )),
              CurvedNavigationBarItem(
                  child: Image.asset(
                    ImagePath.rejected,
                    color: Colors.white,
                    height: 25,
                    width: 25,
                  ),
                  label: 'Rejected Drs',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis
                  )),
              CurvedNavigationBarItem(
                  child: Image.asset(
                    ImagePath.settings,
                    color: Colors.white,
                    height: 22,
                    width: 22,
                  ),
                  label: 'Settings',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis
                  )),
            ],
            onTap: (index) {
              setState(() {
                homecontroller.page.value = index;
              });
            },
          ),
          body: pageList.elementAt(homecontroller.page.value),
        ),
      ),
    );
  }
  Future<void> onSearchQueryChanged(String query) async {
    homecontroller.doctorslist.clear();
    homecontroller.searchenabled = true;
    for (var data in homecontroller.doctorslist) {
      String name = data["name"].toString().toLowerCase();
      String specialist = data["specialist"].toString().toLowerCase();
       if (name.contains(query.toLowerCase()) ||
           specialist.contains(query.toLowerCase())) {
        homecontroller.filteredDoctorslist.add(data);
      }
    }
    setState(() {
    });
  }
}
