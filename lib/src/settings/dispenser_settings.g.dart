// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispenser_settings.dart';

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

DispenserSettings _$DispenserSettingsFromJson(Map json) => $checkedCreate(
      'DispenserSettings',
      json,
      ($checkedConvert) {
        final val = DispenserSettings(
          builds: $checkedConvert(
              'builds',
              (v) => (v as Map).map(
                    (k, e) => MapEntry(
                        k as String, BuildGroupSettings.fromJson(e as Map)),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$DispenserSettingsToJson(DispenserSettings instance) =>
    <String, dynamic>{
      'builds': instance.builds,
    };
