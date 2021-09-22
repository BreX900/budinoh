import 'package:budinoh/src/settings/build_settings.dart';
import 'package:budinoh/src/stringify.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dispenser_settings.g.dart';

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
class DispenserSettings with Stringify {
  final Map<String, BuildGroupSettings> builds;

  const DispenserSettings({
    required this.builds,
  });

  factory DispenserSettings.fromJson(Map<dynamic, dynamic> map) => _$DispenserSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$DispenserSettingsToJson(this);
}
