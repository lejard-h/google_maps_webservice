library google_maps_webservice.geolocation.src;

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

  Future<GeolocationResponse> currentGeolocation({
    int homeMobileCountryCode,
    int homeMobileNetworkCode,
    String radioType,
    String carrier,
    bool considerIp,
    List<CellTower> cellTowers,
    List<WifiAccessPoint> wifiAccessPoints
  }) async {
    final body = buildBody(
      homeMobileCountryCode: homeMobileCountryCode,
      homeMobileNetworkCode: homeMobileNetworkCode,
      radioType: radioType,
      carrier: carrier,
      considerIp: considerIp,
      cellTowers: cellTowers,
      wifiAccessPoints: wifiAccessPoints
    );

    return _decode(await doPost(buildUrl(), body));
  }

  String buildUrl() {
    return "$url?${buildQuery({"key": apiKey})}";
  }

  Map buildBody({
    int homeMobileCountryCode,
    int homeMobileNetworkCode,
    String radioType,
    String carrier,
    bool considerIp,
    List<CellTower> cellTowers,
    List<WifiAccessPoint> wifiAccessPoints
  }) {
    var params = {};

    // All optionals
    if(homeMobileCountryCode != null) {
      params.putIfAbsent("homeMobileCountryCode", homeMobileCountryCode.toString() as dynamic);
    };

    if(homeMobileNetworkCode!= null) {
      params.putIfAbsent("homeMobileNetworkCode", homeMobileNetworkCode.toString() as dynamic);
    };

    if(radioType!= null) {
      params.putIfAbsent("radioType", radioType as dynamic);
    };

    if(carrier!= null) {
      params.putIfAbsent("carrier", carrier as dynamic);
    };

    if(considerIp!= null) {
      params.putIfAbsent("considerIp", considerIp.toString() as dynamic);
    };

    if(cellTowers!= null) {
      params.putIfAbsent("cellTowers", (cellTowers.map((c) => c.toMap()) as dynamic));
    };

    if(wifiAccessPoints!= null) {
      params.putIfAbsent("wifiAccessPoints", (wifiAccessPoints.map((w) => w.toMap()) as dynamic));
    };

  }

  GeolocationResponse _decode(Response res) =>
      new GeolocationResponse.fromJson(json.decode(res.body));

}

class GeolocationResponse extends GoogleResponseStatus {

  final Location location;
  final num accuracy;

  GeolocationResponse(
      String status,
      String errorMessage,
      this.location,
      this.accuracy
  ) : super(status, errorMessage);

  factory GeolocationResponse.fromJson(Map json) => new GeolocationResponse(
    json["status"],
    json["error_message"],
    Location.fromJson(json["location"]),
    json["accuracy"]
  );

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

  CellTower(
    this.cellId,
      this.locationAreaCode,
      this.mobileCountryCode,
      this.mobileNetworkCode,
      {this.timingAdvance, age, signalStrength}
  ) : super(
      age: age,
      signalStrength: signalStrength
  );


  Map<String, String> toMap() {
    var params = {
      "cellId": cellId.toString(),
      "locationAreaCode": locationAreaCode.toString(),
      "mobileCountryCode": mobileCountryCode.toString(),
      "mobileNetworkCode": mobileNetworkCode.toString(),
    };

    // Optionals
    if(age!= null) {
      params.putIfAbsent("age", age.toString() as dynamic);
    };

    if(signalStrength!= null) {
      params.putIfAbsent("signalStrength", signalStrength.toString() as dynamic);
    };

    if(timingAdvance!= null) {
      params.putIfAbsent("timingAdvance", timingAdvance.toString() as dynamic);
    };

    return params;
  }

}

class WifiAccessPoint extends _AccessObject {

  final String macAddress;
  final channel;
  final num signalToNoiseRatio;

  WifiAccessPoint({
    this.macAddress,
    this.channel,
    this.signalToNoiseRatio,
    age,
    signalStrength,
  }) : super (
    age: age,
    signalStrength: signalStrength
  );


  Map<String, String> toMap() {
    var params = {};

    // All optionals
    if(macAddress!= null) {
      params.putIfAbsent("carrier", macAddress as dynamic);
    };

    if(signalStrength!= null) {
      params.putIfAbsent("signalStrength", signalStrength.toString() as dynamic);
    };

    if(age!= null) {
      params.putIfAbsent("age", age.toString() as dynamic);
    };

    if(channel != null) {
      params.putIfAbsent("channel", channel as dynamic);
    };

    if(signalToNoiseRatio!= null) {
      params.putIfAbsent("signalToNoiseRatio", signalToNoiseRatio.toString() as dynamic);
    };

    return params;
  }
}
