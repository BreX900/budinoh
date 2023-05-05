import 'package:json_annotation/json_annotation.dart';

export 'package:json_annotation/json_annotation.dart' show $checkKeys, $checkedCreate;

class SettingsSerializable extends JsonSerializable {
  const SettingsSerializable()
      : super(
          disallowUnrecognizedKeys: true,
        );
}
