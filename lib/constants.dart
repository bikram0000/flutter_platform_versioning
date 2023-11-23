part of flutter_platform_versioning;

// ! File Names
// ? Root
const _FPVConfigFileName = 'flutter_platform_versioning.yaml';
const _pubspecFileName = 'pubspec.yaml';

// ? Android
const _buildGradleFileName = 'build.gradle';
const _localProperties = 'local.properties';

// ? iOS and macOS
const _infoPlistFileName = 'Info.plist';


// ? Windows
const _runnerFileName = 'Runner.rc';

// ? iOS & MacOS
const _projectFileName = 'project.pbxproj';

// ! Keys
const _configKey = 'flutter_platform_versioning';
const _version = 'version';


// ! Directory Paths
// ? Android
const _androidAppDirPath = 'android/app';
const _androidAppRoot = 'android';

// ? iOS
const _iosDirPath = 'ios';
const _iosRunnerDirPath = '$_iosDirPath/Runner';
const _iosProjectDirPath = '$_iosDirPath/Runner.xcodeproj';

// ? Windows
const _windowsDirPath = 'windows';
const _windowsRunnerDirPath = '$_windowsDirPath/runner';

// ? MacOS
const _macOSDirPath = 'macos';
const _macOSInfoPlistPath = '$_macOSDirPath/Runner/$_infoPlistFileName';

// ! File Paths
// ? Android
const _androidAppLevelBuildGradleFilePath =
    '$_androidAppDirPath/$_buildGradleFileName';

const _androidLocalProperties = '$_androidAppRoot/$_localProperties';

// ? iOS
const _iosInfoPlistFilePath = '$_iosRunnerDirPath/$_infoPlistFileName';
const _iosProjectFilePath = '$_iosProjectDirPath/$_projectFileName';

// ? Windows
const _windowsRunnerFilePath = '$_windowsRunnerDirPath/$_runnerFileName';

// ! Decorations
const _outputLength = 100;
final _minorTaskDoneLine = '┈' * _outputLength;
final _majorTaskDoneLine = '━' * _outputLength;
