class CustomerApiResponse {
  final int? id;
  final String? name;
  final DateTime? createdAt;

  CustomerApiResponse({
    this.id,
    this.name,
    this.createdAt,
  });

  factory CustomerApiResponse.fromJson(Map<String, dynamic> json) {
    return CustomerApiResponse(
      id: json['id'] as int?, // will be null if missing
      name: json['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
