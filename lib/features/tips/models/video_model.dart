import 'package:barbell/core/utils/youtube_utils.dart';

/// Video model for video tips functionality
/// Matches the API response format for video tips
class VideoModel {
  final String id;
  final String title;
  final String description;
  final String? video;
  final List<String> tag;
  final int favCount;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool saved;
  final bool liked;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    this.video,
    required this.tag,
    required this.favCount,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.saved,
    required this.liked,
  });

  /// Create VideoModel from API JSON response
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      video: json['video'],
      tag: List<String>.from(json['tag'] ?? []),
      favCount: json['favCount'] ?? 0,
      userId: json['userId'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      version: json['__v'] ?? 0,
      saved: json['saved'] ?? false,
      liked: json['liked'] ?? false,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'video': video,
      'tag': tag,
      'favCount': favCount,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'saved': saved,
      'liked': liked,
    };
  }

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get short description (first 100 characters)
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 100)}...';
  }

  /// Get tags as a comma-separated string
  String get tagsString {
    return tag.join(', ');
  }

  /// Check if this video is a YouTube video
  bool get isYouTubeVideo {
    return video != null && YouTubeUtils.isYouTubeUrl(video!);
  }

  /// Get YouTube video ID if this is a YouTube video
  String? get youTubeVideoId {
    if (!isYouTubeVideo) return null;
    return YouTubeUtils.extractVideoId(video!);
  }

  /// Get YouTube thumbnail URL if this is a YouTube video
  String? get youTubeThumbnailUrl {
    final videoId = youTubeVideoId;
    if (videoId == null) return null;
    return YouTubeUtils.getThumbnailUrl(videoId);
  }

  /// Create a copy with updated properties
  VideoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? video,
    List<String>? tag,
    int? favCount,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? saved,
    bool? liked,
  }) {
    return VideoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      video: video ?? this.video,
      tag: tag ?? this.tag,
      favCount: favCount ?? this.favCount,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      saved: saved ?? this.saved,
      liked: liked ?? this.liked,
    );
  }
}
