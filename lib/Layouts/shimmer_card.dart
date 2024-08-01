import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Layouts/shimmer.dart';
import '../Resources/colors.dart';

class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  const ShimmerCard({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    double cardWidth;
    double cardHeight;
    if (width != null)
      cardWidth = width!;
    else
      cardWidth = Get.width * 0.85;
    if (height != null)
      cardHeight = height!;
    else
      cardHeight = Get.height * 0.18;
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.light_black, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          ShimmerLoading(
            isLoading: true,
            child: Container(
              width: Get.width * 0.25,
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _shimmerTextLoader(Get.width * 0.35),
              _shimmerTextLoader(Get.width * 0.42),
              _shimmerTextLoader(Get.width * 0.25),
            ],
          )
        ],
      ),
    );
  }

  ShimmerLoading _shimmerTextLoader(double width) {
    return ShimmerLoading(
      isLoading: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: SizedBox(
          width: width,
          height: Get.width * 0.035,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
