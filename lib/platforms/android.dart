part of flutter_platform_versioning;

Future<void> _setAndroidConfigurations(dynamic androidConfig) async {
  try {
    if (androidConfig == null) return;
    if (androidConfig is! Map && androidConfig is! String) {
      throw _FPVErrors.invalidAndroidConfig;
    }

    String version;
    if (androidConfig is String) {
      version = androidConfig;
    } else {
      final androidConfigMap = Map<String, dynamic>.from(androidConfig);
      version = androidConfigMap[_version];
    }
    await _setAndroidVersion(version);
    await _setAndroidVersionGradleFile(version);
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Skipping Android configuration!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Skipping Android configuration!!!');
  } finally {
    if (androidConfig != null) _logger.w(_majorTaskDoneLine);
  }
}

Future<void> _setAndroidVersion(dynamic version) async {
  try {
    if (version == null) return;
    if ((version is! String) || (!version.toString().contains('+'))) {
      throw _FPVErrors.invalidVersion;
    }

    String vNumber = version.split("+").first;
    String vBuildNumber = version.split("+").last;

    final androidManifestFile = File(_androidLocalProperties);
    if (!await androidManifestFile.exists()) {
      throw _FPVErrors.androidLocalPropertiesNotFound;
    }

    final regExp = RegExp('flutter.versionName=(.+)');
    final appNameString = 'flutter.versionName=$vNumber';

    final regExp2 = RegExp('flutter.versionCode=(.+)');
    final appNameString2 = 'flutter.versionCode=$vBuildNumber';

    final androidManifestString =await androidManifestFile.readAsString();
    final newLabelAndroidManifestString = androidManifestString
        .replaceAll(
          regExp,
          appNameString,
        )
        .replaceAll(regExp2, appNameString2);

    await androidManifestFile.writeAsString(newLabelAndroidManifestString);

    _logger
      ..i('Android Version to: `$vNumber` ($_androidLocalProperties)')
      ..i('Android Build Number to: `$vBuildNumber` ($_androidLocalProperties)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Android Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Android Version change failed!!!');
  } finally {
    if (version != null) _logger.f(_minorTaskDoneLine);
  }
}

Future<void> _setAndroidVersionGradleFile(dynamic version) async {
  try {
    if (version == null) return;
    if ((version is! String) || (!version.toString().contains('+'))) {
      throw _FPVErrors.invalidVersion;
    }

    String vNumber = version.split("+").first;
    String vBuildNumber = version.split("+").last;

    final buildGradleFile = File(_androidAppLevelBuildGradleFilePath);
    if (!await buildGradleFile.exists()) {
      _logger.w(
        'build.gradle file not found at: $_androidAppLevelBuildGradleFilePath',
      );
      return;
    }

    final buildGradleString =await buildGradleFile.readAsString();
    final newPackageIDBuildGradleString = buildGradleString
        .replaceAll(
          RegExp('versionCode (.+)'),
          'versionCode $vBuildNumber',
        )
        .replaceAll(
          RegExp("versionName (.+)"),
          'versionName "$vNumber"',
        );
    await buildGradleFile.writeAsString(newPackageIDBuildGradleString);

    _logger
      ..i('Android Version to: `$vNumber` ($_androidAppLevelBuildGradleFilePath)')
      ..i('Android Build Number to: `$vBuildNumber` ($_androidAppLevelBuildGradleFilePath)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Android Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Android Version change failed!!!');
  } finally {
    if (version != null) _logger.f(_minorTaskDoneLine);
  }
}

Future<void> _removeAndroidVersionGradleFile() async {
  try {
    final buildGradleFile = File(_androidAppLevelBuildGradleFilePath);
    if (!await buildGradleFile.exists()) {
      _logger.w(
        'build.gradle file not found at: $_androidAppLevelBuildGradleFilePath',
      );
      return;
    }

    final buildGradleString = await buildGradleFile.readAsString();
    final newPackageIDBuildGradleString = buildGradleString
        .replaceAll(
          RegExp('versionCode (.+)'),
          'versionCode flutterVersionCode.toInteger()',
        )
        .replaceAll(
          RegExp("versionName (.+)"),
          'versionName flutterVersionName',
        );
    await buildGradleFile.writeAsString(newPackageIDBuildGradleString);

    _logger
      ..i('Android Version removed by FPV ($_androidAppLevelBuildGradleFilePath)')
      ..i('Android Build removed by FPV ($_androidAppLevelBuildGradleFilePath)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Android Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Android Version change failed!!!');
  } finally {
     _logger.f(_minorTaskDoneLine);
  }
}
