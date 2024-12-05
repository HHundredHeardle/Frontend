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
  /// length of short commit hash
  static const int _shortHashLength = 7;
  // Full commit hash
  static const String _commitHash =
      String.fromEnvironment('COMMIT_HASH', defaultValue: 'debug');

  /// Returns commit hash trimmed to short length if longer than short length,
  /// otherwise returns full commit hash (i.e. default value)
  static String getCommitHash() {
    return _commitHash.length >= _shortHashLength
        ? _commitHash.substring(0, _shortHashLength)
        : _commitHash;
  }
}
