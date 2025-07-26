import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/features/workout/controller/get_all_workout_controller.dart';
import 'package:barbell/features/workout/view/add_exercise_screen.dart';
import 'package:barbell/features/workout/widgets/workout_item_card.dart';
import 'package:shimmer/shimmer.dart';

class AllWorkoutScreen extends StatelessWidget {
  final bool isBottomNav;

  const AllWorkoutScreen({super.key, this.isBottomNav = true});

  void _fetchWorkoutsIfEmpty(GetAllWorkoutController controller) {
    if (controller.workoutList.isEmpty) {
      controller.getAllWorkout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GetAllWorkoutController controller =
        Get.find<GetAllWorkoutController>();
    final searchController = TextEditingController();

    // Fetch workouts if the list is empty
    _fetchWorkoutsIfEmpty(controller);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: isBottomNav ? CustomBottomNavBar() : null,
      appBar: AppBarWidget(
        title: 'All Exercise',
        showBackButton: isBottomNav, // Show back button
        showNotification: true, // Show notification icon
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getAllWorkout();
        },
        color: AppColors.primary,
        backgroundColor: AppColors.background,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Search Input
            Obx(
              () => TextField(
                controller: searchController,
                onChanged: (value) {
                  controller.updateSearchQuery(value);
                },
                style: getTextStyle1(color: AppColors.textWhite, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search exercises...',
                  hintStyle: getTextStyle1(
                    color: Color(0x99949494),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: AppColors.appbar,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                    gapPadding: 0,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                    gapPadding: 0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                    gapPadding: 0,
                  ),
                  suffixIcon:
                      controller.searchQuery.value.isEmpty
                          ? Icon(
                            Icons.search,
                            color: Color(0x99949494),
                            size: 24,
                          )
                          : IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Color(0x99949494),
                              size: 24,
                            ),
                            onPressed: () {
                              searchController.clear();
                              controller.clearSearch();
                            },
                          ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 50),

            /// All Exercise Header and Create Button
            _buildAllExerceseHedarAndCreateButton(),
            SizedBox(height: MediaQuery.of(context).size.height / 50),

            /// Workout List
            _buildAllWorkoutList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllExerceseHedarAndCreateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "All Exercise",
          style: getTextStyle1(
            fontSize: 18,
            color: AppColors.textWhite,
            fontWeight: FontWeight.w500,
          ),
        ),

        if (StorageService.role != 'admin')
          TextButton(
            onPressed: () {
              Get.to(() => AddExerciseScreen(isForAllUsers: false));
            },
            child: Text(
              "Create",
              style: getTextStyle1(
                fontSize: 18,
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (StorageService.role == 'admin')
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'For All Users') {
                Get.to(() => AddExerciseScreen(isForAllUsers: true));
              } else if (value == 'For Personal') {
                Get.to(() => AddExerciseScreen(isForAllUsers: false));
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'For All Users',
                    child: Text('For All Users'),
                  ),
                  PopupMenuItem(
                    value: 'For Personal',
                    child: Text('For Personal'),
                  ),
                ],
            child: Text(
              "Create",
              style: getTextStyle1(
                fontSize: 18,
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  GetBuilder<GetAllWorkoutController> _buildAllWorkoutList() {
    return GetBuilder<GetAllWorkoutController>(
      builder: (controller) {
        /// If the controller is loading, show a shimmer effect
        if (controller.isLoading) {
          return Shimmer.fromColors(
            baseColor: AppColors.primary,
            highlightColor: AppColors.secondary,
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              itemCount: 5,
            ),
          );
        }

        /// If the controller is not loading, show the workout list
        if (controller.workoutList.isEmpty &&
            controller.searchQuery.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No exercises match your search',
                style: getTextStyle1(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        if (controller.workoutList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No exercises found',
                style: getTextStyle1(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return WorkoutItemCard(workoutModel: controller.workoutList[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
          itemCount: controller.workoutList.length,
        );
      },
    );
  }
}
