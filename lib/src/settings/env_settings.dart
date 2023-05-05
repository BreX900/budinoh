import 'package:budinoh/src/settings_serializable.dart';
import 'package:budinoh/src/stringify.dart';

part 'env_settings.g.dart';

@SettingsSerializable()
class EnvSettings with Stringify {
  final String? directory;
  final String? prefix;
  final String? suffix;

  const EnvSettings({
    this.directory,
    this.prefix,
    this.suffix,
  });

  factory EnvSettings.fromJson(Map<dynamic, dynamic> map) => _$EnvSettingsFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$EnvSettingsToJson(this);
}
