import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';

import 'flutter_entities_generator.dart';

class FlutterGenerator {
  FlutterGenerator._();

  static Archive generate({
    required Application application,
  }) {
    final project = application.project!;
    final archive = Archive();
    final projectName = project.name;
    final pubspecYaml = _pubspecYaml(project);
    final file = ArchiveFile(
      '$projectName/pubspec.yaml',
      pubspecYaml.length,
      pubspecYaml,
    );
    final libDirectory = '$projectName/lib';
    final mainContent = _mainContent(projectName);

    archive.addFile(file);
    archive.addFile(ArchiveFile('$libDirectory/main.dart', 0, mainContent));

    final contexts = application.contexts;
    List<ArchiveFile> archivesEntities = [];
    if (contexts.length == 1) {
      archivesEntities = FlutterEntitiesGenerator.generate(
        entities: application.contexts.first.entities,
        rootPath: '$libDirectory/src',
      );
    } else {
      for (final context in contexts) {
        archivesEntities ==
            FlutterEntitiesGenerator.generate(
              entities: context.entities,
              rootPath: '$libDirectory/src/${ChangeCase(context.name).toSnakeCase()}',
            );
      }
    }
    for (final value in archivesEntities) {
      archive.addFile(value);
    }
    return archive;
  }

  static String _pubspecYaml(Project project) {
    final projectName = project.name;
    return '''
name: $projectName
description: A new Flutter project
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <4.0.0"
  
dependencies:
  flutter:
    sdk: flutter
    
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true      
''';
  }

  static String _mainContent(String projectName) {
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
