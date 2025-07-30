import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/_core/utils/types_utils.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/domain/value_objects/rust_value_objects_rules_generator.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_type_extension.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustValueObjectGenerator {
  static List<ArchiveFile> generate(Entity entity) {
    final files = <ArchiveFile>[];
    final valueObjects = entity.valueObjects;
    for (final vo in valueObjects) {
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
    final voType = vo.toRustType();
    final voValidations = _buildValidations(entity, vo);

    String content = _structModel.replaceAll('{name}', voPascal);
    content = content.replaceAll('{imports}', imports);
    content = content.replaceAll('%VALIDATIONS%', voValidations);
    content = content.replaceAll('{type}', voType);

    final mod = _generateValueObjectsMod(path, entity);
    final voFile = RustUtils.genFile(
      path: '$path/$voSnake.rs',
      content: content,
    );
    return [mod, voFile];
  }

  static ArchiveFile _generateValueObjectsMod(String path, Entity entity) {
    final List<String> imports = [];
    for (final vo in entity.valueObjects) {
      if (vo.isEnum) {
        continue;
      }
      final voSnake = "${entity.name.toSnakeCase()}_${vo.name.toSnakeCase()}";
      imports.add(voSnake);
    }
    return RustUtils.genMod(path: path, imports: imports);
  }

  static String _buildImports(ValueObject vo) {
    final imports = <String>[];
    if (vo.isAnyDate) {
      imports.add('use chrono::DateTime;');
      imports.add('use chrono::Utc;');
      final anySumComparator = vo.rules.any((r) {
        return r.groupConditions.any((gc) {
          return gc.conditions.any((c) {
            return TypesUtils.isInputIntegerComparatorForDate(
              c.comparatorOperator,
            );
          });
        });
      });
      if (anySumComparator) {
        imports.add('use chrono::Duration;');
      }
    }
    if (vo.type == 'BigDecimal') {
      imports.add('use bigdecimal::{BigDecimal, FromPrimitive};');
    }
    final containsEmailValidation = vo.rules.any(
      (rule) => rule.groupConditions.any(
        (group) => group.conditions.any(
          (condition) => condition.comparatorOperator == 'isEmail',
        ),
      ),
    );
    if (containsEmailValidation) {
      imports.add('use email_address::EmailAddress;');
    }
    final containsCpfValidation = vo.rules.any(
      (rule) => rule.groupConditions.any(
        (group) => group.conditions.any((condition) {
          return condition.comparatorOperator == 'isCpf';
        }),
      ),
    );
    if (containsCpfValidation) {
      imports.add('use cpf_cnpj::cpf;');
    }
    final containsCnpjValidation = vo.rules.any(
      (rule) => rule.groupConditions.any(
        (group) => group.conditions.any((condition) {
          return condition.comparatorOperator == 'isCnpj';
        }),
      ),
    );
    if (containsCnpjValidation) {
      imports.add('use cpf_cnpj::cnpj;');
    }
    final containsUrlValidation = vo.rules.any(
      (rule) => rule.groupConditions.any(
        (group) => group.conditions.any((condition) {
          return condition.comparatorOperator == 'isUrl';
        }),
      ),
    );
    if (containsUrlValidation) {
      imports.add('use url::Url;');
    }
    final containsMatchesValidation = vo.rules.any(
      (rule) => rule.groupConditions.any(
        (group) => group.conditions.any((condition) {
          return condition.comparatorOperator == 'matches';
        }),
      ),
    );
    if (containsMatchesValidation) {
      imports.add('use regex::Regex;');
    }
    return imports.join('\n');
  }

  static String _buildValidations(Entity entity, ValueObject valueObject) {
    return RustValueObjectsRulesGenerator.generate(entity, valueObject);
  }
}

const _structModel = '''
use crate::domain::_core::errors::domain_error::DomainError;
{imports}

#[derive(Clone)]
pub struct {name} {
    pub value: {type},
}

impl {name} {
    pub fn new(value: {type}, errors: &mut Vec<DomainError>) -> Self {
        let name = {name} { value };
        name.validate(errors);
        name
    }

    fn validate(&self, errors: &mut Vec<DomainError>) {%VALIDATIONS%
    }
}
''';
