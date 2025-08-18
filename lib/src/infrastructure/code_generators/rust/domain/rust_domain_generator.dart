import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/domain/enumerators/rust_enumerators_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_type_extension.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

import 'rust_domain_utils_generator.dart';
import 'value_objects/rust_value_object_generator.dart';

class RustDomainGenerator {
  static List<ArchiveFile> generate(
    Application application,
    List<GlobalEnumerator> enumerators,
  ) {
    final archiveFiles = <ArchiveFile>[];
    final entities = application.entities;
    final List<String> entitiesNames = [];
    for (final entity in entities) {
      archiveFiles.addAll(_generateEntityFile(entity));
      entitiesNames.add(entity.name.toSnakeCase());
      final valueObjectsFiles = RustValueObjectGenerator.generate(entity);
      archiveFiles.addAll(valueObjectsFiles);
    }

    archiveFiles.addAll(RustDomainUtilsGenerator.generate(enumerators));
    final domainMod = RustUtils.genMod(
      path: 'src/domain',
      imports: ['_core', ...entitiesNames],
    );
    archiveFiles.add(domainMod);

    final enumeratorsFiles = RustEnumeratorsGenerator.generate(enumerators);
    archiveFiles.addAll(enumeratorsFiles);
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
    final file = ArchiveFile(
      '$entitiesPath$nameSnack.rs',
      model.length,
      model.codeUnits,
    );
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
    if (vo.name == 'createdAt' || vo.name == 'updatedAt') {
      fieldType = 'DateTime<Utc>';
    }
    if (vo.isBoolean) {
      fieldType = 'bool';
    }
    return 'pub $name: $fieldType,';
  }

  static String _parseGlobalEnumerator(EntityGlobalEnumerator enumerator) {
    final name = enumerator.name.toSnakeCase();
    final type = enumerator.enumerator?.name.toPascalCase();
    return 'pub $name: $type,';
  }

  static String _buildParams(Entity entity) {
    final params = entity.valueObjects.map((vo) {
      if (vo.isEnum) {
        return '${vo.name.toSnakeCase()}: ${vo.name.toPascalCase()}';
      }
      if (vo.name == 'createdAt' || vo.name == 'updatedAt') {
        return '${vo.name.toSnakeCase()}: Option<DateTime<Utc>>';
      }
      return '${vo.name.toSnakeCase()}: ${vo.toRustType()}';
    });
    final paramsEnum = entity.globalEnumerators.map((vo) {
      return '${vo.name.toSnakeCase()}: ${vo.enumerator?.name.toPascalCase()}';
    });
    return [...params, ...paramsEnum].join(', ');
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
      if (vo.isBoolean) {
        value = vo.name.toSnakeCase();
        voParam = '';
      }
      if (vo.name == 'createdAt') {
        value = 'created_at.unwrap_or_else(|| Utc::now())';
        voParam = '';
      }
      if (vo.name == 'updatedAt') {
        value = 'updated_at.unwrap_or_else(|| Utc::now())';
        voParam = '';
      }
      final ass = '$s$key: $value$voParam,';
      assignments += ass;
    }
    for (final ge in entity.globalEnumerators) {
      final s = '\n            ';
      final type = ge.name.toSnakeCase();
      final ass = '$s$type: $type,';
      assignments += ass;
    }
    return assignments;
  }

  static String _buildImports(Entity entity) {
    String imports = '';
    final containsDates = entity.valueObjects.any((vo) {
      return vo.isAnyDate;
    });
    if (containsDates) {
      imports += 'use chrono::DateTime;\n';
      imports += 'use chrono::Utc;\n';
    }
    final containsBigDecimals = entity.valueObjects.any((vo) {
      return vo.isBigDecimal;
    });
    if (containsBigDecimals) {
      imports += 'use bigdecimal::BigDecimal;\n';
    }
    imports +=
        'use crate::domain::_core::id_generator::id_generator::IdGenerator;\n';
    imports += 'use crate::domain::_core::errors::domain_error::DomainError;\n';
    for (final vo in entity.valueObjects) {
      if (!vo.isValueObject) {
        continue;
      }
      final voSnake = '${entity.name.toSnakeCase()}_${vo.name.toSnakeCase()}';
      final voPascal = '${entity.name.toPascalCase()}${vo.name.toPascalCase()}';
      final entitySnack = entity.name.toSnakeCase();
      imports +=
          'use crate::domain::$entitySnack::value_objects::$voSnake::$voPascal;\n';
    }
    for(final enumerator in entity.globalEnumerators) {
      final enumNameSnack = enumerator.enumerator!.name.toSnakeCase();
      final enumName = enumerator.enumerator!.name.toPascalCase();
      imports += 'use crate::domain::_core::enumerators::$enumNameSnack::$enumName;\n';
    }
    return imports;
  }

  static String _buildFields(Entity entity) {
    final fields = entity.valueObjects.map(
      (item) => _parseValueObject(item, entity),
    );
    final fieldsEnum = entity.globalEnumerators.map(
      (item) => _parseGlobalEnumerator(item),
    );
    return [...fields, ...fieldsEnum].join('\n    ');
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
