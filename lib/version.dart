/// Hottest Hundred Heardle
/// version.dart
///
/// Retrieves the latest commit hash
///
/// Authors: Joshua Linehan
library;

/// Retrieves the latest commit hash. Only works on CI/CD deployment: returns
/// "debug" otherwise
class Version {
  static const String commitHash =
      String.fromEnvironment('COMMIT_HASH', defaultValue: 'debug');
}
