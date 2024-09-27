import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_exception_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_pubspec_generator.dart';

import 'flutter_entities_generator.dart';

class FlutterGenerator {
  FlutterGenerator._();

  static Archive generate({
    required Application application,
  }) {
    final archive = Archive();
    final applicationName = ChangeCase(application.name).toSnakeCase();

    final libDirectory = '$applicationName/lib';
    final mainContent = _mainContent();

    final pubspecFile = FlutterPubspecGenerator.generate(application);
    archive.addFile(pubspecFile);
    archive.addFile(ArchiveFile(
      '$libDirectory/main.dart',
      Uint8List
          .fromList(mainContent.codeUnits)
          .length,
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