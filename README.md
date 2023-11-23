# Flutter Platform Versioning

2023 © Bikramaditya Meher

[![Pub](https://img.shields.io/pub/v/flutter_platform_versioning.svg)](https://pub.dartlang.org/packages/flutter_platform_versioning) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/bikram0000/flutter_platform_versioning/blob/master/LICENSE)

Flutter Platform Versioning is a command-line tool to set different versions for different platforms in a Flutter project.

## Installation

Add the following to your `pubspec.yaml` file under `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_platform_versioning: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

To use Flutter Platform Versioning, run the following command in the root of your Flutter project:

```bash
flutter pub run flutter_platform_versioning:fpv
```

This will display the help and available options.

## Options

- `--init`: Initialize Flutter Platform Versioning (creates if not there flutter_platform_versioning.yaml).
- `--update`: Update all platform versions.
- `--remove`: Remove Flutter Platform Versioning (deletes flutter_platform_versioning.yaml) and replace with pubspec.yaml version.
- `--all`: Set version for all platforms.
- `-p, --path`: Specify the path for the config file.
- `-a, --android`: Set the Flutter Android version.
- `-i, --ios`: Set the Flutter iOS version.
- `-m, --macos`: Set the Flutter macOS version.
- `-w, --windows`: Set the Flutter Windows version.
- `-h, --help`: Prints out available command usages.

## Examples

Initialize Flutter Platform Versioning:

```bash
flutter pub run flutter_platform_versioning:fpv --init
```

Update all platform versions:

```bash
flutter pub run flutter_platform_versioning:fpv --update
```

Remove Flutter Platform Versioning and replace with pubspec.yaml version:

```bash
flutter pub run flutter_platform_versioning:fpv --remove
```

Set version for all platforms:

```bash
flutter pub run flutter_platform_versioning:fpv --all --version=2.0.0+1
```

Set version for a specific platform "Android" :

```bash
flutter pub run flutter_platform_versioning:fpv -a 2.0.0+1
```

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.
