import 'domain_error.dart';

class DomainException implements Exception {
  late final List<DomainError> errors;

  DomainException({List<DomainError>? errors}) {
    this.errors = errors ?? [];
  }

  DomainException.withError(DomainError error) {
    errors = [error];
  }

  DomainException.of({
    required String message,
    required String trace,
    required String context,
  }) {
    errors = [DomainError(message: message, trace: trace, context: context)];
  }

  void addError(DomainError error) {
    errors.add(error);
  }

  @override
  String toString() {
    return errors.map((e) => e.message).join('\n');
  }

  String get message => errors.map((e) => e.message).join('\n');

  String get trace => errors.map((e) => e.trace).join('\n');
}
