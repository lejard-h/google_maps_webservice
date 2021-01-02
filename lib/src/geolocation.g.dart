// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeolocationError _$GeolocationErrorFromJson(Map<String, dynamic> json) {
  return GeolocationError(
    domain: json['domain'] as String,
    reason: json['reason'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$GeolocationErrorToJson(GeolocationError instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'reason': instance.reason,
      'message': instance.message,
    };

GeolocationErrorResponse _$GeolocationErrorResponseFromJson(
    Map<String, dynamic> json) {
  return GeolocationErrorResponse(
    errors: (json['errors'] as List<dynamic>?)
            ?.map((e) => GeolocationError.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    code: json['code'] as int,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$GeolocationErrorResponseToJson(
        GeolocationErrorResponse instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'code': instance.code,
      'message': instance.message,
    };

GeolocationResponse _$GeolocationResponseFromJson(Map<String, dynamic> json) {
  return GeolocationResponse(
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    accuracy: json['accuracy'] as num?,
    error: json['error'] == null
        ? null
        : GeolocationErrorResponse.fromJson(
            json['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeolocationResponseToJson(
        GeolocationResponse instance) =>
    <String, dynamic>{
      'location': instance.location,
      'accuracy': instance.accuracy,
      'error': instance.error,
    };

CellTower _$CellTowerFromJson(Map<String, dynamic> json) {
  return CellTower(
    cellId: json['cell_id'] as num,
    locationAreaCode: json['location_area_code'] as num,
    mobileCountryCode: json['mobile_country_code'] as num,
    mobileNetworkCode: json['mobile_network_code'] as num,
    timingAdvance: json['timing_advance'] as num?,
    age: json['age'] as num?,
    signalStrength: json['signal_strength'] as num?,
  );
}

Map<String, dynamic> _$CellTowerToJson(CellTower instance) => <String, dynamic>{
      'age': instance.age,
      'signal_strength': instance.signalStrength,
      'cell_id': instance.cellId,
      'location_area_code': instance.locationAreaCode,
      'mobile_country_code': instance.mobileCountryCode,
      'mobile_network_code': instance.mobileNetworkCode,
      'timing_advance': instance.timingAdvance,
    };

WifiAccessPoint _$WifiAccessPointFromJson(Map<String, dynamic> json) {
  return WifiAccessPoint(
    age: json['age'] as num?,
    signalStrength: json['signal_strength'] as num?,
    macAddress: json['mac_address'] as String?,
    channel: json['channel'],
    signalToNoiseRatio: json['signal_to_noise_ratio'] as num?,
  );
}

Map<String, dynamic> _$WifiAccessPointToJson(WifiAccessPoint instance) =>
    <String, dynamic>{
      'age': instance.age,
      'signal_strength': instance.signalStrength,
      'mac_address': instance.macAddress,
      'channel': instance.channel,
      'signal_to_noise_ratio': instance.signalToNoiseRatio,
    };
