/// A *blazingly fast* way to configure your project to be production ready.
///
/// You can customize configurations it in the following way:
/// 1. `flutter_platform_versioning` key in `pubspec.yaml`:
/// ```yaml
/// flutter_platform_versioning:
///   ...
/// ```
///
/// 2. `flutter_platform_versioning.yaml` file at the root of the project:
/// ```yaml
/// flutter_platform_versioning:
///   ...
/// ```
library flutter_platform_versioning;

import 'dart:io';

import 'package:args/args.dart';
import 'package:logger/logger.dart';
import 'package:yaml/yaml.dart' as yaml;

part 'constants.dart';

part 'exceptions.dart';

part 'messages.dart';

part 'platforms/android.dart';

part 'platforms/ios.dart';

part 'platforms/macos.dart';

part 'platforms/windows.dart';

final _logger = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(
    lineLength: 80,
    methodCount: 0,
    noBoxingByDefault: true,
    printEmojis: false,
  ),
);

/// Starts setting build configurations for the flutter application according
/// to given configuration.
///
/// Configuration is a map of build configurations and their values.
///
/// You can specify it in the following way:
/// 1. `flutter_platform_versioning` key in `pubspec.yaml`:
/// ```yaml
/// flutter_platform_versioning:
///   ...
/// ```
///
/// 2. `flutter_platform_versioning.yaml` file at the root of the project:
/// ```yaml
/// flutter_platform_versioning:
///   ...
/// ```
Future<void> set(List<String> args) async {
  try {
    _logger.w(_majorTaskDoneLine);

    if (!_configFileExists()) throw _FPVErrors.filesNotFound;

    // Create args parser to get flavor flag and its value
    final parser = ArgParser()
      ..addFlag(
        'init',
        negatable: false,
        help:
            'Initialize Flutter Platform Versioning (creates if not there flutter_platform_versioning.yaml)',
      )
      ..addFlag(
        'update',
        negatable: false,
        help: "This will update all platform's version",
      )
      ..addFlag(
        'remove',
        negatable: false,
        help:
            'Remove Flutter Platform Versioning (deletes flutter_platform_versioning.yaml) And replace with pubspec.yaml version',
      )
      ..addOption(
        'all',
        help: 'Set Version for all Platform',
      )
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Specify the path for the config file',
      )
      ..addOption(
        'android',
        abbr: 'a',
        help: 'Set the Flutter Android version',
      )
      ..addOption(
        'ios',
        abbr: 'i',
        help: 'Set the Flutter iOS version',
      )
      ..addOption(
        'macos',
        abbr: 'm',
        help: 'Set the Flutter macOS version',
      )
      ..addOption(
        'windows',
        abbr: 'w',
        help: 'Set the Flutter Windows version',
      )
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Prints out available command usages',
      );

    final results = parser.parse(args);
    if (results.wasParsed('init')) {
      await initializeFlutterPlatformVersioning();
      _logger.i(_instruction);

    }
    if (results.wasParsed('remove')) {
      await _removeFlutterPlatformVersioning();
      await _removeAndroidVersionGradleFile();
      await _removeIOSVersionInfoPlist();
      await _removeMacOSVersionInfoPlist();
      await _removeWindowsVersion();
      _logger.i(_successfullyRemoved);
    }
    if (results.wasParsed('update')) {
      await _changeVersion(results);
      _logger.i(_successMessage);

    }
    final all = results['all'] as String?;
    if (all != null) {
      var d = {
        'path': results['path'] as String?,
        'android': all,
        'ios': all,
        'macos': all,
        'windows': all,
      };
      await _changeVersion(d);
      await _setVersionPubSpec(all);
      _logger.i(_successMessage);
    }
    await _changeVersion(results, checkAll: false);

    if (results.wasParsed('help') || results.arguments.isEmpty) {
      _logger
        ..i(_fpvCommands)
        ..i(parser.usage);
    }
  } on _FPVException catch (e) {
    _logger.f(e.message);
    exit(e.code);
  } catch (e) {
    _logger.f(e.toString());
    exit(255);
  } finally {
    _logger.close();
  }
}

Future<void> _changeVersion(results, {bool checkAll = true}) async {
  final path = results['path'] as String?;
  final android = results['android'] as String?;
  final ios = results['ios'] as String?;
  final macos = results['macos'] as String?;
  final windows = results['windows'] as String?;
  if (android != null) {
    await _setAndroidConfigurations(android);
    await _changeYamlVersion(
        configFile: path, platform: 'android', version: android);
  }
  if (ios != null) {
    await _setIOSConfigurations(ios);
    await _changeYamlVersion(configFile: path, platform: 'ios', version: ios);
  }
  if (macos != null) {
    await _setMacOSConfigurations(macos);
    await _changeYamlVersion(
        configFile: path, platform: 'macos', version: macos);
  }
  if (windows != null) {
    await _setWindowsConfigurations(windows);
    await _changeYamlVersion(
        configFile: path, platform: 'windows', version: windows);
  }
  if (checkAll &&
      android == null &&
      ios == null &&
      macos == null &&
      windows == null) {
    final config = await _getConfig(configFile: path);
    await _setAndroidConfigurations(config['android']);
    await _setIOSConfigurations(config['ios']);
    await _setMacOSConfigurations(config['macos']);
    await _setWindowsConfigurations(config['windows']);
  }
}

Future<void> initializeFlutterPlatformVersioning() async {
  final yamlData = '''
# # Generated By Bikramaditya From Flutter PlatForm Versioning
# Example Flutter Platform Versioning Configuration
flutter_platform_versioning:
  android: '1.0.0+1'   # Replace with your desired Android version
  ios: '1.0.0+1'    # Replace with your desired iOS version 
  macos: '1.0.0+1'    # Replace with your desired macOS version
  windows: '1.0.0+1'    # Replace with your desired Windows version
''';
  // Specify the path where you want to create the file
  final filePath = 'flutter_platform_versioning.yaml';
  try {
    if (await File(filePath).exists()) {
      _logger.e('$filePath already exist');
      return;
    } else {
      // Create the file
      await File(filePath).writeAsString(yamlData);
    }
    _logger.i(
        'Flutter Platform Versioning initialized. Configuration file created at: $filePath');
  } catch (e) {
    _logger.e('Error initializing Flutter Platform Versioning: $e');
  }
}

Future<void> _removeFlutterPlatformVersioning() async {
  // Specify the path of the file to be removed
  final filePath = 'flutter_platform_versioning.yaml';

  try {
    // Check if the file exists
    if (await File(filePath).exists()) {
      // Remove the file
      await File(filePath).delete();
      _logger.i(
          'Flutter Platform Versioning removed. Configuration file deleted: $filePath');
    } else {
      _logger.e(
          'Flutter Platform Versioning is not initialized. Configuration file not found: $filePath');
    }
  } catch (e) {
    _logger.e('Error removing Flutter Platform Versioning: $e');
  }
}

bool _configFileExists() {
  final configFile = File(_fpvConfigFileName);
  final pubspecFile = File(_pubspecFileName);
  return configFile.existsSync() || pubspecFile.existsSync();
}

Future<Map<String, dynamic>> _getConfig({
  String? configFile,
}) async {
  File yamlFile;

  if (configFile != null) {
    if (File(configFile).existsSync()) {
      await _checkConfigContent(configFile);
      yamlFile = File(configFile);
    } else {
      throw _FPVErrors.filesNotFound;
    }
  } else if (File(_fpvConfigFileName).existsSync()) {
    await _checkConfigContent(_fpvConfigFileName);
    yamlFile = File(_fpvConfigFileName);
  } else {
    yamlFile = File(_pubspecFileName);
  }

  final yamlString = await yamlFile.readAsString();
  final parsedYaml = yaml.loadYaml(yamlString) as Map;

  final rawConfig = parsedYaml[_configKey];
  if (rawConfig == null) {
    throw _FPVErrors.configNotFound;
  } else if (rawConfig is! Map) {
    throw _FPVErrors.invalidConfig;
  }

  return Map<String, dynamic>.from(rawConfig);
}

Future<void> _changeYamlVersion({
  String? configFile,
  required String version,
  required String platform,
}) async {
  File yamlFile;

  if (configFile != null) {
    if (await File(configFile).exists()) {
      await _checkConfigContent(configFile);
      yamlFile = File(configFile);
    } else {
      throw _FPVErrors.filesNotFound;
    }
  } else if (await File(_fpvConfigFileName).exists()) {
    await _checkConfigContent(_fpvConfigFileName);
    yamlFile = File(_fpvConfigFileName);
  } else {
    yamlFile = File(_pubspecFileName);
  }

  final yamlString = await yamlFile.readAsString();

  final regExp = RegExp("$platform: (.+)'");
  final appNameString = ("$platform: '$version'");

  final newLabelAndroidManifestString = yamlString.replaceAll(
    regExp,
    appNameString,
  );

  await yamlFile.writeAsString(newLabelAndroidManifestString);
}

Future<void> _setVersionPubSpec(String version) async {
  File yamlFile = File(_pubspecFileName);
  if (await yamlFile.exists()) {
    final yamlString = await yamlFile.readAsString();
    final regExp = RegExp("version: (.+)");
    final appNameString = "version: $version";
    final newLabelAndroidManifestString = yamlString.replaceAll(
      regExp,
      appNameString,
    );

    await yamlFile.writeAsString(newLabelAndroidManifestString);
  }
}

Future<void> _checkConfigContent(String yamlFile) async {
  final fileContent = await File(yamlFile).readAsString();

  if (fileContent.isEmpty) {
    throw _FPVErrors.filesNotFound;
  }

  if (yaml.loadYaml(fileContent) == null) {
    throw _FPVErrors.configNotFound;
  }
}
