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
  static Future<bool> checkForUpdate(
    BuildContext context, {
    UpdateConfig config = const UpdateConfig(),
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appId = config.appId ?? packageInfo.packageName;
    final currentVersion = packageInfo.version;

    final storeVersion = await StoreVersionFetcher.fetchStoreVersion(
      appId: appId,
      country: config.country,
    );

    if (storeVersion == null) return false;
    if (!VersionComparator.isUpdateAvailable(storeVersion, currentVersion)) return false;

    if (!context.mounted) return false;

    await showUpdateDialog(
      context: context,
      storeVersion: storeVersion,
      updateMode: config.updateMode,
      openStore: () => _openStoreListing(appId),
      dialogBuilder: config.dialogBuilder,
    );

    return true;
  }

  static Future<void> _openStoreListing(String appId) async {
    final Uri url;
    if (Platform.isAndroid) {
      url = Uri.parse('https://play.google.com/store/apps/details?id=$appId');
    } else {
      url = Uri.parse('https://apps.apple.com/app/id$appId');
    }
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
