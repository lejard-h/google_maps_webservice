library google_maps_webservice.core;

import 'dart:convert';

class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map json) => json != null
      ? new Location(
          (json["lat"] as num).toDouble(),
          (json["lng"] as num).toDouble(),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = new Map<String, dynamic>();
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

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
      ? new Geometry(
          new Location.fromJson(json["location"]),
          json["location_type"],
          new Bounds.fromJson(json["viewport"]),
          new Bounds.fromJson(json["bounds"]))
      : null;

  Map<String, dynamic> toJson() {
    Map map = new Map<String, dynamic>();
    map['location'] = jsonEncode(location);
    map['location_type'] = locationType;
    map['viewport'] = jsonEncode(viewport);
    map['bounds'] = jsonEncode(bounds);
    return map;
  }  
}

class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds(this.northeast, this.southwest);

  factory Bounds.fromJson(Map json) => json != null
      ? new Bounds(new Location.fromJson(json["northeast"]),
          new Location.fromJson(json["southwest"]))
      : null;

  Map<String, dynamic> toJson() {
    Map map = new Map<String, dynamic>();
    map['northeast'] = jsonEncode(northeast);
    map['southwest'] = jsonEncode(southwest);
    return map;
  }  

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

  Map<String, dynamic> toJson() { 
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["status"] = this.status;
    map["errorMessage"] = this.errorMessage;
    return map;
  }    
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
      ? new AddressComponent((json["types"] as List)?.cast<String>(),
          json["long_name"], json["short_name"])
      : null;

  Map<String, dynamic> toJson() { 
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["types"] = this.types;
    map["long_name"] = this.longName;
    map["short_name"] = this.shortName;
    return map;
  }   
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
