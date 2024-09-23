import 'domain_error.dart';

class ConstraintError extends DomainError {
  ConstraintError({
    required super.context,
    required super.message,
    super.trace = '',
  });
}
