class DomainException implements Exception {
  final String message;
  final String trace;

  DomainException({required this.message, required this.trace});

  @override
  String toString() {
    return message;
  }
}
