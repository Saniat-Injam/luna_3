import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

class MenuItem extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = AppColors.textOrange,
    required this.onTap,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem>
    with SingleTickerProviderStateMixin {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isClicked = true;
        });
        // Trigger the onTap callback
        widget.onTap();
        // Revert the clicked state after a short delay (e.g., 200ms)
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              _isClicked = false;
            });
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(0.8), // Gradient border thickness
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff254933), // Start color
              const Color(0xff254933).withValues(alpha: 0.3), // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
                _isClicked
                    ? AppColors.border.withValues(alpha: 0.5)
                    : AppColors.background,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff303502)),
                  color: const Color(0xff1F2301),
                ),
                child: Image.asset(
                  widget.icon,
                  color: widget.iconColor,
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.title,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textWhite,
                  lineHeight: 18,
                ),
              ),

              Text(
                widget.subtitle,
                style: getTextStyle(
                  fontSize: 12,
                  color: AppColors.textSub,
                  lineHeight: 12,
                ),
              ),
              const SizedBox(height: 10),
              SvgPicture.asset(SvgPath.divider, width: 100, height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
