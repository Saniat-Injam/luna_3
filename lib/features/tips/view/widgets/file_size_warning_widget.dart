// import 'package:flutter/material.dart';
// import 'package:barbell/core/common/styles/global_text_style.dart';

// /// Widget that shows file size warnings and recommendations
// class FileSizeWarningWidget extends StatelessWidget {
//   final double fileSizeMB;
//   final VoidCallback? onCompressPressed;

//   const FileSizeWarningWidget({
//     Key? key,
//     required this.fileSizeMB,
//     this.onCompressPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (fileSizeMB <= 5) return const SizedBox.shrink();

//     Color warningColor;
//     String warningMessage;
//     IconData warningIcon;

//     if (fileSizeMB > 15) {
//       warningColor = Colors.red;
//       warningIcon = Icons.error_outline;
//       warningMessage =
//           'File is very large (${fileSizeMB.toStringAsFixed(1)}MB). Upload may fail without compression.';
//     } else if (fileSizeMB > 10) {
//       warningColor = Colors.orange;
//       warningIcon = Icons.warning_outlined;
//       warningMessage =
//           'File is large (${fileSizeMB.toStringAsFixed(1)}MB). Compression recommended for reliable upload.';
//     } else {
//       warningColor = Colors.blue;
//       warningIcon = Icons.info_outline;
//       warningMessage =
//           'File size: ${fileSizeMB.toStringAsFixed(1)}MB. Consider compression for faster upload.';
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: warningColor.withValues(alpha:0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: warningColor.withValues(alpha:0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(warningIcon, color: warningColor, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               warningMessage,
//               style: AppTextStyle.f14W400().copyWith(
//                 color: warningColor.withValues(alpha:0.8),
//               ),
//             ),
//           ),
//           if (onCompressPressed != null && fileSizeMB > 5)
//             TextButton(
//               onPressed: onCompressPressed,
//               style: TextButton.styleFrom(
//                 foregroundColor: warningColor,
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//               ),
//               child: const Text('Compress'),
//             ),
//         ],
//       ),
//     );
//   }
// }
