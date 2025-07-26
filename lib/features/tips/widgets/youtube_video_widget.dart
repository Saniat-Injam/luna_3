import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/youtube_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoWidget extends StatefulWidget {
  const YouTubeVideoWidget({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.showPlayButton = true,
    this.autoPlay = false,
    this.showControls = true,
  });

  final String videoUrl;
  final double aspectRatio;
  final bool showPlayButton;
  final bool autoPlay;
  final bool showControls;

  @override
  State<YouTubeVideoWidget> createState() => _YouTubeVideoWidgetState();
}

class _YouTubeVideoWidgetState extends State<YouTubeVideoWidget> {
  YoutubePlayerController? _controller;
  String? videoId;
  String? thumbnailUrl;
  bool _hasError = false;
  bool _isPlayerReady = false;
  // Removed _showPlayer since player is always visible now

  @override
  void initState() {
    super.initState();
    _initializeYouTubeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializeYouTubeVideo() {
    videoId = YouTubeUtils.extractVideoId(widget.videoUrl);
    if (videoId != null) {
      thumbnailUrl = YouTubeUtils.getThumbnailUrl(videoId);
      _setupController();
    } else {
      _hasError = true;
    }
    setState(() {});
  }

  void _setupController() {
    if (videoId == null) return;

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: false, // Always false to prevent auto-play
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        controlsVisibleAtStart: true, // Always show controls
        hideControls: false, // Never hide controls
        loop: false,
        forceHD: false,
        startAt: 0,
        disableDragSeek: false,
        useHybridComposition: true,
        // Remove fullscreen functionality
        hideThumbnail: true,
        // Additional flags to ensure embedded behavior
        isLive: false,
      ),
    );

    _controller?.addListener(_onPlayerStateChanged);
  }

  void _onPlayerStateChanged() {
    if (_controller?.value.isReady == true && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildVideoContent(),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError || videoId == null) {
      return _buildErrorState();
    }

    // Always show the YouTube player immediately
    if (_controller != null) {
      return _buildYouTubePlayer();
    }

    // Fallback while controller is loading
    return _buildLoadingState();
  }

  Widget _buildYouTubePlayer() {
    if (_controller == null) return _buildErrorState();

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.secondary,
      progressColors: ProgressBarColors(
        playedColor: AppColors.secondary,
        handleColor: AppColors.secondary,
      ),
      onReady: () {
        setState(() {
          _isPlayerReady = true;
        });
      },
      onEnded: (data) {
        // Keep player visible when video ends
        // User can replay by clicking the replay button
      },
      topActions: [
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            _controller!.metadata.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        // Removed close button and fullscreen to keep player always visible
      ],
      bottomActions: [
        CurrentPosition(),
        const SizedBox(width: 10.0),
        ProgressBar(isExpanded: true),
        const SizedBox(width: 10.0),
        RemainingDuration(),
        // Sound control is handled by the native YouTube controls
        PlaybackSpeedButton(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading YouTube player...',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[300], size: 48),
            const SizedBox(height: 8),
            Text(
              'Invalid YouTube URL',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load video player',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

}