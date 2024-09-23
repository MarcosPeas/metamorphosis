import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_exception_generator.dart';

import 'flutter_entities_generator.dart';

class FlutterGenerator {
  FlutterGenerator._();

  static Archive generate({
    required Application application,
  }) {
    final project = application.project!;
    final archive = Archive();
    final projectName = ChangeCase(project.name).toSnakeCase();

    final libDirectory = '$projectName/lib';
    final mainContent = _mainContent();

    final pubspecFile = _generateYaml(
      projectName: projectName,
      project: project,
    );
    archive.addFile(pubspecFile);
    archive.addFile(ArchiveFile(
      '$libDirectory/main.dart',
      Uint8List.fromList(mainContent.codeUnits).length,
      Uint8List.fromList(mainContent.codeUnits),
    ));

    final domainFiles = _generateDomain(
      application: application,
      libDirectory: libDirectory,
    );
    domainFiles.forEach(archive.addFile);
    return archive;
  }

  static List<ArchiveFile> _generateDomain({
    required Application application,
    required String libDirectory,
  }) {
    final contexts = application.contexts;
    List<ArchiveFile> domainFiles = [];
    if (contexts.length == 1) {
      final domainPath = '$libDirectory/src/domain';
      domainFiles = FlutterEntitiesGenerator.generate(
        entities: application.contexts.first.entities,
        domainPath: domainPath,
      );
      final exceptionFiles = FlutterExceptionGenerator.generate(domainPath);
      domainFiles.addAll(exceptionFiles);
      return domainFiles;
    }
    for (final context in contexts) {
      final contextName = ChangeCase(context.name).toSnakeCase();
      final domainPath = '$libDirectory/src/$contextName/domain';
      domainFiles.addAll(FlutterEntitiesGenerator.generate(
        entities: context.entities,
        domainPath: domainPath,
      ));
      final exceptionFiles = FlutterExceptionGenerator.generate(domainPath);
      domainFiles.addAll(exceptionFiles);
    }
    return domainFiles;
  }

  static ArchiveFile _generateYaml({
    required String projectName,
    required Project project,
  }) {
    final pubspecYaml = _pubspecYaml(project);
    return ArchiveFile(
      '$projectName/pubspec.yaml',
      Uint8List.fromList(pubspecYaml.codeUnits).length,
      Uint8List.fromList(pubspecYaml.codeUnits),
    );
  }

  static String _pubspecYaml(Project project) {
    final projectName = ChangeCase(project.name).toSnakeCase();
    return '''
name: $projectName
description: A new Flutter project
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"
  
dependencies:
  flutter:
    sdk: flutter
  uuid: ^4.4.0
    
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true      
''';
  }

  static String _mainContent() {
    return '''
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Text("Hello, World!"),
    );
  }
}
''';
  }
}
