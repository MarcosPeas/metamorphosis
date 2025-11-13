import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/infrastructure/_core/rust_infra_core_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/infrastructure/_core/rust_postgres_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/infrastructure/rust_repository_impl_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustInfrastructureGenerator {
  static List<ArchiveFile> generate(Application app) {
    final core = RustInfraCoreGenerator.generate(app);
    final scheme = RustPostgresGenerator.generate(app);
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
}
