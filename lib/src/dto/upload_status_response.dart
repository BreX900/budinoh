import 'package:googleapis/firebaseappdistribution/v1.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_status_response.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum UploadResult {
  releaseUpdated,
  releaseUnmodified,
  releaseCreated,
}

// See: https://github.com/fastlane/fastlane-plugin-firebase_app_distribution/blob/master/lib/fastlane/plugin/firebase_app_distribution/helper/upload_status_response.rb#L1
@JsonSerializable(fieldRename: FieldRename.none)
class UploadStatusResponse {
  final UploadResult result;
  final GoogleFirebaseAppdistroV1Release release;

  const UploadStatusResponse({
    required this.result,
    required this.release,
  });

  factory UploadStatusResponse.fromJson(Map<String, dynamic> map) =>
      _$UploadStatusResponseFromJson(map);
  Map<String, dynamic> toJson() => _$UploadStatusResponseToJson(this);
}
