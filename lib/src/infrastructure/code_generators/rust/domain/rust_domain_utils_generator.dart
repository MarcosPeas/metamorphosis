import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustDomainUtilsGenerator {
  static List<ArchiveFile> generate(List<GlobalEnumerator> enumerators) {
    final mods = ['id_generator', 'errors'];
    if (enumerators.isNotEmpty) {
      mods.add('enumerators');
    }
    return [
      RustUtils.genFile(
        path: 'src/domain/_core/errors/domain_error.rs',
        content: _domainError,
      ),
      RustUtils.genMod(
        path: 'src/domain/_core/errors/',
        imports: ['domain_error'],
      ),
      RustUtils.genFile(
        path: 'src/domain/_core/id_generator/id_generator.rs',
        content: _idGenerator,
      ),
      RustUtils.genMod(
        path: 'src/domain/_core/id_generator/',
        imports: ['id_generator'],
      ),
      RustUtils.genMod(path: 'src/domain/_core/', imports: mods),
    ];
  }
}

const String _domainError = '''
#[derive(Clone, Debug)]
pub struct DomainError {
    pub message: String,
    pub context: String,
    pub trace: String,
}

impl DomainError {
    pub fn new(message: String, context: String, trace: String) -> Self {
        Self {
            message,
            context,
            trace,
        }
    }
}
''';

const String _idGenerator = '''
use uuid::{ContextV7, Timestamp, Uuid};

pub struct IdGenerator;

impl IdGenerator {
    pub fn v7 () -> String {
        Uuid::new_v7(Timestamp::now(ContextV7::new())).to_string()
    }
}
''';
