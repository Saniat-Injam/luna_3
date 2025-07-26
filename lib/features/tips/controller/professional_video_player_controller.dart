import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Professional video player controller for managing video playback and UI state
/// Handles all business logic for video player functionality
class ProfessionalVideoPlayerController extends GetxController
    with GetTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late AnimationController _seekAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _seekAnimation;

  // Video state management
  final _isInitialized = false.obs;
  final _hasError = false.obs;
  final _showControls = true.obs;
  final _isPlaying = false.obs;
  final _isMuted = false.obs;
  final _isBuffering = false.obs;
  final _currentVolume = 1.0.obs;
  final _currentPosition = Duration.zero.obs;
  final _totalDuration = Duration.zero.obs;
  final _showVolumeIndicator = false.obs;
  final _showVolumeSlider = false.obs;
  final _isSeeking = false.obs;
  final _showSeekIndicator = false.obs;
  final _seekDirection = ''.obs;
  final _seekAmount = 0.obs;

  // Video configuration
  String? _videoUrl;
  bool _autoPlay = false;

  /// Timer to hide controls automatically
  Timer? _hideControlsTimer;
  Timer? _hideVolumeTimer;
  Timer? _hideSeekTimer;

  // Getters for reactive values
  bool get isInitialized => _isInitialized.value;
  bool get hasError => _hasError.value;
  bool get showControls => _showControls.value;
  bool get isPlaying => _isPlaying.value;
  bool get isMuted => _isMuted.value;
  bool get isBuffering => _isBuffering.value;
  double get currentVolume => _currentVolume.value;
  Duration get currentPosition => _currentPosition.value;
  Duration get totalDuration => _totalDuration.value;
  bool get showVolumeIndicator => _showVolumeIndicator.value;
  bool get showVolumeSlider => _showVolumeSlider.value;
  bool get isSeeking => _isSeeking.value;
  bool get showSeekIndicator => _showSeekIndicator.value;
  String get seekDirection => _seekDirection.value;
  int get seekAmount => _seekAmount.value;

  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<double> get seekAnimation => _seekAnimation;
  VideoPlayerController get videoController => _videoController;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
  }

  /// Initialize video player with configuration
  /// [videoUrl] - URL of the video to play
  /// [autoPlay] - Whether to start playing automatically
  /// [showControls] - Whether to show video controls
  /// [aspectRatio] - Video aspect ratio
  void initializeVideoPlayer({
    required String videoUrl,
    bool autoPlay = false,
    bool showControls = true,
    double aspectRatio = 16 / 9,
  }) {
    _videoUrl = videoUrl;
    _autoPlay = autoPlay;

    _setupVideoPlayer();
    _startHideControlsTimer();
  }

  /// Initialize animations for smooth transitions
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _seekAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _seekAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _seekAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  /// Setup video player with enhanced error handling
  void _setupVideoPlayer() {
    if (_videoUrl == null || _videoUrl!.isEmpty) {
      _hasError.value = true;
      return;
    }

    try {
      // Validate URL before creating controller
      final uri = Uri.tryParse(_videoUrl!);
      if (uri == null) {
        print('Invalid video URL: $_videoUrl');
        _hasError.value = true;
        return;
      }

      _videoController = VideoPlayerController.networkUrl(uri);
      _videoController.addListener(_videoPlayerListener);

      // Add timeout for initialization
      _videoController
          .initialize()
          .timeout(const Duration(seconds: 30)) // 30 second timeout
          .then((_) {
            if (!isClosed) {
              // Check if controller is still active
              _isInitialized.value = true;
              _hasError.value = false;
              _totalDuration.value = _videoController.value.duration;

              if (_autoPlay) {
                playVideo();
              }
            }
          })
          .catchError((error) {
            print('Video initialization error: $error');
            if (!isClosed) {
              _hasError.value = true;
            }
          });
    } catch (e) {
      print('Video player creation error: $e');
      _hasError.value = true;
    }
  }

  /// Enhanced video player listener with buffering detection
  void _videoPlayerListener() {
    if (_isInitialized.value && !isClosed) {
      final value = _videoController.value;

      // Check for errors
      if (value.hasError) {
        print('Video player error: ${value.errorDescription}');
        _hasError.value = true;
        return;
      }

      _isPlaying.value = value.isPlaying;
      _isBuffering.value = value.isBuffering;

      if (!_isSeeking.value) {
        _currentPosition.value = value.position;
      }
      _totalDuration.value = value.duration;
    }
  }

  /// Start timer to hide controls with YouTube-like behavior
  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (_isPlaying.value && !_isSeeking.value) {
        _fadeController.reverse();
        _showControls.value = false;
      }
    });
  }

  /// Cancel the hide controls timer
  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
  }

  /// Show controls with smooth animation
  void showControlsTemporarily() {
    _showControls.value = true;
    _fadeController.forward();
    if (_isPlaying.value && !_isSeeking.value) {
      _startHideControlsTimer();
    }
  }

  /// Enhanced seek functionality with visual feedback
  void seekWithFeedback(int seconds) {
    HapticFeedback.lightImpact();

    _seekDirection.value = seconds > 0 ? 'forward' : 'backward';
    _seekAmount.value = seconds.abs();
    _showSeekIndicator.value = true;

    final newPosition = _currentPosition.value + Duration(seconds: seconds);
    final clampedPosition = Duration(
      milliseconds: newPosition.inMilliseconds.clamp(
        0,
        _totalDuration.value.inMilliseconds,
      ),
    );

    seekTo(clampedPosition);
    _seekAnimationController.forward().then((_) {
      _seekAnimationController.reset();
    });

    _hideSeekTimer?.cancel();
    _hideSeekTimer = Timer(const Duration(milliseconds: 1000), () {
      _showSeekIndicator.value = false;
    });
  }

  /// Enhanced volume control with better feedback - Only show when button clicked
  void _showVolumeIndicatorTemporarily() {
    _showVolumeIndicator.value = true;
    _hideVolumeTimer?.cancel();
    _hideVolumeTimer = Timer(const Duration(seconds: 2), () {
      _showVolumeIndicator.value = false;
    });
  }

  /// Show volume slider temporarily
  void showVolumeSliderTemporarily() {
    _showVolumeSlider.value = true;
    Timer(const Duration(seconds: 4), () {
      _showVolumeSlider.value = false;
    });
  }

  /// Toggle mute/unmute with haptic feedback - Fixed volume indicator issue
  void toggleMute() {
    HapticFeedback.selectionClick();

    if (_isMuted.value) {
      // Unmute: restore previous volume
      _isMuted.value = false;
      _videoController.setVolume(_currentVolume.value);
    } else {
      // Mute: set volume to 0 but keep current volume value
      _isMuted.value = true;
      _videoController.setVolume(0.0);
    }

    _showVolumeIndicatorTemporarily();
    showControlsTemporarily();
  }

  /// Enhanced play/pause toggle
  void togglePlayPause() {
    HapticFeedback.selectionClick();

    if (_videoController.value.isPlaying) {
      pauseVideo();
    } else {
      playVideo();
    }
    showControlsTemporarily();
  }

  /// Play video
  void playVideo() {
    _videoController.play();
  }

  /// Pause video
  void pauseVideo() {
    _videoController.pause();
  }

  /// Enhanced seek functionality
  void seekTo(Duration position) {
    final wasPlaying = _videoController.value.isPlaying;
    _videoController.seekTo(position).then((_) {
      if (!wasPlaying && _videoController.value.isPlaying) {
        _videoController.pause();
      }
    });
    showControlsTemporarily();
  }

  /// Enhanced volume adjustment with better sensitivity - Only show via button click
  void adjustVolume(double delta) {
    // Calculate new volume
    final newVolume = (_currentVolume.value + delta).clamp(0.0, 1.0);
    _currentVolume.value = newVolume;

    // If currently muted, unmute when volume is adjusted
    if (_isMuted.value && newVolume > 0) {
      _isMuted.value = false;
    }

    // If volume is set to 0, consider it muted
    if (newVolume == 0) {
      _isMuted.value = true;
    }

    // Apply volume to video controller
    _videoController.setVolume(_isMuted.value ? 0.0 : newVolume);

    // Don't show volume indicator for gesture-based adjustments
    // Only show when button is clicked
  }

  /// Volume adjustment specifically for button clicks - Shows volume indicator
  void adjustVolumeWithIndicator(double delta) {
    // Debug logging
    print('Volume button clicked with delta: $delta');

    // Calculate new volume
    final newVolume = (_currentVolume.value + delta).clamp(0.0, 1.0);
    _currentVolume.value = newVolume;

    // If currently muted, unmute when volume is adjusted
    if (_isMuted.value && newVolume > 0) {
      _isMuted.value = false;
    }

    // If volume is set to 0, consider it muted
    if (newVolume == 0) {
      _isMuted.value = true;
    }

    // Apply volume to video controller
    _videoController.setVolume(_isMuted.value ? 0.0 : newVolume);

    // Show volume indicator for button clicks
    _showVolumeIndicatorTemporarily();
    print('Volume indicator should be showing: ${_showVolumeIndicator.value}');
  }

  /// Retry video initialization
  void retryVideoInitialization() {
    _hasError.value = false;
    _isInitialized.value = false;
    _isBuffering.value = false;

    // Clean up existing controller if any
    _videoController.removeListener(_videoPlayerListener);
    _videoController.dispose();

    // Retry setup
    _setupVideoPlayer();
  }

  /// Handle tap on video player
  void handleVideoTap() {
    if (_showControls.value) {
      _fadeController.reverse();
      _showControls.value = false;
      _cancelHideControlsTimer();
    } else {
      showControlsTemporarily();
    }
  }

  /// Handle double tap for seeking
  void handleDoubleTap(double tapPosition, double screenWidth) {
    if (tapPosition < screenWidth * 0.4) {
      seekWithFeedback(-10);
    } else if (tapPosition > screenWidth * 0.6) {
      seekWithFeedback(10);
    }
  }

  /// Handle vertical drag for volume adjustment
  void handleVerticalDrag(
    double tapPosition,
    double screenWidth,
    double delta,
  ) {
    if (tapPosition > screenWidth * 0.7) {
      final volumeDelta = -delta / 150;
      adjustVolume(volumeDelta);
    }
  }

  /// Handle progress bar seeking
  void handleProgressSeek(double value) {
    _isSeeking.value = true;
    _cancelHideControlsTimer();
    HapticFeedback.selectionClick();

    _currentPosition.value = Duration(
      milliseconds: (value * _totalDuration.value.inMilliseconds).round(),
    );
  }

  /// Handle progress bar seek end
  void handleProgressSeekEnd(double value) {
    _isSeeking.value = false;
    final newPosition = Duration(
      milliseconds: (value * _totalDuration.value.inMilliseconds).round(),
    );
    seekTo(newPosition);
    HapticFeedback.selectionClick();
  }

  /// Format duration to YouTube-like format
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  /// Get current volume percentage for display
  int get volumePercentage =>
      (_isMuted.value ? 0 : (_currentVolume.value * 100)).round();

  /// Get appropriate volume icon based on current state
  IconData get volumeIcon {
    if (_isMuted.value) {
      return Icons.volume_off;
    } else if (_currentVolume.value > 0.6) {
      return Icons.volume_up;
    } else if (_currentVolume.value > 0.3) {
      return Icons.volume_down;
    } else {
      return Icons.volume_mute;
    }
  }

  @override
  void onClose() {
    /// Clean up resources to prevent memory leaks
    _hideControlsTimer?.cancel();
    _hideVolumeTimer?.cancel();
    _hideSeekTimer?.cancel();
    _fadeController.dispose();
    _seekAnimationController.dispose();
    _videoController.removeListener(_videoPlayerListener);
    _videoController.dispose();
    super.onClose();
  }
}
