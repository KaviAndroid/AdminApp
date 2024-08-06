import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Services/utils.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

enum FieldType { email, text, number, password, multiline }

class CustomInput extends StatefulWidget {
  final String hintText;
  final String? initvalue;
  final String fieldname;
  final FieldType fieldType;
  final dynamic validating;
  final Function onEnter;
  final Function? onSubmitted;
  final Function? onTap;
  final double? height;
  final Widget? prefixwidget;
  final Widget? suffixWidget;
  final bool showpassword;
  final bool showlabel;
  final bool closeKeyboard;
  const CustomInput(
      {super.key,
      required this.hintText,
      required this.fieldname,
      required this.validating,
      required this.onEnter,
      this.onSubmitted,
      this.onTap,
      this.fieldType = FieldType.text,
      this.height,
      this.prefixwidget,
      this.suffixWidget,
      this.showpassword = false,
      this.showlabel = false,
      this.closeKeyboard = true,
      this.initvalue});
  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    switch (widget.fieldType) {
      case FieldType.email:
        inputType = TextInputType.emailAddress;
        break;
      case FieldType.number:
        inputType = TextInputType.number;
        break;
      case FieldType.multiline:
        inputType = TextInputType.multiline;
        break;
      default:
        inputType = TextInputType.text;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showlabel) ResponsiveFonts(text: widget.hintText, size: 12, color: AppColors.primaryColor),
        Container(
          height: widget.height,
          decoration: UIHelper.roundedBorderWithColor(10, Colors.transparent,borderColor: AppColors.secondaryColor2,borderWidth: 1),
          child: FormBuilderTextField(
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.black),
            name: widget.fieldname,
            minLines: widget.fieldname=="description"?5:1,
            maxLines: null,
            maxLength: widget.fieldname=="mobile"?10:null,
            initialValue: widget.initvalue ?? "",
            obscureText: widget.showpassword,
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTap: () {
              widget.onTap != null ? widget.onTap!() : null;
            },
            onChanged: (value) {
              widget.onEnter(value);
            },
            onSubmitted: (value) {
              widget.onSubmitted != null ? widget.onSubmitted!(value) : null;
            },
            onTapOutside: (event) {
              widget.closeKeyboard ? Utils().closeKeyboard() : null;
            },
            decoration: UIHelper.inputDecorateWidget(widget.hintText, suffixWidget: widget.suffixWidget),
            keyboardType: inputType,
            validator: widget.validating,
          ),
        ),
      ],
    );
  }
}
