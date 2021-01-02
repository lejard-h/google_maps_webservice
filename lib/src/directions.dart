import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import 'core.dart';
import 'utils.dart';

part 'directions.g.dart';

const _directionsUrl = '/directions/json';

/// https://developers.google.com/maps/documentation/directions/start
class GoogleMapsDirections extends GoogleWebService {
  GoogleMapsDirections({
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          apiPath: _directionsUrl,
          httpClient: httpClient,
          apiHeaders: apiHeaders,
        );

  Future<DirectionsResponse> directions(
    Object /*Location|String*/ origin,
    Object /*Location|String*/ destination, {
    TravelMode? travelMode,
    List<Waypoint> waypoints = const [],
    bool alternatives = false,
    @deprecated RouteType? avoid,
    List<RouteType> avoids = const [],
    String? language,
    Unit? units,
    String? region,
    Object? /*DateTime|num*/ arrivalTime,
    Object? /*DateTime|num|String('now')*/ departureTime,
    List<TransitMode> transitMode = const [],
    TrafficModel? trafficModel,
    TransitRoutingPreferences? transitRoutingPreference,
  }) async {
    final url = buildUrl(
      origin: origin,
      destination: destination,
      travelMode: travelMode,
      waypoints: waypoints,
      alternatives: alternatives,
      avoids: avoids,
      language: language,
      units: units,
      region: region,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
    return _decode(await doGet(url, headers: apiHeaders));
  }

  Future<DirectionsResponse> directionsWithLocation(
    Location origin,
    Location destination, {
    TravelMode? travelMode,
    List<Waypoint> waypoints = const [],
    bool alternatives = false,
    @deprecated RouteType? avoid,
    List<RouteType> avoids = const [],
    String? language,
    Unit? units,
    String? region,
    Object? /*DateTime|num*/ arrivalTime,
    Object? /*DateTime|num|String('now')*/ departureTime,
    List<TransitMode> transitMode = const [],
    TrafficModel? trafficModel,
    TransitRoutingPreferences? transitRoutingPreference,
  }) async {
    return directions(
      origin,
      destination,
      travelMode: travelMode,
      waypoints: waypoints,
      alternatives: alternatives,
      avoids: avoids,
      language: language,
      units: units,
      region: region,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
  }

  Future<DirectionsResponse> directionsWithAddress(
    String origin,
    String destination, {
    TravelMode? travelMode,
    List<Waypoint> waypoints = const [],
    bool alternatives = false,
    @deprecated RouteType? avoid,
    List<RouteType> avoids = const [],
    String? language,
    Unit? units,
    String? region,
    Object? /*DateTime|num*/ arrivalTime,
    Object? /*DateTime|num|String('now')*/ departureTime,
    List<TransitMode> transitMode = const [],
    TrafficModel? trafficModel,
    TransitRoutingPreferences? transitRoutingPreference,
  }) async {
    return directions(
      origin,
      destination,
      travelMode: travelMode,
      waypoints: waypoints,
      alternatives: alternatives,
      avoids: avoids,
      language: language,
      units: units,
      region: region,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
  }

  String buildUrl({
    required Object /*Location|String*/ origin,
    required Object /*Location|String*/ destination,
    TravelMode? travelMode,
    List<Waypoint> waypoints = const <Waypoint>[],
    bool alternatives = false,
    @deprecated RouteType? avoid,
    List<RouteType> avoids = const <RouteType>[],
    String? language,
    Unit? units,
    String? region,
    Object? /*DateTime|num*/ arrivalTime,
    Object? /*DateTime|num|String('now')*/ departureTime,
    List<TransitMode> transitMode = const <TransitMode>[],
    TrafficModel? trafficModel,
    TransitRoutingPreferences? transitRoutingPreference,
  }) {
    final params = <String, String>{};

    if (origin is! Location && origin is! String) {
      throw ArgumentError("'origin' must be a '$String' or a '$Location'");
    }
    params['origin'] =
        origin is String ? Uri.encodeComponent(origin) : origin.toString();

    if (destination is! Location && destination is! String) {
      throw ArgumentError("'destination' must be a '$String' or a '$Location'");
    }
    params['destination'] = destination is String
        ? Uri.encodeComponent(destination)
        : destination.toString();

    if (departureTime != null) {
      if (departureTime is! DateTime &&
          departureTime is! num &&
          departureTime != 'now') {
        throw ArgumentError(
            "'departureTime' must be a '$num' or a '$DateTime'");
      }

      params['departure_time'] = departureTime is DateTime
          ? (departureTime.millisecondsSinceEpoch ~/ 1000).toString()
          : departureTime.toString();
    }

    if (arrivalTime != null) {
      if (arrivalTime is! DateTime && arrivalTime is! num) {
        throw ArgumentError("'arrivalTime' must be a '$num' or a '$DateTime'");
      }

      params['arrival_time'] = arrivalTime is DateTime
          ? (arrivalTime.millisecondsSinceEpoch ~/ 1000).toString()
          : arrivalTime.toString();
    }

    if (waypoints.isNotEmpty == true) {
      if (alternatives == true) {
        throw ArgumentError(
          "'alternatives' is only available for requests without intermediate waypoints",
        );
      }

      params['waypoints'] = waypoints.join('|');
    }

    if (travelMode != null) {
      params['mode'] = travelMode.toApiString();
    }

    if (alternatives) {
      params['alternatives'] = alternatives.toString();
    }

    if (avoid != null) {
      avoids = [
        ...avoids,
        avoid,
      ];
    }

    if (avoids.isNotEmpty) {
      params['avoid'] = avoids.map((t) => t.toApiString()).join('|');
    }

    if (language != null) {
      params['language'] = language;
    }

    if (units != null) {
      params['units'] = units.toApiString();
    }

    if (region != null) {
      params['region'] = region;
    }

    if (trafficModel != null) {
      params['traffic_model'] = trafficModel.toApiString();
    }

    if (transitMode.isNotEmpty) {
      params['transit_mode'] =
          transitMode.map((t) => t.toApiString()).join('|');
    }

    if (transitRoutingPreference != null) {
      params['transit_routing_preference'] =
          transitRoutingPreference.toApiString();
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url.replace(queryParameters: params).toString();
  }

  DirectionsResponse _decode(Response res) =>
      DirectionsResponse.fromJson(json.decode(res.body));
}

@JsonSerializable()
class DirectionsResponse extends GoogleResponseStatus {
  /// JSON geocoded_waypos
  @JsonKey(defaultValue: <GeocodedWaypoint>[])
  final List<GeocodedWaypoint> geocodedWaypoints;

  @JsonKey(defaultValue: <Route>[])
  final List<Route> routes;

  DirectionsResponse({
    required String status,
    String? errorMessage,
    required this.geocodedWaypoints,
    required this.routes,
  }) : super(status: status, errorMessage: errorMessage);

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$DirectionsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DirectionsResponseToJson(this);
}

@JsonSerializable()
class Waypoint {
  final String value;

  Waypoint({required this.value});

  static Waypoint fromAddress(String address) => Waypoint(value: address);

  static Waypoint fromLocation(Location location) =>
      Waypoint(value: location.toString());

  static Waypoint fromPlaceId(String placeId) =>
      Waypoint(value: 'place_id:$placeId');

  static Waypoint fromEncodedPolyline(String polyline) =>
      Waypoint(value: 'enc:$polyline:');

  static Waypoint optimize() => Waypoint(value: 'optimize:true');

  @override
  String toString() => value;

  factory Waypoint.fromJson(Map<String, dynamic> json) =>
      _$WaypointFromJson(json);
  Map<String, dynamic> toJson() => _$WaypointToJson(this);
}

@JsonSerializable()
class GeocodedWaypoint {
  /// JSON geocoder_status
  final String geocoderStatus;

  /// JSON place_id
  final String placeId;

  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  /// JSON partial_match
  final bool partialMatch;

  GeocodedWaypoint({
    required this.geocoderStatus,
    required this.placeId,
    required this.types,
    required this.partialMatch,
  });

  factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) =>
      _$GeocodedWaypointFromJson(json);
  Map<String, dynamic> toJson() => _$GeocodedWaypointToJson(this);
}

@JsonSerializable()
class Route {
  final String summary;

  @JsonKey(defaultValue: <Leg>[])
  final List<Leg> legs;

  final String copyrights;

  /// JSON overview_polyline
  final Polyline overviewPolyline;

  final List warnings;

  /// JSON waypoint_order
  @JsonKey(defaultValue: <num>[])
  final List<num> waypointOrder;

  final Bounds bounds;

  final Fare? fare;

  Route({
    required this.summary,
    required this.legs,
    required this.copyrights,
    required this.overviewPolyline,
    required this.warnings,
    required this.waypointOrder,
    required this.bounds,
    this.fare,
  });

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

abstract class _Step {
  /// JSON start_location
  final Location startLocation;

  /// JSON end_location
  final Location endLocation;

  final Value duration;

  final Value distance;

  _Step({
    required this.startLocation,
    required this.endLocation,
    required this.duration,
    required this.distance,
  });
}

@JsonSerializable()
class Leg extends _Step {
  @JsonKey(defaultValue: <Step>[])
  final List<Step> steps;

  /// JSON start_address
  final String startAddress;

  /// JSON end_address
  final String endAddress;

  /// JSON duration_in_traffic
  final Value? durationInTraffic;

  /// JSON arrival_time
  final Time? arrivalTime;

  /// JSON departure_time
  final Time? departureTime;

  Leg({
    required this.steps,
    required this.startAddress,
    required this.endAddress,
    this.durationInTraffic,
    this.arrivalTime,
    this.departureTime,
    required Location startLocation,
    required Location endLocation,
    required Value duration,
    required Value distance,
  }) : super(
          startLocation: startLocation,
          endLocation: endLocation,
          duration: duration,
          distance: distance,
        );

  factory Leg.fromJson(Map<String, dynamic> json) => _$LegFromJson(json);
  Map<String, dynamic> toJson() => _$LegToJson(this);
}

@JsonSerializable()
class Step extends _Step {
  /// JSON travel_mode
  final TravelMode travelMode;

  /// JSON html_instructions
  final String htmlInstructions;
  final String maneuver;
  final Polyline polyline;

  /// JSON transit_details
  final TransitDetails? transitDetails;

  Step({
    required this.travelMode,
    required this.htmlInstructions,
    required this.maneuver,
    required this.polyline,
    this.transitDetails,
    required Location startLocation,
    required Location endLocation,
    required Value duration,
    required Value distance,
  }) : super(
          startLocation: startLocation,
          endLocation: endLocation,
          duration: duration,
          distance: distance,
        );

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
  Map<String, dynamic> toJson() => _$StepToJson(this);
}

@JsonSerializable()
class Polyline {
  final String points;

  Polyline({required this.points});

  factory Polyline.fromJson(Map<String, dynamic> json) =>
      _$PolylineFromJson(json);
  Map<String, dynamic> toJson() => _$PolylineToJson(this);
}

@JsonSerializable()
class Value {
  final num value;
  final String text;

  Value({required this.value, required this.text});

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
  Map<String, dynamic> toJson() => _$ValueToJson(this);
}

@JsonSerializable()
class Fare extends Value {
  final String currency;

  Fare({required this.currency, required num value, required String text})
      : super(value: value, text: text);

  factory Fare.fromJson(Map<String, dynamic> json) => _$FareFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FareToJson(this);
}

@JsonSerializable()
class Time extends Value {
  /// JSON time_zone
  final String timeZone;

  Time({required this.timeZone, required num value, required String text})
      : super(value: value, text: text);

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TimeToJson(this);
}

@JsonSerializable()
class TransitDetails {
  /// JSON arrival_stop
  final Stop arrivalStop;

  /// JSON departure_stop
  final Stop departureStop;

  /// JSON arrival_time
  final Time arrivalTime;

  /// JSON departure_time
  final Time departureTime;

  final String headsign;

  final num headway;

  /// JSON num_stops
  final num numStops;

  TransitDetails({
    required this.arrivalStop,
    required this.departureStop,
    required this.arrivalTime,
    required this.departureTime,
    required this.headsign,
    required this.headway,
    required this.numStops,
  });

  factory TransitDetails.fromJson(Map<String, dynamic> json) =>
      _$TransitDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TransitDetailsToJson(this);
}

@JsonSerializable()
class Stop {
  final String name;
  final Location location;

  Stop({required this.name, required this.location});

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
  Map<String, dynamic> toJson() => _$StopToJson(this);
}

@JsonSerializable()
class Line {
  final String name;

  /// JSON short_name
  final String shortName;

  final String color;

  final List<TransitAgency> agencies;

  final String url;

  final String icon;

  /// JSON text_color
  final String textColor;

  final VehicleType vehicle;

  Line({
    required this.name,
    required this.shortName,
    required this.color,
    required this.agencies,
    required this.url,
    required this.icon,
    required this.textColor,
    required this.vehicle,
  });

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);
  Map<String, dynamic> toJson() => _$LineToJson(this);
}

@JsonSerializable()
class TransitAgency {
  final String name;
  final String url;
  final String phone;

  TransitAgency({
    required this.name,
    required this.url,
    required this.phone,
  });

  factory TransitAgency.fromJson(Map<String, dynamic> json) =>
      _$TransitAgencyFromJson(json);
  Map<String, dynamic> toJson() => _$TransitAgencyToJson(this);
}

@JsonSerializable()
class VehicleType {
  final String name;
  final String type;
  final String icon;

  /// JSON local_icon
  final String localIcon;

  VehicleType({
    required this.name,
    required this.type,
    required this.icon,
    required this.localIcon,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypeToJson(this);

  bool isType(String type) => type.toLowerCase() == this.type.toLowerCase();

  static const rail = 'RAIL';
  static const metroRail = 'METRO_RAIL';
  static const subway = 'SUBWAY';
  static const tram = 'TRAM';
  static const monorail = 'MONORAIL';
  static const heavyRail = 'HEAVY_RAIL';
  static const commuterTrain = 'COMMUTER_TRAIN';
  static const highSpeedTrain = 'HIGH_SPEED_TRAI';
  static const bus = 'BUS';
  static const intercityBus = 'INTERCITY_BUS';
  static const trolleyBus = 'TROLLEYBUS';
  static const shareTaxi = 'SHARE_TAXI';
  static const ferry = 'FERRY';
  static const cableCar = 'CABLE_CARE';
  static const gondolaLift = 'GONDOLA_LIFT';
  static const funicular = 'FUNICULAR';
  static const other = 'OTHER';
}
