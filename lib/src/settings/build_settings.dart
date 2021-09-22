import 'package:budinoh/src/settings/distribution_settings.dart';
import 'package:budinoh/src/stringify.dart';
import 'package:json_annotation/json_annotation.dart';

part 'build_settings.g.dart';

abstract class BuildSettings with Stringify {
  String get name;

  const BuildSettings();

  FirebaseSettings? get firebase => null;
  GoogleStoreSettings? get googleStore => null;
  AppleStoreSettings? get appleStore => null;
}

@JsonSerializable()
class ApkSettings extends BuildSettings {
  @override
  final FirebaseSettings? firebase;

  const ApkSettings({
    required this.firebase,
  }) : super();

  @override
  String get name => 'Apk';

  factory ApkSettings.fromJson(Map<dynamic, dynamic> map) => _$ApkSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$ApkSettingsToJson(this);
}

@JsonSerializable()
class AppBundleSettings extends BuildSettings {
  @override
  final GoogleStoreSettings? googleStore;

  const AppBundleSettings({
    required this.googleStore,
  }) : super();

  @override
  String get name => 'AppBundle';

  factory AppBundleSettings.fromJson(Map<dynamic, dynamic> map) => _$AppBundleSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$AppBundleSettingsToJson(this);
}

@JsonSerializable()
class IpaSettings extends BuildSettings {
  final String exportOptions;
  @override
  final FirebaseSettings? firebase;
  @override
  final AppleStoreSettings? appleStore;

  const IpaSettings({
    required this.firebase,
    required this.appleStore,
    required this.exportOptions,
  }) : super();

  @override
  String get name => 'Ipa';

  factory IpaSettings.fromJson(Map<dynamic, dynamic> map) => _$IpaSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$IpaSettingsToJson(this);
}
