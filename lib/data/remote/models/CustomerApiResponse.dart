class Customer {
  final int? id;
  final String? name;
  final DateTime? createdAt;

  Customer({
    this.id,
    this.name,
    this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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
