import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/food_logging/controllers/food_image_controller.dart';

class FoodImageUploadWidget extends StatelessWidget {
  final FoodImageController controller;
  final String? imageUrl;

  const FoodImageUploadWidget({
    super.key,
    required this.controller,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: controller.pickImage,
        child: Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.appbar,
            borderRadius: BorderRadius.circular(6),
            image:
                controller.imagePath != null
                    ? DecorationImage(
                      image: FileImage(File(controller.imagePath!)),
                      fit: BoxFit.cover,
                    )
                    : imageUrl != null
                    ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              controller.isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : controller.imagePath == null && imageUrl == null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SvgPath.addImageSvg,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to add image',
                          style: TextStyle(
                            color: AppColors.textWhite.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(), // Empty container for stack layout
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: controller.clearImage,
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      );
    });
  }
}
