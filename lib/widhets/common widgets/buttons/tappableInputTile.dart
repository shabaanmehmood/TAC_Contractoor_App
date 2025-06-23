import 'package:flutter/material.dart';
import 'package:taccontractor/data/data/constants/constants.dart';

class TappableInputTile extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final VoidCallback onTap;

  TappableInputTile({
    Key? key,
    this.controller,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayText = (controller != null && controller!.text.isNotEmpty)
        ? controller!.text
        : title;

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTypography.kLight14.copyWith(
                      color: displayText == title
                          ? AppColors.kinput
                          : Colors.white, // Highlight selected
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: AppColors.kSkyBlue,
          ),
        ],
      ),
    );
  }
}
