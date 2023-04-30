import 'package:budinoh/src/settings_serializable.dart';
import 'package:budinoh/src/stringify.dart';

part 'distribution_settings.g.dart';

@SettingsSerializable()
class FirebaseCliSettings with Stringify {
  final String appId;
  final List<String> groups;

  const FirebaseCliSettings({
    required this.appId,
    this.groups = const <String>[],
  });

  factory FirebaseCliSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$FirebaseCliSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$FirebaseCliSettingsToJson(this);
}

@SettingsSerializable()
class FirebaseApiSettings with Stringify {
  final String? credentials;
  final String appId;
  final List<String> groups;

  const FirebaseApiSettings({
    this.credentials,
    required this.appId,
    this.groups = const <String>[],
  });

  factory FirebaseApiSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$FirebaseApiSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$FirebaseApiSettingsToJson(this);
}

@SettingsSerializable()
class AppleStoreAppSettings with Stringify {
  final String apiIssuer;
  final String apiKeyId;

  /// Directory to key or key content
  final String? apiKey;

  const AppleStoreAppSettings({
    required this.apiKeyId,
    required this.apiIssuer,
    this.apiKey,
  });

  factory AppleStoreAppSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$AppleStoreAppSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$AppleStoreAppSettingsToJson(this);
}

@SettingsSerializable()
class GoogleStoreSettings with Stringify {
  final String? credentials;
  final String packageName;

  const GoogleStoreSettings({
    this.credentials,
    required this.packageName,
  });

  factory GoogleStoreSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$GoogleStoreSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$GoogleStoreSettingsToJson(this);
}
