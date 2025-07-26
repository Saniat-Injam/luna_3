import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/profile/controller/privacy_policy_controller.dart';

class CreatePrivacyPolicyScreen extends StatefulWidget {
  const CreatePrivacyPolicyScreen({super.key});

  @override
  State<CreatePrivacyPolicyScreen> createState() =>
      _CreatePrivacyPolicyScreenState();
}

class _CreatePrivacyPolicyScreenState extends State<CreatePrivacyPolicyScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _versionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Privacy Policy');
    _contentController = TextEditingController();
    _versionController = TextEditingController(text: '1.0');
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
        title: 'Create Privacy Policy',
        showNotification: false,
        showBackButton: true,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isCreating.value ? null : _createPolicy,
              child:
                  controller.isCreating.value
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        'Create',
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
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.privacy_tip_outlined,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Create a new privacy policy document for your application.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title Field
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Version Field
              _buildTextField(
                controller: _versionController,
                label: 'Version',
                icon: Icons.numbers,
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
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[600]!),
                ),
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText:
                        'Enter HTML content for the privacy policy...\n\nExample:\n<h1>Privacy Policy</h1>\n<p>Your content here...</p>',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 14,
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

              // Warning Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[900]?.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[700]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.orange[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This will create a new privacy policy. Make sure to review the content carefully as it will be visible to all users.',
                        style: TextStyle(
                          color: Colors.orange[200],
                          fontSize: 13,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: AppColors.secondary),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: validator,
    );
  }

  void _createPolicy() {
    if (_formKey.currentState?.validate() == true) {
      final PrivacyPolicyController controller =
          Get.find<PrivacyPolicyController>();

      controller
          .createPrivacyPolicy(
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
