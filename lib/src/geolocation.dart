library google_maps_webservice.geolocation.src;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'core.dart';
import 'utils.dart';

// geolocation api does not use maps.geolocation
const _baseUrl = "https://www.googleapis.com";
const _geolocationUrl = "/geolocation/v1/geolocate";

//// https://developers.google.com/maps/documentation/geolocation/intro
class GoogleMapsGeolocation extends GoogleWebService {
  GoogleMapsGeolocation({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl ?? _baseUrl,
          url: _geolocationUrl,
          httpClient: httpClient,
        );

  Future<GeolocationResponse> getGeolocation(
      {int homeMobileCountryCode,
      int homeMobileNetworkCode,
      String radioType,
      String carrier,
      bool considerIp,
      List<CellTower> cellTowers,
      List<WifiAccessPoint> wifiAccessPoints}) async {
    final body = buildBody(
        homeMobileCountryCode: homeMobileCountryCode,
        homeMobileNetworkCode: homeMobileNetworkCode,
        radioType: radioType,
        carrier: carrier,
        considerIp: considerIp,
        cellTowers: cellTowers,
        wifiAccessPoints: wifiAccessPoints);

    return _decode(await doPost(buildUrl(), json.encode(body)));
  }

  Future<GeolocationResponse> getGeolocationFromMap(Map params) async {
    return _decode(await doPost(buildUrl(), json.encode(params)));
  }

  Future<GeolocationResponse> currentGeolocation() async =>
      _decode(await doPost(buildUrl(), json.encode({})));

  String buildUrl() {
    return "$url?${buildQuery({"key": apiKey})}";
  }

  Map buildBody(
      {int homeMobileCountryCode,
      int homeMobileNetworkCode,
      String radioType,
      String carrier,
      bool considerIp,
      List<CellTower> cellTowers,
      List<WifiAccessPoint> wifiAccessPoints}) {
    var params = {};

    // All optionals
    if (homeMobileCountryCode != null) {
      params.putIfAbsent(
          "'homeMobileCountryCode'", () => homeMobileCountryCode.toString());
    }

    if (homeMobileNetworkCode != null) {
      params.putIfAbsent(
          "'homeMobileNetworkCode'", () => homeMobileNetworkCode.toString());
    }

    if (radioType != null) {
      params.putIfAbsent("'radioType'", () => radioType);
    }

    if (carrier != null) {
      params.putIfAbsent("'carrier'", () => carrier);
    }

    if (considerIp != null) {
      params.putIfAbsent("'considerIp'", () => considerIp.toString());
    }

    if (cellTowers != null) {
      params.putIfAbsent(
          "'cellTowers'", () => (cellTowers.map((c) => c.toMap())));
    }

    if (wifiAccessPoints != null) {
      params.putIfAbsent(
          "'wifiAccessPoints'", () => (wifiAccessPoints.map((w) => w.toMap())));
    }

    return params;
  }

  GeolocationResponse _decode(Response res) =>
      GeolocationResponse.fromJson(json.decode(res.body));
}

class GeolocationResponse extends GoogleResponseStatus {
  final Location location;
  final num accuracy;

  GeolocationResponse(
      String status, String errorMessage, this.location, this.accuracy)
      : super(status, errorMessage);

  factory GeolocationResponse.fromJson(Map json) => GeolocationResponse(
      // Response body only contains error message, if post request not successful
      json.containsKey("error") ? "KO" : "OK",
      json.containsKey("error") ? json["error"]["message"] : null,
      Location.fromJson(json["location"]),
      json["accuracy"]);
}

abstract class _AccessObject {
  final num age;
  final num signalStrength;

  _AccessObject({this.age, this.signalStrength});
}

class CellTower extends _AccessObject {
  final num cellId;
  final num locationAreaCode;
  final num mobileCountryCode;
  final num mobileNetworkCode;
  final num timingAdvance;

  CellTower(this.cellId, this.locationAreaCode, this.mobileCountryCode,
      this.mobileNetworkCode,
      {this.timingAdvance, age, signalStrength})
      : super(age: age, signalStrength: signalStrength);

  Map<String, String> toMap() {
    var params = {
      "cellId": cellId.toString(),
      "locationAreaCode": locationAreaCode.toString(),
      "mobileCountryCode": mobileCountryCode.toString(),
      "mobileNetworkCode": mobileNetworkCode.toString(),
    };

    // Optionals
    if (age != null) {
      params.putIfAbsent("age", age.toString() as dynamic);
    }

    if (signalStrength != null) {
      params.putIfAbsent(
          "signalStrength", signalStrength.toString() as dynamic);
    }

    if (timingAdvance != null) {
      params.putIfAbsent("timingAdvance", timingAdvance.toString() as dynamic);
    }

    return params;
  }
}

class WifiAccessPoint extends _AccessObject {
  final String macAddress;
  final dynamic channel;
  final num signalToNoiseRatio;

  WifiAccessPoint({
    age,
    signalStrength,
    this.macAddress,
    this.channel,
    this.signalToNoiseRatio,
  }) : super(
          age: age,
          signalStrength: signalStrength,
        );

  Map<String, String> toMap() {
    var params = {};

    // All optionals
    if (macAddress != null) {
      params.putIfAbsent("carrier", macAddress as dynamic);
    }

    if (signalStrength != null) {
      params.putIfAbsent(
          "signalStrength", signalStrength.toString() as dynamic);
    }

    if (age != null) {
      params.putIfAbsent("age", age.toString() as dynamic);
    }

    if (channel != null) {
      params.putIfAbsent("channel", channel as dynamic);
    }

    if (signalToNoiseRatio != null) {
      params.putIfAbsent(
          "signalToNoiseRatio", signalToNoiseRatio.toString() as dynamic);
    }

    return params;
  }
}
