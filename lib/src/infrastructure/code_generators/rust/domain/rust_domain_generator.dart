import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_type_extension.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

import 'rust_domain_utils_generator.dart';
import 'rust_value_object_generator.dart';

class RustDomainGenerator {
  static List<ArchiveFile> generate(Application application) {
    final archiveFiles = <ArchiveFile>[];
    final entities = application.entities;
    final List<String> entitiesNames = [];
    for (final entity in entities) {
      archiveFiles.addAll(_generateEntityFile(entity));
      entitiesNames.add(entity.name.toSnakeCase());
      final valueObjectsFiles = RustValueObjectGenerator.generate(entity);
      archiveFiles.addAll(valueObjectsFiles);
    }
    archiveFiles.addAll(RustDomainUtilsGenerator.generate());
    final domainMod = RustUtils.genMod(
      path: 'src/domain',
      imports: ['_core', ...entitiesNames],
    );
    archiveFiles.add(domainMod);
    return archiveFiles;
  }

  static List<ArchiveFile> _generateEntityFile(Entity entity) {
    final nameSnack = entity.name.toSnakeCase();
    final namePascal = entity.name.toPascalCase();
    String model = _structModel.replaceAll("{imports}", _buildImports(entity));
    model = model.replaceAll('{name}', namePascal);
    model = model.replaceAll('{fields}', _buildFields(entity));
    model = model.replaceAll('{params}', _buildParams(entity));
    model = model.replaceAll('{assignments}', _buildAssignments(entity));
    model += _buildEnum(entity);
    final entityPath = 'src/domain/$nameSnack/';
    final entitiesPath = '${entityPath}entities/';
    final file = ArchiveFile('$entitiesPath$nameSnack.rs', model.length, model);
    final modEntities = RustUtils.genMod(
      path: entitiesPath,
      imports: [nameSnack],
    );
    final entityMod = RustUtils.genMod(
      path: entityPath,
      imports: ['entities', 'value_objects'],
    );
    return [file, modEntities, entityMod];
  }

  static String _parseValueObject(ValueObject vo, Entity entity) {
    final entityNamePascal = entity.name.toPascalCase();
    final name = vo.name.toSnakeCase();
    final namePascal = vo.name.toPascalCase();
    String fieldType = '$entityNamePascal$namePascal';
    if (vo.isEnum) {
      fieldType = namePascal;
    }
    return 'pub {name}: {type},'
        .replaceAll('{name}', name)
        .replaceAll('{type}', fieldType);
  }

  static String _buildParams(Entity entity) {
    final params = entity.valueObjects.map((vo) {
      if (vo.isEnum) {
        return '${vo.name.toSnakeCase()}: ${vo.name.toPascalCase()}';
      }
      return '${vo.name.toSnakeCase()}: ${vo.type.toRustType()}';
    });
    return params.join(', ');
  }

  static String _buildAssignments(Entity entity) {
    String assignments = '';
    for (final vo in entity.valueObjects) {
      final s = '\n            ';
      final key = vo.name.toSnakeCase();
      String value = '${entity.name.toPascalCase()}${vo.name.toPascalCase()}';
      String voParam = '::new($key, &mut errors)';
      if (vo.isEnum) {
        value = vo.name.toSnakeCase();
        voParam = '';
      }
      final ass = '$s$key: $value$voParam,';
      assignments += ass;
    }
    return assignments;
  }

  static String _buildImports(Entity entity) {
    String imports = '';
    final containsDates = entity.valueObjects.any((vo) {
      return vo.isDate || vo.isTime || vo.isDateTime;
    });
    if (containsDates) {
      imports += 'use chrono::{DateTime, Utc};\n';
    }
    imports +=
        'use crate::domain::_core::id_generator::id_generator::IdGenerator;\n';
    imports += 'use crate::domain::_core::errors::domain_error::DomainError;\n';
    for (final vo in entity.valueObjects) {
      if (vo.isEnum) {
        continue;
      }
      final voSnake = '${entity.name.toSnakeCase()}_${vo.name.toSnakeCase()}';
      final voPascal = '${entity.name.toPascalCase()}${vo.name.toPascalCase()}';
      final entitySnack = entity.name.toSnakeCase();
      imports +=
          'use crate::domain::$entitySnack::value_objects::$voSnake::$voPascal;\n';
    }
    return imports;
  }

  static String _buildFields(Entity entity) {
    final fields = entity.valueObjects.map(
      (item) => _parseValueObject(item, entity),
    );
    return fields.join('\n    ');
  }

  static String _buildEnum(Entity entity) {
    final vos = entity.valueObjects.where((vo) => vo.isEnum);
    String enums = '';
    for (final vo in vos) {
      final name = vo.name.toPascalCase();
      final values = vo.enumValues.split(',').map((e) => e.toPascalCase());
      final enumContent = _enumModel
          .replaceAll('{name}', name)
          .replaceAll('{values}', values.join(', '));
      enums += '\n\n$enumContent';
    }
    return enums;
  }
}

const _structModel = '''
{imports}
pub struct {name} {
    id: String,    
    {fields}
    errors: Vec<DomainError>,
}
impl {name} {
    pub fn new(id: Option<String>, {params}) -> Self {
        let mut errors: Vec<DomainError> = Vec::new();
        let id = id.unwrap_or_else(|| IdGenerator::v7());
        {name} {
            id,{assignments}
            errors,
        }
    }
}
''';

const _enumModel = '''
pub enum {name} {
    {values},
}
''';
