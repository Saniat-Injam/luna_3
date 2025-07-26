/// Article model based on API response format
/// Maps directly to the server response structure
class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String? image;
  final List<String> tag;
  final int favCount;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool saved;
  final bool liked;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.tag,
    required this.favCount,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.saved,
    required this.liked,
  });

  /// Create ArticleModel from API JSON response
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      tag: List<String>.from(json['tag'] ?? []),
      favCount: json['favCount'] ?? 0,
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
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
      'image': image,
      'tag': tag,
      'favCount': favCount,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'saved': saved,
      'liked': liked,
    };
  }

  /// Get primary category from tags
  String get primaryCategory {
    if (tag.isEmpty) return 'FITNESS';

    final firstTag = tag.first.toUpperCase();
    const categoryMap = {
      'NUTRITION': 'NUTRITION',
      'STRENGTH': 'STRENGTH',
      'CARDIO': 'CARDIO',
      'FOCUS': 'MINDSET',
      'MOTIVATION': 'MINDSET',
      'PRODUCTIVITY': 'MINDSET',
    };

    return categoryMap[firstTag] ?? 'FITNESS';
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

  /// Create a copy of the model with modified fields
  ArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    List<String>? tag,
    int? favCount,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? saved,
    bool? liked,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      tag: tag ?? this.tag,
      favCount: favCount ?? this.favCount,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      saved: saved ?? this.saved,
      liked: liked ?? this.liked,
    );
  }
}
