import 'package:budinoh/src/settings/distribution_settings.dart';
import 'package:budinoh/src/settings_serializable.dart';
import 'package:budinoh/src/stringify.dart';

part 'build_settings.g.dart';

abstract class BuildSettings with Stringify {
  final String? args;
  String get type;

  const BuildSettings({
    required this.args,
  });

  FirebaseCliSettings? get firebaseCli => null;
  FirebaseApiSettings? get firebaseApi => null;
  GoogleStoreSettings? get googleStore => null;
  AppleStoreAppSettings? get appleStoreApp => null;
}

@SettingsSerializable()
class ApkSettings extends BuildSettings {
  @override
  final FirebaseCliSettings? firebaseCli;
  @override
  final FirebaseApiSettings? firebaseApi;

  const ApkSettings({
    required super.args,
    required this.firebaseCli,
    required this.firebaseApi,
  });

  @override
  String get type => 'Apk';

  factory ApkSettings.fromJson(Map<dynamic, dynamic> map) => _$ApkSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$ApkSettingsToJson(this);
}

@SettingsSerializable()
class AppBundleSettings extends BuildSettings {
  @override
  final GoogleStoreSettings? googleStore;

  const AppBundleSettings({
    required super.args,
    required this.googleStore,
  });

  @override
  String get type => 'AppBundle';

  factory AppBundleSettings.fromJson(Map<dynamic, dynamic> map) => _$AppBundleSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$AppBundleSettingsToJson(this);
}

@SettingsSerializable()
class IpaSettings extends BuildSettings {
  final String? exportOptions;
  @override
  final FirebaseCliSettings? firebaseCli;
  @override
  final FirebaseApiSettings? firebaseApi;
  @override
  final AppleStoreAppSettings? appleStoreApp;

  const IpaSettings({
    required super.args,
    required this.exportOptions,
    required this.firebaseCli,
    required this.firebaseApi,
    required this.appleStoreApp,
  });

  @override
  String get type => 'Ipa';

  factory IpaSettings.fromJson(Map<dynamic, dynamic> map) => _$IpaSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$IpaSettingsToJson(this);
}
