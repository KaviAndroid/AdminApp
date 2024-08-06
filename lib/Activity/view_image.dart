import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:admin_app/Controllers/home_controller.dart';
import 'package:admin_app/Resources/colors.dart';
import 'package:admin_app/Resources/image_path.dart';
import 'package:admin_app/Resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/view_image_controller.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

import '../Layouts/shimmer.dart';
/*

class ViewImage extends StatefulWidget {
  const ViewImage({super.key});

  @override
  State<ViewImage> createState() => ViewImageState();
}

class ViewImageState extends State<ViewImage> {
  final ViewImageController controller = Get.find<ViewImageController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      controller.arguments = Get.arguments!;
      if (controller.arguments['imagesList'] != null) {
        List<Map<String, dynamic>> imageListData = List<Map<String, dynamic>>.from(controller.arguments['imagesList']);
        List temp = [];
        for (var i in imageListData) {
          Map<String, dynamic> jsformat = Map<String, dynamic>.from(i);
          jsformat[AppStrings.key_image_available] = "Y";
          temp.add(jsformat);
        }
        controller.imageList.value = temp;
      } else {
      }
    } else {
      Get.back();
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Shimmer(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              _bodyWidget(controller),
            ],
          ),
        ),
      )
    );
  }
  Widget _bodyWidget(ViewImageController controller) {
    return Expanded(
      child: Obx(
        () => GridView.builder(
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 5 / 5),
          itemCount: controller.shimmerLoading.value ? 5 : controller.imageList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> list = controller.shimmerLoading.value ? {} : controller.imageList[index];

            if (list.isNotEmpty) {
              return Material(
                elevation: 3,
                type: MaterialType.card,
                borderRadius: BorderRadius.circular(15),
                child: list.isNotEmpty
                    ? Hero(
                        tag: index,
                        placeholderBuilder: (context, heroSize, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: FileImage(File(list[AppStrings.key_image])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(File(list[AppStrings.key_image])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            list[AppStrings.key_image]!=null?showStageImage(controller, index):null;
                          },
                          child:list[AppStrings.key_image]!=null? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: FileImage(File(list[AppStrings.key_image])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ):SizedBox(),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              ImagePath.camera,
                              opacity: const AlwaysStoppedAnimation(.6),
                              fit: BoxFit.fill,
                            ),
                            Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              color: Colors.black.withOpacity(0.25),
                            )
                          ],
                        ),
                      ),
              );
            } else {
              return ShimmerLoading(
                isLoading: controller.shimmerLoading.value,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
*/

showStageImage(imageList, int pos) {
  //Caurosal
  int currentIndex = pos;
  PageController pageScrollController = PageController(initialPage: pos);

  double tempOffset = 0;
  if (currentIndex > 9) tempOffset = currentIndex * 10;

  bool scrollRightFlag = true;
  bool scrollLeftFlag = true;

  ScrollController imgController = ScrollController(initialScrollOffset: tempOffset);

  Get.dialog(barrierDismissible: true, barrierColor: AppColors.black.withOpacity(0.6), transitionDuration: Duration(milliseconds: 800), transitionCurve: Curves.bounceIn,
      StatefulBuilder(builder: (context, setstate) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.5,
      child: Hero(
        tag: currentIndex,
        child: Stack(
          alignment: Alignment.center,
          children: [
            FractionallySizedBox(
              heightFactor: 0.8,
              child: PageView.builder(
                onPageChanged: (value) {
                  setstate(
                    () {
                      currentIndex = value;
                      if (value > 8) {
                        if (scrollRightFlag) {
                          scrollRightFlag = !scrollRightFlag;
                          imgController.animateTo(150, duration: Duration(milliseconds: 600), curve: Curves.easeIn);
                        }
                      } else {
                        if (scrollLeftFlag && !scrollRightFlag) {
                          scrollLeftFlag = !scrollLeftFlag;
                          imgController.animateTo(0, duration: Duration(milliseconds: 600), curve: Curves.easeIn);
                        }
                      }
                    },
                  );
                },
                controller: pageScrollController,
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(File(imageList[index][AppStrings.key_image])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            top: 15,
                            left: 15,
                            child: buildBlur(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                color: Colors.black.withOpacity(0.25),
                                child: ResponsiveFonts(text: "${index + 1} / ${imageList.length}", size: 13, color: AppColors.white, decoration: TextDecoration.none),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: Get.width * 0.75,
                alignment: Alignment.center,
                height: 30,
                child: SingleChildScrollView(
                  controller: imgController,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      imageList.length,
                      (index) {
                        bool isSelected = currentIndex == index;
                        return GestureDetector(
                          onTap: () {
                            pageScrollController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.linearToEaseOut);
                            imgController.animateTo(index * 10, duration: Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: isSelected ? 50 : 15,
                            height: 10,
                            margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryLiteColor : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(
                                40,
                              ),
                            ),
                            curve: Curves.ease,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }));
}

Widget buildBlur({
  required Widget child,
  required BorderRadius borderRadius,
  double sigmaX = 1,
  double sigmaY = 1,
}) =>
    ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
