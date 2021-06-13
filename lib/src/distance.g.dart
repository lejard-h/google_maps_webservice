// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistanceResponse _$DistanceResponseFromJson(Map<String, dynamic> json) {
  return DistanceResponse(
    status: json['status'] as String,
    errorMessage: json['error_message'] as String?,
    originAddresses: (json['origin_addresses'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    destinationAddresses: (json['destination_addresses'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    rows: (json['rows'] as List<dynamic>?)
            ?.map((e) => Row.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$DistanceResponseToJson(DistanceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'origin_addresses': instance.originAddresses,
      'destination_addresses': instance.destinationAddresses,
      'rows': instance.rows,
    };

Row _$RowFromJson(Map<String, dynamic> json) {
  return Row(
    elements: (json['elements'] as List<dynamic>?)
            ?.map((e) => Element.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$RowToJson(Row instance) => <String, dynamic>{
      'elements': instance.elements,
    };

Element _$ElementFromJson(Map<String, dynamic> json) {
  return Element(
    distance: json['distance'] == null
        ? null
        : Value.fromJson(json['distance'] as Map<String, dynamic>),
    duration: json['duration'] == null
        ? null
        : Value.fromJson(json['duration'] as Map<String, dynamic>),
    elementStatus: json['element_status'] as String?,
  );
}

Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'element_status': instance.elementStatus,
    };

Value _$ValueFromJson(Map<String, dynamic> json) {
  return Value(
    value: json['value'] as num,
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
    };
