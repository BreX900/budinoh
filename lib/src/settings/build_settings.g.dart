// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApkSettings _$ApkSettingsFromJson(Map json) => $checkedCreate(
      'ApkSettings',
      json,
      ($checkedConvert) {
        final val = ApkSettings(
          firebase: $checkedConvert('firebase',
              (v) => v == null ? null : FirebaseSettings.fromJson(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ApkSettingsToJson(ApkSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('firebase', instance.firebase);
  return val;
}

AppBundleSettings _$AppBundleSettingsFromJson(Map json) => $checkedCreate(
      'AppBundleSettings',
      json,
      ($checkedConvert) {
        final val = AppBundleSettings(
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

  writeNotNull('google_store', instance.googleStore);
  return val;
}

IpaSettings _$IpaSettingsFromJson(Map json) => $checkedCreate(
      'IpaSettings',
      json,
      ($checkedConvert) {
        final val = IpaSettings(
          firebase: $checkedConvert('firebase',
              (v) => v == null ? null : FirebaseSettings.fromJson(v as Map)),
          appleStore: $checkedConvert('apple_store',
              (v) => v == null ? null : AppleStoreSettings.fromJson(v as Map)),
          exportOptions: $checkedConvert('export_options', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'appleStore': 'apple_store',
        'exportOptions': 'export_options'
      },
    );

Map<String, dynamic> _$IpaSettingsToJson(IpaSettings instance) {
  final val = <String, dynamic>{
    'export_options': instance.exportOptions,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('firebase', instance.firebase);
  writeNotNull('apple_store', instance.appleStore);
  return val;
}
