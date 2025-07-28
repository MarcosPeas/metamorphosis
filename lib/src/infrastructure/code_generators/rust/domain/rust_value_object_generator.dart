import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_type_extension.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustValueObjectGenerator {
  static List<ArchiveFile> generate(Entity entity) {
    final files = <ArchiveFile>[];
    final valueObjects = entity.valueObjects;
    for(final vo in valueObjects) {
      if (vo.type == 'Enum') {
        continue;
      }
      final result = _generate(vo, entity);
      files.addAll(result);
    }
    return files;
  }

  static List<ArchiveFile> _generate(ValueObject vo, Entity entity) {
    final entitySnake = entity.name.toSnakeCase();
    final entityPascal = entity.name.toPascalCase();
    final path = 'src/domain/$entitySnake/value_objects';
    final voSnake = '${entitySnake}_${vo.name.toSnakeCase()}';
    final voPascal = '$entityPascal${vo.name.toPascalCase()}';
    final imports = _buildImports(vo);
    final voType = _buildType(vo);
    final voValidations = _buildValidations(vo);

    String content = _structModel.replaceAll('%NAME%', voPascal);
    content = content.replaceAll('%IMPORTS%', imports);
    content = content.replaceAll('%VALIDATIONS%', voValidations);
    content = content.replaceAll('%TYPE%', voType);

    final mod = _generateValueObjectsMod(path, entity);
    final voFile = RustUtils.genFile(path: '$path/$voSnake.rs', content: content);
    return [mod, voFile];
  }

  static ArchiveFile _generateValueObjectsMod(String path, Entity entity) {
    final List<String> imports = [];
    for(final vo in entity.valueObjects) {
      if (vo.isEnum) {
        continue;
      }
      final voSnake = "${entity.name.toSnakeCase()}_${vo.name.toSnakeCase()}";
      imports.add(voSnake);
    }
    return RustUtils.genMod(path: path, imports: imports);
  }

  static String _buildType(ValueObject vo) {
    return vo.type.toRustType();
  }

  static String _buildImports(ValueObject vo) {
    final imports = <String>[];
    if (vo.type == 'Date' || vo.type == 'Time' || vo.type == 'DateTime') {
      imports.add('use chrono::{DateTime, Utc};');
    }
    if (vo.type == 'UUID') {
      imports.add('uuid::Uuid;');
    }
    if (vo.type == 'BigDecimal') {
      imports.add('bigdecimal::BigDecimal;');
    }
    return imports.join('\n');
  }

  static String _buildValidations(ValueObject vo) {
    return '';
  }
}

const _structModel = '''
use crate::domain::_core::errors::domain_error::DomainError;
%IMPORTS%

#[derive(Clone)]
pub struct %NAME% {
    pub value: %TYPE%,
}

impl %NAME% {
    pub fn new(value: %TYPE%, errors: &mut Vec<DomainError>) -> Self {
        let name = %NAME% { value };
        name.validate(errors);
        name
    }

    fn validate(&self, errors: &mut Vec<DomainError>) {
        %VALIDATIONS%
    }
}
''';
