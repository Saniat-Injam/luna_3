import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/home/controllers/home_controller.dart';
import 'package:barbell/features/home/widgets/home_shimmer_effect.dart';

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1F2429), const Color(0xFF2A2F35)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Clean header
          _buildSimpleHeader(),

          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              // Show loading state
              if (controller.isLoadingFoodProgress.value) {
                return _buildLoadingState();
              }

              // Show error state if there's an error
              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorState(controller);
              }

              // Show normal content
              return Column(
                children: [
                  // Calories focus section
                  _buildCaloriesSection(controller),
                  const SizedBox(height: 24),

                  // Simple macro cards
                  _buildSimpleMacroGrid(controller),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Clean, simple header
  Widget _buildSimpleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Today\'s Nutrition',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Track Goals',
              style: getTextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),

          // const Spacer(),
        ],
      ),
    );
  }

  /// Focus on calories with clean design
  Widget _buildCaloriesSection(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.textOrange.withValues(alpha: 0.1),
            AppColors.textOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textOrange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Calories info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.textOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Calories',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        lineHeight: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Text(
                    controller.caloriesText,
                    style: getTextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'kcal target',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                    lineHeight: 12,
                  ),
                ),
              ],
            ),
          ),

          // Simple progress indicator
          Obx(() => _buildSimpleProgressRing(controller)),
        ],
      ),
    );
  }

  /// Clean progress ring
  Widget _buildSimpleProgressRing(HomeController controller) {
    double percentage = 0.0;

    if (controller.foodAnalysisProgress.value?.isSuccessful == true) {
      percentage =
          controller.foodAnalysisProgress.value!.data!.calories.progress /
          100.0; // Use actual progress value from database
    }

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Progress circle
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 6,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOrange),
              strokeCap: StrokeCap.round,
            ),
          ),

          // Center text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(percentage * 100).toInt()}%',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOrange,
                  lineHeight: 10,
                ),
              ),
              Text(
                'goal',
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Simple macro grid - clean and minimal
  Widget _buildSimpleMacroGrid(HomeController controller) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _buildMacroCard(
              'Protein',
              controller.proteinText,
              controller.foodAnalysisProgress.value?.isSuccessful == true
                  ? controller
                          .foodAnalysisProgress
                          .value!
                          .data!
                          .protein
                          .progress /
                      100.0 // Use actual progress value from database
                  : 0.0,
              const Color(0xFF00C896),
              Icons.fitness_center_rounded,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => _buildMacroCard(
              'Fats',
              controller.fatsText,
              controller.foodAnalysisProgress.value?.isSuccessful == true
                  ? controller.foodAnalysisProgress.value!.data!.fats.progress /
                      100.0 // Use actual progress value from database
                  : 0.0,
              const Color(0xFFFF9800),
              Icons.opacity_rounded,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => _buildMacroCard(
              'Carbs',
              controller.carbsText,
              controller.foodAnalysisProgress.value?.isSuccessful == true
                  ? controller
                          .foodAnalysisProgress
                          .value!
                          .data!
                          .carbs
                          .progress /
                      100.0 // Use actual progress value from database
                  : 0.0,
              AppColors.secondary,
              Icons.grain_rounded,
            ),
          ),
        ),
      ],
    );
  }

  /// Redesigned macro card with better organization and overflow handling
  Widget _buildMacroCard(
    String title,
    String value,
    double progress,
    Color color,
    IconData icon,
  ) {
    final percentage = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon and title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                    lineHeight: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Value with constrained text handling
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Text(
              value,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
                lineHeight: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),

          // Percentage indicator
          Text(
            '${(percentage * 100).toInt()}% goal',
            style: getTextStyle(
              fontSize: 10,
              lineHeight: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  /// Professional shimmer loading state for nutrition data
  Widget _buildLoadingState() {
    return HomeShimmerEffects.shimmerWrapper(
      child: Column(
        children: [
          // Shimmer for calories section
          _buildShimmerCaloriesSection(),
          const SizedBox(height: 24),

          // Shimmer for macro cards
          _buildShimmerMacroGrid(),
        ],
      ),
    );
  }

  /// Shimmer effect for calories section
  Widget _buildShimmerCaloriesSection() {
    return HomeShimmerEffects.caloriesShimmerCard(
      child: Row(
        children: [
          // Left content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer (icon + "Calories" text)
                Row(
                  children: [
                    HomeShimmerEffects.shimmerBox(
                      width: 20,
                      height: 20,
                      borderRadius: 4,
                    ),
                    const SizedBox(width: 8),
                    HomeShimmerEffects.shimmerText(width: 80, height: 16),
                  ],
                ),
                const SizedBox(height: 12),
                // Main calorie number shimmer
                HomeShimmerEffects.shimmerText(width: 140, height: 28),
                const SizedBox(height: 4),
                // Subtitle shimmer ("kcal target")
                HomeShimmerEffects.shimmerText(width: 85, height: 12),
              ],
            ),
          ),

          // Right progress ring shimmer
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring shimmer
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 6,
                    ),
                  ),
                ),
                // Inner content shimmer
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HomeShimmerEffects.shimmerText(width: 35, height: 16),
                    const SizedBox(height: 2),
                    HomeShimmerEffects.shimmerText(width: 25, height: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer effect for macro cards grid
  Widget _buildShimmerMacroGrid() {
    return Row(
      children: [
        // Protein shimmer (green theme)
        Expanded(
          child: _buildShimmerMacroCard(
            color: const Color(0xFF00C896),
            icon: Icons.fitness_center_rounded,
          ),
        ),
        const SizedBox(width: 12),
        // Fats shimmer (orange theme)
        Expanded(
          child: _buildShimmerMacroCard(
            color: const Color(0xFFFF9800),
            icon: Icons.opacity_rounded,
          ),
        ),
        const SizedBox(width: 12),
        // Carbs shimmer (secondary color theme)
        Expanded(
          child: _buildShimmerMacroCard(
            color: AppColors.secondary,
            icon: Icons.grain_rounded,
          ),
        ),
      ],
    );
  }

  /// Individual shimmer macro card with specific color theme
  Widget _buildShimmerMacroCard({
    required Color color,
    required IconData icon,
  }) {
    return HomeShimmerEffects.macroShimmerCard(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon container and title shimmer
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HomeShimmerEffects.shimmerBox(
                width: 26,
                height: 26,
                borderRadius: 8,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: HomeShimmerEffects.shimmerText(width: 45, height: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar shimmer
          HomeShimmerEffects.shimmerBox(
            width: double.infinity,
            height: 4,
            borderRadius: 2,
          ),
          const SizedBox(height: 10),

          // Value shimmer (e.g., "89g/150g")
          HomeShimmerEffects.shimmerText(width: 65, height: 15),
          const SizedBox(height: 4),

          // Percentage text shimmer ("59% goal")
          HomeShimmerEffects.shimmerText(width: 50, height: 10),
        ],
      ),
    );
  }

  /// Error state for nutrition data
  Widget _buildErrorState(HomeController controller) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load nutrition data',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // controller.refreshFoodProgress()
              },
              icon: Icon(Icons.refresh_rounded, size: 18),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
