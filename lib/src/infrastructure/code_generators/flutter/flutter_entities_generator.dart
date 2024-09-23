import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_types.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_value_objects_generator.dart';

class FlutterEntitiesGenerator {
  FlutterEntitiesGenerator._();

  static List<ArchiveFile> generate({
    required List<Entity> entities,
    required String domainPath,
  }) {
    final files = <ArchiveFile>[];
    for (final entity in entities) {
      _generateEntity(
        entity: entity,
        domainPath: domainPath,
        files: files,
      );
    }
    return files;
  }

  static void _generateEntity({
    required Entity entity,
    required String domainPath,
    required List<ArchiveFile> files,
  }) {
    final entityPath = '$domainPath/${ChangeCase(entity.name).toSnakeCase()}';
    final result = FlutterValueObjectsGenerator.generate(
      entity: entity,
      entityPath: entityPath,
    );
    files.addAll(result);
    String content = _entityContent.replaceAll(
      '%name%',
      ChangeCase(entity.name).toPascalCase(),
    );

    final imports = _generateImports(entity);
    final fields = _generateFields(entity);
    final constructorFields = _generateConstructorFields(entity);
    final constructorAssignments = _generateConstructorAssignments(entity);
    final getters = _generateGetter(entity);
    final setters = _generateSetter(entity);

    content = content.replaceAll('%imports%', imports);
    content = content.replaceAll('%fields%', fields);
    content = content.replaceAll('%constructorFields%', constructorFields);
    content = content.replaceAll(
      '%constructorAssignments%',
      constructorAssignments,
    );
    content = content.replaceAll('%getters%', getters);
    content = content.replaceAll('%setters%', setters);

    final bytes = utf8.encode(content);
    final archiveFile = ArchiveFile(
      '$entityPath/entities/${ChangeCase(entity.name).toSnakeCase()}.dart',
      bytes.length,
      bytes,
    );
    files.add(archiveFile);
  }

  static String _generateImports(Entity entity) {
    final valueObjects = entity.valueObjects;
    final imports = valueObjects.map((valueObject) {
      final entityName = ChangeCase(entity.name).toPascalCase();
      final valueObjectName = ChangeCase(valueObject.name).toPascalCase();
      final nameSnackCase = ChangeCase(
        '$entityName$valueObjectName',
      ).toSnakeCase();
      return 'import \'../value_objects/$nameSnackCase.dart\';';
    }).join('\n');
    return imports;
  }

  static String _generateFields(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final entityName = ChangeCase(entity.name).toPascalCase();
      final valueObjectName = ChangeCase(valueObject.name).toPascalCase();
      if (valueObject.rules.isEmpty) {
        final type = FlutterTypes.getType(valueObject.type);
        final nullable = valueObject.isNullable ? '?' : '';
        return 'late $type$nullable _${ChangeCase(valueObject.name).toCamelCase()};';
      }
      return 'late $entityName$valueObjectName _${ChangeCase(valueObject.name).toCamelCase()};';
    }).join('\n  ');
    return fields;
  }

  static String _generateConstructorFields(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final name = ChangeCase(valueObject.name).toCamelCase();
      final type = FlutterTypes.getType(valueObject.type);
      if (name == 'createdAt' || name == 'updatedAt') {
        return 'DateTime? $name,';
      }
      if (valueObject.isNullable) {
        return '$type $name,';
      }
      if (valueObject.rules.isEmpty) {
        if (valueObject.isNullable) {
          return '$type? $name,';
        }
        return 'required $type $name,';
      }
      return 'required $type $name,';
    }).join('\n    ');
    return fields;
  }

  static String _generateConstructorAssignments(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final name = valueObject.name;
      final fieldName = ChangeCase(name).toCamelCase();
      final entityName = ChangeCase(entity.name).toPascalCase();
      final valueObjectName = ChangeCase(valueObject.name).toPascalCase();
      if (name == 'createdAt' || name == 'updatedAt') {
        return '_$fieldName = $fieldName ?? DateTime.now();';
      }
      if (valueObject.rules.isEmpty) {
        return '_$fieldName = $fieldName;';
      }
      return '_$fieldName = $entityName$valueObjectName($fieldName);';
    }).join('\n    ');
    return fields;
  }

  static String _generateGetter(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final type = FlutterTypes.getType(valueObject.type);
      final nullable = valueObject.isNullable ? '?' : '';
      final name = ChangeCase(valueObject.name).toCamelCase();
      if (name == 'createdAt' || name == 'updatedAt') {
        return 'DateTime get $name => _$name;';
      }
      if (valueObject.rules.isEmpty) {
        return '$type$nullable get $name => _$name;';
      }
      return '$type$nullable get $name => _$name.value;';
    }).join('\n\n  ');
    return fields;
  }

  static String _generateSetter(Entity entity) {
    final valueObjects = [...entity.valueObjects];
    final containsUpdatedAt = valueObjects.any((vo) => vo.name == 'updatedAt');
    valueObjects.removeWhere((vo) {
      return vo.name == 'createdAt' || vo.name == 'updatedAt';
    });
    final fields = valueObjects.map((valueObject) {
      final entityName = ChangeCase(entity.name).toPascalCase();
      final valueObjectName = ChangeCase(valueObject.name).toPascalCase();
      final type = FlutterTypes.getType(valueObject.type);
      final name = ChangeCase(valueObject.name).toCamelCase();
      final nullable = valueObject.isNullable ? '?' : '';
      String content = 'set $name($type$nullable value) {\n';
      if (valueObject.rules.isEmpty) {
        content = '$content    _$name = value;\n';
      } else {
        content = '$content    _$name = $entityName$valueObjectName(value);\n';
      }
      content = '$content    _validate();\n';
      if (containsUpdatedAt) {
        content = '$content    _updatedAt = DateTime.now();';
      }
      content = '$content\n  }';
      return content;
    }).join('\n\n  ');
    return fields;
  }
}

String _entityContent = '''
import 'package:uuid/uuid.dart';

import '../../_core/exception/domain_error.dart';
import '../../_core/exception/domain_exception.dart';
%imports%

class %name% {

  late final String id;
  %fields%
  final List<DomainError> _errors = [];
  
  %name%({
    String? id,
    %constructorFields%  
  }) {
    this.id = id ?? const Uuid().v4();
    %constructorAssignments%
    _validate();
  } 
  
  %getters%
  
  %setters%
  
  void _validate() {
    if (_errors.isNotEmpty) {
      throw DomainException(errors: _errors);
    }
  }
}
''';
