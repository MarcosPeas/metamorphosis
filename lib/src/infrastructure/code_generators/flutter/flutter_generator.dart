import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_exception_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_path_utils.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_pubspec_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_repositories/flutter_repositories_impl_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/flutter/flutter_use_cases_generator.dart';

import 'flutter_entities_generator.dart';
import 'flutter_repositories_generator.dart';

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
    final mainFile = Uint8List.fromList(mainContent.codeUnits);
    archive.addFile(pubspecFile);
    archive.addFile(ArchiveFile(
      '$libDirectory/main.dart',
      mainFile.length,
      mainFile,
    ));

    final domainFiles = _generateDomainAndApplication(
      application: application,
      libDirectory: libDirectory,
    );
    domainFiles.forEach(archive.addFile);
    return archive;
  }

  static List<ArchiveFile> _generateDomainAndApplication({
    required Application application,
    required String libDirectory,
  }) {
    final contexts = application.contexts;
    List<ArchiveFile> domainFiles = [];
    List<ArchiveFile> applicationFiles = [];
    List<ArchiveFile> infraFiles = [];
    if (contexts.length == 1) {
      final domainPath = '$libDirectory/src/domain';
      final applicationPath = '$libDirectory/src/application';
      final infraPath = '$libDirectory/src/infrastructure';
      domainFiles = FlutterEntitiesGenerator.generate(
        entities: application.contexts.first.entities,
        domainPath: domainPath,
      );
      final repositories = FlutterRepositoriesGenerator.generate(
        entities: application.contexts.first.entities,
        domainPath: domainPath,
      );
      domainFiles.addAll(repositories);
      applicationFiles = FlutterUseCasesGenerator.generate(
        entities: application.contexts.first.entities,
        applicationPath: applicationPath,
        domainPath: FlutterPathUtils.getFlutterPath(domainPath),
        applicationNameSnakeCase: ChangeCase(application.name).toSnakeCase(),
      );
      final exceptionFiles = FlutterExceptionGenerator.generate(domainPath);
      domainFiles.addAll(exceptionFiles);
      infraFiles = FlutterRepositoriesImplGenerator.generate(
        application: application,
        entities: application.contexts.first.entities,
        dataPath: infraPath,
        domainPath: domainPath,
      );
      return [...domainFiles, ...applicationFiles, ...infraFiles];
    }
    for (final context in contexts) {
      final contextName = ChangeCase(context.name).toSnakeCase();
      final domainPath = '$libDirectory/src/$contextName/domain';
      final applicationPath = '$libDirectory/src/$contextName/application';
      final infraPath = '$libDirectory/src/$contextName/infrastructure';
      domainFiles.addAll(FlutterEntitiesGenerator.generate(
        entities: context.entities,
        domainPath: domainPath,
      ));
      final repositories = FlutterRepositoriesGenerator.generate(
        entities: application.contexts.first.entities,
        domainPath: domainPath,
      );
      domainFiles.addAll(repositories);
      applicationFiles.addAll(FlutterUseCasesGenerator.generate(
        applicationPath: applicationPath,
        domainPath: FlutterPathUtils.getFlutterPath(domainPath),
        applicationNameSnakeCase: ChangeCase(application.name).toSnakeCase(),
        entities: context.entities,
      ));
      final exceptionFiles = FlutterExceptionGenerator.generate(domainPath);
      domainFiles.addAll(exceptionFiles);
      infraFiles.addAll(FlutterRepositoriesImplGenerator.generate(
        application: application,
        entities: context.entities,
        dataPath: infraPath,
        domainPath: domainPath,
      ));
    }
    return [...domainFiles, ...applicationFiles, ...infraFiles];
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
