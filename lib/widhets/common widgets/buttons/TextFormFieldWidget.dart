import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final String iconPath;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool? readOnly;
  final Function(String)? onChanged;


  const CustomTextField({
    Key? key,
    required this.keyboardType,
    required this.controller,
    required this.hintText,
    required this.iconPath,
    this.inputFormatters,
    this.onTap,
    this.validator,
    this.readOnly,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (onChanged),
      readOnly: readOnly ?? false,
      onTap: onTap,
      validator: validator, // 🔥 Added validator here
      keyboardType: keyboardType,
      controller: controller,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.kSkyBlue,
      cursorErrorColor: Colors.red,
      style: const TextStyle(color: AppColors.kWhite),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        contentPadding: const EdgeInsets.all(15),
        isDense: true,
        fillColor: AppColors.kWhite,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(iconPath, color: Colors.grey,),
        ),
      ),
    );
  }
}
