import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/auth/controller/create_account_controller.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAccountController());

    return Obx(() {
      final imageFile = controller.pickedImage.value;
      return GestureDetector(
        onTap: () => _showImageSourceModal(context, controller),
        child: Container(
          height: 92,
          width: 92,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
            image:
                imageFile != null
                    ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              imageFile == null
                  ? SvgPicture.asset(
                    SvgPath.addImageSvg,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  )
                  : null,
        ),
      );
    });
  }

  // void _showImageSourceActionSheet(
  //   BuildContext context,
  //   ProfileController controller,
  // ) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder:
  //         (context) => SafeArea(
  //           child: Wrap(
  //             children: <Widget>[
  //               ListTile(
  //                 leading: const Icon(Icons.photo_library),
  //                 title: const Text('Gallery'),
  //                 onTap: () async {
  //                   // await controller.pickImageFromGallery();
  //                   Get.back();
  //                 },
  //               ),
  //               ListTile(
  //                 leading: const Icon(Icons.photo_camera),
  //                 title: const Text('Camera'),
  //                 onTap: () async {
  //                   // await controller.pickImageFromCamera();
  //                   Get.back();
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //   );
  // }

  /////////////////////////////////////////////////////////////

  Future<void> _showImageSourceModal(
    BuildContext context,
    CreateAccountController controller,
  ) async {
    final ImagePicker picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Image Source', style: AppTextStyle.f18W600()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                      );
                      if (image != null) {
                        // Handle the picked image
                        controller.handlePickedImage(File(image.path));
                      }
                    },
                  ),
                  _buildImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );
                      if (image != null) {
                        // Update the picked image in the controller
                        controller.handlePickedImage(File(image.path));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyle.f16W400().copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.f14W400().copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// Builds the default profile image widget
  // Widget _buildDefaultImage() {
  //   return Container(
  //     height: 92,
  //     width: 92,
  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(37)),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(37),
  //       child: Image.asset(ImagePath.profile, fit: BoxFit.cover),
  //     ),
  //   );
  // }
}
