import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';

import '../../../data/data/constants/app_typography.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? color;
  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.fontSize,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: widget.height ?? Get.height * 0.06,
        alignment: Alignment.center,
        width: widget.width ?? double.maxFinite,
        decoration: BoxDecoration(
          color: widget.color ??
              (isDarkMode(context) ? Colors.black : AppColors.kSkyBlue),
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppSpacing.fiveHorizontal,
          ),
        ),
        child: Text(
          widget.text,
          style: AppTypography.kBold20.copyWith(
            color: widget.color == null ? Colors.white : Colors.black,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }
}
