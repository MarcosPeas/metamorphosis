import 'dart:convert';

import 'package:archive/archive.dart';

class FlutterExceptionGenerator {
  FlutterExceptionGenerator._();

  static const _exceptionPath = '_core/exception';

  static List<ArchiveFile> generate(String domainPath) {
    final domainExceptionFile = _generateDomainException(domainPath);
    final domainErrorFile = _generateDomainError(domainPath);
    final constraintErrorFile = _generateConstraintError(domainPath);
    return [
      domainExceptionFile,
      domainErrorFile,
      constraintErrorFile,
    ];
  }

  static ArchiveFile _generateDomainException(String domainPath) {
    final content = _domainException;
    final path = '$domainPath/$_exceptionPath/domain_exception.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static ArchiveFile _generateDomainError(String domainPath) {
    final content = _domainError;
    final path = '$domainPath/$_exceptionPath/domain_error.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
  }

  static ArchiveFile _generateConstraintError(String domainPath) {
    final content = _constraintError;
    final path = '$domainPath/$_exceptionPath/constraint_error.dart';
    final bytes = utf8.encode(content);
    return ArchiveFile.noCompress(path, bytes.length, bytes);
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

String _constraintError = '''
import 'domain_error.dart';

class ConstraintError extends DomainError {
  ConstraintError({
    required super.context,
    required super.message,
    super.trace = '',
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
    String trace = '',
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
