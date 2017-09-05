library google_maps_webservice.core;

class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map jsonMap) =>
      new Location(jsonMap["lat"], jsonMap["lng"]);

  String toString() => "$lat,$lng";
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
}
