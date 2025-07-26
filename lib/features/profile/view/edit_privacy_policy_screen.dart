import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/profile/controller/privacy_policy_controller.dart';
import 'package:barbell/features/profile/models/privacy_policy_model.dart';

class EditPrivacyPolicyScreen extends StatefulWidget {
  final PrivacyPolicyModel privacyPolicy;

  const EditPrivacyPolicyScreen({super.key, required this.privacyPolicy});

  @override
  State<EditPrivacyPolicyScreen> createState() =>
      _EditPrivacyPolicyScreenState();
}

class _EditPrivacyPolicyScreenState extends State<EditPrivacyPolicyScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _versionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.privacyPolicy.title);
    _contentController = TextEditingController(
      text: widget.privacyPolicy.content,
    );
    _versionController = TextEditingController(
      text: widget.privacyPolicy.version,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PrivacyPolicyController controller =
        Get.find<PrivacyPolicyController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Edit Privacy Policy',
        showNotification: false,
        showBackButton: true,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isUpdating.value ? null : _saveChanges,
              child:
                  controller.isUpdating.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        'Save',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Version Field
              TextFormField(
                controller: _versionController,
                decoration: InputDecoration(
                  labelText: 'Version',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a version';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Content Field
              Text(
                'Content (HTML)',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[600]!),
                ),
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Enter HTML content here...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Info Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[900]?.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[700]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[400]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can use HTML tags to format the content. Be careful with your changes as they will be visible to all users.',
                        style: TextStyle(
                          color: Colors.orange[200],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() == true) {
      final PrivacyPolicyController controller =
          Get.find<PrivacyPolicyController>();

      controller
          .updatePrivacyPolicy(
            title: _titleController.text,
            content: _contentController.text,
            version: _versionController.text,
          )
          .then((_) {
            // Navigate back if successful
            if (controller.errorMessage.value.isEmpty) {
              Get.back();
            }
          });
    }
  }
}
