import 'package:flutter/material.dart';
import 'package:barbell/features/home/widgets/home_shimmer_effect.dart';


/// Shimmer loading state for menu items
/// Used while menu data is being loaded
class MenuItemShimmer extends StatelessWidget {
  const MenuItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeShimmerEffects.shimmerWrapper(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon shimmer
            HomeShimmerEffects.shimmerBox(
              width: 48,
              height: 48,
              borderRadius: 8,
            ),
            const SizedBox(width: 16),
            // Text content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeShimmerEffects.shimmerText(width: 120, height: 16),
                  const SizedBox(height: 4),
                  HomeShimmerEffects.shimmerText(width: 180, height: 12),
                ],
              ),
            ),
            // Arrow shimmer
            HomeShimmerEffects.shimmerBox(
              width: 24,
              height: 24,
              borderRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
