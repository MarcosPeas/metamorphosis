import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_entity.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/infrastructure/_core/rust_infra_core_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/infrastructure/_core/rust_mysql_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/infrastructure/rust_repository_impl_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';
/*
class RustInfrastructureGenerator {
  static List<ArchiveFile> generate(Application app, List<VersionedEntity> entities) {
    final core = RustInfraCoreGenerator.generate(app);
    //final scheme = RustMySQLGenerator.generate(app, entities);
    final repositoryImpl = RustRepositoryImplGenerator.generate(app);
    return [_module(), ...core, ...scheme, ...repositoryImpl];
  }

  static ArchiveFile _module() {
    final mod = RustUtils.genMod(
      path: 'src/infrastructure',
      imports: ['_core'],
    );
    return mod;
  }
}*/
