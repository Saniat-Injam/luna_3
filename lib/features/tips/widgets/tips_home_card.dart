import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';

class TipsTabCard extends StatelessWidget {
  const TipsTabCard({super.key, this.label, required this.icon});

  final String? label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizer.wp(158),
      height: Sizer.hp(140),
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.wp(17.18),
        vertical: Sizer.hp(12),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff22432F), width: 0.86),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        spacing: 12,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff1E2301),
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xff373D02), width: 0.86),
            ),
            child: SvgPicture.asset(icon, width: 20, height: 20),
          ),
          Text(
            label ?? '',
            style: AppTextStyle.f14W400().copyWith(color: Colors.white),
          ),

          SvgPicture.asset(SvgPath.divider, width: 152, height: 0.86),
        ],
      ),
    );
  }
}
