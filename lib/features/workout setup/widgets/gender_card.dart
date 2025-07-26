import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class GenderCard extends StatelessWidget {
  final String iconPath;
  final String text;
  final String imagePath;

  final bool isSelected;
  final VoidCallback onTap;

  // Padding options
  final EdgeInsets iconTextRowPadding;
  final EdgeInsets checkboxPadding;
  final EdgeInsets imagePadding;

  const GenderCard({
    super.key,
    required this.iconPath,
    required this.text,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    this.iconTextRowPadding = const EdgeInsets.only(right: 125.0, top: 15),
    this.checkboxPadding = const EdgeInsets.only(top: 65, right: 165),
    this.imagePadding = const EdgeInsets.only(right: 10),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140.53,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.appbar,
          border: Border.all(
            color:
                isSelected
                    ? AppColors
                        .secondary // Yellow when selected
                    : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      iconPath,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      text,
                      style: getTextStyle1(
                        color: AppColors.backgroundLight,
                        fontSize: 15.58,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ).paddingOnly(
                  right: iconTextRowPadding.right,
                  top: iconTextRowPadding.top,
                ),

                Padding(
                  padding: checkboxPadding,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.backgroundLight,
                        width: 2,
                      ),
                      color: isSelected ? Colors.transparent : null,
                    ),
                    child:
                        isSelected
                            ? const Center(
                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.white,
                              ),
                            )
                            : null,
                  ),
                ),
              ],
            ),

            Flexible(
              child: Padding(
                padding: imagePadding,
                child: Image.asset(
                  imagePath,
                  width: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
