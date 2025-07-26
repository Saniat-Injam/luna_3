// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:barbell/features/tips/controllers/upload_video_tip_controller.dart';

// /// Widget that displays compression status and controls for video upload
// /// Shows compression progress and allows user to cancel compression
// class VideoCompressionStatusWidget extends StatelessWidget {
//   const VideoCompressionStatusWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<UploadVideoTipController>(
//       builder: (controller) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Compression status message
//             if (controller.compressionStatus.value.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color:
//                       controller.compressionStatus.value.contains('failed')
//                           ? Colors.red.withValues(alpha:0.1)
//                           : Colors.blue.withValues(alpha:0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color:
//                         controller.compressionStatus.value.contains('failed')
//                             ? Colors.red.withValues(alpha:0.3)
//                             : Colors.blue.withValues(alpha:0.3),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       controller.compressionStatus.value.contains('failed')
//                           ? Icons.error_outline
//                           : controller.compressionStatus.value.contains(
//                             'successfully',
//                           )
//                           ? Icons.check_circle_outline
//                           : Icons.info_outline,
//                       color:
//                           controller.compressionStatus.value.contains('failed')
//                               ? Colors.red
//                               : controller.compressionStatus.value.contains(
//                                 'successfully',
//                               )
//                               ? Colors.green
//                               : Colors.blue,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         controller.compressionStatus.value,
//                         style: TextStyle(
//                           color:
//                               controller.compressionStatus.value.contains(
//                                     'failed',
//                                   )
//                                   ? Colors.red[700]
//                                   : controller.compressionStatus.value.contains(
//                                     'successfully',
//                                   )
//                                   ? Colors.green[700]
//                                   : Colors.blue[700],
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//             // Compression progress indicator
//             if (controller.isCompressing.value)
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             'Compressing video... ${controller.compressionProgress.value.toStringAsFixed(0)}%',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: controller.cancelCompression,
//                           child: const Text('Cancel'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     LinearProgressIndicator(
//                       value: controller.compressionProgress.value / 100,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
