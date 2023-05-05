// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadStatusResponse _$UploadStatusResponseFromJson(Map json) => $checkedCreate(
      'UploadStatusResponse',
      json,
      ($checkedConvert) {
        final val = UploadStatusResponse(
          result: $checkedConvert(
              'result', (v) => $enumDecode(_$UploadResultEnumMap, v)),
          release: $checkedConvert('release',
              (v) => GoogleFirebaseAppdistroV1Release.fromJson(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$UploadStatusResponseToJson(
        UploadStatusResponse instance) =>
    <String, dynamic>{
      'result': _$UploadResultEnumMap[instance.result]!,
      'release': instance.release,
    };

const _$UploadResultEnumMap = {
  UploadResult.releaseUpdated: 'RELEASE_UPDATED',
  UploadResult.releaseUnmodified: 'RELEASE_UNMODIFIED',
  UploadResult.releaseCreated: 'RELEASE_CREATED',
};
