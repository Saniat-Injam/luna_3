// import 'package:flutter/material.dart';
// import 'package:barbell/core/common/styles/global_text_style.dart';
// import 'package:barbell/core/utils/constants/colors.dart';

// class TrackButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final String text;

//   const TrackButton({
//     super.key,
//     required this.onTap,
//     required this.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       width: double.infinity,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.32,
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//               color: AppColors.secondary,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: getTextStyleWorkSans(
//                 color: AppColors.textfieldBackground,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
