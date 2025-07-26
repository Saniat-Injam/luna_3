class Urls {
  static const String baseUrl = "https://luna3server.onrender.com/api/v1";

  // users
  static const String getProfile = "$baseUrl/users/getProfile";
  static const String createAccount = "$baseUrl/users/createUser";
  static const String updateWorkoutSetup = "$baseUrl/users/updateWorkoutSetup";
  static const String workoutSetup = "$baseUrl/users/createWorkoutSetup";
  static const String getWorkoutSetup = "$baseUrl/users/getWorkoutSetup";
  static const String uploadOrChangeImg = "$baseUrl/users/uploadOrChangeImg";
  static const String updateProfileData = "$baseUrl/users/updateProfileData";
  static const String setFCMToken = "$baseUrl/users/setFCMToken";

  // auth
  static const String login = "$baseUrl/auth/login";
  static const String sendOtp = "$baseUrl/auth/send_OTP";
  static const String resendOtp = "$baseUrl/auth/reSend_OTP";
  static const String verifyOtp = "$baseUrl/auth/otpcrossCheck";
  static const String logout = "$baseUrl/auth/logout";
  static const String forgetPassword = "$baseUrl/auth/forgetPassword";
  static const String resetPassword = "$baseUrl/auth/resetPassword";

  // workout
  static const String getAllworkout =
      "$baseUrl/exercise/getExerciseBothCommonAndPersonalize";
  static const String createCommonExercise =
      "$baseUrl/exercise/createCommonExercise";
  static const String createPersonalizeExercise =
      "$baseUrl/exercise/createPersonalizeExercise";
  static const String performExercise = "$baseUrl/exercise/performExercise";
  static String markExerciseAsCompleated(performedExerciseId) =>
      "$baseUrl/exercise/markExerciseAsCompleated?performedExerciseId=$performedExerciseId";
  static String deleteExercise(String exerciseId) =>
      "$baseUrl/exercise/deleteExercise/$exerciseId";
  static String getExerciseById(String exerciseId) =>
      "$baseUrl/exercise/getExerciseById?exerciseId=$exerciseId";

  //  Exercise Analysis
  static String runAnalysis(
    String days,
    String exerciseId, {
    String? filterParameter,
  }) {
    if (filterParameter != null) {
      return "$baseUrl/analysis/runAnalysis?timeSpan=$days&exerciseId=$exerciseId&filterParameter=$filterParameter";
    }
    return "$baseUrl/analysis/runAnalysis?timeSpan=$days&exerciseId=$exerciseId";
  }

  /// ------------------------ Food Logging ------------------------
  static const String addFoodManually =
      "$baseUrl/foods/addFoodManually"; // admin section
  static String editFood(foodId) =>
      "$baseUrl/foods/updateFood?foodId=$foodId"; // admin section
  static String deleteFoodItem(foodId) =>
      "$baseUrl/foods/deleteFood?foodId=$foodId"; // admin section

  static const String addPersonalizeFoodManually =
      "$baseUrl/foods/addPersonalizeFoodManually";
  static const String getAllFood = "$baseUrl/foods/getAllFood";
  static String addConsumedFood({required String consumedAs, String? foodId}) {
    if (foodId != null) {
      return "$baseUrl/foods/addConsumedFoodFromImgOrQRCodeOrFoodId?consumedAs=$consumedAs&food_id=$foodId";
    }
    return "$baseUrl/foods/addConsumedFoodFromImgOrQRCodeOrFoodId?consumedAs=$consumedAs";
  }

  /// ------------------------ Barbell LLM ------------------------
  static const String createExerciseRoutine =
      "$baseUrl/barbelLLM/createExerciseRoutine";
  static const String saveWorkoutPlan = "$baseUrl/barbelLLM/saveWorkoutPlan";
  static const String getWorkoutRoutine =
      "$baseUrl/barbelLLM/getWorkoutRoutine";
  static const String updateExerciseRoutine =
      "$baseUrl/barbelLLM/updateExerciseRoutine";
  static const String startChat =
      "$baseUrl/barbelLLM/startChatOrGetPreviousChat";
  static const String sendMessageAndGetReply =
      "$baseUrl/barbelLLM/sendMessageAndGetReply";
  static const String endChat = "$baseUrl/barbelLLM/endChat";

  /// ------------------------ Habit ------------------------
  static const String createHabit = "$baseUrl/habits/createHabit";
  static const String getHabit = "$baseUrl/habits/getHabit";
  static const String getUserHabits = "$baseUrl/habits/getUserHabits";
  static const String addHabitToUser = "$baseUrl/habits/addHabitToUser";
  static String updateUserHabit(String habitId) =>
      "$baseUrl/habits/updateUserHabit?habit_id=$habitId";
  static String deleteHabit(String habitId) =>
      "$baseUrl/habits/deleteHabit?habit_id=$habitId";
  static String deleteUserHabit(String habitId) =>
      "$baseUrl/habits/deleteUserHabit?habit_id=$habitId";

  /// ------------------------ Food Analysis Progress ------------------------
  static String getFoodAnalysisProgress(int? timeRange) {
    if (timeRange != null) {
      return "$baseUrl/foodAnalysis/progress?timeRange=$timeRange";
    }
    return "$baseUrl/foodAnalysis/progress";
  }

  static String getFoodAnalysisSummary({int? timeRange, List<String>? filter}) {
    if (filter != null && filter.isNotEmpty && timeRange != null) {
      String filterQuery = filter.map((f) => 'filter=$f').join('&');
      return "$baseUrl/foodAnalysis/summary?timeRange=$timeRange&$filterQuery";
    }
    if (timeRange != null) {
      return "$baseUrl/foodAnalysis/summary?timeRange=$timeRange";
    }
    if (filter != null && filter.isNotEmpty) {
      String filterQuery = filter.map((f) => 'filter=$f').join('&');
      return "$baseUrl/foodAnalysis/summary?$filterQuery";
    }
    return "$baseUrl/foodAnalysis/summary";
  }

  /// ------------------------ Video Tips ------------------------
  static const String createVideoTip = "$baseUrl/tips/create-tips";

  static const String getAllVideoTip = "$baseUrl/tips/all-tips";
  static String saveVideoTip(String videoId) =>
      "$baseUrl/tips/save-tip/$videoId"; // PATCH API
  static String likeVideoTip(String videoId) =>
      "$baseUrl/tips/like-tip/$videoId"; // PATCH API
  static String deleteVideoTip(String videoId) =>
      "$baseUrl/tips/delete-tip/$videoId"; // DELETE API
  static String updateVideoTip(String videoId) =>
      "$baseUrl/tips/update-tip/$videoId"; // PUT API

  static const String getMySavedVideos = "$baseUrl/tips/saved-videos";

  /// ------------------------ Article Tips ------------------------
  static const String createArticalTip = "$baseUrl/articles/create-article";

  static String updateArticleTip(String articleId) =>
      "$baseUrl/articles/update-article/$articleId"; // PUT API

  static const String getAllArticleTip = "$baseUrl/articles/all-articles";
  static String deleteArticleTip(String articleId) =>
      "$baseUrl/articles/delete-article/$articleId"; // PUT API

  static String saveArticle(String articleId) =>
      "$baseUrl/articles/save-article/$articleId"; // PATCH API

  static String likeArticle(String articleId) =>
      "$baseUrl/articles/like-article/$articleId"; // PATCH API

  static const String getMySavedArticles = "$baseUrl/articles/saved-articles";

  /// ------------------------ Progress Section ------------------------
  static String getProgressOverview({int? timeRange}) {
    if (timeRange != null) {
      return "$baseUrl/progress/overview?timeRange=$timeRange";
    }
    return "$baseUrl/progress/overview";
  }

  static String getProgressAnalytics({int? timeRange, List<String>? metrics}) {
    String url = "$baseUrl/progress/analytics";
    List<String> params = [];

    if (timeRange != null) {
      params.add("timeRange=$timeRange");
    }

    if (metrics != null && metrics.isNotEmpty) {
      for (String metric in metrics) {
        params.add("metrics=$metric");
      }
    }

    if (params.isNotEmpty) {
      url += "?${params.join('&')}";
    }

    return url;
  }

  /// ------------------------ Notification ------------------------

  // Get all notifications
  static const String getAllNotifications =
      "$baseUrl/notifications/getAllNotifications";

  // View specific notification
  static String viewSpecificNotification(String notificationId) =>
      "$baseUrl/notifications/viewSpecificNotification?notification_id=$notificationId";

  // send notification from admin
  static const String sendNotificationFromAdmin =
      "$baseUrl/notifications/sendNotificationFromAdmin";

  // Get all notifications for admin
  static String getAllNotificationsForAdmin(String notificationType) =>
      "$baseUrl/notifications/getAllNotificationForAdmin?notificationType=$notificationType";

  // get notification for notification bell
  static const String getNotificationForNotificationBell =
      "$baseUrl/notifications/getNotificationForNotificationBell";

  // Delete notifications from user
  static String deleteUserNotification(String notificationId) =>
      "$baseUrl/notifications/deleteUserNotification/$notificationId";

  // Delete any notification (admin)
  static String deleteAnyNotification(String id) =>
      "$baseUrl/notifications/deleteAnyNotification/$id";

  // Notification on/off
  static const String notificationOnOff =
      "$baseUrl/users/notification-toggle";

  /// ------------------------ Privacy Policy ------------------------
  static const String getPrivacyPolicy = "$baseUrl/privacy-policy/get";
  static const String createPrivacyPolicy = "$baseUrl/privacy-policy/create";
  static String updatePrivacyPolicy(String id) =>
      "$baseUrl/privacy-policy/update/$id";
  static String deletePrivacyPolicy(String id) =>
      "$baseUrl/privacy-policy/delete/$id";
}
