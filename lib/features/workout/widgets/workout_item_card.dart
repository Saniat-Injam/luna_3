import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/workout/controller/delete_workout_controller.dart';
import 'package:barbell/features/workout/controller/exercise_analysis_controller.dart';
import 'package:barbell/features/workout/controller/get_all_workout_controller.dart';
import 'package:barbell/features/workout/controller/get_workout_by_id_controller.dart';
import 'package:barbell/features/workout/model/all_workout_model.dart';
import 'package:barbell/features/workout/model/analysis_days_model.dart';
import 'package:barbell/features/workout/view/perform_exercise_screen.dart';
import 'package:shimmer/shimmer.dart';

// CONTROLLER embedded here
class WorkoutCardController extends GetxController {
  var selectedIndex = RxInt(-1);

  void toggleSelection(int index) {
    selectedIndex.value = selectedIndex.value == index ? -1 : index;
  }
}

// ITEM CARD
class WorkoutItemCard extends StatelessWidget {
  final WorkoutModel workoutModel;

  const WorkoutItemCard({super.key, required this.workoutModel});

  @override
  Widget build(BuildContext context) {
    final allWorkoutController = Get.find<GetAllWorkoutController>();
    return GetBuilder<DeleteWorkoutController>(
      builder: (deleteCtrl) {
        if (deleteCtrl.isLoading && deleteCtrl.workoutId == workoutModel.id) {
          return Shimmer.fromColors(
            baseColor: AppColors.appbar,
            highlightColor: Colors.grey[300]!,
            child: _buildListTile(allWorkoutController),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await allWorkoutController.getAllWorkout();
          },
          child: _buildListTile(allWorkoutController),
        );
      },
    );
  }

  Widget _buildListTile(GetAllWorkoutController allWorkoutController) {
    return Slidable(
      key: ValueKey(workoutModel.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // Replace Get.defaultDialog with a modern bottom sheet
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark, // Use a dark background
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Delete Workout',
                        textAlign: TextAlign.center,
                        style: getTextStyle1(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ), // Modern title style
                      ),

                      const SizedBox(height: 16),
                      Text(
                        StorageService.role == 'admin'
                            ? workoutModel.userId != null
                                ? 'This is your personal workout. Are you sure you want to delete it? This action cannot be undone.'
                                : 'This workout is for all users. Are you sure you want to delete it? This action cannot be undone.'
                            : workoutModel.userId != null
                            ? 'This is your personal workout. Are you sure you want to delete it? This action cannot be undone.'
                            : 'This workout is for all users. You are not authorized to delete it.',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.f16W400().copyWith(
                          color: AppColors.textWhite.withValues(alpha: 0.8),
                        ), // Slightly muted text
                      ),

                      const SizedBox(height: 24),
                      if (StorageService.role == 'admin' ||
                          workoutModel.userId != null)
                        ElevatedButton(
                          onPressed: () {
                            Get.back(); // Close the bottom sheet
                            _onClickDelete(
                              allWorkoutController,
                            ); // Trigger delete action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.error, // Red background for delete
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Yes, Delete',
                            style: AppTextStyle.f16W500().copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Get.back(), // Close the bottom sheet
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: AppColors.textWhite.withValues(alpha: 0.3),
                            ), // Border for cancel button
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyle.f16W500().copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isScrollControlled:
                    true, // Allows content to take up more space if needed
              );
            },

            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            spacing: 1,
            autoClose: true,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Get.to(() => PerformExerciseScreen());
          Get.find<GetWorkoutByIdController>().getWorkoutById(
            workoutModel.id ?? '',
          );
          Get.find<ExerciseAnalysisController>().fetchExerciseAnalysis(
            exerciseId: workoutModel.id ?? '',
            timeSpan: AnalysisDaysModel.last7Days,
          );
        },
        tileColor: AppColors.appbar,
        leading: Image.network(
          workoutModel.img ?? '',
          height: Sizer.hp(48),
          width: Sizer.wp(48),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: Sizer.hp(16),
              width: Sizer.wp(8),
              color: Colors.grey[300],
              child: const Icon(Icons.error_outline, color: Colors.red),
            );
          },
        ),

        title: Text(workoutModel.name ?? '', style: AppTextStyle.f16W500()),
        subtitle: Text(
          workoutModel.exerciseType ?? '',
          style: AppTextStyle.f14W400().copyWith(color: Color(0xFFB7B7B7)),
        ),
        // trailing:
        //     workoutModel.userId != null || StorageService.role == 'admin'
        //         ? IconButton(
        //           onPressed: () => _onClickDelete(allWorkoutController),
        //           icon: Icon(Icons.delete, color: AppColors.error),
        //         )
        //         : null,
        trailing:
            StorageService.role == "admin"
                ? workoutModel.userId != null
                    ? Text("Personal")
                    : Text("Global")
                : Icon(Icons.arrow_forward_sharp, color: AppColors.primary),
        // onTap: () => _onClickDelete(context),
        // dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          // side: BorderSide(color: Colors.transparent, width: 2),
        ),
        visualDensity: VisualDensity.standard,
        horizontalTitleGap: 20,
      ),
    );
  }

  void _onClickDelete(GetAllWorkoutController allWorkoutController) async {
    final bool isDeleted = await Get.find<DeleteWorkoutController>()
        .deleteWorkout(workoutModel.id!);

    if (isDeleted) {
      EasyLoading.showSuccess(
        "Workout deleted successfully",
      );
      // Remove the workout from the list
      allWorkoutController.workoutList.removeWhere(
        (workout) => workout.id == workoutModel.id,
      );
      allWorkoutController.update();
    } else {
      EasyLoading.showError(
        "Failed to delete workout",
      );
    }
  }
}
