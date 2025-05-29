class ApiFailure {
  final String code;
  final String message;
  final String? details;

  ApiFailure({
    required this.code,
    required this.message,
    this.details,
  });
}