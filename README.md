# Easy App Update

A lightweight Flutter package that notifies users when a new app version is available on the **Google Play Store** or **Apple App Store** — from a single codebase.

## Features

- Scrapes Play Store & uses iTunes Lookup API to fetch latest version
- Auto-detects current installed version via `package_info_plus`
- Semantic version comparison
- Customizable update dialog UI
- **Force update** (non-dismissible) and **soft update** (dismissible) modes
- No native SDKs required — pure Dart HTTP requests

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_app_update: ^0.0.1
```

Ensure your Android app has internet permission in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Usage

### Basic (soft update)

```dart
import 'package:easy_app_update/easy_app_update.dart';

// Call after your app's main widget has built
EasyAppUpdate.checkForUpdate(context);
```

### Force update

```dart
EasyAppUpdate.checkForUpdate(
  context,
  config: UpdateConfig(updateMode: UpdateMode.force),
);
```

### Custom dialog

```dart
EasyAppUpdate.checkForUpdate(
  context,
  config: UpdateConfig(
    dialogBuilder: (context, storeVersion, openStore, dismiss) {
      return AlertDialog(
        title: Text('New version $storeVersion!'),
        actions: [
          if (dismiss != null) TextButton(onPressed: dismiss, child: Text('Skip')),
          ElevatedButton(onPressed: openStore, child: Text('Update')),
        ],
      );
    },
  ),
);
```

### Override app ID

```dart
EasyAppUpdate.checkForUpdate(
  context,
  config: UpdateConfig(appId: 'com.example.myapp'),
);
```

## How It Works

| Platform | Method |
|----------|--------|
| Android  | Scrapes the Google Play Store listing page |
| iOS      | Uses the iTunes Lookup API |

The fetched store version is compared against the installed version. If a newer version exists, the update dialog is displayed.

## Additional Information

- Requires internet access on the user's device
- For iOS, the `country` parameter defaults to `"us"`. Set it to match your primary App Store region.
- Play Store scraping may need updates if Google changes their page structure — contributions welcome!
