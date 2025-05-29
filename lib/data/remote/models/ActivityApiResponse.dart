class ActivityApiResponse {
  final int? id;
  final String? description;
  final DateTime? createdAt;

  ActivityApiResponse({
    this.id,
    this.description,
    this.createdAt,
  });

  factory ActivityApiResponse.fromJson(Map<String, dynamic> json) {
    return ActivityApiResponse(
      id: json['id'] as int?,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
