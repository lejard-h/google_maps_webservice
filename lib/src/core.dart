library google_maps_webservice.core;

class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map json) =>
      json != null ? new Location(json["lat"], json["lng"]) : null;

  String toString() => "$lat,$lng";
}

class Geometry {
  final Location location;

  /// JSON location_type
  final String locationType;

  final Bounds viewport;

  final Bounds bounds;

  Geometry(this.location, this.locationType, this.viewport, this.bounds);

  factory Geometry.fromJson(Map json) => json != null
      ? new Geometry(
          new Location.fromJson(json["location"]),
          json["location_type"],
          new Bounds.fromJson(json["viewport"]),
          new Bounds.fromJson(json["bounds"]))
      : null;
}

class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds(this.northeast, this.southwest);

  factory Bounds.fromJson(Map json) => json != null
      ? new Bounds(new Location.fromJson(json["northeast"]),
          new Location.fromJson(json["southwest"]))
      : null;

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

  AddressComponent(this.types, this.longName, this.shortName);

  factory AddressComponent.fromJson(Map json) => json != null
      ? new AddressComponent(
          json["types"], json["long_name"], json["short_name"])
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

  String toString() => "$component:${Uri.encodeComponent(value)}";
}
