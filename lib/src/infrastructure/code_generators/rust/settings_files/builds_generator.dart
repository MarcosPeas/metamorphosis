import 'package:archive/archive.dart';
import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class BuildsGenerator {
  static List<ArchiveFile> generate(Application app) {
    final win = _buildWin(app);
    final ubuntu = _buildUbuntu(app);
    final mac = _buildMac(app);
    final dockerfileDev = _buildDockerfileDev();
    final dockerCompose = _buildDockerCompose();
    return [win, ubuntu, mac, dockerfileDev, dockerCompose];
  }

  static ArchiveFile _buildWin(Application app) {
    final content = win.replaceAll('%APP_NAME%', app.name.toSnakeCase()).trim();

    return ArchiveFile(
      'build-win.bat',
      content.length,
      content,
    );
  }

  static ArchiveFile _buildUbuntu(Application app) {
    final content =
        ubuntu.replaceAll('%APP_NAME%', app.name.toSnakeCase()).trim();

    return ArchiveFile(
      'build-ubuntu.sh',
      content.length,
      content,
    );
  }

  static ArchiveFile _buildMac(Application app) {
    final content = mac.replaceAll('%APP_NAME%', app.name.toSnakeCase()).trim();

    return ArchiveFile(
      'build-mac.sh',
      content.length,
      content,
    );
  }

  static ArchiveFile _buildDockerfileDev() {
    final content = dockerfileDev.trim();
    return ArchiveFile(
      'Dockerfile.dev',
      content.length,
      content.codeUnits,
    );
  }

  static ArchiveFile _buildDockerCompose() {
    final content = dockerCompose.trim();
    return ArchiveFile(
      'docker-compose.yml',
      content.length,
      content.codeUnits,
    );
  }
}

const win = '''
@echo off
setlocal

set BIN_NAME=%APP_NAME%

if not exist build (
    mkdir build
)

docker run --rm ^
    -v "%cd%":/app ^
    -v "%cd%\\build":/output ^
    -w /app ^
    rust:slim-bullseye bash -c "apt-get update && apt-get install -y gcc-mingw-w64-x86-64 && rustup target add x86_64-pc-windows-gnu && cargo build --release --target=x86_64-pc-windows-gnu && cp target/x86_64-pc-windows-gnu/release/%BIN_NAME%.exe /output/"

endlocal
''';

const ubuntu = '''
#!/bin/bash

set -e

BIN_NAME="%APP_NAME%"

# Cria a pasta build se não existir
mkdir -p build

docker run --rm \\
    -v "\$(pwd)":/app \\
    -v "\$(pwd)/build":/output \\
    -w /app \\
    rust:slim-bullseye bash -c "\\
        apt-get update && \\
        apt-get install -y build-essential && \\
        cargo build --release && \\
        cp target/release/\$BIN_NAME /output/"
''';

const mac = '''
#!/bin/bash

set -e

BIN_NAME="%APP_NAME%"

mkdir -p build

docker run --rm \\
    -v "\$(pwd)":/app \\
    -v "\$(pwd)/build":/output \\
    -w /app \\
    ghcr.io/messense/cargo-zigbuild:latest bash -c "\\
        cargo zigbuild --release --target x86_64-apple-darwin && \\
        cp target/x86_64-apple-darwin/release/\$BIN_NAME /output/"
''';

const dockerfileDev = '''
FROM rust:1.86

# Instala ferramentas úteis
RUN apt-get update && \\
    apt-get install -y build-essential git curl pkg-config && \\
    rustup component add rustfmt clippy

# Cria usuário comum para desenvolvimento
RUN useradd -ms /bin/bash devuser
USER devuser
WORKDIR /home/devuser/app
''';

const dockerCompose = '''
services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/home/devuser/app
    working_dir: /home/devuser/app
    ports:
      - 3000:3000
''';
