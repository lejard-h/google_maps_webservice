import 'package:json_annotation/json_annotation.dart';

part 'core.g.dart';

@JsonSerializable()
class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() => '$lat,$lng';
}

@JsonSerializable()
class Geometry {
  final Location location;

  /// JSON location_type
  final String? locationType;

  final Bounds? viewport;

  final Bounds? bounds;

  Geometry({
    required this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds({
    required this.northeast,
    required this.southwest,
  });

  @override
  String toString() =>
      '${northeast.lat},${northeast.lng}|${southwest.lat},${southwest.lng}';

  factory Bounds.fromJson(Map<String, dynamic> json) => _$BoundsFromJson(json);
  Map<String, dynamic> toJson() => _$BoundsToJson(this);
}

abstract class GoogleResponseStatus {
  static const okay = 'OK';
  static const zeroResults = 'ZERO_RESULTS';
  static const overQueryLimit = 'OVER_QUERY_LIMIT';
  static const requestDenied = 'REQUEST_DENIED';
  static const invalidRequest = 'INVALID_REQUEST';
  static const unknownErrorStatus = 'UNKNOWN_ERROR';
  static const notFound = 'NOT_FOUND';
  static const maxWaypointsExceeded = 'MAX_WAYPOINTS_EXCEEDED';
  static const maxRouteLengthExceeded = 'MAX_ROUTE_LENGTH_EXCEEDED';

  // TODO use enum for Response status
  final String status;

  /// JSON error_message
  final String? errorMessage;

  bool get isOkay => status == okay;
  bool get hasNoResults => status == zeroResults;
  bool get isOverQueryLimit => status == overQueryLimit;
  bool get isDenied => status == requestDenied;
  bool get isInvalid => status == invalidRequest;
  bool get unknownError => status == unknownErrorStatus;
  bool get isNotFound => status == notFound;

  GoogleResponseStatus({required this.status, this.errorMessage});
}

abstract class GoogleResponseList<T> extends GoogleResponseStatus {
  @JsonKey(defaultValue: [])
  final List<T> results;

  GoogleResponseList(String status, String? errorMessage, this.results)
      : super(status: status, errorMessage: errorMessage);
}

abstract class GoogleResponse<T> extends GoogleResponseStatus {
  final T? result;

  GoogleResponse(String status, String? errorMessage, this.result)
      : super(status: status, errorMessage: errorMessage);
}

@JsonSerializable()
class AddressComponent {
  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  /// JSON long_name
  final String longName;

  /// JSON short_name
  final String shortName;

  AddressComponent({
    required this.types,
    required this.longName,
    required this.shortName,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);
  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}

class Component {
  static const route = 'route';
  static const locality = 'locality';
  static const administrativeArea = 'administrative_area';
  static const postalCode = 'postal_code';
  static const country = 'country';

  final String component;
  final String value;

  Component(this.component, this.value);

  @override
  String toString() => '$component:$value';
}

enum TravelMode {
  @JsonValue('DRIVING')
  driving,
  @JsonValue('WALKING')
  walking,
  @JsonValue('BICYCLING')
  bicycling,
  @JsonValue('TRANSIT')
  transit,
}

@JsonSerializable()
class _TravelMode {
  final TravelMode value;

  _TravelMode(this.value);

  // ignore: unused_element
  factory _TravelMode.fromJson(Map<String, dynamic> json) =>
      _$_TravelModeFromJson(json);
  Map<String, dynamic> toJson() => _$_TravelModeToJson(this);
}

extension TravelModeExt on TravelMode {
  static TravelMode fromApiString(String mode) {
    return _$enumDecode(_$TravelModeEnumMap, mode);
  }

  String toApiString() {
    return _$TravelModeEnumMap[this] ?? '';
  }
}

enum RouteType {
  tolls,
  highways,
  ferries,
  indoor,
}

@JsonSerializable()
class _RouteType {
  final RouteType value;

  _RouteType(this.value);

  // ignore: unused_element
  factory _RouteType.fromJson(Map<String, dynamic> json) =>
      _$_RouteTypeFromJson(json);
  Map<String, dynamic> toJson() => _$_RouteTypeToJson(this);
}

extension RouteTypeExt on RouteType {
  static RouteType fromApiString(String mode) {
    return _$enumDecode(_$RouteTypeEnumMap, mode);
  }

  String toApiString() {
    return _$RouteTypeEnumMap[this] ?? '';
  }
}

enum Unit {
  metric,
  imperial,
}

@JsonSerializable()
class _Unit {
  final Unit value;

  _Unit(this.value);

  // ignore: unused_element
  factory _Unit.fromJson(Map<String, dynamic> json) => _$_UnitFromJson(json);
  Map<String, dynamic> toJson() => _$_UnitToJson(this);
}

extension UnitExt on Unit {
  static Unit fromApiString(String mode) {
    return _$enumDecode(_$UnitEnumMap, mode);
  }

  String toApiString() {
    return _$UnitEnumMap[this] ?? '';
  }
}

enum TrafficModel {
  @JsonValue('best_guess')
  bestGuess,
  pessimistic,
  optimistic,
}

@JsonSerializable()
class _TrafficModel {
  final TrafficModel value;

  _TrafficModel(this.value);

  // ignore: unused_element
  factory _TrafficModel.fromJson(Map<String, dynamic> json) =>
      _$_TrafficModelFromJson(json);
  Map<String, dynamic> toJson() => _$_TrafficModelToJson(this);
}

extension TrafficModelExt on TrafficModel {
  static TrafficModel fromApiString(String mode) {
    return _$enumDecode(_$TrafficModelEnumMap, mode);
  }

  String toApiString() {
    return _$TrafficModelEnumMap[this] ?? '';
  }
}

enum TransitMode {
  bus,
  subway,
  train,
  tram,
  rail,
}

@JsonSerializable()
class _TransitMode {
  final TransitMode value;

  _TransitMode(this.value);

  // ignore: unused_element
  factory _TransitMode.fromJson(Map<String, dynamic> json) =>
      _$_TransitModeFromJson(json);
  Map<String, dynamic> toJson() => _$_TransitModeToJson(this);
}

extension TransitModeExt on TransitMode {
  static TransitMode fromApiString(String mode) {
    return _$enumDecode(_$TransitModeEnumMap, mode);
  }

  String toApiString() {
    return _$TransitModeEnumMap[this] ?? '';
  }
}

enum TransitRoutingPreferences {
  @JsonValue('less_walking')
  lessWalking,
  @JsonValue('fewer_transfers')
  fewerTransfers,
}

@JsonSerializable()
class _TransitRoutingPreferences {
  final TransitRoutingPreferences value;

  _TransitRoutingPreferences(this.value);

  // ignore: unused_element
  factory _TransitRoutingPreferences.fromJson(Map<String, dynamic> json) =>
      _$_TransitRoutingPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$_TransitRoutingPreferencesToJson(this);
}

extension TransitRoutingPreferencesExt on TransitRoutingPreferences {
  static TransitRoutingPreferences fromApiString(String mode) {
    return _$enumDecode(_$TransitRoutingPreferencesEnumMap, mode);
  }

  String toApiString() {
    return _$TransitRoutingPreferencesEnumMap[this] ?? '';
  }
}
