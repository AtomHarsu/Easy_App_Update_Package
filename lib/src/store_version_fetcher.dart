import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Result from the store version fetch.
class StoreVersionResult {
  final String version;

  /// Numeric App Store track ID (iOS only). Null on Android.
  final String? trackId;

  const StoreVersionResult({required this.version, this.trackId});
}

/// Fetches the latest app version from the Play Store or App Store.
class StoreVersionFetcher {
  const StoreVersionFetcher._();

  /// Fetches latest version from the appropriate store based on platform.
  /// Throws on network/parse errors so callers can handle failures.
  static Future<StoreVersionResult?> fetchStoreVersion({
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
  static Future<StoreVersionResult?> _fetchPlayStoreVersion(String appId) async {
    final uri = Uri.parse('https://play.google.com/store/apps/details?id=$appId&hl=en');
    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final matches = RegExp(r'\]\]\],"(\d+\.\d+\.[\d.]+)"').allMatches(response.body);
    if (matches.isEmpty) return null;

    final versions = matches.map((m) => m.group(1)!).toList();
    versions.sort(_compareVersions);
    return StoreVersionResult(version: versions.last);
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

  /// Uses the iTunes Lookup API to get the current App Store version and trackId.
  /// Throws on network/parse errors.
  static Future<StoreVersionResult?> _fetchAppStoreVersion(String appId, String country) async {
    final uri = Uri.parse('https://itunes.apple.com/lookup?bundleId=$appId&country=$country');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw HttpException('iTunes lookup failed with status ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = json['results'] as List;
    if (results.isEmpty) return null;

    final first = results.first as Map<String, dynamic>;
    final version = first['version'] as String?;
    final trackId = first['trackId']?.toString();
    if (version == null) return null;

    return StoreVersionResult(version: version, trackId: trackId);
  }
}
