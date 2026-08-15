import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';
/*
class RustPostgresGenerator {
  static final _root = 'src/infrastructure/_core/db/postgres';

  static List<ArchiveFile> generate(Application app) {
    final mod = RustUtils.genMod(path: _root, imports: ['postgres_builder']);
    final schemes = _generateSchemes(app.entities, 1);
    final builder = RustUtils.genFile(
      path: '$_root/postgres_builder.rs',
      content: _builderContent,
    );
    return [mod, builder, ...schemes];
  }

  static List<ArchiveFile> _generateSchemes(List<Entity> entities, int version) {
    List<ArchiveFile> result = [];
    String content = _schemeVersionContent;
    String sqlContent = '';
    for (final entity in entities) {
      final versionedEntity = entity;
      String sp8 = '        ';
      String sp12 = '            ';
      final entitySnake = versionedEntity.name.toSnakeCase();

      String sql = '${sp8}r#"\n';
      sql += '${sp8}CREATE TABLE IF NOT EXISTS $entitySnake (\n';
      sql += versionedEntity.valueObjects
          .map((vo) {
            final voSnake = vo.name.toSnakeCase();
            if (vo.name == 'id') {
              return '$sp12$voSnake VARCHAR(36) PRIMARY KEY';
            }
            return '$sp12$voSnake ${vo.toMySqlType()}${!vo.isNullable ? ' NOT NULL' : ''}';
          })
          .join(',\n');
      sql += '\n$sp8)\n';
      sql += '$sp8"#\n';
      sql += '$sp8.to_string(),\n';
      sqlContent += sql;
    }
    content = content.replaceAll('{sql}', sqlContent);
    final schemeV1 = RustUtils.genFile(path: '$_root/scheme_v$version.rs', content: content);
    result.add(schemeV1);    
    return result;
  }
}

//use crate::infrastructure::_core::db::db_builders::postegres::scheme_v1::scheme_v1;
//use crate::infrastructure::_core::db::postgres::scheme_v1;
const _builderContent = '''
{schemesImports}
use sqlx::{postgres::PgPoolOptions, Pool, Postgres, Row};

use crate::{
    domain::_core::errors::domain_error::DomainError,
    infrastructure::_core::db::{
        app_state::AppState,
        db_builder::{ConnectionResult, DbBuilder, SchemeVersion},
    },
};

{importSchemes}

pub struct PostgresBuilder;

impl PostgresBuilder {
    pub fn new() -> Self {
        PostgresBuilder {}
    }
}

impl DbBuilder for PostgresBuilder {
    async fn build(&self) -> ConnectionResult {
        //"postgres://usuario:senha@meu-postgres:5432/meubanco";
        let pool = PgPoolOptions::new()
            .max_connections(5)
            .connect("postgres://users:users@192.168.1.4:5432/users")
            .await;
        if pool.is_err() {
            let error = pool.err().unwrap();
            return ConnectionResult::ConnectionError(DomainError::new(
                String::from(error.to_string()),
                String::from("Error connecting to Postgres"),
                String::from("Error connecting to Postgres"),
            ));
        }
        let pool = verify_version(pool.unwrap()).await;
        ConnectionResult::ConnectionPostgres(AppState::with_pg(pool))
    }
}

async fn verify_version(pool: Pool<Postgres>) -> Pool<Postgres> {
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

async fn validate_version(pool: Pool<Postgres>) -> Pool<Postgres> {
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

async fn build_scheme(version: i32, pool: Pool<Postgres>) -> Pool<Postgres> {
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
    let mut schemes: Vec<SchemeVersion> = Vec::new();
    schemes.push(scheme_v1::build());
    schemes
}
''';

const _schemeVersionContent = '''
use crate::infrastructure::_core::db::db_builder::SchemeVersion;

pub fn build() -> SchemeVersion {
    let scripts = vec![
{sql}
    ];
    SchemeVersion {
        scripts: scripts,
        version: 1,
    }
}
''';
*/