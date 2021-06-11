import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import 'core.dart';
import 'utils.dart';

part 'geolocation.g.dart';

// geolocation api does not use maps.geolocation
const _baseUrl = 'https://www.googleapis.com';
const _geolocationUrl = '/geolocation/v1/geolocate';

//// https://developers.google.com/maps/documentation/geolocation/intro
class GoogleMapsGeolocation extends GoogleWebService {
  GoogleMapsGeolocation({
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl ?? _baseUrl,
          apiPath: _geolocationUrl,
          httpClient: httpClient,
        );

  Future<GeolocationResponse> getGeolocation({
    int? homeMobileCountryCode,
    int? homeMobileNetworkCode,
    String? radioType,
    String? carrier,
    bool? considerIp,
    List<CellTower> cellTowers = const [],
    List<WifiAccessPoint> wifiAccessPoints = const [],
  }) async {
    final body = buildBody(
      homeMobileCountryCode: homeMobileCountryCode,
      homeMobileNetworkCode: homeMobileNetworkCode,
      radioType: radioType,
      carrier: carrier,
      considerIp: considerIp,
      cellTowers: cellTowers,
      wifiAccessPoints: wifiAccessPoints,
    );

    return getGeolocationFromMap(body);
  }

  Future<GeolocationResponse> getGeolocationFromMap(
    Map<String, dynamic> params,
  ) async {
    return _decode(
      await doPost(buildUrl(), json.encode(params), headers: apiHeaders),
    );
  }

  Future<GeolocationResponse> currentGeolocation() async {
    return _decode(
      await doPost(buildUrl(), json.encode({}), headers: apiHeaders),
    );
  }

  String buildUrl() {
    final params = <String, String>{};

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url.replace(queryParameters: params).toString();
  }

  Map<String, dynamic> buildBody({
    int? homeMobileCountryCode,
    int? homeMobileNetworkCode,
    String? radioType,
    String? carrier,
    bool? considerIp,
    List<CellTower> cellTowers = const [],
    List<WifiAccessPoint> wifiAccessPoints = const [],
  }) {
    var params = <String, dynamic>{};

    // All optionals
    if (homeMobileCountryCode != null) {
      params['homeMobileCountryCode'] = homeMobileCountryCode.toString();
    }

    if (homeMobileNetworkCode != null) {
      params['homeMobileNetworkCode'] = homeMobileNetworkCode.toString();
    }

    if (radioType != null) {
      params['radioType'] = radioType;
    }

    if (carrier != null) {
      params['carrier'] = carrier;
    }

    if (considerIp != null) {
      params['considerIp'] = considerIp.toString();
    }

    if (cellTowers.isNotEmpty) {
      params['cellTowers'] = cellTowers.map((c) => c.toJson()).toList();
    }

    if (wifiAccessPoints.isNotEmpty) {
      params['wifiAccessPoints'] =
          wifiAccessPoints.map((w) => w.toJson()).toList();
    }

    return params;
  }

  GeolocationResponse _decode(Response res) {
    return GeolocationResponse.fromJson(json.decode(res.body));
  }
}

@JsonSerializable()
class GeolocationError with StringifyJson {
  final String domain;
  final String reason;
  final String message;

  GeolocationError({
    required this.domain,
    required this.reason,
    required this.message,
  });

  factory GeolocationError.fromJson(Map<String, dynamic> json) =>
      _$GeolocationErrorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GeolocationErrorToJson(this);
}

@JsonSerializable()
class GeolocationErrorResponse with StringifyJson {
  @JsonKey(defaultValue: <GeolocationError>[])
  final List<GeolocationError> errors;

  final int code;
  final String message;

  GeolocationErrorResponse({
    required this.errors,
    required this.code,
    required this.message,
  });

  factory GeolocationErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$GeolocationErrorResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GeolocationErrorResponseToJson(this);
}

@JsonSerializable()
class GeolocationResponse {
  final Location? location;
  final num? accuracy;
  final GeolocationErrorResponse? error;

  GeolocationResponse({
    this.location,
    this.accuracy,
    this.error,
  });

  bool get isOkay => error == null;

  factory GeolocationResponse.fromJson(Map<String, dynamic> json) =>
      _$GeolocationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeolocationResponseToJson(this);
}

abstract class _AccessObject with StringifyJson {
  final num? age;
  final num? signalStrength;

  _AccessObject({this.age, this.signalStrength});
}

@JsonSerializable()
class CellTower extends _AccessObject {
  final num cellId;
  final num locationAreaCode;
  final num mobileCountryCode;
  final num mobileNetworkCode;
  final num? timingAdvance;

  CellTower({
    required this.cellId,
    required this.locationAreaCode,
    required this.mobileCountryCode,
    required this.mobileNetworkCode,
    this.timingAdvance,
    num? age,
    num? signalStrength,
  }) : super(age: age, signalStrength: signalStrength);

  factory CellTower.fromJson(Map<String, dynamic> json) =>
      _$CellTowerFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CellTowerToJson(this);
}

@JsonSerializable()
class WifiAccessPoint extends _AccessObject {
  final String? macAddress;
  final Object? channel;
  final num? signalToNoiseRatio;

  WifiAccessPoint({
    num? age,
    num? signalStrength,
    this.macAddress,
    this.channel,
    this.signalToNoiseRatio,
  }) : super(
          age: age,
          signalStrength: signalStrength,
        );

  factory WifiAccessPoint.fromJson(Map<String, dynamic> json) =>
      _$WifiAccessPointFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$WifiAccessPointToJson(this);
}
