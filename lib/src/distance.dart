library google_maps_webservice.distance.src;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'core.dart';
import 'utils.dart';

const _distanceUrl = '/distancematrix/json';

///https://developers.google.com/maps/documentation/distance-matrix/intro
class GoogleDistanceMatrix extends GoogleWebService {
  GoogleDistanceMatrix({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
            apiKey: apiKey,
            baseUrl: baseUrl,
            url: _distanceUrl,
            httpClient: httpClient);

  Future<DistanceResponse> _distance(
    List<dynamic> origin,
    List<dynamic> destination, {
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType avoid,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) async {
    final url = buildUrl(
      origin: origin,
      destination: destination,
      travelMode: travelMode,
      languageCode: languageCode,
      alternative: alternative,
      region: region,
      routeType: avoid,
      unit: unit,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );

    return _decode(await doGet(url));
  }

  Future<DistanceResponse> distanceWithLocation(
    List<Location> origin,
    List<Location> destination, {
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType avoid,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) {
    return _distance(
      origin,
      destination,
      travelMode: travelMode,
      languageCode: languageCode,
      alternative: alternative,
      region: region,
      avoid: avoid,
      unit: unit,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
  }

  Future<DistanceResponse> distanceWithAddress(
    List<String> origin,
    List<String> destination, {
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType avoid,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) async {
    return _distance(
      origin,
      destination,
      travelMode: travelMode,
      languageCode: languageCode,
      alternative: alternative,
      region: region,
      avoid: avoid,
      unit: unit,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
  }

  String buildUrl({
    List<dynamic> origin,
    List<dynamic> destination,
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType routeType,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) {
    if (origin is! List<Location> && origin is! List<String>) {
      throw ArgumentError("'origin' must be a '$String' or a '$Location'");
    }
    if (destination is! List<Location> && destination is! List<String>) {
      throw ArgumentError("'destination' must be a '$String' or a '$Location'");
    }
    if (departureTime != null &&
        departureTime is! DateTime &&
        departureTime is! num &&
        departureTime != 'now') {
      throw ArgumentError("'departureTime' must be a '$num' or a '$DateTime'");
    }
    if (arrivalTime != null &&
        arrivalTime is! DateTime &&
        arrivalTime is! num) {
      throw ArgumentError("'arrivalTime' must be a '$num' or a '$DateTime'");
    }

    final params = {
      'origins': origin != null && origin is List<String>
          ? origin?.map(Uri.encodeComponent)?.join('|')
          : origin,
      'destinations': destination != null && destination is List<String>
          ? destination?.map(Uri.encodeComponent)?.join('|')
          : destination,
      'mode': travelModeToString(travelMode),
      'language': languageCode,
      'alternative': alternative,
      'region': region,
      'avoid': routeTypeToString(routeType),
      'units': unitToString(unit),
      'arrival_time': arrivalTime is DateTime
          ? arrivalTime.millisecondsSinceEpoch ~/ 1000
          : arrivalTime,
      'departure_time': departureTime is DateTime
          ? departureTime.millisecondsSinceEpoch ~/ 1000
          : departureTime,
      'traffic_model': trafficModelToString(trafficModel),
      'transit_mode': transitMode?.map(transitModeToString)?.join('|'),
      'transit_routing_preference':
          transitRoutingPreferencesToString(transitRoutingPreference)
    };

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url?${buildQuery(params)}';
  }

  DistanceResponse _decode(Response res) =>
      DistanceResponse.fromJson(json.decode(res.body));
}

class DistanceResponse extends GoogleResponseStatus {
  final List<String> originAddress;
  final List<String> destinationAddress;
  final List<Row> results;

  DistanceResponse(
    String status,
    String errorMsg,
    this.originAddress,
    this.destinationAddress,
    this.results,
  ) : super(
          status,
          errorMsg,
        );

  factory DistanceResponse.fromJson(Map json) => DistanceResponse(
      json['status'],
      json['error_message'],
      (json['origin_addresses'] as List)?.cast<String>(),
      (json['destination_addresses'] as List)?.cast<String>(),
      json['rows']
          ?.map((row) {
            return Row.fromJson(row);
          })
          ?.toList()
          ?.cast<Row>());
}

class Row {
  final List<Element> elements;

  Row(this.elements);

  factory Row.fromJson(Map json) => json != null
      ? Row(json['elements']
          ?.map((element) {
            return Element.fromJson(element);
          })
          ?.toList()
          ?.cast<Element>())
      : null;
}

class Element {
  final Value distance;
  final Value duration;
  final String elementStatus;

  Element(this.distance, this.duration, this.elementStatus);

  factory Element.fromJson(Map json) => json != null
      ? Element(
          Value.fromJson(json['distance']),
          Value.fromJson(json['duration']),
          json['status'],
        )
      : null;
}

class Value {
  final num value;
  final String text;

  Value(this.value, this.text);

  factory Value.fromJson(Map json) =>
      json != null ? Value(json['value'], json['text']) : null;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text,
    };
  }
}
