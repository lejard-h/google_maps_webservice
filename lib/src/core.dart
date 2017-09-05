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

abstract class GoogleResponse<T> {
  static const statusOkay = "OK";
  static const statusZeroResults = "ZERO_RESULTS";
  static const statusOverQueryLimit = "OVER_QUERY_LIMIT";
  static const statusRequestDenied = "REQUEST_DENIED";
  static const statusInvalidRequest = "INVALID_REQUEST";
  static const statusUnknownError = "UNKNOWN_ERROR";

  final String status;

  /// JSON error_message
  final String errorMessage;

  final List<T> results;

  GoogleResponse(this.status, this.errorMessage, this.results);

  bool get isOkay => status == statusOkay;
  bool get hasNoResults => status == statusZeroResults;
  bool get isOverQueryLimit => status == statusOverQueryLimit;
  bool get isDenied => status == statusRequestDenied;
  bool get isInvalid => status == statusInvalidRequest;
  bool get unknownError => status == statusUnknownError;
}
