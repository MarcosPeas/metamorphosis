import '../../_core/exception/constraint_error.dart';
import '../../_core/exception/domain_error.dart';

class ApplicationName {
  final String value;

  ApplicationName({
    required this.value,
    required List<DomainError> errors,
  }) {
    _validate(errors);
  }

  void _validate(List<DomainError> errors) {
    if (value.length < 3) {
      errors.add(
        ConstraintError(
          context: 'ApplicationName',
          message: 'O nome da aplicação deve ter no mínimo 3 caracteres',
        ),
      );
    }
    if (value.length > 30) {
      errors.add(
        ConstraintError(
          context: 'ApplicationName',
          message: 'O nome da aplicação deve ter no máximo 30 caracteres',
        ),
      );
    }
  }
}
