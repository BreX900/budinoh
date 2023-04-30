// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseCliSettings _$FirebaseCliSettingsFromJson(Map json) => $checkedCreate(
      'FirebaseCliSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['app_id', 'groups'],
        );
        final val = FirebaseCliSettings(
          appId: $checkedConvert('app_id', (v) => v as String),
          groups: $checkedConvert(
              'groups',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const <String>[]),
        );
        return val;
      },
      fieldKeyMap: const {'appId': 'app_id'},
    );

Map<String, dynamic> _$FirebaseCliSettingsToJson(
        FirebaseCliSettings instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'groups': instance.groups,
    };

FirebaseApiSettings _$FirebaseApiSettingsFromJson(Map json) => $checkedCreate(
      'FirebaseApiSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['credentials', 'app_id', 'groups'],
        );
        final val = FirebaseApiSettings(
          credentials: $checkedConvert('credentials', (v) => v as String?),
          appId: $checkedConvert('app_id', (v) => v as String),
          groups: $checkedConvert(
              'groups',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const <String>[]),
        );
        return val;
      },
      fieldKeyMap: const {'appId': 'app_id'},
    );

Map<String, dynamic> _$FirebaseApiSettingsToJson(FirebaseApiSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('credentials', instance.credentials);
  val['app_id'] = instance.appId;
  val['groups'] = instance.groups;
  return val;
}

AppleStoreAppSettings _$AppleStoreAppSettingsFromJson(Map json) =>
    $checkedCreate(
      'AppleStoreAppSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['api_issuer', 'api_key_id', 'api_key'],
        );
        final val = AppleStoreAppSettings(
          apiKeyId: $checkedConvert('api_key_id', (v) => v as String),
          apiIssuer: $checkedConvert('api_issuer', (v) => v as String),
          apiKey: $checkedConvert('api_key', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'apiKeyId': 'api_key_id',
        'apiIssuer': 'api_issuer',
        'apiKey': 'api_key'
      },
    );

Map<String, dynamic> _$AppleStoreAppSettingsToJson(
    AppleStoreAppSettings instance) {
  final val = <String, dynamic>{
    'api_issuer': instance.apiIssuer,
    'api_key_id': instance.apiKeyId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('api_key', instance.apiKey);
  return val;
}

GoogleStoreSettings _$GoogleStoreSettingsFromJson(Map json) => $checkedCreate(
      'GoogleStoreSettings',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['credentials', 'package_name'],
        );
        final val = GoogleStoreSettings(
          credentials: $checkedConvert('credentials', (v) => v as String?),
          packageName: $checkedConvert('package_name', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'packageName': 'package_name'},
    );

Map<String, dynamic> _$GoogleStoreSettingsToJson(GoogleStoreSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('credentials', instance.credentials);
  val['package_name'] = instance.packageName;
  return val;
}
