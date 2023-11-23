part of flutter_platform_versioning;

const _fpvCommands = '''
╔══════════════════════════════════════════════════════════════╗
║        Flutter Platform Versioning Commands                  ║
║  (Note: Linux and Web versioning not currently supported)    ║
╚══════════════════════════════════════════════════════════════╝
''';

const _successMessage = '''
╔══════════════════════════════════════════════════════════════╗
║    🥳🥳🥳 Done! Now go ahead and build your app 🥳🥳🥳      ║
╚══════════════════════════════════════════════════════════════╝
''';

const _instruction = '''
╔═══════════════════════════════════════════════════════════════════╗
║  🥳🥳🥳 Done! Now check `flutter_platform_versioning.yaml` file,  ║
║  change the version, and run `--update` 🥳🥳🥳                    ║
╚═══════════════════════════════════════════════════════════════════╝
''';


const _filesNotFoundMessage = '''
╔════════════════════════════════════════════════════════════════════════════╗
║   Neither `pubspec.yaml` nor `flutter_platform_versioning.yaml` found!!!   ║
╚════════════════════════════════════════════════════════════════════════════╝
''';

const _successfullyRemoved = '''
╔══════════════════════════════════════════════════════════════════════════════════════════╗
║  `flutter_platform_versioning.yaml` removed you can use version from `pubspec.yaml` Now  ║
╚══════════════════════════════════════════════════════════════════════════════════════════╝
''';

const _configNotFoundMessage = '''
╔════════════════════════════════════════════════════════════╗
║   `flutter_platform_versioning` key not found or NULL!!!   ║
          Please create file using `--init` command
╚════════════════════════════════════════════════════════════╝
''';

const _invalidConfigMessage = '''
╔══════════════════════════════╗
║   Invalid Configuration!!!   ║
╚══════════════════════════════╝
''';

const _invalidAndroidConfigMessage = '''
╔═══════════════════════════════════════╗
║   Invalid Android Configuration!!!.   ║
╚═══════════════════════════════════════╝
''';


const _invalidVersionMessage = '''
╔══════════════════════════════════════════════════════════════════════════════════╗
║   version (Version) must be a String and Contain + for version and build number. ║
╚══════════════════════════════════════════════════════════════════════════════════╝
''';


const _androidLocalPropertiesNotFoundMessage = '''
╔═══════════════════════════════════════════════════════════════╗
║   local.properties not found in `android/`.   ║
╚═══════════════════════════════════════════════════════════════╝
''';


const _invalidIOSConfigMessage = '''
╔═══════════════════════════════════╗
║   Invalid iOS Configuration!!!.   ║
╚═══════════════════════════════════╝
''';

const _iosInfoPlistNotFoundMessage = '''
╔════════════════════════════════════════════╗
║   Info.plist not found in `ios/Runner/`.   ║
╚════════════════════════════════════════════╝
''';

const _iosProjectFileNotFoundMessage = '''
╔═══════════════════════════════════════════════════════════╗
║   project.pbxproj not found in `ios/Runner.xcodeproj/`.   ║
╚═══════════════════════════════════════════════════════════╝
''';

const _invalidWindowsConfigMessage = '''
╔═══════════════════════════════════════╗
║   Invalid Windows Configuration!!!.   ║
╚═══════════════════════════════════════╝
''';

const _windowsRunnerNotFoundMessage = '''
╔═══════════════════════════════════════════════╗
║   Runner.rc not found in `windows/runner/`.   ║
╚═══════════════════════════════════════════════╝
''';

const _invalidMacOSConfigMessage = '''
╔═════════════════════════════════════╗
║   Invalid MacOS Configuration!!!.   ║
╚═════════════════════════════════════╝
''';

