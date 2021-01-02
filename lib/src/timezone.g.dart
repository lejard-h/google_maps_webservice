// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimezoneResponse _$TimezoneResponseFromJson(Map<String, dynamic> json) {
  return TimezoneResponse(
    status: json['status'] as String,
    errorMessage: json['error_message'] as String?,
    dstOffset: json['dstOffset'] as int,
    rawOffset: json['rawOffset'] as int,
    timeZoneId: json['timeZoneId'] as String,
    timeZoneName: json['timeZoneName'] as String,
  );
}

Map<String, dynamic> _$TimezoneResponseToJson(TimezoneResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'dstOffset': instance.dstOffset,
      'rawOffset': instance.rawOffset,
      'timeZoneId': instance.timeZoneId,
      'timeZoneName': instance.timeZoneName,
    };
