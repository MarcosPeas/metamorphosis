class DomainError implements Exception {
  final String context;
  final String message;
  final String trace;

  const DomainError({
    required this.context,
    required this.message,
    required this.trace,
  });
}
