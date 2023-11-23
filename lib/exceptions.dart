part of flutter_platform_versioning;

class _FPVException implements Exception {
  const _FPVException(this.message, this.code);

  final String message;
  final int code;
}

class _FPVErrors {
  static const filesNotFound = _FPVException(
    _filesNotFoundMessage,
    1,
  );

  static const configNotFound = _FPVException(
    _configNotFoundMessage,
    2,
  );

  static const invalidConfig = _FPVException(
    _invalidConfigMessage,
    3,
  );

  static const invalidAndroidConfig = _FPVException(
    _invalidAndroidConfigMessage,
    4,
  );

  static const invalidVersion = _FPVException(
    _invalidVersionMessage,
    5,
  );

  static const androidLocalPropertiesNotFound = _FPVException(
    _androidLocalPropertiesNotFoundMessage,
    6,
  );

  static const invalidIOSConfig = _FPVException(
    _invalidIOSConfigMessage,
    8,
  );

  static const iosInfoPlistNotFound = _FPVException(
    _iosInfoPlistNotFoundMessage,
    9,
  );

  static const macOSInfoPlistNotFound = _FPVException(
    _iosInfoPlistNotFoundMessage,
    10,
  );

  static const iosProjectFileNotFound = _FPVException(
    _iosProjectFileNotFoundMessage,
    11,
  );

  static const invalidWindowsConfig = _FPVException(
    _invalidWindowsConfigMessage,
    18,
  );

  static const windowsRunnerNotFound = _FPVException(
    _windowsRunnerNotFoundMessage,
    21,
  );

  static const invalidMacOSConfig = _FPVException(
    _invalidMacOSConfigMessage,
    24,
  );
}
