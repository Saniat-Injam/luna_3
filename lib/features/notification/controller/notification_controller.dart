import 'package:get/get.dart';
import 'package:barbell/features/notification/model/notification_bell_model.dart';
import 'package:barbell/features/notification/model/notifications_model.dart';

class NotificationController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationBellModel? _notificationBellModel;
  NotificationBellModel? get notificationBellModel => _notificationBellModel;

  NotificationsModel? _notificationsModel;
  NotificationsModel? get notificationsModel => _notificationsModel;

  /// Toggles the loading state
  void toggleLoading() {
    _isLoading = !_isLoading;
    update(); // Notify listeners about the change
  }

  var swipeOffsets = <double>[].obs;

  // Ensure the swipeOffsets list has enough elements for the given index
  void ensureSwipeOffsetsLength(int requiredLength) {
    while (swipeOffsets.length < requiredLength) {
      swipeOffsets.add(0.0);
    }
  }

  // Safely get offset for an index without modifying the list during build
  double getOffset(int index) {
    if (index >= swipeOffsets.length) {
      return 0.0; // Return default value without modifying list
    }
    return swipeOffsets[index];
  }

  // Safely get offset and ensure list is properly sized (use this for non-build operations)
  double getOffsetAndEnsure(int index) {
    if (index >= swipeOffsets.length) {
      ensureSwipeOffsetsLength(index + 1);
    }
    return swipeOffsets[index];
  }

  void updateOffset(int index, double offset) {
    if (index >= swipeOffsets.length) {
      ensureSwipeOffsetsLength(index + 1);
    }
    swipeOffsets[index] = offset;
    swipeOffsets.refresh();
  }

  void resetOffset(int index) {
    updateOffset(index, 0.0);
  }

  void revealDelete(int index) {
    updateOffset(index, -37);
  }

  // Clear all offsets (useful when notifications list changes)
  void clearOffsets() {
    swipeOffsets.clear();
  }
}
