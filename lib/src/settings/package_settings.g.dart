// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildGroupSettings _$BuildGroupSettingsFromJson(Map json) => $checkedCreate(
      'BuildGroupSettings',
      json,
      ($checkedConvert) {
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
        final val = PackageSettings(
          defineEnv: $checkedConvert('define_env', (v) => v as String?),
          builds: $checkedConvert(
              'builds',
              (v) => (v as Map).map(
                    (k, e) => MapEntry(
                        k as String, BuildGroupSettings.fromJson(e as Map)),
                  )),
        );
        return val;
      },
      fieldKeyMap: const {'defineEnv': 'define_env'},
    );

Map<String, dynamic> _$PackageSettingsToJson(PackageSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('define_env', instance.defineEnv);
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
