import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/data/constants/app_colors.dart';
import '../../../data/data/constants/app_typography.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final IconData? icon;
  final bool iconOnRight;
  final double? height;
  final double? width;
  final double borderRadius;

  const CustomButtonWithIcon({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.icon,
    this.iconOnRight = false,
    this.height,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final double btnHeight = height ?? Get.height * 0.065;
    final double btnWidth = width ?? Get.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.kSkyBlue,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: icon != null
                ? iconOnRight
                    ? [
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.kLight14.copyWith(
                              color: AppColors.kBlack,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(icon, color: AppColors.kBlack, size: Get.width * 0.05),
                      ]
                    : [
                        Icon(icon, color: AppColors.kBlack, size: Get.width * 0.05),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.kBold16.copyWith(
                              color: AppColors.kBlack,
                            ),
                          ),
                        ),
                      ]
                : [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.kBold16.copyWith(
                          color: AppColors.kWhite,
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
