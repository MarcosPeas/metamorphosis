import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class TomlGenerator {
  static ArchiveFile generate(Application application) {
    String tomlContent = _tomlTemplate.replaceFirst(
      "{name}",
      application.name.toSnakeCase(),
    );
    tomlContent = _chrono(tomlContent, application);
    tomlContent = _emailValidator(tomlContent, application);
    tomlContent = _documentValidator(tomlContent, application);
    tomlContent = _urlValidator(tomlContent, application);
    tomlContent = _regex(tomlContent, application);
    tomlContent = _bigDecimal(tomlContent, application);
    final file = RustUtils.genFile(path: 'Cargo.toml', content: tomlContent);
    return file;
  }

  static String _chrono(String content, Application application) {
    final hasAnyDateTime = application.entities.any((entity) {
      return entity.valueObjects.any((vo) {
        return vo.isDate || vo.isTime || vo.isDateTime;
      });
    });
    return content.replaceAll(
      '{chrono}',
      hasAnyDateTime ? 'chrono = "0.4.41"\n' : '',
    );
  }

  static String _emailValidator(String content, Application application) {
    final hasAnyEmailVO = application.entities.any((entity) {
      return entity.valueObjects.any((vo) {
        return vo.rules.any((rule) {
          return rule.groupConditions.any((group) {
            return group.conditions.any((condition) {
              return condition.comparatorOperator == 'isEmail';
            });
          });
        });
      });
    });
    return content.replaceAll(
      '{emailValidator}',
      hasAnyEmailVO ? 'email_address = "0.2"\n' : '',
    );
  }

  static String _documentValidator(String content, Application application) {
    final hasAnyEmailVO = application.entities.any((entity) {
      return entity.valueObjects.any((vo) {
        return vo.rules.any((rule) {
          return rule.groupConditions.any((group) {
            return group.conditions.any((condition) {
              final docs = ['isCpf', 'isCnpj'];
              return docs.contains(condition.comparatorOperator);
            });
          });
        });
      });
    });
    return content.replaceAll(
      '{documentValidator}',
      hasAnyEmailVO ? 'cpf_cnpj = "0.2.1"\n' : '',
    );
  }

  static String _urlValidator(String content, Application application) {
    final hasAnyEmailVO = application.entities.any((entity) {
      return entity.valueObjects.any((vo) {
        return vo.rules.any((rule) {
          return rule.groupConditions.any((group) {
            return group.conditions.any((condition) {
              return condition.comparatorOperator == 'isUrl';
            });
          });
        });
      });
    });
    return content.replaceAll(
      '{urlValidator}',
      hasAnyEmailVO ? 'url = "2"\n' : '',
    );
  }

  static String _regex(String content, Application application) {
    final hasAnyEmailVO = application.entities.any((entity) {
      return entity.valueObjects.any((vo) {
        return vo.rules.any((rule) {
          return rule.groupConditions.any((group) {
            return group.conditions.any((condition) {
              return condition.comparatorOperator == 'matches';
            });
          });
        });
      });
    });
    return content.replaceAll('{regex}', hasAnyEmailVO ? 'regex = "1"\n' : '');
  }

  static String _bigDecimal(String content, Application application) {
    final bigDecimalDependencies = [
      'bigdecimal = "0.4"',
      'num-bigint = "0.4"',
    ];
    final libs = bigDecimalDependencies.join('\n');
    final hasAnyEmailVO = application.entities.any((entity) {
      return entity.valueObjects.any((vo) {
        return vo.isBigDecimal;
      });
    });
    return content.replaceAll('{bigDecimal}', hasAnyEmailVO ? '$libs\n' : '');
  }
}

const _tomlTemplate = '''
[package]
name = "{name}"
version = "0.1.0"
edition = "2021"

[dependencies]
uuid = { version = "1.17.0", features = ["v7"] }
{chrono}{emailValidator}{documentValidator}{urlValidator}{regex}{bigDecimal}
''';
