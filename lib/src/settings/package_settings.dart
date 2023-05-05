import 'package:budinoh/budinoh.dart';
import 'package:budinoh/src/settings_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_settings.g.dart';

@SettingsSerializable()
class BuildGroupSettings with Stringify {
  final ApkSettings? apk;
  final IpaSettings? ipa;
  final AppBundleSettings? appbundle;

  List<BuildSettings> getBuilds({
    bool apk = true,
    bool appbundle = true,
    bool ipa = true,
  }) {
    return [
      if (apk && this.apk != null) this.apk!,
      if (appbundle && this.appbundle != null) this.appbundle!,
      if (ipa && this.ipa != null) this.ipa!,
    ];
  }

  const BuildGroupSettings({
    this.apk,
    this.ipa,
    this.appbundle,
  });

  factory BuildGroupSettings.fromJson(Map<dynamic, dynamic> map) {
    return _$BuildGroupSettingsFromJson(map.map((key, value) => MapEntry(key, value ?? {})));
  }
  @override
  Map<String, dynamic> toJson() => _$BuildGroupSettingsToJson(this);
}

@SettingsSerializable()
class PackageSettings with Stringify {
  final EnvSettings? env;

  final String? firebaseApiCredentials;

  final Map<String, BuildGroupSettings> builds;

  const PackageSettings({
    this.env,
    this.firebaseApiCredentials,
    required this.builds,
  });

  static PackageSettings fromYaml(Map map) => GeneralSettings.fromJson(map).budinoh;

  factory PackageSettings.fromJson(Map<dynamic, dynamic> map) => _$PackageSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$PackageSettingsToJson(this);
}

@JsonSerializable()
class GeneralSettings with Stringify {
  final PackageSettings budinoh;

  const GeneralSettings({required this.budinoh});

  factory GeneralSettings.fromJson(Map<dynamic, dynamic> map) => _$GeneralSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$GeneralSettingsToJson(this);
}
