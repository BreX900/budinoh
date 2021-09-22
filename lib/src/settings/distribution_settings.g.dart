// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseSettings _$FirebaseSettingsFromJson(Map json) => $checkedCreate(
      'FirebaseSettings',
      json,
      ($checkedConvert) {
        final val = FirebaseSettings(
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

Map<String, dynamic> _$FirebaseSettingsToJson(FirebaseSettings instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'groups': instance.groups,
    };

AppleStoreSettings _$AppleStoreSettingsFromJson(Map json) => $checkedCreate(
      'AppleStoreSettings',
      json,
      ($checkedConvert) {
        final val = AppleStoreSettings(
          username: $checkedConvert('username', (v) => v as String),
          password: $checkedConvert('password', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AppleStoreSettingsToJson(AppleStoreSettings instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

GoogleStoreSettings _$GoogleStoreSettingsFromJson(Map json) => $checkedCreate(
      'GoogleStoreSettings',
      json,
      ($checkedConvert) {
        final val = GoogleStoreSettings(
          apiKey: $checkedConvert('api_key', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'apiKey': 'api_key'},
    );

Map<String, dynamic> _$GoogleStoreSettingsToJson(
        GoogleStoreSettings instance) =>
    <String, dynamic>{
      'api_key': instance.apiKey,
    };
