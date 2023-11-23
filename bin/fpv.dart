import 'package:flutter_platform_versioning/flutter_platform_versioning.dart' as flutter_platform_versioning;
import 'package:logger/logger.dart';



/// Command line entry point to configure package details.
///
/// Execute following command to set package details:
/// ```bash
/// flutter pub run package_rename:set
/// ```
void main(List<String> arguments) {
  Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      lineLength: 80,
      methodCount: 0,
      noBoxingByDefault: true,
      printEmojis: false,
    ),
  ).w(
    'This command is deprecated and replaced with "dart run fpv"',
  );
  flutter_platform_versioning.set(arguments);
}
