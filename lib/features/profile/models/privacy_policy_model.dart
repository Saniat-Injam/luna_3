class PrivacyPolicyModel {
  final String id;
  final String title;
  final String content;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrivacyPolicyModel({
    required this.id,
    required this.title,
    required this.content,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      version: json['version'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PrivacyPolicyModel copyWith({
    String? id,
    String? title,
    String? content,
    String? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrivacyPolicyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PrivacyPolicyResponse {
  final bool success;
  final List<PrivacyPolicyModel> data;

  PrivacyPolicyResponse({required this.success, required this.data});

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => PrivacyPolicyModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
