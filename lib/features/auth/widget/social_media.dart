import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialAuth extends StatelessWidget {
  const SocialAuth({super.key, required this.svgIconPath, this.onTap});

  final String svgIconPath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color(0xff50535B), width: 0.8),
          color: Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SvgPicture.asset(svgIconPath),
        ),
      ),
    );
  }
}

// class SocialMedia extends StatelessWidget {
//   const SocialMedia({super.key, required this.svgIconPath});

//   // List of social media icon asset paths
//   static const List<String> iconPaths = [
//     IconPath.googleSvg,
//     IconPath.facebookSvg,
//   ];

//   final String svgIconPath;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       spacing: 8,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(color: AppColors.textSecondary, width: 0.8),
//             color: Colors.transparent,
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: SvgPicture.asset(svgIconPath),
//           ),
//         ),

//       ],

//       // children: List.generate(iconPaths.length, (index) {
//       //   final iconPath = iconPaths[index];
//       //   return Container(
//       //     decoration: BoxDecoration(
//       //       borderRadius: BorderRadius.circular(18),
//       //       border: Border.all(color: AppColors.textSecondary, width: 0.8),
//       //       color: Colors.transparent,
//       //     ),
//       //     child: Padding(
//       //       padding: EdgeInsets.all(16),
//       //       child: SvgPicture.asset(iconPath),
//       //     ),
//       //   );
//       // }),
//     );
//   }
// }
