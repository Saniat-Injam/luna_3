class YouTubeUtils {
  /// List of YouTube URL patterns
  static const List<String> _youtubePatterns = [
    'youtube.com/watch',
    'youtu.be/',
    'm.youtube.com/watch',
    'youtube-nocookie.com/embed',
    'youtube.com/embed',
    'youtube.com/v/',
    'youtube.com/e/',
    'youtube.com/user/',
    'youtube.com/c/',
    'youtube.com/channel/',
    'youtube.com/playlist',
  ];

  /// Check if a URL is a YouTube video URL
  static bool isYouTubeUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    final String lowerUrl = url.toLowerCase();
    return _youtubePatterns.any((pattern) => lowerUrl.contains(pattern));
  }

  /// Extract YouTube video ID from various YouTube URL formats
  static String? extractVideoId(String? url) {
    if (url == null || url.isEmpty) return null;

    // Remove any whitespace
    url = url.trim();

    // Handle different YouTube URL formats
    final regexPatterns = [
      // Standard watch URL: https://www.youtube.com/watch?v=VIDEO_ID
      r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]+)',
      // Embed URL: https://www.youtube.com/embed/VIDEO_ID
      r'youtube\.com\/embed\/([a-zA-Z0-9_-]+)',
      // Short URL: https://youtu.be/VIDEO_ID
      r'youtu\.be\/([a-zA-Z0-9_-]+)',
      // Mobile URL: https://m.youtube.com/watch?v=VIDEO_ID
      r'm\.youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)',
      // YouTube nocookie embed
      r'youtube-nocookie\.com\/embed\/([a-zA-Z0-9_-]+)',
    ];

    for (String pattern in regexPatterns) {
      final RegExp regex = RegExp(pattern, caseSensitive: false);
      final Match? match = regex.firstMatch(url);
      if (match != null && match.groupCount > 0) {
        return match.group(1);
      }
    }

    return null;
  }

  /// Get YouTube video thumbnail URL
  static String? getThumbnailUrl(
    String? videoId, {
    String quality = 'maxresdefault',
  }) {
    if (videoId == null || videoId.isEmpty) return null;

    // Available qualities: maxresdefault, sddefault, hqdefault, mqdefault, default
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }

  /// Get YouTube embed URL for video ID
  static String? getEmbedUrl(String? videoId) {
    if (videoId == null || videoId.isEmpty) return null;
    return 'https://www.youtube.com/embed/$videoId';
  }

  /// Get YouTube watch URL for video ID
  static String? getWatchUrl(String? videoId) {
    if (videoId == null || videoId.isEmpty) return null;
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  /// Convert any YouTube URL to standard watch URL
  static String? normalizeYouTubeUrl(String? url) {
    final videoId = extractVideoId(url);
    return getWatchUrl(videoId);
  }

  /// Check if video ID is valid (11 characters, alphanumeric + underscore + hyphen)
  static bool isValidVideoId(String? videoId) {
    if (videoId == null || videoId.isEmpty) return false;
    final RegExp regex = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return regex.hasMatch(videoId);
  }

  /// Get video duration from YouTube API (requires API key - placeholder for future implementation)
  static Future<Duration?> getVideoDuration(String videoId) async {
    // This would require YouTube Data API v3 implementation
    // For now, return null - can be implemented later if needed
    return null;
  }

  /// Open YouTube video in external app/browser
  static void openYouTubeVideo(String? url) {
    if (url == null || url.isEmpty) return;

    // This would use url_launcher package
    // For now, it's a placeholder for future implementation
    // launchUrl(Uri.parse(url));
  }
}
