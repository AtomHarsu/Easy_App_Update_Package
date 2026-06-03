import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Fetches the latest app version from the Play Store or App Store.
class StoreVersionFetcher {
  const StoreVersionFetcher._();

  /// Fetches latest version from the appropriate store based on platform.
  static Future<String?> fetchStoreVersion({
    required String appId,
    String country = 'us',
  }) async {
    if (Platform.isAndroid) {
      return _fetchPlayStoreVersion(appId);
    } else if (Platform.isIOS) {
      return _fetchAppStoreVersion(appId, country);
    }
    return null;
  }

  /// Scrapes the Google Play Store page for the current version.
  static Future<String?> _fetchPlayStoreVersion(String appId) async {
    try {
      final uri = Uri.parse('https://play.google.com/store/apps/details?id=$appId&hl=en');
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      // Version appears in pattern: ]]],"x.x.x",null
      final matches = RegExp(r'\]\]\],"(\d+\.\d+\.\d+[\d.]*)"').allMatches(response.body);
      if (matches.isEmpty) return null;

      // Return the highest version found.
      final versions = matches.map((m) => m.group(1)!).toList();
      versions.sort(_compareVersions);
      return versions.last;
    } catch (_) {
      return null;
    }
  }

  static int _compareVersions(String a, String b) {
    final aParts = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final bParts = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final length = aParts.length > bParts.length ? aParts.length : bParts.length;
    for (var i = 0; i < length; i++) {
      final av = i < aParts.length ? aParts[i] : 0;
      final bv = i < bParts.length ? bParts[i] : 0;
      if (av != bv) return av.compareTo(bv);
    }
    return 0;
  }

  /// Uses the iTunes Lookup API to get the current App Store version.
  static Future<String?> _fetchAppStoreVersion(String appId, String country) async {
    try {
      final uri = Uri.parse('https://itunes.apple.com/lookup?bundleId=$appId&country=$country');
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List;
      if (results.isEmpty) return null;
      return results.first['version'] as String?;
    } catch (_) {
      return null;
    }
  }
}
