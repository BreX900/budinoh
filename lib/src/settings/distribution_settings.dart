import 'package:budinoh/src/stringify.dart';
import 'package:json_annotation/json_annotation.dart';

part 'distribution_settings.g.dart';

@JsonSerializable()
class FirebaseSettings with Stringify {
  final String appId;
  final List<String> groups;

  const FirebaseSettings({
    required this.appId,
    this.groups = const <String>[],
  });

  factory FirebaseSettings.fromJson(Map<dynamic, dynamic> map) => _$FirebaseSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$FirebaseSettingsToJson(this);
}

// xcrun altool --upload-app -f <PathToFile>.ipa -u <Username> -p <Password>
@JsonSerializable()
class AppleStoreSettings with Stringify {
  final String username;
  final String password;

  const AppleStoreSettings({
    required this.username,
    required this.password,
  });

  factory AppleStoreSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$AppleStoreSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$AppleStoreSettingsToJson(this);
}

// https://developers.google.com/android-publisher/api-ref/rest/v3/edits/insert
// https://developers.google.com/android-publisher/api-ref/rest/v3/edits.bundles/upload
// https://developers.google.com/android-publisher/api-ref/rest/v3/edits/commit
@JsonSerializable()
class GoogleStoreSettings with Stringify {
  final String apiKey;

  const GoogleStoreSettings({
    required this.apiKey,
  });

  factory GoogleStoreSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$GoogleStoreSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$GoogleStoreSettingsToJson(this);
}
