part of flutter_platform_versioning;

Future<void> _setIOSConfigurations(dynamic iosConfig) async {
  try {
    if (iosConfig == null) return;
    if (iosConfig is! Map && iosConfig is! String) {
      throw _FPVErrors.invalidIOSConfig;
    }

    String version;
    if (iosConfig is String) {
      version = iosConfig;
    } else {
      final iosConfigMap = Map<String, dynamic>.from(iosConfig);
      version = iosConfigMap[_version];
    }

    await _setIOSVersion(version);
    await _setIOSVersionInfoPlist(version);
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Skipping iOS configuration!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Skipping iOS configuration!!!');
  } finally {
    if (iosConfig != null) _logger.w(_majorTaskDoneLine);
  }
}

Future<void> _setIOSVersion(dynamic version) async {
  try {
    if (version == null) return;
    if ((version is! String) || (!version.toString().contains('+'))) {
      throw _FPVErrors.invalidVersion;
    }

    String vNumber = version.split("+").first;
    String vBuildNumber = version.split("+").last;

    final iosProjectFile = File(_iosProjectFilePath);
    if (!await iosProjectFile.exists()) {
      throw _FPVErrors.iosProjectFileNotFound;
    }

    final regExp = RegExp('MARKETING_VERSION = (.*?);');
    final packageNameString = 'MARKETING_VERSION = $vNumber;';

    final regExp2 = RegExp('CURRENT_PROJECT_VERSION = (.*?);');
    final packageNameString2 = 'CURRENT_PROJECT_VERSION = $vBuildNumber;';

    final iosProjectString = await iosProjectFile.readAsString();
    final newBundleIDIOSProjectString = iosProjectString
        .replaceAll(
          regExp,
          packageNameString,
        )
        .replaceAll(regExp2, packageNameString2);

    await iosProjectFile.writeAsString(newBundleIDIOSProjectString);

    _logger
      ..i('iOS Version set to: `$vNumber` (project.pbxproj)')
      ..i('iOS Build set to: `$vBuildNumber` (project.pbxproj)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('iOS Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('iOS Version change failed!!!');
  } finally {
    if (version != null) _logger.f(_minorTaskDoneLine);
  }
}

Future<void> _setIOSVersionInfoPlist(dynamic version) async {
  try {
    if (version == null) return;
    if ((version is! String) || (!version.toString().contains('+'))) {
      throw _FPVErrors.invalidVersion;
    }

    String vNumber = version.split("+").first;
    String vBuildNumber = version.split("+").last;

    final iosInfoPlistFile = File(_iosInfoPlistFilePath);
    if (!await iosInfoPlistFile.exists()) {
      throw _FPVErrors.iosInfoPlistNotFound;
    }
    final iosInfoPlistString = await iosInfoPlistFile.readAsString();
    final newDisplayNameIOSInfoPlistString = iosInfoPlistString
        .replaceAll(
          RegExp(
              r'<key>CFBundleShortVersionString</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleShortVersionString</key>\n\t<string>$vNumber</string>',
        )
        .replaceAll(
          RegExp(r'<key>CFBundleVersion</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleVersion</key>\n\t<string>$vBuildNumber</string>',
        );

    await iosInfoPlistFile.writeAsString(newDisplayNameIOSInfoPlistString);

    _logger
      ..i('iOS Version set to: `$vNumber` ($_iosInfoPlistFilePath)')
      ..i('iOS Build set to: `$vBuildNumber` ($_iosInfoPlistFilePath)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('iOS Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('iOS Version change failed!!!');
  } finally {
    if (version != null) _logger.f(_minorTaskDoneLine);
  }
}

Future<void> _removeIOSVersionInfoPlist() async {
  try {
    final iosInfoPlistFile = File(_iosInfoPlistFilePath);
    if (!await iosInfoPlistFile.exists()) {
      throw _FPVErrors.iosInfoPlistNotFound;
    }
    String vNumber = "\$(MARKETING_VERSION)";
    String vBuildNumber = "\$(CURRENT_PROJECT_VERSION)";
    final iosInfoPlistString = await iosInfoPlistFile.readAsString();
    final newDisplayNameIOSInfoPlistString = iosInfoPlistString
        .replaceAll(
          RegExp(
              r'<key>CFBundleShortVersionString</key>\s*<string>(.*?)</string>'),
          "<key>CFBundleShortVersionString</key>\n\t<string>$vNumber</string>",
        )
        .replaceAll(
          RegExp(r'<key>CFBundleVersion</key>\s*<string>(.*?)</string>'),
          '<key>CFBundleVersion</key>\n\t<string>$vBuildNumber</string>',
        );

    await iosInfoPlistFile.writeAsString(newDisplayNameIOSInfoPlistString);

    _logger
      ..i('iOS Version removed by FPV ($_iosInfoPlistFilePath)')
      ..i('iOS Build removed by FPV ($_iosInfoPlistFilePath)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('iOS Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('iOS Version change failed!!!');
  } finally {
    _logger.f(_minorTaskDoneLine);
  }
}
