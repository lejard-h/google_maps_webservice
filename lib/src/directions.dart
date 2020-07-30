library google_maps_webservice.directions.src;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'core.dart';
import 'utils.dart';

const _directionsUrl = '/directions/json';

/// https://developers.google.com/maps/documentation/directions/start
class GoogleMapsDirections extends GoogleWebService {
  GoogleMapsDirections({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          url: _directionsUrl,
          httpClient: httpClient,
        );

  Future<DirectionsResponse> directions(
    origin,
    destination, {
    TravelMode travelMode,
    List<Waypoint> waypoints,
    bool alternatives,
    RouteType avoid,
    String language,
    Unit units,
    String region,
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
      waypoints: waypoints,
      alternatives: alternatives,
      avoid: avoid,
      language: language,
      units: units,
      region: region,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
    return _decode(await doGet(url));
  }

  Future<DirectionsResponse> directionsWithLocation(
    Location origin,
    Location destination, {
    TravelMode travelMode,
    List<Waypoint> waypoints,
    bool alternatives,
    RouteType avoid,
    String language,
    Unit units,
    String region,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) async {
    return directions(origin, destination,
        travelMode: travelMode,
        waypoints: waypoints,
        alternatives: alternatives,
        avoid: avoid,
        language: language,
        units: units,
        region: region,
        arrivalTime: arrivalTime,
        departureTime: departureTime,
        transitMode: transitMode,
        trafficModel: trafficModel,
        transitRoutingPreference: transitRoutingPreference);
  }

  Future<DirectionsResponse> directionsWithAddress(
    String origin,
    String destination, {
    TravelMode travelMode,
    List<Waypoint> waypoints,
    bool alternatives,
    RouteType avoid,
    String language,
    Unit units,
    String region,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) async {
    return directions(
      origin,
      destination,
      travelMode: travelMode,
      waypoints: waypoints,
      alternatives: alternatives,
      avoid: avoid,
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
    origin,
    destination,
    TravelMode travelMode,
    List<Waypoint> waypoints,
    bool alternatives,
    RouteType avoid,
    String language,
    Unit units,
    String region,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) {
    if (origin is! Location && origin is! String) {
      throw ArgumentError("'origin' must be a '$String' or a '$Location'");
    }
    if (destination is! Location && destination is! String) {
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

    if (waypoints?.isNotEmpty == true && alternatives == true) {
      throw ArgumentError(
        "'alternatives' is only available for requests without intermediate waypoints",
      );
    }

    final params = {
      'origin': origin != null && origin is String
          ? Uri.encodeComponent(origin)
          : origin,
      'destination': destination != null && destination is String
          ? Uri.encodeComponent(destination)
          : destination,
      'mode': travelModeToString(travelMode),
      'waypoints': waypoints,
      'alternatives': alternatives,
      'avoid': routeTypeToString(avoid),
      'language': language,
      'units': unitToString(units),
      'region': region,
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

  DirectionsResponse _decode(Response res) =>
      DirectionsResponse.fromJson(json.decode(res.body));
}

class DirectionsResponse extends GoogleResponseStatus {
  /// JSON geocoded_waypos
  final List<GeocodedWaypoint> geocodedWaypoints;

  final List<Route> routes;

  DirectionsResponse(
    String status,
    String errorMessage,
    this.geocodedWaypoints,
    this.routes,
  ) : super(status, errorMessage);

  factory DirectionsResponse.fromJson(Map json) => DirectionsResponse(
      json['status'],
      json['error_message'],
      json['geocoded_waypoints']
          ?.map((r) {
            return GeocodedWaypoint.fromJson(r);
          })
          ?.toList()
          ?.cast<GeocodedWaypoint>(),
      json['routes']
          ?.map((r) {
            return Route.fromJson(r);
          })
          ?.toList()
          ?.cast<Route>());

  @override
  Map<String, dynamic> toJson() {
    Map map = super.toJson();
    map['geocoded_waypoints'] = geocodedWaypoints?.map((r) {
      return r.toJson();
    })?.toList();
    map['routes'] = routes?.map((r) {
      return r.toJson();
    })?.toList();
    return map;
  }
}

class Waypoint {
  final String value;

  Waypoint(this.value);

  static Waypoint fromAddress(String address) => Waypoint(address);

  static Waypoint fromLocation(Location location) =>
      Waypoint(location.toString());

  static Waypoint fromPlaceId(String placeId) => Waypoint('place_id:$placeId');

  static Waypoint fromEncodedPolyline(String polyline) =>
      Waypoint('enc:$polyline:');

  static Waypoint optimize() => Waypoint('optimize:true');

  @override
  String toString() => value;
}

class GeocodedWaypoint {
  /// JSON geocoder_status
  final String geocoderStatus;

  /// JSON place_id
  final String placeId;

  final List<String> types;

  /// JSON partial_match
  final bool partialMatch;

  GeocodedWaypoint(
    this.geocoderStatus,
    this.placeId,
    this.types,
    this.partialMatch,
  );

  factory GeocodedWaypoint.fromJson(Map json) => GeocodedWaypoint(
      json['geocoder_status'],
      json['place_id'],
      (json['types'] as List)?.cast<String>(),
      json['partial_match']);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['geocoder_status'] = geocoderStatus;
    map['place_id'] = placeId;
    map['types'] = types;
    map['partial_match'] = partialMatch;
    return map;
  }
}

class Route {
  final String summary;
  final List<Leg> legs;
  final String copyrights;

  /// JSON overview_polyline
  final Polyline overviewPolyline;

  final List warnings;

  /// JSON waypoint_order
  final List<num> waypointOrder;

  final Bounds bounds;

  final Fare fare;

  Route(
    this.summary,
    this.legs,
    this.copyrights,
    this.overviewPolyline,
    this.warnings,
    this.waypointOrder,
    this.bounds,
    this.fare,
  );

  factory Route.fromJson(Map json) => json != null
      ? Route(
          json['summary'],
          json['legs']
              ?.map((r) {
                return Leg.fromJson(r);
              })
              ?.toList()
              ?.cast<Leg>(),
          json['copyrights'],
          Polyline.fromJson(json['overview_polyline']),
          json['warnings'] as List,
          (json['waypoint_order'] as List)?.cast<num>(),
          Bounds.fromJson(json['bounds']),
          Fare.fromJson(json['fare']))
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['summary'] = summary;
    map['legs'] = legs?.map((r) {
      return r.toJson();
    })?.toList();
    map['copyrights'] = copyrights;
    map['overview_polyline'] = overviewPolyline?.toJson();
    map['warnings'] = warnings;
    map['waypoint_order'] = waypointOrder;
    map['bounds'] = bounds.toJson();
    map['fare'] = fare;
    return map;
  }
}

abstract class _Step {
  /// JSON start_location
  final Location startLocation;

  /// JSON end_location
  final Location endLocation;

  final Value duration;

  final Value distance;

  _Step(
    this.startLocation,
    this.endLocation,
    this.duration,
    this.distance,
  );
}

class Leg extends _Step {
  final List<Step> steps;

  /// JSON start_address
  final String startAddress;

  /// JSON end_address
  final String endAddress;

  /// JSON duration_in_traffic
  final Value durationInTraffic;

  /// JSON arrival_time
  final Time arrivalTime;

  /// JSON departure_time
  final Time departureTime;

  Leg(
    this.steps,
    this.startAddress,
    this.endAddress,
    this.durationInTraffic,
    this.arrivalTime,
    this.departureTime,
    Location startLocation,
    Location endLocation,
    Value duration,
    Value distance,
  ) : super(
          startLocation,
          endLocation,
          duration,
          distance,
        );

  factory Leg.fromJson(Map json) => json != null
      ? Leg(
          json['steps']
              ?.map((r) {
                return Step.fromJson(r);
              })
              ?.toList()
              ?.cast<Step>(),
          json['start_address'],
          json['end_address'],
          Value.fromJson(json['duration_in_traffic']),
          Time.fromJson(json['arrival_time']),
          Time.fromJson(json['departure_time']),
          Location.fromJson(json['start_location']),
          Location.fromJson(json['end_location']),
          Value.fromJson(json['duration']),
          Value.fromJson(json['distance']))
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['steps'] = steps?.map((r) {
      return r.toJson();
    })?.toList();
    map['start_address'] = startAddress;
    map['end_address'] = endAddress;
    map['duration_in_traffic'] =
        (durationInTraffic != null) ? durationInTraffic.toJson() : null;
    map['arrival_time'] = (arrivalTime != null) ? arrivalTime.toJson() : null;
    map['departure_time'] =
        (departureTime != null) ? departureTime.toJson() : null;
    map['start_location'] = startLocation.toJson();
    map['end_location'] = endLocation.toJson();
    map['duration'] = (duration != null) ? duration.toJson() : null;
    map['distance'] = (distance != null) ? distance.toJson() : null;
    return map;
  }
}

class Step extends _Step {
  /// JSON travel_mode
  final TravelMode travelMode;

  /// JSON html_instructions
  final String htmlInstructions;
  final String maneuver;
  final Polyline polyline;

  /// JSON transit_details
  final TransitDetails transitDetails;

  Step(
    this.travelMode,
    this.htmlInstructions,
    this.maneuver,
    this.polyline,
    this.transitDetails,
    Location startLocation,
    Location endLocation,
    Value duration,
    Value distance,
  ) : super(
          startLocation,
          endLocation,
          duration,
          distance,
        );

  factory Step.fromJson(Map json) => json != null
      ? Step(
          stringToTravelMode(json['travel_mode']),
          json['html_instructions'],
          json['maneuver'],
          Polyline.fromJson(json['polyline']),
          TransitDetails.fromJson(json['transit_details']),
          Location.fromJson(json['start_location']),
          Location.fromJson(json['end_location']),
          Value.fromJson(json['duration']),
          Value.fromJson(json['distance']))
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['travel_mode'] = travelModeToString(travelMode);
    map['html_instructions'] = htmlInstructions;
    map['maneuver'] = maneuver;
    map['polyline'] = (polyline != null) ? polyline.toJson() : null;
    map['transit_details'] =
        (transitDetails != null) ? transitDetails.toJson() : null;
    map['start_location'] =
        (startLocation != null) ? startLocation.toJson() : null;
    map['end_location'] = (endLocation != null) ? endLocation.toJson() : null;
    map['duration'] = (duration != null) ? duration.toJson() : null;
    map['distance'] = (distance != null) ? distance.toJson() : null;
    return map;
  }
}

class Polyline {
  final String points;

  Polyline(this.points);

  factory Polyline.fromJson(Map json) =>
      json != null ? Polyline(json['points']) : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['points'] = points;
    return map;
  }
}

class Value {
  final num value;
  final String text;

  Value(this.value, this.text);

  factory Value.fromJson(Map json) =>
      json != null ? Value(json['value'], json['text']) : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['value'] = value;
    map['text'] = text;
    return map;
  }
}

class Fare extends Value {
  final String currency;

  Fare(this.currency, num value, String text) : super(value, text);

  factory Fare.fromJson(Map json) =>
      json != null ? Fare(json['currency'], json['value'], json['text']) : null;

  @override
  Map<String, dynamic> toJson() {
    Map map = super.toJson();
    map['currency'] = currency;
    return map;
  }
}

class Time extends Value {
  /// JSON time_zone
  final String timeZone;

  Time(this.timeZone, num value, String text) : super(value, text);

  factory Time.fromJson(Map json) => json != null
      ? Time(json['time_zone'], json['value'], json['text'])
      : null;

  @override
  Map<String, dynamic> toJson() {
    Map map = super.toJson();
    map['time_zone'] = timeZone;
    return map;
  }
}

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

  TransitDetails(
    this.arrivalStop,
    this.departureStop,
    this.arrivalTime,
    this.departureTime,
    this.headsign,
    this.headway,
    this.numStops,
  );

  factory TransitDetails.fromJson(Map json) => json != null
      ? TransitDetails(
          Stop.fromJson(json['arrival_stop']),
          Stop.fromJson(json['departure_stop']),
          Time.fromJson(json['arrival_time']),
          Time.fromJson(json['departure_time']),
          json['headsign'],
          json['headway'],
          json['num_stops'])
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['arrival_stop'] = (arrivalStop != null) ? arrivalStop.toJson() : null;
    map['departure_stop'] =
        (departureStop != null) ? departureStop.toJson() : null;
    map['arrival_time'] = (arrivalTime != null) ? arrivalTime.toJson() : null;
    map['departure_time'] =
        (departureTime != null) ? departureTime.toJson() : null;
    map['headsign'] = headsign;
    map['headway'] = headway;
    map['num_stops'] = numStops;
    return map;
  }
}

class Stop {
  final String name;
  final Location location;

  Stop(this.name, this.location);

  factory Stop.fromJson(Map json) => json != null
      ? Stop(json['name'], Location.fromJson(json['location']))
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['location'] = (location != null) ? location.toJson() : null;
    return map;
  }
}

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

  Line(
    this.name,
    this.shortName,
    this.color,
    this.agencies,
    this.url,
    this.icon,
    this.textColor,
    this.vehicle,
  );

  factory Line.fromJson(Map json) => json != null
      ? Line(
          json['name'],
          json['short_name'],
          json['color'],
          json['agencies']
              ?.map((a) => TransitAgency.fromJson(a))
              ?.toList()
              ?.cast<TransitAgency>(),
          json['url'],
          json['icon'],
          json['text_color'],
          VehicleType.fromJson(json['vehicle']))
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['short_name'] = shortName;
    map['color'] = color;
    map['agencies'] = agencies?.map((r) => r.toJson())?.toList();
    map['url'] = url;
    map['icon'] = icon;
    map['text_color'] = textColor;
    map['vehicle'] = (vehicle != null) ? vehicle.toJson() : null;
    return map;
  }
}

class TransitAgency {
  final String name;
  final String url;
  final String phone;

  TransitAgency(this.name, this.url, this.phone);

  factory TransitAgency.fromJson(Map json) => json != null
      ? TransitAgency(json['name'], json['url'], json['phone'])
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    map['phone'] = phone;
    return map;
  }
}

class VehicleType {
  final String name;
  final String type;
  final String icon;

  /// JSON local_icon
  final String localIcon;

  VehicleType(
    this.name,
    this.type,
    this.icon,
    this.localIcon,
  );

  factory VehicleType.fromJson(Map json) => json != null
      ? VehicleType(
          json['name'], json['type'], json['icon'], json['local_icon'])
      : null;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type;
    map['icon'] = icon;
    map['local_icon'] = localIcon;
    return map;
  }

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
