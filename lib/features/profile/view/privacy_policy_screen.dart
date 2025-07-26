import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/profile/controller/privacy_policy_controller.dart';
import 'package:barbell/features/profile/view/edit_privacy_policy_screen.dart';
import 'package:barbell/features/profile/view/create_privacy_policy_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final bool isTermsAndConditions;

  const PrivacyPolicyScreen({super.key, this.isTermsAndConditions = false});

  @override
  Widget build(BuildContext context) {
    final PrivacyPolicyController controller = Get.put(
      PrivacyPolicyController(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Privacy Policy & Terms',
        showNotification: true,
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
              backgroundColor: AppColors.appbar,
            ),
          );
        }

        return RefreshIndicator(
          backgroundColor: AppColors.appbar,
          color: AppColors.secondary,
          onRefresh: () => controller.refreshPrivacyPolicy(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Admin Controls Section
                if (controller.isAdmin) ...[
                  _buildAdminControlsCard(controller),
                  const SizedBox(height: 20),
                ],

                // Content Section
                if (controller.errorMessage.value.isNotEmpty)
                  _buildErrorCard(controller)
                else if (controller.currentPrivacyPolicy.value == null)
                  _buildNoContentCard(controller)
                else
                  _buildContentCard(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildAdminControlsCard(PrivacyPolicyController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: AppColors.secondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Admin Controls',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Manage privacy policy documents',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              // Create Button
              Expanded(
                child: Obx(
                  () => ElevatedButton.icon(
                    onPressed:
                        controller.isCreating.value
                            ? null
                            : () =>
                                Get.to(() => const CreatePrivacyPolicyScreen()),
                    icon:
                        controller.isCreating.value
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Icon(Icons.add, color: AppColors.background),
                    label: Text(
                      'Create',
                      style: TextStyle(color: AppColors.background),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Edit Button
              Expanded(
                child: Obx(
                  () => ElevatedButton.icon(
                    onPressed:
                        (controller.isUpdating.value ||
                                controller.currentPrivacyPolicy.value == null)
                            ? null
                            : () => Get.to(
                              () => EditPrivacyPolicyScreen(
                                privacyPolicy:
                                    controller.currentPrivacyPolicy.value!,
                              ),
                            ),
                    icon:
                        controller.isUpdating.value
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Delete Button
              Expanded(
                child: Obx(
                  () => ElevatedButton.icon(
                    onPressed:
                        (controller.isDeleting.value ||
                                controller.currentPrivacyPolicy.value == null)
                            ? null
                            : () => _showDeleteConfirmation(controller),
                    icon:
                        controller.isDeleting.value
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.delete, color: Colors.white),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(PrivacyPolicyController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[900]?.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[600]!),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 48),
          const SizedBox(height: 16),
          Text(
            'Error Loading Privacy Policy',
            style: TextStyle(
              color: Colors.red[300],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            style: TextStyle(color: Colors.red[200], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => controller.refreshPrivacyPolicy(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoContentCard(PrivacyPolicyController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[600]!),
      ),
      child: Column(
        children: [
          Icon(Icons.privacy_tip_outlined, color: Colors.grey[400], size: 64),
          const SizedBox(height: 20),
          Text(
            'No Privacy Policy Available',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There is currently no privacy policy document available.',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (controller.isAdmin) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const CreatePrivacyPolicyScreen()),
              icon: const Icon(Icons.add),
              label: const Text('Create Privacy Policy'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.background,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentCard(PrivacyPolicyController controller) {
    final policy = controller.currentPrivacyPolicy.value!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[600]!.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.privacy_tip, color: AppColors.secondary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        policy.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Version: ${policy.version}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Updated: ${_formatDate(policy.updatedAt)}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Html(
              data: policy.content,
              style: {
                "body": Style(
                  backgroundColor: AppColors.cardBackground,
                  color: Colors.white,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "h1": Style(
                  color: AppColors.secondary,
                  fontSize: FontSize(24),
                  fontWeight: FontWeight.bold,
                ),
                "h2": Style(
                  color: AppColors.secondary,
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.w600,
                ),
                "h3": Style(
                  color: AppColors.secondary,
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.w500,
                ),
                "p": Style(
                  color: Colors.white,
                  fontSize: FontSize(14),
                  lineHeight: LineHeight.number(1.5),
                ),
                "ul": Style(color: Colors.white),
                "li": Style(color: Colors.white, fontSize: FontSize(14)),
                ".disclaimer": Style(
                  backgroundColor: Colors.orange[900]?.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.orange[600]!, width: 1),
                  padding: HtmlPaddings.all(16),
                  margin: Margins.symmetric(vertical: 16),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(PrivacyPolicyController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.red[400],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'Confirm Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this privacy policy? This action cannot be undone and will remove the document for all users.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deletePrivacyPolicy();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
