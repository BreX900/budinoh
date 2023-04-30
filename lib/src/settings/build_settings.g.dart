// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApkSettings _$ApkSettingsFromJson(Map json) => $checkedCreate(
      'ApkSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['args', 'firebase_cli', 'firebase_api'],
        );
        final val = ApkSettings(
          args: $checkedConvert('args', (v) => v as String?),
          firebaseCli: $checkedConvert('firebase_cli',
              (v) => v == null ? null : FirebaseCliSettings.fromJson(v as Map)),
          firebaseApi: $checkedConvert('firebase_api',
              (v) => v == null ? null : FirebaseApiSettings.fromJson(v as Map)),
        );
        return val;
      },
      fieldKeyMap: const {
        'firebaseCli': 'firebase_cli',
        'firebaseApi': 'firebase_api'
      },
    );

Map<String, dynamic> _$ApkSettingsToJson(ApkSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('args', instance.args);
  writeNotNull('firebase_cli', instance.firebaseCli);
  writeNotNull('firebase_api', instance.firebaseApi);
  return val;
}

AppBundleSettings _$AppBundleSettingsFromJson(Map json) => $checkedCreate(
      'AppBundleSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['args', 'google_store'],
        );
        final val = AppBundleSettings(
          args: $checkedConvert('args', (v) => v as String?),
          googleStore: $checkedConvert('google_store',
              (v) => v == null ? null : GoogleStoreSettings.fromJson(v as Map)),
        );
        return val;
      },
      fieldKeyMap: const {'googleStore': 'google_store'},
    );

Map<String, dynamic> _$AppBundleSettingsToJson(AppBundleSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('args', instance.args);
  writeNotNull('google_store', instance.googleStore);
  return val;
}

IpaSettings _$IpaSettingsFromJson(Map json) => $checkedCreate(
      'IpaSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'args',
            'export_options',
            'firebase_cli',
            'firebase_api',
            'apple_store_app'
          ],
        );
        final val = IpaSettings(
          args: $checkedConvert('args', (v) => v as String?),
          exportOptions: $checkedConvert('export_options', (v) => v as String?),
          firebaseCli: $checkedConvert('firebase_cli',
              (v) => v == null ? null : FirebaseCliSettings.fromJson(v as Map)),
          firebaseApi: $checkedConvert('firebase_api',
              (v) => v == null ? null : FirebaseApiSettings.fromJson(v as Map)),
          appleStoreApp: $checkedConvert(
              'apple_store_app',
              (v) =>
                  v == null ? null : AppleStoreAppSettings.fromJson(v as Map)),
        );
        return val;
      },
      fieldKeyMap: const {
        'exportOptions': 'export_options',
        'firebaseCli': 'firebase_cli',
        'firebaseApi': 'firebase_api',
        'appleStoreApp': 'apple_store_app'
      },
    );

Map<String, dynamic> _$IpaSettingsToJson(IpaSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('args', instance.args);
  writeNotNull('export_options', instance.exportOptions);
  writeNotNull('firebase_cli', instance.firebaseCli);
  writeNotNull('firebase_api', instance.firebaseApi);
  writeNotNull('apple_store_app', instance.appleStoreApp);
  return val;
}
