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

class RejectedDoctors extends StatefulWidget {
  const RejectedDoctors({super.key});

  @override
  State<RejectedDoctors> createState() => _RejectedDoctorsState();
}

class _RejectedDoctorsState extends State<RejectedDoctors> {
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
                ResponsiveFonts(text: 'Rejected Doctors', size: 14,color: AppColors.primaryColorDark,fontWeight: FontWeight.bold,),
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
                Align(alignment: Alignment.centerLeft,child: ResponsiveFonts(text: "Rejected Doctors List", size: 14,color: AppColors.primaryColor,fontWeight: FontWeight.bold,)),
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
                        child: Stack(
                          children: [
                            Material(
                              color:AppColors.primaryLiteColor_2 ,
                              child: InkWell(
                                onTap: (){
                                  Get.toNamed(Routes.doctordetails,arguments: {"tag":tag,"flag":"rejected"});
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
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Image.asset(ImagePath.denied,height: 35,width: 35,color: AppColors.red,))
                          ],
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

