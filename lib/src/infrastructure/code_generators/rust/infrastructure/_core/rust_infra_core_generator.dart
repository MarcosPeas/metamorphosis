import 'package:archive/archive.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/infrastructure/code_generators/rust/utils/rust_utils.dart';

class RustInfraCoreGenerator {
  static final _root = 'src/infrastructure/_core';

  static List<ArchiveFile> generate(Application app) {
    final appState = _appState();
    final dbBuilder = _dbBuilder();
    final coreMod = RustUtils.genMod(path: _root, imports: ['db']);
    final dbMod = RustUtils.genMod(
      path: '$_root/db',
      imports: ['app_state', 'db_builder', 'mysql'],
    );
    return [appState, dbBuilder, coreMod, dbMod];
  }

  static ArchiveFile _appState() {
    return RustUtils.genFile(
      path: '$_root/db/app_state.rs',
      content: _appStateContent,
    );
  }

  static ArchiveFile _dbBuilder() {
    return RustUtils.genFile(
      path: '$_root/db/db_builder.rs',
      content: _dbBuilderContent,
    );
  }
}

const _appStateContent = '''
use std::sync::Arc;

use sqlx::MySqlPool;

#[derive(Clone)]
pub struct AppState {
    pub mysql_pool: Arc<MySqlPool>,
}

impl AppState {
    pub fn with_pg(mysql_pool: MySqlPool) -> Self {
        AppState {
            mysql_pool: Arc::new(mysql_pool),
        }
    }
}
''';

const _dbBuilderContent = '''
use crate::domain::_core::errors::domain_error::DomainError;

use super::app_state::AppState;

pub trait DbBuilder {
    async fn build(&self) -> ConnectionResult;
}

pub enum ConnectionResult {
    ConnectionSuccess(AppState),
    ConnectionError(DomainError),
}

pub struct SchemeVersion {
    pub version: i32,
    pub scripts: Vec<String>,
}
''';
