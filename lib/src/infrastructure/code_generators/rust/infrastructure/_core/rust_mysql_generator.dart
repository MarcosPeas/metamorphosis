import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/code_generators/_core/db_extension.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustMySQLGenerator {
  static final _root = 'src/infrastructure/_core/db/mysql';

  static final List<String> _schemesVersions = [];

  static List<ArchiveFile> generate(Application app) {
    List<ArchiveFile> schemes = [];
    String schemesVersionImports = '';
    String schemesVersionUsages = '';
    for (int i = 1; i <= app.version; i++) {
      final currentEntities = app.entities
          .map((e) => e.getByVersion(i))
          .where((e) => e != null)
          .toList();
      if (currentEntities.isNotEmpty) {
        schemesVersionImports +=
            '\nuse crate::infrastructure::_core::db::mysql::scheme_v$i;';
        schemesVersionUsages += '\n    schemes.push(scheme_v$i::build());';
        final scheme = _generateSchemes(currentEntities, i);
        schemes.add(scheme);
      } else {
        log('Sem entidades na versão $i');
      }
    }

    String builderContent = _builderContent.replaceAll(
      '{schemesVersionImports}',
      schemesVersionImports,
    );
    builderContent = builderContent.replaceAll(
      '{shemeVersionUsages}',
      schemesVersionUsages,
    );
    final builder = RustUtils.genFile(
      path: '$_root/mysql_builder.rs',
      content: builderContent,
    );

    final mod = RustUtils.genMod(
      path: _root,
      imports: ['mysql_builder', ..._schemesVersions],
    );
    _schemesVersions.clear();
    return [mod, builder, ...schemes];
  }

  static ArchiveFile _generateSchemes(List<Entity?> entities, int version) {
    String content = _schemeVersionContent;
    String sqlContent = '';
    for (final entity in entities) {
      if (entity == null) {
        continue;
      }
      log('Generating scheme for ${entity.name}');
      if (entity.parent != null) {
        final sql = modifyTable(entity);
        sqlContent += sql;
      } else {
        final sql = createTable(entity);
        sqlContent += sql;
      }
    }
    content = content.replaceAll('{sql}', sqlContent);
    content = content.replaceAll('{version}', version.toString());
    _schemesVersions.add('scheme_v$version');
    final scheme = RustUtils.genFile(
      path: '$_root/scheme_v$version.rs',
      content: content,
    );
    return scheme;
  }
}

String createTable(Entity entity) {
  String sp8 = '        ';
  String sp12 = '            ';
  final entitySnake = entity.name.toSnakeCase();

  String sql = '\n${sp8}r#"\n';
  sql += '${sp8}CREATE TABLE IF NOT EXISTS $entitySnake (\n';
  sql += entity.valueObjects
      .map((vo) {
        final voSnake = vo.name.toSnakeCase();
        if (vo.isUUID) {
          return '$sp12$voSnake VARCHAR(36) PRIMARY KEY';
        } else if (vo.isLongId) {
          return '$sp12$voSnake INT PRIMARY KEY';
        }
        return '$sp12$voSnake ${vo.toMySqlType()}';
      })
      .join(',\n');
  sql += '\n$sp8)\n';
  sql += '$sp8"#\n';
  sql += '$sp8.to_string(),';
  return sql;
}

String modifyTable(Entity entity) {
  final modifiers = entity.getModifiers();
  String sql = '';
  for (final modifier in modifiers) {
    if (modifier.isAdd) {
      sql += addField(entity, modifier.valueObject);
    } else if (modifier.isRemove) {
      sql += removeField(entity, modifier.valueObject);
    } else if (modifier.isModifyName) {
      sql += changeName(entity, modifier.valueObject);
    } else if (modifier.isModifyType) {
      sql += changeType(entity, modifier.valueObject);
    }
  }
  return sql;
}

String removeField(Entity entity, ValueObject valueObject) {
  String sp8 = '        ';
  final voSnake = valueObject.name.toSnakeCase();
  final entitySnake = entity.name.toSnakeCase();
  return '\n$sp8"ALTER TABLE $entitySnake DROP COLUMN $voSnake".to_string(),';
}

String addField(Entity entity, ValueObject valueObject) {
  String sp8 = '        ';
  final entitySnake = entity.name.toSnakeCase();
  String sql = '\n${sp8}r#"\n';
  sql += '${sp8}ALTER TABLE $entitySnake\n';
  final voSnake = valueObject.name.toSnakeCase();
  if (valueObject.isUUID) {
    sql += '${sp8}ADD COLUMN $voSnake VARCHAR(36) PRIMARY KEY';
  } else if (valueObject.isLongId) {
    sql += '${sp8}ADD COLUMN $voSnake INT PRIMARY KEY';
  } else {
    sql += '${sp8}ADD COLUMN $voSnake ${valueObject.toMySqlType()}';
  }
  sql += '\n$sp8\n';
  sql += '$sp8"#\n';
  sql += '$sp8.to_string(),';
  return sql;
}

String changeName(Entity entity, ValueObject valueObject) {
  String sp8 = '        ';
  String sp12 = '            ';
  final entitySnake = entity.name.toSnakeCase();

  String sql = '\n${sp8}r#"\n';
  sql += '${sp8}ALTER TABLE $entitySnake (\n';
  sql += entity.valueObjects
      .map((vo) {
        final voSnake = vo.name.toSnakeCase();
        if (vo.isUUID) {
          return '$sp12$voSnake VARCHAR(36) PRIMARY KEY';
        } else if (vo.isLongId) {
          return '$sp12$voSnake INT PRIMARY KEY';
        }
        return '$sp12$voSnake ${vo.toMySqlType()}';
      })
      .join(',\n');
  sql += '\n$sp8\n';
  sql += '$sp8"#\n';
  sql += '$sp8.to_string(),';
  return sql;
}

String changeType(Entity entity, ValueObject vo) {
  String sp8 = '        ';
  String sp12 = '            ';
  final entitySnake = entity.name.toSnakeCase();

  String sql = '\n${sp8}r#"\n';
  sql += '${sp8}ALTER TABLE $entitySnake (\n';
  sql += entity.valueObjects
      .map((vo) {
        final voSnake = vo.name.toSnakeCase();
        if (vo.isUUID) {
          return '$sp12$voSnake VARCHAR(36) PRIMARY KEY';
        } else if (vo.isLongId) {
          return '$sp12$voSnake INT PRIMARY KEY';
        }
        return '$sp12$voSnake ${vo.toMySqlType()}';
      })
      .join(',\n');
  sql += '\n$sp8\n';
  sql += '$sp8"#\n';
  sql += '$sp8.to_string(),';
  return sql;
}

const _builderContent = '''
use sqlx::{MySql, Pool, Row, mysql::MySqlPoolOptions};{schemesVersionImports}

use crate::{
    domain::_core::errors::domain_error::DomainError,
    infrastructure::_core::db::{
        app_state::AppState,
        db_builder::{ConnectionResult, DbBuilder, SchemeVersion},
    },
};

pub struct MySqlBuilder;

impl MySqlBuilder {
    pub fn new() -> Self {
        MySqlBuilder {}
    }
}

impl DbBuilder for MySqlBuilder {
    async fn build(&self) -> ConnectionResult {   
        let url = "mysql://zabha:hayate2011@localhost:3306/zabha-contabil";     
        let pool = MySqlPoolOptions::new()
            .max_connections(10)
            .connect(url)
            .await;
        if pool.is_err() {
            let error = pool.err().unwrap();
            return ConnectionResult::ConnectionError(DomainError::new(
                String::from(error.to_string()),
                String::from("Error connecting to MySQL"),
                String::from("Error connecting to MySQL"),
            ));
        }
        let pool = verify_version(pool.unwrap()).await;
        ConnectionResult::ConnectionSuccess(AppState::with_pg(pool))
    }
}

async fn verify_version(pool: Pool<MySql>) -> Pool<MySql> {
    let result = sqlx::query(
        r#"
        CREATE TABLE IF NOT EXISTS scheme_version (
            version INT PRIMARY KEY,
            created_at TIMESTAMP NOT NULL DEFAULT NOW()
        )
        "#,
    )
    .execute(&pool)
    .await;
    if result.is_err() {
        let error = result.err().unwrap();
        panic!("{:?}", error.to_string());
    }
    validate_version(pool).await
}

async fn validate_version(pool: Pool<MySql>) -> Pool<MySql> {
    let sql = "SELECT version FROM scheme_version ORDER BY version DESC LIMIT 1";
    let result = sqlx::query(sql).fetch_one(&pool).await;
    let no_rows = "no rows returned by a query that expected to return at least one row";
    if result.is_err() {
        if result.as_ref().err().unwrap().to_string() == no_rows {
            return build_scheme(0, pool).await;
        }
        let error = result.err().unwrap();
        panic!("{:?}", error.to_string());
    }
    let row = result.unwrap();
    let mut version: i32 = 0;
    if !row.is_empty() {
        version = row.get::<i32, _>("version");
    }
    build_scheme(version, pool).await
}

async fn build_scheme(version: i32, pool: Pool<MySql>) -> Pool<MySql> {
    let mut max_version = 0;
    let scripts = scripts();
    for script in scripts {
        if script.version > version {
            for sql in script.scripts {
                let result = sqlx::query(&sql.trim()).execute(&pool).await;
                if result.is_err() {
                    let error = result.err().unwrap();
                    panic!("{:?}\n{:?}", sql, error.to_string());
                }
            }
        }
        max_version = if max_version > script.version {
            max_version
        } else {
            script.version
        };
    }

    if max_version > version {
        let sql = "INSERT INTO scheme_version (version) VALUES (\$1)";
        let result = sqlx::query(sql).bind(max_version).execute(&pool).await;
        if result.is_err() {
            let error = result.err().unwrap();
            panic!("{:?}", error.to_string());
        }
    }
    pool
}

fn scripts() -> Vec<SchemeVersion> {
    let mut schemes: Vec<SchemeVersion> = Vec::new();{shemeVersionUsages}
    schemes
}
''';

const _schemeVersionContent = '''
use crate::infrastructure::_core::db::db_builder::SchemeVersion;

pub fn build() -> SchemeVersion {
    let scripts = vec![{sql}
    ];
    SchemeVersion {
        scripts: scripts,
        version: {version},
    }
}
''';
