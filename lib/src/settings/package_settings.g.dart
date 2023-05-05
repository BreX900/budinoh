// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildGroupSettings _$BuildGroupSettingsFromJson(Map json) => $checkedCreate(
      'BuildGroupSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['apk', 'ipa', 'appbundle'],
        );
        final val = BuildGroupSettings(
          apk: $checkedConvert(
              'apk', (v) => v == null ? null : ApkSettings.fromJson(v as Map)),
          ipa: $checkedConvert(
              'ipa', (v) => v == null ? null : IpaSettings.fromJson(v as Map)),
          appbundle: $checkedConvert('appbundle',
              (v) => v == null ? null : AppBundleSettings.fromJson(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$BuildGroupSettingsToJson(BuildGroupSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('apk', instance.apk);
  writeNotNull('ipa', instance.ipa);
  writeNotNull('appbundle', instance.appbundle);
  return val;
}

PackageSettings _$PackageSettingsFromJson(Map json) => $checkedCreate(
      'PackageSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['env', 'firebase_api_credentials', 'builds'],
        );
        final val = PackageSettings(
          env: $checkedConvert(
              'env', (v) => v == null ? null : EnvSettings.fromJson(v as Map)),
          firebaseApiCredentials:
              $checkedConvert('firebase_api_credentials', (v) => v as String?),
          builds: $checkedConvert(
              'builds',
              (v) => (v as Map).map(
                    (k, e) => MapEntry(
                        k as String, BuildGroupSettings.fromJson(e as Map)),
                  )),
        );
        return val;
      },
      fieldKeyMap: const {'firebaseApiCredentials': 'firebase_api_credentials'},
    );

Map<String, dynamic> _$PackageSettingsToJson(PackageSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('env', instance.env);
  writeNotNull('firebase_api_credentials', instance.firebaseApiCredentials);
  val['builds'] = instance.builds;
  return val;
}

GeneralSettings _$GeneralSettingsFromJson(Map json) => $checkedCreate(
      'GeneralSettings',
      json,
      ($checkedConvert) {
        final val = GeneralSettings(
          budinoh: $checkedConvert(
              'budinoh', (v) => PackageSettings.fromJson(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$GeneralSettingsToJson(GeneralSettings instance) =>
    <String, dynamic>{
      'budinoh': instance.budinoh,
    };
