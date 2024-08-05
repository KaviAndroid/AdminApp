import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_fonts/responsive_fonts.dart';
import '../../Services/routes_services.dart';
import '../../Services/utils.dart';
import '../Controllers/home_controller.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import '../Resources/strings.dart';

class PendingDoctors extends StatefulWidget {
  const PendingDoctors({super.key});

  @override
  State<PendingDoctors> createState() => _PendingDoctorsState();
}

class _PendingDoctorsState extends State<PendingDoctors> {
  Utils utils = Utils();
  final HomeController homecontroller = Get.find<HomeController>();
  String profile = "";
  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    profile = await homecontroller.prefs.getString(AppStrings.key_profile_image);
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // UIHelper.bgDesign2(),
        Scaffold(
          backgroundColor: Colors.white,
          body:Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                UIHelper.verticalSpaceSmall,
                Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          padding: EdgeInsets.all(5),
                          decoration: UIHelper.circledecorationWithColor(AppColors.secondaryColor, AppColors.primaryColor),
                          height: Get.width / 5 ,
                          width: Get.width / 5 ,
                          margin: EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(ImagePath.admin, fit: BoxFit.cover),
                          ),
                        ),
                        UIHelper.horizontalSpaceTiny,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIHelper.verticalSpaceSmall,
                              ResponsiveFonts(text: 'Hi Admin!', size: 20,color: AppColors.primaryColor,fontWeight: FontWeight.bold,),
                              UIHelper.verticalSpaceSmall,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(ImagePath.location, fit: BoxFit.cover,height: 20,width: 20,),
                                  UIHelper.horizontalSpaceTiny,
                                  Expanded(child: ResponsiveFonts(text: 'K. AIYAPPAN, (SECRETARY). 21, Sabari Street, Nesapakkam,. K.K. Nagar West, Chennai - 600 078.', size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.normal,)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                UIHelper.verticalSpaceMedium,
                Container(decoration: UIHelper.roundedBorderWithColor(10, AppColors.white,borderWidth: 2,borderColor: AppColors.primaryColor,),
                  padding: EdgeInsets.all(20),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveFonts(text: 'Welcome!', size: 16,color: AppColors.primaryColor,fontWeight: FontWeight.bold,),
                          UIHelper.verticalSpaceSmall,
                          ResponsiveFonts(text: 'Lets start doctors profile validation.', size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.normal,)
                        ],),
                    ),
                    Image.asset(ImagePath.select_profile, fit: BoxFit.cover,width: Get.width/3,height: Get.width/3,),
                  ],),),
                UIHelper.verticalSpaceSmall,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 5),
                  decoration: UIHelper.roundedBorderWithColor(30, AppColors.primaryLiteColor_4),
                  child: Center(
                    child: TextField(
                      cursorColor: AppColors.grey2,
                      maxLines: null,
                      onChanged: (String value) async {
                        onSearchQueryChanged(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search",
                        hintStyle: TextStyle(color: AppColors.grey2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                Align(alignment: Alignment.centerLeft,child: ResponsiveFonts(text: "Doctors List", size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
                UIHelper.verticalSpaceMedium,
                Expanded(
                  child:GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: List.generate(10/*homecontroller.searchenabled?homecontroller.filteredDoctorslist.length:homecontroller.doctorslist.length*/, (index) {
                      // final item=homecontroller.searchenabled?homecontroller.filteredDoctorslist[index]:homecontroller.doctorslist[index];
                      String tag="Hero"+index.toString();
                      return Container(
                        width:Get.width,
                        padding: EdgeInsets.all(10),
                        decoration: UIHelper.roundedBorderWithColor(10, AppColors.primaryLiteColor_2),
                        child: Material(
                          color:AppColors.primaryLiteColor_2 ,
                          child: InkWell(
                            onTap: (){
                              Get.toNamed(Routes.doctordetails,arguments: {"tag":tag});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag:tag,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(ImagePath.admin, fit: BoxFit.cover,height: 80,width: 80,),
                                    ),
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall,
                                ResponsiveFonts(text: 'Dr.Test User', size: 15,color: AppColors.primaryColorDark,fontWeight: FontWeight.normal,),
                                UIHelper.verticalSpaceTiny,
                                ResponsiveFonts(text: 'Cardiologist', size: 13,color: AppColors.primaryLiteColor,fontWeight: FontWeight.normal,)

                              ],),
                          ),
                        ),
                      );
                    }
                    ),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
              ],),
          ),
        ),
      ],
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

