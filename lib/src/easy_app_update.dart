import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models.dart';
import 'store_version_fetcher.dart';
import 'update_dialog.dart';
import 'version_comparator.dart';

/// Main class to check for updates and show the update prompt.
class EasyAppUpdate {
  const EasyAppUpdate._();

  /// Checks for an update and shows a dialog if one is available.
  /// Returns `true` if an update was detected, `false` otherwise.
  /// Throws on network errors so the caller can handle failures.
  static Future<bool> checkForUpdate(
    BuildContext context, {
    UpdateConfig config = const UpdateConfig(),
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appId = config.appId ?? packageInfo.packageName;
    final currentVersion = packageInfo.version;

    final result = await StoreVersionFetcher.fetchStoreVersion(
      appId: appId,
      country: config.country,
    );

    if (result == null) return false;
    if (!VersionComparator.isUpdateAvailable(result.version, currentVersion)) return false;

    if (!context.mounted) return false;

    final storeUrl = _buildStoreUrl(appId, config.iosStoreId ?? result.trackId);

    await showUpdateDialog(
      context: context,
      storeVersion: result.version,
      updateMode: config.updateMode,
      openStore: () => launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication),
      dialogBuilder: config.dialogBuilder,
    );

    return true;
  }

  static String _buildStoreUrl(String appId, String? iosTrackId) {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=$appId';
    }
    // iOS: use numeric trackId for correct URL
    if (iosTrackId != null) {
      return 'https://apps.apple.com/app/id$iosTrackId';
    }
    // Fallback (shouldn't happen if iTunes API returned results)
    return 'https://apps.apple.com/app/id$appId';
  }
}
