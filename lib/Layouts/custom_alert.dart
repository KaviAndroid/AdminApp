import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/image_path.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

enum AlertType { success, fail, warning, others }

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key, required this.alertType, required this.hintText, this.action = const <Widget>[]});
  final String hintText;
  final List<Widget> action;
  final AlertType alertType;
  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String title = "";
  Color aprimaryclr = Colors.black;
  String icon = "";
  @override
  void initState() {
    super.initState();

    if (widget.alertType == AlertType.success) {
      title = "Success";
      aprimaryclr = AppColors.green;
      icon = ImagePath.success;
    } else if (widget.alertType == AlertType.warning) {
      title = "Warning";
      aprimaryclr = AppColors.orange;
      icon = ImagePath.warning;
    } else if (widget.alertType == AlertType.fail) {
      title = "Failiure";
      aprimaryclr = AppColors.red;
      icon = ImagePath.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon.isNotEmpty) Image.asset(icon, height: 50, width: 50),
            ResponsiveFonts(text: title, size: 16, fontWeight: FontWeight.bold, color: aprimaryclr),
            UIHelper.verticalSpaceSmall,
            ResponsiveFonts(text: widget.hintText, size: 12, fontWeight: FontWeight.bold),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.action,
            )
          ],
        ),
      ),
    );
  }
}
