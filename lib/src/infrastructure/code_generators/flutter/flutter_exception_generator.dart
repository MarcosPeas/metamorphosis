import 'package:archive/archive.dart';

class FlutterExceptionGenerator {
  FlutterExceptionGenerator._();

  static const _exceptionPath = '_core/exception';

  static List<ArchiveFile> generate(String domainPath) {
    final domainExceptionFile = _generateDomainException(domainPath);
    final domainErrorFile = _generateDomainError(domainPath);
    return [
      domainExceptionFile,
      domainErrorFile,
    ];
  }

  static ArchiveFile _generateDomainException(String domainPath) {
    final content = _domainException;
    final path = '$domainPath/$_exceptionPath/domain_exception.dart';
    return ArchiveFile(path, content.length, content.codeUnits);
  }

  static ArchiveFile _generateDomainError(String domainPath) {
    final content = _domainError;
    final path = '$domainPath/$_exceptionPath/domain_error.dart';
    return ArchiveFile(path, content.length, content.codeUnits);
  }
}

String _domainError = '''
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

''';

String _domainException = '''
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
    return errors.map((e) => e.message).join('\\n');
  }

  String get message => errors.map((e) => e.message).join('\\n');

  String get trace => errors.map((e) => e.trace).join('\\n');
}

''';
