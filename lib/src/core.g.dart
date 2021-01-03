// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) {
  return Geometry(
    location: Location.fromJson(json['location'] as Map<String, dynamic>),
    locationType: json['location_type'] as String,
    viewport: json['viewport'] == null
        ? null
        : Bounds.fromJson(json['viewport'] as Map<String, dynamic>),
    bounds: json['bounds'] == null
        ? null
        : Bounds.fromJson(json['bounds'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
      'location_type': instance.locationType,
      'viewport': instance.viewport,
      'bounds': instance.bounds,
    };

Bounds _$BoundsFromJson(Map<String, dynamic> json) {
  return Bounds(
    northeast: Location.fromJson(json['northeast'] as Map<String, dynamic>),
    southwest: Location.fromJson(json['southwest'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BoundsToJson(Bounds instance) => <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) {
  return AddressComponent(
    types:
        (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    longName: json['long_name'] as String,
    shortName: json['short_name'] as String,
  );
}

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'types': instance.types,
      'long_name': instance.longName,
      'short_name': instance.shortName,
    };

_TravelMode _$_TravelModeFromJson(Map<String, dynamic> json) {
  return _TravelMode(
    _$enumDecode(_$TravelModeEnumMap, json['value']),
  );
}

Map<String, dynamic> _$_TravelModeToJson(_TravelMode instance) =>
    <String, dynamic>{
      'value': _$TravelModeEnumMap[instance.value],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TravelModeEnumMap = {
  TravelMode.driving: 'DRIVING',
  TravelMode.walking: 'WALKING',
  TravelMode.bicycling: 'BICYCLING',
  TravelMode.transit: 'TRANSIT',
};

_RouteType _$_RouteTypeFromJson(Map<String, dynamic> json) {
  return _RouteType(
    _$enumDecode(_$RouteTypeEnumMap, json['value']),
  );
}

Map<String, dynamic> _$_RouteTypeToJson(_RouteType instance) =>
    <String, dynamic>{
      'value': _$RouteTypeEnumMap[instance.value],
    };

const _$RouteTypeEnumMap = {
  RouteType.tolls: 'tolls',
  RouteType.highways: 'highways',
  RouteType.ferries: 'ferries',
  RouteType.indoor: 'indoor',
};

_Unit _$_UnitFromJson(Map<String, dynamic> json) {
  return _Unit(
    _$enumDecode(_$UnitEnumMap, json['value']),
  );
}

Map<String, dynamic> _$_UnitToJson(_Unit instance) => <String, dynamic>{
      'value': _$UnitEnumMap[instance.value],
    };

const _$UnitEnumMap = {
  Unit.metric: 'metric',
  Unit.imperial: 'imperial',
};

_TrafficModel _$_TrafficModelFromJson(Map<String, dynamic> json) {
  return _TrafficModel(
    _$enumDecode(_$TrafficModelEnumMap, json['value']),
  );
}

Map<String, dynamic> _$_TrafficModelToJson(_TrafficModel instance) =>
    <String, dynamic>{
      'value': _$TrafficModelEnumMap[instance.value],
    };

const _$TrafficModelEnumMap = {
  TrafficModel.bestGuess: 'best_guess',
  TrafficModel.pessimistic: 'pessimistic',
  TrafficModel.optimistic: 'optimistic',
};

_TransitMode _$_TransitModeFromJson(Map<String, dynamic> json) {
  return _TransitMode(
    _$enumDecode(_$TransitModeEnumMap, json['value']),
  );
}

Map<String, dynamic> _$_TransitModeToJson(_TransitMode instance) =>
    <String, dynamic>{
      'value': _$TransitModeEnumMap[instance.value],
    };

const _$TransitModeEnumMap = {
  TransitMode.bus: 'bus',
  TransitMode.subway: 'subway',
  TransitMode.train: 'train',
  TransitMode.tram: 'tram',
  TransitMode.rail: 'rail',
};

_TransitRoutingPreferences _$_TransitRoutingPreferencesFromJson(
    Map<String, dynamic> json) {
  return _TransitRoutingPreferences(
    _$enumDecode(_$TransitRoutingPreferencesEnumMap, json['value']),
  );
}

Map<String, dynamic> _$_TransitRoutingPreferencesToJson(
        _TransitRoutingPreferences instance) =>
    <String, dynamic>{
      'value': _$TransitRoutingPreferencesEnumMap[instance.value],
    };

const _$TransitRoutingPreferencesEnumMap = {
  TransitRoutingPreferences.lessWalking: 'less_walking',
  TransitRoutingPreferences.fewerTransfers: 'fewer_transfers',
};
