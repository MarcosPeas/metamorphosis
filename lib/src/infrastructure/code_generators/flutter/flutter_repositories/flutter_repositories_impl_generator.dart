import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/application/entities/api_type.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

import 'flutter_models_generator.dart';
import 'flutter_repositories_supabase_generator.dart';

class FlutterRepositoriesImplGenerator {
  static List<ArchiveFile> generate({
    required Application application,
    required List<Entity> entities,
    required String dataPath,
    required String domainPath,
  }) {
    final List<ArchiveFile> files = [];
    final modelsFiles = FlutterModelsGenerator.generate(
      entities: entities,
      domainPath: domainPath,
      dataPath: dataPath,
    );
    files.addAll(modelsFiles);
    if (application.apiOptions.apiType == ApiType.supabase) {
      final supabaseFiles = FlutterRepositoriesSupabaseGenerator.generate(
        entities: entities,
        dataPath: dataPath,
        domainPath: domainPath,
      );
      files.addAll(supabaseFiles);
    }
    return files;
  }
}
