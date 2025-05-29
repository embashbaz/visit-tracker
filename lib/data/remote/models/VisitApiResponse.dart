class VisitApiResponse {
  final int? id;
  final int? customerId;
  final DateTime? visitDate;
  final String? status;
  final String? location;
  final String? notes;
  final List<String>? activitiesDone;
  final DateTime? createdAt;

  VisitApiResponse({
    this.id,
    this.customerId,
    this.visitDate,
    this.status,
    this.location,
    this.notes,
    this.activitiesDone,
    this.createdAt,
  });

  factory VisitApiResponse.fromJson(Map<String, dynamic> json) {
    return VisitApiResponse(
      id: json['id'] as int?,
      customerId: json['customer_id'] as int?,
      visitDate: json['visit_date'] != null
          ? DateTime.parse(json['visit_date'])
          : null,
      status: json['status'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      activitiesDone: json['activities_done'] != null
          ? List<String>.from(json['activities_done'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'visit_date': visitDate?.toIso8601String(),
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesDone,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
