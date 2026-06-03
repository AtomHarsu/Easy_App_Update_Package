import 'package:flutter/material.dart';

/// Update mode: force (non-dismissible) or soft (dismissible).
enum UpdateMode { force, soft }

/// Configuration for the update checker.
class UpdateConfig {
  /// The app's bundle ID (iOS) / package name (Android).
  /// If null, it will be auto-detected via package_info_plus.
  final String? appId;

  /// Numeric App Store ID for iOS (e.g. "6758769110").
  /// If null, it will be fetched from the iTunes Lookup API.
  final String? iosStoreId;

  /// The country code for the App Store lookup (default: "us").
  final String country;

  /// Update mode: force blocks usage, soft allows dismissal.
  final UpdateMode updateMode;

  /// Custom dialog builder. If null, a default dialog is shown.
  final Widget Function(BuildContext context, String storeVersion, VoidCallback openStore, VoidCallback? dismiss)?
      dialogBuilder;

  const UpdateConfig({
    this.appId,
    this.iosStoreId,
    this.country = 'us',
    this.updateMode = UpdateMode.soft,
    this.dialogBuilder,
  });
}
