library google_maps_webservice.directions.src;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'core.dart';
import 'utils.dart';

const _directionsUrl = "/directions/json";

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
      throw new ArgumentError("'origin' must be a '$String' or a '$Location'");
    }
    if (destination is! Location && destination is! String) {
      throw new ArgumentError(
          "'destination' must be a '$String' or a '$Location'");
    }
    if (departureTime != null &&
        departureTime is! DateTime &&
        departureTime is! num) {
      throw new ArgumentError(
          "'departureTime' must be a '$num' or a '$DateTime'");
    }
    if (arrivalTime != null &&
        arrivalTime is! DateTime &&
        arrivalTime is! num) {
      throw new ArgumentError(
          "'arrivalTime' must be a '$num' or a '$DateTime'");
    }
    final params = {
      "origin": origin != null && origin is String
          ? Uri.encodeComponent(origin)
          : origin,
      "destination": destination != null && destination is String
          ? Uri.encodeComponent(destination)
          : destination,
      "mode": travelModeToString(travelMode),
      "waypoints": waypoints,
      "alternatives": alternatives,
      "avoid": routeTypeToString(avoid),
      "language": language,
      "units": unitToString(units),
      "region": region,
      "arrival_time": arrivalTime is DateTime
          ? arrivalTime.millisecondsSinceEpoch ~/ 1000
          : arrivalTime,
      "departure_time": departureTime is DateTime
          ? departureTime.millisecondsSinceEpoch ~/ 1000
          : departureTime,
      "traffic_model": trafficModelToString(trafficModel),
      "transit_mode":
          transitMode?.map((t) => transitModeToString(t))?.join("|"),
      "transit_routing_preference":
          transitRoutingPreferencesToString(transitRoutingPreference)
    };

    if (apiKey != null) {
      params.putIfAbsent("key", () => apiKey);
    }

    return "$url?${buildQuery(params)}";
  }

  DirectionsResponse _decode(Response res) =>
      new DirectionsResponse.fromJson(json.decode(res.body));
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

  factory DirectionsResponse.fromJson(Map json) => new DirectionsResponse(
      json["status"],
      json["error_message"],
      json["geocoded_waypoints"]
          ?.map((r) {
            return new GeocodedWaypoint.fromJson(r);
          })
          ?.toList()
          ?.cast<GeocodedWaypoint>(),
      json["routes"]
          ?.map((r) {
            return new Route.fromJson(r);
          })
          ?.toList()
          ?.cast<Route>());
}

class Waypoint {
  final String value;

  Waypoint(this.value);

  static fromAddress(String address) => new Waypoint(address);

  static fromLocation(Location location) => new Waypoint(location.toString());

  static fromPlaceId(String placeId) => new Waypoint("place_id:$placeId");

  static fromEncodedPolyline(String polyline) => new Waypoint("enc:$polyline:");

  static optimize() => new Waypoint("optimize:true");

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
  final String partialMatch;

  GeocodedWaypoint(
    this.geocoderStatus,
    this.placeId,
    this.types,
    this.partialMatch,
  );

  factory GeocodedWaypoint.fromJson(Map json) => new GeocodedWaypoint(
      json["geocoder_status"],
      json["place_id"],
      (json["types"] as List)?.cast<String>(),
      json["partial_match"]);
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
      ? new Route(
          json["summary"],
          json["legs"]
              ?.map((r) {
                return new Leg.fromJson(r);
              })
              ?.toList()
              ?.cast<Leg>(),
          json["copyrights"],
          new Polyline.fromJson(json["overview_polyline"]),
          json["warnings"] as List,
          (json["waypoint_order"] as List)?.cast<num>(),
          new Bounds.fromJson(json["bounds"]),
          new Fare.fromJson(json["fare"]))
      : null;
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
      ? new Leg(
          json["steps"]
              ?.map((r) {
                return new Step.fromJson(r);
              })
              ?.toList()
              ?.cast<Step>(),
          json["start_address"],
          json["end_address"],
          new Value.fromJson(json["duration_in_traffic"]),
          new Time.fromJson(json["arrival_time"]),
          new Time.fromJson(json["departure_time"]),
          new Location.fromJson(json["start_location"]),
          new Location.fromJson(json["end_location"]),
          new Value.fromJson(json["duration"]),
          new Value.fromJson(json["distance"]))
      : null;
}

class Step extends _Step {
  /// JSON travel_mode
  final TravelMode travelMode;

  /// JSON html_instructions
  final String htmlInstructions;

  final Polyline polyline;

  /// JSON transit_details
  final TransitDetails transitDetails;

  Step(
    this.travelMode,
    this.htmlInstructions,
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
      ? new Step(
          stringToTravelMode(json["travel_mode"]),
          json["html_instructions"],
          new Polyline.fromJson(json["polyline"]),
          new TransitDetails.fromJson(json["transit_details"]),
          new Location.fromJson(json["start_location"]),
          new Location.fromJson(json["end_location"]),
          new Value.fromJson(json["duration"]),
          new Value.fromJson(json["distance"]))
      : null;
}

class Polyline {
  final String points;

  Polyline(this.points);

  factory Polyline.fromJson(Map json) =>
      json != null ? new Polyline(json["points"]) : null;
}

class Value {
  final num value;
  final String text;

  Value(this.value, this.text);

  factory Value.fromJson(Map json) =>
      json != null ? new Value(json["value"], json["text"]) : null;
}

class Fare extends Value {
  final String currency;

  Fare(this.currency, num value, String text) : super(value, text);

  factory Fare.fromJson(Map json) => json != null
      ? new Fare(json["currency"], json["value"], json["text"])
      : null;
}

class Time extends Value {
  /// JSON time_zone
  final String timeZone;

  Time(this.timeZone, num value, String text) : super(value, text);

  factory Time.fromJson(Map json) => json != null
      ? new Time(json["time_zone"], json["value"], json["text"])
      : null;
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
      ? new TransitDetails(
          new Stop.fromJson(json["arrival_stop"]),
          new Stop.fromJson(json["departure_stop"]),
          new Time.fromJson(json["arrival_time"]),
          new Time.fromJson(json["departure_time"]),
          json["headsign"],
          json["headway"],
          json["num_stops"])
      : null;
}

class Stop {
  final String name;
  final Location location;

  Stop(this.name, this.location);

  factory Stop.fromJson(Map json) => json != null
      ? new Stop(json["name"], new Location.fromJson(json["location"]))
      : null;
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
      ? new Line(
          json["name"],
          json["short_name"],
          json["color"],
          json["agencies"]?.map((a) => new TransitAgency.fromJson(a))?.toList(),
          json["url"],
          json["icon"],
          json["text_color"],
          new VehicleType.fromJson(json["vehicle"]))
      : null;
}

class TransitAgency {
  final String name;
  final String url;
  final String phone;

  TransitAgency(this.name, this.url, this.phone);

  factory TransitAgency.fromJson(Map json) => json != null
      ? new TransitAgency(json["name"], json["url"], json["phone"])
      : null;
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
      ? new VehicleType(
          json["name"], json["type"], json["icon"], json["local_icon"])
      : null;

  bool isType(String type) => type.toLowerCase() == this.type.toLowerCase();

  static const rail = "RAIL";
  static const metroRail = "METRO_RAIL";
  static const subway = "SUBWAY";
  static const tram = "TRAM";
  static const monorail = "MONORAIL";
  static const heavyRail = "HEAVY_RAIL";
  static const commuterTrain = "COMMUTER_TRAIN";
  static const highSpeedTrain = "HIGH_SPEED_TRAI";
  static const bus = "BUS";
  static const intercityBus = "INTERCITY_BUS";
  static const trolleyBus = "TROLLEYBUS";
  static const shareTaxi = "SHARE_TAXI";
  static const ferry = "FERRY";
  static const cableCar = "CABLE_CARE";
  static const gondolaLift = "GONDOLA_LIFT";
  static const funicular = "FUNICULAR";
  static const other = "OTHER";
}
