import 'package:budinoh/src/settings/build_settings.dart';
import 'package:budinoh/src/stringify.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_settings.g.dart';

@JsonSerializable()
class BuildGroupSettings with Stringify {
  final ApkSettings? apk;
  final IpaSettings? ipa;
  final AppBundleSettings? appbundle;

  List<BuildSettings> get builds => [
        if (apk != null) apk!,
        if (ipa != null) ipa!,
        if (appbundle != null) appbundle!,
      ];

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

@JsonSerializable()
class PackageSettings with Stringify {
  final String? defineEnv;
  final Map<String, BuildGroupSettings> builds;

  const PackageSettings({
    this.defineEnv,
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
