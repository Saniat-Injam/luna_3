import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/services/app_service.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/auth/view/login_screen.dart';
import 'package:barbell/features/profile/controller/profile_controller.dart';
import 'package:barbell/features/profile/view/privacy_policy_screen.dart';
import 'package:barbell/features/profile/widget/custom_row.dart';
import 'package:barbell/features/profile/widget/notification_toggle_row.dart';
import 'package:barbell/features/workout%20setup/controller/workout_setup_controller.dart';
import 'package:barbell/features/workout%20setup/view/app_setup_screen_1.dart';

import '../widget/custom_container.dart';

/// A screen that displays and manages user profile information.
/// This includes profile picture, personal details, and account settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.put(ProfileController());

  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController heightTEController = TextEditingController();
  final TextEditingController weightTEController = TextEditingController();
  final TextEditingController ageTEController = TextEditingController();

  @override
  void dispose() {
    nameTEController.dispose();
    heightTEController.dispose();
    weightTEController.dispose();
    ageTEController.dispose();
    super.dispose();
  }

  bool isEditing = false;

  @override
  void initState() {
    _setProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getProfileData();
    return Scaffold(
      appBar: AppBarWidget(
        title: "Profile",
        showNotification: true,
        showBackButton: isEditing,
        onClickBackButton: () {
          setState(() {
            // reset the text controllers
            nameTEController.text = profileController.profileModel?.name ?? '';
            heightTEController.text = cmToFeet(
              profileController.profileModel?.workoutSetup?.height.toDouble() ??
                  0,
            );
            weightTEController.text =
                profileController.profileModel?.workoutSetup?.weight
                    .toString() ??
                '';
            ageTEController.text =
                profileController.profileModel?.workoutSetup?.age.toString() ??
                '';
            isEditing = false;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const SizedBox(height: 15),
              _buildProfileHeader(),
              _buildUserStats(profileController),
              const SizedBox(height: 24),
              if (!isEditing) _buildAccountSection(),
              const SizedBox(height: 40),
              SizedBox(height: isEditing ? Sizer.hp(220) : Sizer.hp(50)),
              isEditing ? _buildEditButton() : _buildLogoutButton(),
              const SizedBox(height: 29),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the profile header section containing the profile picture and name
  Widget _buildProfileHeader() {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            // ------------------------ profile image ------------------------
            Stack(children: [_buildProfileImage()]),
            const SizedBox(height: 10),
            // ------------------------ profile name ------------------------
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: width * 0.8,
                height: 40,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    nameTEController.text = value;
                  },
                  readOnly: !isEditing,
                  controller: nameTEController,
                  style: getTextStyle2(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    isCollapsed: true,
                    isDense: true, // isCollapsed: true,
                    // isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ],
    );
  }

  /// Shows a bottom modal sheet with options to pick image from camera or gallery

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

  /// Builds the profile image widget with edit pencil when isEditing is true
  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: isEditing ? _showImageSourceModal : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() {
            // Show selected image if available
            if (profileController.pickedImage.value != null) {
              return Container(
                height: 92,
                width: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(37),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(37),
                  child: Image.file(
                    profileController.pickedImage.value!,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (profileController.profileModel?.img != null) {
              return Container(
                height: 92,
                width: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(37),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(37),
                  child: CachedNetworkImage(
                    imageUrl: profileController.profileModel!.img!,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return _buildDefaultImage();
                    },
                  ),
                ),
              );
            }

            // Default image
            return _buildDefaultImage();
          }),
          if (isEditing)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAFF55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the user statistics section (height, weight, age)
  Widget _buildUserStats(ProfileController profileController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ------------------------ height ------------------------
        Expanded(
          child: CustomContiner(
            controller: heightTEController,
            titleText: 'HEIGHT',
            readOnly: !isEditing,
            onChanged: (value) {
              if (double.tryParse(value) == null) {
                heightTEController.clear();
                EasyLoading.showError(
                  '❌ Invalid height value. Please enter a valid number.',
                  duration: const Duration(seconds: 1),
                );
                return;
              }
            },
          ),
        ),
        const SizedBox(width: 10), // Add spacing between items
        // ------------------------ weight ------------------------
        Expanded(
          child: CustomContiner(
            controller: weightTEController,
            titleText: 'WEIGHT',
            readOnly: !isEditing,
            onChanged: (value) {
              if (int.tryParse(value) == null) {
                weightTEController.clear();
                EasyLoading.showError(
                  '❌ Invalid weight value. Please enter a valid number.',
                  duration: const Duration(seconds: 1),
                );
                return;
              }
            },
          ),
        ),
        const SizedBox(width: 10), // Add spacing between items
        // ------------------------ age ------------------------
        Expanded(
          child: CustomContiner(
            controller: ageTEController,
            onChanged: (value) {
              if (int.tryParse(value) == null) {
                ageTEController.clear();
                EasyLoading.showError(
                  '❌ Invalid age value. Please enter a valid number.',
                  duration: const Duration(seconds: 1),
                );
                return;
              }
            },
            titleText: 'AGE',
            readOnly: !isEditing,
          ),
        ),
      ],
    );
  }

  /// Builds the account section with privacy policy and notifications
  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // ------------------------ edit profile ------------------------
        InkWell(
          onTap: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
          child: CustomRow(
            leadingIcon: SvgPath.personSvg,
            title: 'Edit Profile',
            trailingIcon: IconPath.next,
          ),
        ),

        // ------------------------ edit Workout ------------------------
        InkWell(
          onTap: () {
            Get.find<WorkoutSetupController>().updateWorkoutSetup();
            Get.to(() => AppSetupScreen1());
          },
          child: CustomRow(
            leadingIcon: SvgPath.availableEquipmentSvg,
            title: 'Edit Workout',
            trailingIcon: IconPath.next,
          ),
        ),
        // ------------------------ privacy policy ------------------------
        CustomRow(
          leadingIcon: IconPath.policy,
          title: 'Privacy Policy and Terms',
          trailingIcon: IconPath.next,
          onTap: () => Get.to(() => PrivacyPolicyScreen()),
        ),
        // ------------------------ notifications ------------------------
        NotificationToggleRow(
          leadingIcon: IconPath.notification1,
          title: 'Notifications',
        ),
      ],
    );
  }

  Future<void> _showImageSourceModal() async {
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
                        profileController.handlePickedImage(File(image.path));
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
                        profileController.handlePickedImage(File(image.path));
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

  /// Builds the default profile image widget
  Widget _buildDefaultImage() {
    return Container(
      height: 92,
      width: 92,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(37)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(37),
        child: Image.network(
          StorageService.imgUrl ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 92, color: Colors.white54);
          },
        ),
      ),
    );
  }

  /// Builds the logout button at the bottom of the screen
  Widget _buildLogoutButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            // Professional way: Handle FCM token cleanup before logout
            await AppService.onUserLogout();

            // Clear all local data
            await StorageService.clearAllDataFromStorage();

            // Navigate to login
            Get.offAll(() => const LoginScreen());
          },
          child: Text(
            'Log out',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFFEAFF55),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the edit button at the bottom of the screen
  Widget _buildEditButton() {
    return Align(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: () async {
          if (nameTEController.text.isNotEmpty &&
              heightTEController.text.isNotEmpty &&
              weightTEController.text.isNotEmpty &&
              ageTEController.text.isNotEmpty &&
              double.tryParse(heightTEController.text) != null &&
              int.tryParse(weightTEController.text) != null &&
              int.tryParse(ageTEController.text) != null) {
            final bool isUpdated = await profileController.updateProfileData(
              data: {
                "name": nameTEController.text,
                "age": int.parse(ageTEController.text),
                "hight": double.parse(heightTEController.text),
                "weight": int.parse(weightTEController.text),
              },
            );
            EasyLoading.dismiss();
            if (isUpdated) {
              setState(() {
                isEditing = false;
              });
            }
          } else {
            EasyLoading.showError('❌ Please fill all fields');
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFFEAFF55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Save',
          style: AppTextStyle.f16W500().copyWith(
            color: const Color(0xFFEAFF55),
          ),
        ),
      ),
    );
  }

  /// Get profile data from controller
  void _getProfileData() async {
    if (profileController.profileModel != null) return;
    EasyLoading.show(status: 'Loading...');
    await profileController.getProfileData();
    EasyLoading.dismiss();

    _setProfileData();

    if (profileController.profileModel == null) {
      EasyLoading.showError('❌ Failed to load profile data');
      Get.offAll(() => const LoginScreen());
    }
  }

  /// set profile data in text fields
  void _setProfileData() {
    setState(() {
      nameTEController.text = profileController.profileModel?.name ?? '';
      heightTEController.text = cmToFeet(
        profileController.profileModel?.workoutSetup?.height.toDouble() ?? 0,
      );
      weightTEController.text =
          "${profileController.profileModel?.workoutSetup?.weight.toInt().toString()}KG";
      ageTEController.text =
          profileController.profileModel?.workoutSetup?.age.toString() ?? '';
    });
  }

  /// Converts a number in cm to feet
  String cmToFeet(double cm) {
    const inchesPerFoot = 12;
    const cmPerInch = 2.54;
    final feet = (cm / cmPerInch) / inchesPerFoot;
    return feet.toStringAsFixed(1);
  }
}
