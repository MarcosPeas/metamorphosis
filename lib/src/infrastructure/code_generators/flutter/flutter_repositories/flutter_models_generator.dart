import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class FlutterModelsGenerator {
  FlutterModelsGenerator._();

  static List<ArchiveFile> generate({
    required List<Entity> entities,
    required String domainPath,
    required String dataPath,
  }) {
    final files = <ArchiveFile>[];
    for (final entity in entities) {
      _generateModel(
        entity: entity,
        domainPath: domainPath,
        dataPath: dataPath,
        files: files,
      );
    }
    return files;
  }

  static void _generateModel({
    required Entity entity,
    required String domainPath,
    required String dataPath,
    required List<ArchiveFile> files,
  }) {
    final nameSnakeCase = entity.name.toSnakeCase();
    final modelPath =
        '$dataPath/$nameSnakeCase/models/${nameSnakeCase}_model.dart';
    String content = _entityContent.replaceAll(
      '%nameModel%',
      '${entity.name.toPascalCase()}Model',
    );
    content = content.replaceAll(
      '%nameEntity%',
      entity.name.toPascalCase(),
    );

    final imports = _generateImports(
      entity: entity,
      domainPath: domainPath.replaceAll('/lib', ''),
    );
    final constructorFields = _generateConstructorFields(entity);

    content = content.replaceAll('%imports%', imports);
    content = content.replaceAll('%constructorFields%', constructorFields);
    content = content.replaceAll(
      '%fromEntityFields%',
      _generateFromEntityFields(entity),
    );
    content = content.replaceAll(
      '%toMapFields%',
      _generateToMapFields(entity),
    );
    content = content.replaceAll(
      '%fromJsonFields%',
      _generateFromJsonFields(entity),
    );

    final bytes = utf8.encode(content);
    final archiveFile = ArchiveFile(
      modelPath,
      bytes.length,
      bytes,
    );
    files.add(archiveFile);
  }

  static String _generateImports({
    required Entity entity,
    required String domainPath,
  }) {
    final name = entity.name.toSnakeCase();
    return 'import \'package:$domainPath/$name/entities/$name.dart\';';
  }

  static String _generateConstructorFields(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final name = valueObject.name.toCamelCase();
      return 'required super.$name,';
    }).join('\n    ');
    return fields;
  }

  static String _generateFromEntityFields(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final name = valueObject.name.toCamelCase();
      return '$name: entity.$name,';
    }).join('\n      ');
    return fields;
  }

  static String _generateToMapFields(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final name = valueObject.name.toCamelCase();
      final nameSnack = valueObject.name.toSnakeCase();
      if (valueObject.type == 'DateTime') {
        if (valueObject.isNullable) {
          return '\'$nameSnack\': $name?.toUtc(),';
        }
        return '\'$nameSnack\': $name.toUtc(),';
      }
      return '\'$nameSnack\': $name,';
    }).join('\n      ');
    return fields;
  }

  static String _generateFromJsonFields(Entity entity) {
    final valueObjects = entity.valueObjects;
    final fields = valueObjects.map((valueObject) {
      final name = valueObject.name.toCamelCase();
      final nameSnack = valueObject.name.toSnakeCase();
      return '$name: json[\'$nameSnack\'],';
    }).join('\n      ');
    return fields;
  }
}

String _entityContent = '''
import 'dart:convert';
%imports%

class %nameModel% extends %nameEntity% {
  
  %nameModel%({
    required super.id,
    %constructorFields%  
  });
  
  factory %nameModel%.fromEntity(%nameEntity% entity) {
    return %nameModel%(
      id: entity.id,
      %fromEntityFields%  
    );
  }
  
  factory %nameModel%.fromJson(dynamic json) {
    return %nameModel%(
      id: json['id'],
      %fromJsonFields%  
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      %toMapFields%  
    };
  } 
  
  String toJson() {
    return jsonEncode(toMap());
  } 
}
''';
