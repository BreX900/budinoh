// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvSettings _$EnvSettingsFromJson(Map json) => $checkedCreate(
      'EnvSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['directory', 'prefix', 'suffix'],
        );
        final val = EnvSettings(
          directory: $checkedConvert('directory', (v) => v as String?),
          prefix: $checkedConvert('prefix', (v) => v as String?),
          suffix: $checkedConvert('suffix', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$EnvSettingsToJson(EnvSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('directory', instance.directory);
  writeNotNull('prefix', instance.prefix);
  writeNotNull('suffix', instance.suffix);
  return val;
}
