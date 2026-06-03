## 0.0.3

* Fixed iOS store URL using numeric `trackId` from iTunes API instead of bundle ID
* Added `iosStoreId` parameter to `UpdateConfig` for manual override
* Network errors now propagate instead of silently returning null

## 0.0.2

* Lowered Dart SDK constraint to `>=3.0.0 <4.0.0` for broader Flutter compatibility

## 0.0.1

* Initial release
* Version fetching via Play Store scraping and iTunes Lookup API
* Automatic current version detection using package_info_plus
* Semantic version comparison
* In-app update dialog with force and soft update modes
* Customizable dialog UI via builder callback
* Cross-platform support (Android & iOS)
