import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/progress/controllers/progress_controller.dart';
import 'package:barbell/features/workout/controller/exercise_analysis_controller.dart';
import 'package:barbell/features/workout/controller/get_workout_by_id_controller.dart';
import 'package:barbell/features/workout/controller/workout_perform_controller.dart';
import 'package:barbell/features/workout/model/all_workout_model.dart';
import 'package:barbell/features/workout/widgets/rest_timer_bottomsheet.dart';
import 'package:barbell/features/workout/widgets/workout_progress_chart.dart';
import 'package:shimmer/shimmer.dart'; // Import your existing controller
import 'package:slide_countdown/slide_countdown.dart';

class PerformExerciseScreen extends StatelessWidget {
  const PerformExerciseScreen({super.key});

  // final int index;

  @override
  Widget build(BuildContext context) {
    final performController = Get.put(WorkoutPerformController());
    final progressController = Get.put(ProgressController());
    final getWorkoutByIdController = Get.find<GetWorkoutByIdController>();
    final ExerciseAnalysisController exerciseAnalysisController =
        Get.find<ExerciseAnalysisController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: CustomBottomNavBar(),
      appBar: AppBarWidget(title: "All Exercise", showNotification: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Sizer.hp(20)),

              /// Workout Title, Image, Note Section, Rest Timer, and Exercise Sets
              _buildExercisePerformSection(
                context,
                performController,
                getWorkoutByIdController.workout,
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 24),

              /// Stats Tab Selector
              _buildStatsTabSelector(exerciseAnalysisController),
              const SizedBox(height: 16),

              /// Today's Workout Stats
              _buildWorkoutStatsSection(
                performController,
                progressController,
                exerciseAnalysisController,
              ),
              const SizedBox(height: 30),

              /// Workout Progress Chart
              WorkoutProgressChart(controller: progressController),
              const SizedBox(height: 24),
              // Stats Cards and Weekly Progress Section only shown when workout is completed
              Obx(
                () =>
                    performController.workoutCompleted.value
                        ? Column(children: [const SizedBox(height: 20)])
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildExercisePerformSection(
    BuildContext context,
    WorkoutPerformController performCtrl,
    WorkoutModel? workoutModel,
  ) {
    final getWorkoutByIdController = Get.find<GetWorkoutByIdController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appbar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<GetWorkoutByIdController>(
            builder: (ctrl) {
              if (ctrl.isLoading) {
                return Shimmer.fromColors(
                  baseColor: AppColors.appbar,
                  highlightColor: Colors.grey[300]!,
                  child: _buildExerciseInfo(ctrl.workout),
                );
              }
              return _buildExerciseInfo(ctrl.workout);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            style: AppTextStyle.f14W400(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'Add Note Here......',
              hintStyle: AppTextStyle.f14W400().copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              showRestTimerBottomSheet(
                context: context,
                // initialTime: performCtrl.restTime.value,
                initialTime: Get.find<RestTimerController>().selectedTime.value,
                name: workoutModel?.name ?? '',
                category: workoutModel?.exerciseType ?? '',
                onTimeSelected: (selectedTime) {
                  Get.find<RestTimerController>().updateTime(selectedTime);
                },
              );
            },
            child: Obx(
              () => Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.yellow, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Reset Time: ',
                    style: TextStyle(
                      fontSize: Sizer.wp(22),
                      color: AppColors.textWhite,
                    ),
                  ),
                  // Directly use controller.isTimerRunning.value and controller.restTime.value here
                  performCtrl.isTimerRunning.value
                      ? SlideCountdown(
                        key: ValueKey(
                          Get.find<RestTimerController>().selectedTime.value,
                        ),
                        duration: Duration(
                          seconds:
                              Get.find<RestTimerController>()
                                  .selectedTime
                                  .value,
                        ),
                        separator: ":",
                        style: AppTextStyle.f21W500().copyWith(
                          color: AppColors.textWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(),
                        onDone: () {
                          performCtrl.onTimerCompleted();
                        },
                      )
                      : Text(
                        // '${performCtrl.restTime.value}s',
                        '${Get.find<RestTimerController>().selectedTime.value}s',
                        style: getTextStyleWorkSans(
                          color: AppColors.textWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            // Wrap the whole row with Obx to react to changes in 'sets'
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  getWorkoutByIdController.performColumns.map((columnName) {
                    return Container(
                      // height: MediaQuery.of(context).size.height / 9,
                      width: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0x1A17B9FF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                columnName,
                                style: getTextStyle1(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.textWhite,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...List.generate(performCtrl.sets.length, (
                                index,
                              ) {
                                final set = performCtrl.sets[index];
                                if (columnName == 'SET') {
                                  return SizedBox(
                                    height: 28,
                                    // Match the height of lbs and REPS columns
                                    child: Center(
                                      // Center the text vertically
                                      child: Text(
                                        set['SET'],
                                        style: getTextStyle1(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: AppColors.textWhite,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (columnName == 'lbs') {
                                  return SizedBox(
                                    height: 28,
                                    child: TextField(
                                      controller: performCtrl.setList[index].kg,
                                      // controller: TextEditingController(
                                      //     text: set['lbs'],
                                      //   )
                                      //   ..selection = TextSelection.collapsed(
                                      //     offset: set['lbs'].length,
                                      //   ),
                                      keyboardType: TextInputType.number,
                                      style: getTextStyle1(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: AppColors.textWhite,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 10,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        performCtrl.updateSetValue(
                                          index,
                                          'lbs',
                                          value,
                                        );
                                      },
                                    ),
                                  );
                                } else if (columnName == 'REPS') {
                                  return SizedBox(
                                    height: 28,
                                    child: TextField(
                                      controller:
                                          performCtrl.setList[index].reps,
                                      // controller: TextEditingController(
                                      //     text: set['REPS'],
                                      //   )
                                      // ..selection = TextSelection.collapsed(
                                      //   offset: set['REPS'].length,
                                      // ),
                                      keyboardType: TextInputType.number,
                                      style: getTextStyle1(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: AppColors.textWhite,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 10,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        performCtrl.updateSetValue(
                                          index,
                                          'REPS',
                                          value,
                                        );
                                      },
                                    ),
                                  );
                                } else if (columnName == 'START') {
                                  final isStarted = performCtrl.isStarted(
                                    index,
                                  );
                                  return SizedBox(
                                    height: 28,

                                    /// ==================== perform exercise button ====================
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await performCtrl.performWorkout(
                                            index,
                                          );
                                        },
                                        child: Image.asset(
                                          IconPath.starttickicon,
                                          height: 15,
                                          width: 15,
                                          color:
                                              isStarted ? Colors.yellow : null,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              performCtrl.addSet();
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 21),
              alignment: Alignment.center,
              child: Text(
                'Add Set',
                style: getTextStyleWorkSans(
                  color: AppColors.textfieldBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutStatsSection(
    WorkoutPerformController performCtrl,
    ProgressController progressCtrl,
    ExerciseAnalysisController exerciseAnalysisCtrl,
  ) {
    return Column(
      children: [
        // First row: Sets, lbs, Reps
        GetBuilder<ExerciseAnalysisController>(
          builder: (ctrl) {
            final stats = ctrl.getCurrentStats();
            final completedSets = stats['sets'].toString();
            final totalWeight = stats['weight'] as double;
            final totalReps = stats['reps'].toString();

            return Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'SETS',
                    completedSets,
                    Icons.table_rows,
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'lbs',
                    totalWeight.toStringAsFixed(1),
                    IconPath.lifting,
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'REPS',
                    totalReps,
                    Icons.repeat,
                    AppColors.secondary,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        // Second row: Full-width calories card
        GetBuilder<ExerciseAnalysisController>(
          builder: (ctrl) {
            final stats = ctrl.getCurrentStats();
            final caloriesBurned = (stats['calories'] as double).toInt();
            return _buildFullWidthCaloriesCard(caloriesBurned);
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    dynamic icon, // Can be either IconData or String (asset path)
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.textFieldFill,
            AppColors.textFieldFill.withValues(alpha: 0.8),
          ],
        ),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                icon is String
                    ? Image.asset(
                      icon,
                      width: 28,
                      height: 28,
                      color: AppColors.accent,
                    )
                    : Icon(icon, color: AppColors.accent, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: getTextStyleWorkSans(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: getTextStyleWorkSans(
              color: AppColors.textDescription,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthCaloriesCard(int calories) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.textFieldFill,
            AppColors.textFieldFill.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.local_fire_department,
              color: AppColors.warning,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$calories kcal',
                style: getTextStyleWorkSans(
                  color: AppColors.textWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'CALORIES BURNED',
                style: getTextStyleWorkSans(
                  color: AppColors.textDescription,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // int _calculateTotalReps(WorkoutPerformController controller) {
  //   int totalReps = 0;
  //   for (int index in controller.activeStartIndices) {
  //     if (index < controller.setList.length) {
  //       final repsText = controller.setList[index].reps.text;
  //       totalReps += int.tryParse(repsText) ?? 0;
  //     }
  //   }
  //   return totalReps;
  // }

  // double _calculateTotalWeight(WorkoutPerformController controller) {
  //   double totalWeight = 0.0;
  //   for (int index in controller.activeStartIndices) {
  //     if (index < controller.setList.length) {
  //       final weightText = controller.setList[index].kg?.text ?? '0';
  //       final repsText = controller.setList[index].reps.text;
  //       final weight = double.tryParse(weightText) ?? 0.0;
  //       final reps = int.tryParse(repsText) ?? 0;
  //       totalWeight += weight * reps; // Total volume (weight × reps)
  //     }
  //   }
  //   return totalWeight;
  // }

  Row _buildExerciseInfo(WorkoutModel? workoutModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            workoutModel?.img ?? '',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(width: 80, height: 80, color: Colors.grey[200]);
            },
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workoutModel?.name ?? '', style: AppTextStyle.f16W500()),
            const SizedBox(height: 6),
            Text(
              workoutModel?.exerciseType ?? '',
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
              ),
              style: AppTextStyle.f14W400().copyWith(
                color: const Color(0xFFB7B7B7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsTabSelector(ExerciseAnalysisController controller) {
    return GetBuilder<ExerciseAnalysisController>(
      builder:
          (ctrl) => Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.textFieldFill,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => ctrl.switchStatsTab(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient:
                            ctrl.selectedStatsTab == 0
                                ? LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accent.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color:
                            ctrl.selectedStatsTab == 0
                                ? null
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow:
                            ctrl.selectedStatsTab == 0
                                ? [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Text(
                        'Today',
                        textAlign: TextAlign.center,
                        style: getTextStyleWorkSans(
                          color:
                              ctrl.selectedStatsTab == 0
                                  ? Colors.white
                                  : AppColors.textDescription,
                          fontSize: 15,
                          fontWeight:
                              ctrl.selectedStatsTab == 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => ctrl.switchStatsTab(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient:
                            ctrl.selectedStatsTab == 1
                                ? LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accent.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color:
                            ctrl.selectedStatsTab == 1
                                ? null
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow:
                            ctrl.selectedStatsTab == 1
                                ? [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Text(
                        'Total',
                        textAlign: TextAlign.center,
                        style: getTextStyleWorkSans(
                          color:
                              ctrl.selectedStatsTab == 1
                                  ? Colors.white
                                  : AppColors.textDescription,
                          fontSize: 15,
                          fontWeight:
                              ctrl.selectedStatsTab == 1
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
