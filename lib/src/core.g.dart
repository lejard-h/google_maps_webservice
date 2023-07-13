// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      locationType: json['location_type'] as String?,
      viewport: json['viewport'] == null
          ? null
          : Bounds.fromJson(json['viewport'] as Map<String, dynamic>),
      bounds: json['bounds'] == null
          ? null
          : Bounds.fromJson(json['bounds'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
      'location_type': instance.locationType,
      'viewport': instance.viewport,
      'bounds': instance.bounds,
    };

Bounds _$BoundsFromJson(Map<String, dynamic> json) => Bounds(
      northeast: Location.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest: Location.fromJson(json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BoundsToJson(Bounds instance) => <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      longName: json['long_name'] as String,
      shortName: json['short_name'] as String,
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'types': instance.types,
      'long_name': instance.longName,
      'short_name': instance.shortName,
    };

_TravelMode _$TravelModeFromJson(Map<String, dynamic> json) => _TravelMode(
      $enumDecode(_$TravelModeEnumMap, json['value']),
    );

Map<String, dynamic> _$TravelModeToJson(_TravelMode instance) =>
    <String, dynamic>{
      'value': _$TravelModeEnumMap[instance.value]!,
    };

const _$TravelModeEnumMap = {
  TravelMode.driving: 'DRIVING',
  TravelMode.walking: 'WALKING',
  TravelMode.bicycling: 'BICYCLING',
  TravelMode.transit: 'TRANSIT',
};

_RouteType _$RouteTypeFromJson(Map<String, dynamic> json) => _RouteType(
      $enumDecode(_$RouteTypeEnumMap, json['value']),
    );

Map<String, dynamic> _$RouteTypeToJson(_RouteType instance) =>
    <String, dynamic>{
      'value': _$RouteTypeEnumMap[instance.value]!,
    };

const _$RouteTypeEnumMap = {
  RouteType.tolls: 'tolls',
  RouteType.highways: 'highways',
  RouteType.ferries: 'ferries',
  RouteType.indoor: 'indoor',
};

_Unit _$UnitFromJson(Map<String, dynamic> json) => _Unit(
      $enumDecode(_$UnitEnumMap, json['value']),
    );

Map<String, dynamic> _$UnitToJson(_Unit instance) => <String, dynamic>{
      'value': _$UnitEnumMap[instance.value]!,
    };

const _$UnitEnumMap = {
  Unit.metric: 'metric',
  Unit.imperial: 'imperial',
};

_TrafficModel _$TrafficModelFromJson(Map<String, dynamic> json) =>
    _TrafficModel(
      $enumDecode(_$TrafficModelEnumMap, json['value']),
    );

Map<String, dynamic> _$TrafficModelToJson(_TrafficModel instance) =>
    <String, dynamic>{
      'value': _$TrafficModelEnumMap[instance.value]!,
    };

const _$TrafficModelEnumMap = {
  TrafficModel.bestGuess: 'best_guess',
  TrafficModel.pessimistic: 'pessimistic',
  TrafficModel.optimistic: 'optimistic',
};

_TransitMode _$TransitModeFromJson(Map<String, dynamic> json) => _TransitMode(
      $enumDecode(_$TransitModeEnumMap, json['value']),
    );

Map<String, dynamic> _$TransitModeToJson(_TransitMode instance) =>
    <String, dynamic>{
      'value': _$TransitModeEnumMap[instance.value]!,
    };

const _$TransitModeEnumMap = {
  TransitMode.bus: 'bus',
  TransitMode.subway: 'subway',
  TransitMode.train: 'train',
  TransitMode.tram: 'tram',
  TransitMode.rail: 'rail',
};

_TransitRoutingPreferences _$TransitRoutingPreferencesFromJson(
        Map<String, dynamic> json) =>
    _TransitRoutingPreferences(
      $enumDecode(_$TransitRoutingPreferencesEnumMap, json['value']),
    );

Map<String, dynamic> _$TransitRoutingPreferencesToJson(
        _TransitRoutingPreferences instance) =>
    <String, dynamic>{
      'value': _$TransitRoutingPreferencesEnumMap[instance.value]!,
    };

const _$TransitRoutingPreferencesEnumMap = {
  TransitRoutingPreferences.lessWalking: 'less_walking',
  TransitRoutingPreferences.fewerTransfers: 'fewer_transfers',
};
