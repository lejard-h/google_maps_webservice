library google_maps_webservice.core;

class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map json) => json != null
      ? Location(
          (json["lat"] as num).toDouble(),
          (json["lng"] as num).toDouble(),
        )
      : null;

  @override
  String toString() => "$lat,$lng";
}

class Geometry {
  final Location location;

  /// JSON location_type
  final String locationType;

  final Bounds viewport;

  final Bounds bounds;

  Geometry(
    this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  );

  factory Geometry.fromJson(Map json) => json != null
      ? Geometry(
          Location.fromJson(json["location"]),
          json["location_type"],
          Bounds.fromJson(json["viewport"]),
          Bounds.fromJson(json["bounds"]),
        )
      : null;
}

class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds(this.northeast, this.southwest);

  factory Bounds.fromJson(Map json) => json != null
      ? Bounds(Location.fromJson(json["northeast"]),
          Location.fromJson(json["southwest"]))
      : null;

  @override
  String toString() =>
      "${northeast.lat},${northeast.lng}|${southwest.lat},${southwest.lng}";
}

abstract class GoogleResponseStatus {
  static const okay = "OK";
  static const zeroResults = "ZERO_RESULTS";
  static const overQueryLimit = "OVER_QUERY_LIMIT";
  static const requestDenied = "REQUEST_DENIED";
  static const invalidRequest = "INVALID_REQUEST";
  static const unknownErrorStatus = "UNKNOWN_ERROR";
  static const notFound = "NOT_FOUND";
  static const maxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED";
  static const maxRouteLengthExceeded = "MAX_ROUTE_LENGTH_EXCEEDED";

  final String status;

  /// JSON error_message
  final String errorMessage;

  bool get isOkay => status == okay;
  bool get hasNoResults => status == zeroResults;
  bool get isOverQueryLimit => status == overQueryLimit;
  bool get isDenied => status == requestDenied;
  bool get isInvalid => status == invalidRequest;
  bool get unknownError => status == unknownErrorStatus;
  bool get isNotFound => status == notFound;

  GoogleResponseStatus(this.status, this.errorMessage);
}

abstract class GoogleResponseList<T> extends GoogleResponseStatus {
  final List<T> results;

  GoogleResponseList(String status, String errorMessage, this.results)
      : super(status, errorMessage);
}

abstract class GoogleResponse<T> extends GoogleResponseStatus {
  final T result;

  GoogleResponse(String status, String errorMessage, this.result)
      : super(status, errorMessage);
}

class AddressComponent {
  final List<String> types;

  /// JSON long_name
  final String longName;

  /// JSON short_name
  final String shortName;

  AddressComponent(
    this.types,
    this.longName,
    this.shortName,
  );

  factory AddressComponent.fromJson(Map json) => json != null
      ? AddressComponent((json["types"] as List)?.cast<String>(),
          json["long_name"], json["short_name"])
      : null;
}

class Component {
  static const route = "route";
  static const locality = "locality";
  static const administrativeArea = "administrative_area";
  static const postalCode = "postal_code";
  static const country = "country";

  final String component;
  final String value;

  Component(this.component, this.value);

  @override
  String toString() => "$component:${Uri.encodeComponent(value)}";
}

enum TravelMode { driving, walking, bicycling, transit }

TravelMode stringToTravelMode(String mode) {
  if (mode.toLowerCase() == "driving") return TravelMode.driving;
  if (mode.toLowerCase() == "walking") return TravelMode.walking;
  if (mode.toLowerCase() == "bicycling") return TravelMode.bicycling;
  if (mode.toLowerCase() == "transit") return TravelMode.transit;
  return null;
}

String travelModeToString(TravelMode mode) {
  if (mode == TravelMode.driving) return "driving";
  if (mode == TravelMode.walking) return "walking";
  if (mode == TravelMode.bicycling) return "bicycling";
  if (mode == TravelMode.transit) return "transit";
  return null;
}

enum RouteType { tolls, highways, ferries, indoor }

RouteType stringToRouteType(String type) {
  if (type.toLowerCase() == "tolls") return RouteType.tolls;
  if (type.toLowerCase() == "highways") return RouteType.highways;
  if (type.toLowerCase() == "ferries") return RouteType.ferries;
  if (type.toLowerCase() == "indoor") return RouteType.indoor;
  return null;
}

String routeTypeToString(RouteType type) {
  if (type == RouteType.tolls) return "tolls";
  if (type == RouteType.highways) return "highways";
  if (type == RouteType.ferries) return "ferries";
  if (type == RouteType.indoor) return "indoor";
  return null;
}

enum Unit { metric, imperial }

Unit stringToUnit(String type) {
  if (type.toLowerCase() == "metric") return Unit.metric;
  if (type.toLowerCase() == "imperial") return Unit.imperial;
  return null;
}

String unitToString(Unit type) {
  if (type == Unit.metric) return "metric";
  if (type == Unit.imperial) return "imperial";
  return null;
}

enum TrafficModel { bestGuess, pessimistic, optimistic }

TrafficModel stringToTrafficModel(String type) {
  if (type.toLowerCase() == "best_guess") return TrafficModel.bestGuess;
  if (type.toLowerCase() == "pessimistic") return TrafficModel.pessimistic;
  if (type.toLowerCase() == "optimistic") return TrafficModel.optimistic;
  return null;
}

String trafficModelToString(TrafficModel type) {
  if (type == TrafficModel.bestGuess) return "best_guess";
  if (type == TrafficModel.pessimistic) return "pessimistic";
  if (type == TrafficModel.optimistic) return "optimistic";
  return null;
}

enum TransitMode { bus, subway, train, tram, rail }

TransitMode stringToTransitMode(String type) {
  if (type.toLowerCase() == "bus") return TransitMode.bus;
  if (type.toLowerCase() == "subway") return TransitMode.subway;
  if (type.toLowerCase() == "train") return TransitMode.train;
  if (type.toLowerCase() == "tram") return TransitMode.tram;
  if (type.toLowerCase() == "rail") return TransitMode.rail;
  return null;
}

String transitModeToString(TransitMode type) {
  if (type == TransitMode.bus) return "bus";
  if (type == TransitMode.subway) return "subway";
  if (type == TransitMode.train) return "train";
  if (type == TransitMode.tram) return "tram";
  if (type == TransitMode.rail) return "rail";
  return null;
}

enum TransitRoutingPreferences { lessWalking, fewerTransfers }

TransitRoutingPreferences stringToTransitRoutingPreferences(String type) {
  if (type.toLowerCase() == "less_walking")
    return TransitRoutingPreferences.lessWalking;
  if (type.toLowerCase() == "fewer_transfers")
    return TransitRoutingPreferences.fewerTransfers;
  return null;
}

String transitRoutingPreferencesToString(TransitRoutingPreferences type) {
  if (type == TransitRoutingPreferences.lessWalking) return "less_walking";
  if (type == TransitRoutingPreferences.fewerTransfers)
    return "fewer_transfers";
  return null;
}
