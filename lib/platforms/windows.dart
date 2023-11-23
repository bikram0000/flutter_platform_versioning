part of flutter_platform_versioning;

Future<void> _setWindowsConfigurations(dynamic windowsConfig) async {
  try {
    if (windowsConfig == null) return;
    if (windowsConfig is! Map && windowsConfig is! String) {
      throw _FPVErrors.invalidWindowsConfig;
    }

    String version;
    if (windowsConfig is String) {
      version = windowsConfig;
    } else {
      final windowsConfigMap = Map<String, dynamic>.from(windowsConfig);
      version = windowsConfigMap[_version];
    }
    await _setWindowsVersion(version);
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Skipping Windows configuration!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Skipping Windows configuration!!!');
  } finally {
    if (windowsConfig != null) _logger.w(_majorTaskDoneLine);
  }
}

Future<void> _setWindowsVersion(dynamic version) async {
  try {
    if (version == null) return;
    if ((version is! String) || (!version.toString().contains('+'))) {
      throw _FPVErrors.invalidVersion;
    }

    String vNumber = version.split("+").first;
    final runnerFile = File(_windowsRunnerFilePath);
    if (!await runnerFile.exists()) {
      throw _FPVErrors.windowsRunnerNotFound;
    }
    final runnerString = await runnerFile.readAsString();

    String newProductDetailsRunnerString = runnerString;

    //if already have
    newProductDetailsRunnerString = runnerString
        .replaceAll(
          RegExp('#define VERSION_AS_NUMBER\\s+(\\d+,\\d+,\\d+)'),
          '#define VERSION_AS_NUMBER ${vNumber.replaceAll('.', ',')}',
        )
        .replaceAll(
          RegExp('#define VERSION_AS_STRING "(.*?)"'),
          '#define VERSION_AS_STRING "$vNumber"',
        );

    newProductDetailsRunnerString = newProductDetailsRunnerString
        .replaceAll('VS_VERSION_INFO VERSIONINFO', """
//
// Generated from the FPV.
//
#define VERSION_AS_NUMBER ${vNumber.replaceAll('.', ',')}
#define VERSION_AS_STRING "$vNumber"
VS_VERSION_INFO VERSIONINFO""");

    await runnerFile.writeAsString(newProductDetailsRunnerString);

    _logger.i('Windows application version set to: `$vNumber` (Runner.rc)');
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Windows Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Windows Version change failed!!!');
  } finally {
    if (version != null) _logger.f(_minorTaskDoneLine);
  }
}

Future<void> _removeWindowsVersion() async {
  try {
    final runnerFile = File(_windowsRunnerFilePath);
    if (!await runnerFile.exists()) {
      throw _FPVErrors.windowsRunnerNotFound;
    }
    final runnerString = await runnerFile.readAsString();

    String newProductDetailsRunnerString = runnerString;
    if (runnerString.contains('Generated from the FPV')) {
      //if already have
      newProductDetailsRunnerString = runnerString.replaceAll(
        RegExp("""
//
// Generated from the FPV.
//
#define VERSION_AS_NUMBER (.+)
#define VERSION_AS_STRING "(.*?)"
VS_VERSION_INFO VERSIONINFO"""),
        'VS_VERSION_INFO VERSIONINFO',
      );
      await runnerFile.writeAsString(newProductDetailsRunnerString);

      _logger.i('Windows application version removed by FPV (Runner.rc)');
    }
  } on _FPVException catch (e) {
    _logger
      ..e('${e.message}ERR Code: ${e.code}')
      ..e('Windows Version change failed!!!');
  } catch (e) {
    _logger
      ..w(e.toString())
      ..e('ERR Code: 255')
      ..e('Windows Version change failed!!!');
  } finally {
    _logger.f(_minorTaskDoneLine);
  }
}
