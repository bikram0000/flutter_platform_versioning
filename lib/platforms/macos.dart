part of flutter_platform_versioning;

Future<void> _setMacOSConfigurations(dynamic macOSConfig) async {
  try {
    if (macOSConfig == null) return;
    if (macOSConfig is! Map && macOSConfig is! String) {
      throw _FPVErrors.invalidMacOSConfig;
    }

    String version;
    if (macOSConfig is String) {
      version = macOSConfig;
    } else {
      final macOSConfigMap = Map<String, dynamic>.from(macOSConfig);
      version = macOSConfigMap[_version];
    }

    await _setMacOSVersionInfoPlist(version);
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Skipping MacOS configuration!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Skipping MacOS configuration!!!');
  } finally {
    if (macOSConfig != null) _logger.w(_majorTaskDoneLine);
  }
}

Future<void> _setMacOSVersionInfoPlist(dynamic version) async {
  try {
    if (version == null) return;
    if ((version is! String) || (!version.toString().contains('+'))) {
      throw _FPVErrors.invalidVersion;
    }

    String vNumber = version.split("+").first;
    String vBuildNumber = version.split("+").last;

    final macOSInfoPlistFile = File(_macOSInfoPlistPath);
    if (!await macOSInfoPlistFile.exists()) {
      throw _FPVErrors.macOSInfoPlistNotFound;
    }
    final macOSInfoPlistString = await macOSInfoPlistFile.readAsString();
    final newDisplayNamemacOSInfoPlistString = macOSInfoPlistString
        .replaceAll(
          RegExp(
              r'<key>CFBundleShortVersionString</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleShortVersionString</key>\n\t<string>$vNumber</string>',
        )
        .replaceAll(
          RegExp(r'<key>CFBundleVersion</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleVersion</key>\n\t<string>$vBuildNumber</string>',
        );

    await macOSInfoPlistFile.writeAsString(newDisplayNamemacOSInfoPlistString);

    _logger
      ..i('macOS Version set to: `$vNumber` ($_macOSInfoPlistPath)')
      ..i('macOS Build set to: `$vBuildNumber` ($_macOSInfoPlistPath)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('macOS Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('macOS Version change failed!!!');
  } finally {
    if (version != null) _logger.wtf(_minorTaskDoneLine);
  }
}

Future<void> _removeMacOSVersionInfoPlist() async {
  try {
    final macOSInfoPlistFile = File(_macOSInfoPlistPath);
    if (!await macOSInfoPlistFile.exists()) {
      throw _FPVErrors.macOSInfoPlistNotFound;
    }
    String vNumber = "\$(FLUTTER_BUILD_NAME)";
    String vBuildNumber = "\$(FLUTTER_BUILD_NUMBER)";

    final macOSInfoPlistString =await macOSInfoPlistFile.readAsString();
    final newDisplayNamemacOSInfoPlistString = macOSInfoPlistString
        .replaceAll(
          RegExp(
              r'<key>CFBundleShortVersionString</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleShortVersionString</key>\n\t<string>$vNumber</string>',
        )
        .replaceAll(
          RegExp(r'<key>CFBundleVersion</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleVersion</key>\n\t<string>$vBuildNumber</string>',
        );

    await macOSInfoPlistFile.writeAsString(newDisplayNamemacOSInfoPlistString);

    _logger
      ..i('macOS Version removed by FPV ($_macOSInfoPlistPath)')
      ..i('macOS Build removed by FPV ($_macOSInfoPlistPath)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('macOS Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('macOS Version change failed!!!');
  } finally {
    _logger.wtf(_minorTaskDoneLine);
  }
}
