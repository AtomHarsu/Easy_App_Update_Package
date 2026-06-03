/// Compares two semantic version strings.
class VersionComparator {
  const VersionComparator._();

  /// Returns true if [storeVersion] is greater than [currentVersion].
  static bool isUpdateAvailable(String storeVersion, String currentVersion) {
    final storeParts = storeVersion.split('.').map(int.tryParse).toList();
    final currentParts = currentVersion.split('.').map(int.tryParse).toList();

    final length = storeParts.length > currentParts.length ? storeParts.length : currentParts.length;

    for (var i = 0; i < length; i++) {
      final s = i < storeParts.length ? (storeParts[i] ?? 0) : 0;
      final c = i < currentParts.length ? (currentParts[i] ?? 0) : 0;
      if (s > c) return true;
      if (s < c) return false;
    }
    return false;
  }
}
