import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class FlutterPubspecGenerator {
  FlutterPubspecGenerator._();

  static ArchiveFile generate(Application application) {
    final applicationName = ChangeCase(application.name).toSnakeCase();
    final libs = _libs(application);
    String pubspecYaml = _pubspecYaml;
    pubspecYaml = pubspecYaml.replaceAll('%name%', applicationName);
    pubspecYaml = pubspecYaml.replaceAll('%version%', '1.0.0+1');
    pubspecYaml = pubspecYaml.replaceAll('%libs%', libs);
    final file = ArchiveFile(
      '$applicationName/pubspec.yaml',
      Uint8List.fromList(pubspecYaml.codeUnits).length,
      Uint8List.fromList(pubspecYaml.codeUnits),
    );
    return file;
  }

  static String _libs(Application application) {
    final libs = <String>{};
    final context = application.contexts;
    final hasCpfCnpj = context.any((context) {
      return context.entities.any((entity) {
        return entity.valueObjects.any((valueObject) {
          return valueObject.rules.any((rule) {
            return rule.groupConditions.any((groupCondition) {
              return groupCondition.conditions.any((condition) {
                final operator = condition.comparatorOperator;
                return operator == 'isCpf' || operator == 'isCnpj';
              });
            });
          });
        });
      });
    });
    if (hasCpfCnpj) {
      libs.add('  brasil_fields: ^1.15.0');
    }
    return libs.join('\n');
  }

  static const String _pubspecYaml = '''
name: %name%
description: A new Flutter project
publish_to: 'none'
version: %version%

environment:
  sdk: ">=3.4.0 <4.0.0"
  
dependencies:
  flutter:
    sdk: flutter
  uuid: ^4.4.0
  dartz: ^0.10.1
%libs%
    
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true 
''';
}
