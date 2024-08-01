import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import '../Layouts/ui_helper.dart';
import '../Resources/colors.dart';
import '../Resources/strings.dart';
import '../Services/preference_services.dart';
import 'package:responsive_fonts/responsive_fonts.dart';

enum DropDownType { gender, designation, level, district, block, village, category }

class CustomDropdown extends StatefulWidget {
  final List dropDownList;
  final Function onSelected;
  final DropDownType type;
  final dynamic initValue;
  final String hintText;
  final dynamic validating;
  final bool isEnable;
  final double? height;
  final bool showlabel;
  const CustomDropdown(
      {super.key,
      required this.dropDownList,
      required this.onSelected,
      required this.type,
      required this.hintText,
      required this.validating,
      this.showlabel = false,
      this.isEnable = true,
      this.height = 48.0,
      this.initValue = ""});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final PreferenceService preferencesService = Get.find<PreferenceService>();

  String lang = "";
  String key = "";
  String value = "";

  @override
  void initState() {
    super.initState();

    lang = preferencesService.selectedLanguage;

    switch (widget.type) {
      case DropDownType.level:
        key = AppStrings.key_localbody_code;
        value = AppStrings.key_localbody_name;
        break;
      case DropDownType.designation:
        key = AppStrings.key_desig_code;
        value = AppStrings.key_desig_name;
        break;
      case DropDownType.district:
        key = AppStrings.key_dcode;
        value = lang == "ta" ? AppStrings.key_dname_ta : AppStrings.key_dname;
        break;
      case DropDownType.block:
        key = AppStrings.key_bcode;
        value = lang == "ta" ? AppStrings.key_bname_ta : AppStrings.key_bname;
        break;
      case DropDownType.gender:
        key = AppStrings.key_gender_code;
        value = lang == "ta" ? AppStrings.key_gender_name_ta : AppStrings.key_gender_name_en;
        break;
      case DropDownType.village:
        key = AppStrings.key_pvcode;
        value = lang == "ta" ? AppStrings.key_pvname_ta : AppStrings.key_pvname;
        break;
      case DropDownType.category:
        key = AppStrings.key_category_id;
        value = AppStrings.key_category_name;
        break;
      default:
        key = AppStrings.key_gender_code;
        value = lang == "ta" ? AppStrings.key_gender_name_ta : AppStrings.key_gender_name_en;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showlabel) ResponsiveFonts(text: widget.hintText, size: 12, color: AppColors.primaryColor),
        Container(
          height: widget.height,
          decoration: UIHelper.roundedBorderWithColor(10, AppColors.white),
          child: IgnorePointer(
            ignoring: !widget.isEnable,
            child: FormBuilderDropdown(
              name: key,
              initialValue: widget.initValue,
              decoration: UIHelper.inputDecorateWidget(widget.hintText),
              borderRadius: BorderRadius.circular(10),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              items: widget.dropDownList
                  .map((item) => DropdownMenuItem(
                        alignment: AlignmentDirectional.centerStart,
                        value: item[key].toString(),
                        child: ResponsiveFonts(
                          text: item[value] ?? "",
                          size: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                  .toList(),
              onChanged: (value) async {
                widget.onSelected(value);
              },
              validator: widget.validating,
            ),
          ),
        ),
      ],
    );
  }
}
