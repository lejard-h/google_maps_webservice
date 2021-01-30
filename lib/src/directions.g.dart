// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectionsResponse _$DirectionsResponseFromJson(Map<String, dynamic> json) {
  return DirectionsResponse(
    status: json['status'] as String,
    errorMessage: json['error_message'] as String?,
    geocodedWaypoints: (json['geocoded_waypoints'] as List<dynamic>?)
            ?.map((e) => GeocodedWaypoint.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    routes: (json['routes'] as List<dynamic>?)
            ?.map((e) => Route.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$DirectionsResponseToJson(DirectionsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'geocoded_waypoints': instance.geocodedWaypoints,
      'routes': instance.routes,
    };

Waypoint _$WaypointFromJson(Map<String, dynamic> json) {
  return Waypoint(
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$WaypointToJson(Waypoint instance) => <String, dynamic>{
      'value': instance.value,
    };

GeocodedWaypoint _$GeocodedWaypointFromJson(Map<String, dynamic> json) {
  return GeocodedWaypoint(
    geocoderStatus: json['geocoder_status'] as String,
    placeId: json['place_id'] as String,
    types:
        (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    partialMatch: json['partial_match'] as bool? ?? false,
  );
}

Map<String, dynamic> _$GeocodedWaypointToJson(GeocodedWaypoint instance) =>
    <String, dynamic>{
      'geocoder_status': instance.geocoderStatus,
      'place_id': instance.placeId,
      'types': instance.types,
      'partial_match': instance.partialMatch,
    };

Route _$RouteFromJson(Map<String, dynamic> json) {
  return Route(
    summary: json['summary'] as String,
    legs: (json['legs'] as List<dynamic>?)
            ?.map((e) => Leg.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    copyrights: json['copyrights'] as String,
    overviewPolyline:
        Polyline.fromJson(json['overview_polyline'] as Map<String, dynamic>),
    warnings: json['warnings'] as List<dynamic>,
    waypointOrder: (json['waypoint_order'] as List<dynamic>?)
            ?.map((e) => e as num)
            .toList() ??
        [],
    bounds: Bounds.fromJson(json['bounds'] as Map<String, dynamic>),
    fare: json['fare'] == null
        ? null
        : Fare.fromJson(json['fare'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'summary': instance.summary,
      'legs': instance.legs,
      'copyrights': instance.copyrights,
      'overview_polyline': instance.overviewPolyline,
      'warnings': instance.warnings,
      'waypoint_order': instance.waypointOrder,
      'bounds': instance.bounds,
      'fare': instance.fare,
    };

Leg _$LegFromJson(Map<String, dynamic> json) {
  return Leg(
    steps: (json['steps'] as List<dynamic>?)
            ?.map((e) => Step.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    startAddress: json['start_address'] as String,
    endAddress: json['end_address'] as String,
    durationInTraffic: json['duration_in_traffic'] == null
        ? null
        : Value.fromJson(json['duration_in_traffic'] as Map<String, dynamic>),
    arrivalTime: json['arrival_time'] == null
        ? null
        : Time.fromJson(json['arrival_time'] as Map<String, dynamic>),
    departureTime: json['departure_time'] == null
        ? null
        : Time.fromJson(json['departure_time'] as Map<String, dynamic>),
    startLocation:
        Location.fromJson(json['start_location'] as Map<String, dynamic>),
    endLocation:
        Location.fromJson(json['end_location'] as Map<String, dynamic>),
    duration: Value.fromJson(json['duration'] as Map<String, dynamic>),
    distance: Value.fromJson(json['distance'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LegToJson(Leg instance) => <String, dynamic>{
      'start_location': instance.startLocation,
      'end_location': instance.endLocation,
      'duration': instance.duration,
      'distance': instance.distance,
      'steps': instance.steps,
      'start_address': instance.startAddress,
      'end_address': instance.endAddress,
      'duration_in_traffic': instance.durationInTraffic,
      'arrival_time': instance.arrivalTime,
      'departure_time': instance.departureTime,
    };

Step _$StepFromJson(Map<String, dynamic> json) {
  return Step(
    travelMode: _$enumDecode(_$TravelModeEnumMap, json['travel_mode']),
    htmlInstructions: json['html_instructions'] as String,
    polyline: Polyline.fromJson(json['polyline'] as Map<String, dynamic>),
    startLocation:
        Location.fromJson(json['start_location'] as Map<String, dynamic>),
    endLocation:
        Location.fromJson(json['end_location'] as Map<String, dynamic>),
    duration: Value.fromJson(json['duration'] as Map<String, dynamic>),
    distance: Value.fromJson(json['distance'] as Map<String, dynamic>),
    transitDetails: json['transit_details'] == null
        ? null
        : TransitDetails.fromJson(
            json['transit_details'] as Map<String, dynamic>),
    maneuver: json['maneuver'] as String?,
  );
}

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'start_location': instance.startLocation,
      'end_location': instance.endLocation,
      'duration': instance.duration,
      'distance': instance.distance,
      'travel_mode': _$TravelModeEnumMap[instance.travelMode],
      'html_instructions': instance.htmlInstructions,
      'maneuver': instance.maneuver,
      'polyline': instance.polyline,
      'transit_details': instance.transitDetails,
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

Polyline _$PolylineFromJson(Map<String, dynamic> json) {
  return Polyline(
    points: json['points'] as String,
  );
}

Map<String, dynamic> _$PolylineToJson(Polyline instance) => <String, dynamic>{
      'points': instance.points,
    };

Value _$ValueFromJson(Map<String, dynamic> json) {
  return Value(
    value: json['value'] as num,
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
    };

Fare _$FareFromJson(Map<String, dynamic> json) {
  return Fare(
    currency: json['currency'] as String,
    value: json['value'] as num,
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$FareToJson(Fare instance) => <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'currency': instance.currency,
    };

Time _$TimeFromJson(Map<String, dynamic> json) {
  return Time(
    timeZone: json['time_zone'] as String,
    value: json['value'] as num,
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'time_zone': instance.timeZone,
    };

TransitDetails _$TransitDetailsFromJson(Map<String, dynamic> json) {
  return TransitDetails(
    arrivalStop: Stop.fromJson(json['arrival_stop'] as Map<String, dynamic>),
    departureStop:
        Stop.fromJson(json['departure_stop'] as Map<String, dynamic>),
    arrivalTime: Time.fromJson(json['arrival_time'] as Map<String, dynamic>),
    departureTime:
        Time.fromJson(json['departure_time'] as Map<String, dynamic>),
    headsign: json['headsign'] as String,
    headway: json['headway'] as num,
    numStops: json['num_stops'] as num,
  );
}

Map<String, dynamic> _$TransitDetailsToJson(TransitDetails instance) =>
    <String, dynamic>{
      'arrival_stop': instance.arrivalStop,
      'departure_stop': instance.departureStop,
      'arrival_time': instance.arrivalTime,
      'departure_time': instance.departureTime,
      'headsign': instance.headsign,
      'headway': instance.headway,
      'num_stops': instance.numStops,
    };

Stop _$StopFromJson(Map<String, dynamic> json) {
  return Stop(
    name: json['name'] as String,
    location: Location.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StopToJson(Stop instance) => <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
    };

Line _$LineFromJson(Map<String, dynamic> json) {
  return Line(
    name: json['name'] as String,
    shortName: json['short_name'] as String,
    color: json['color'] as String,
    agencies: (json['agencies'] as List<dynamic>)
        .map((e) => TransitAgency.fromJson(e as Map<String, dynamic>))
        .toList(),
    url: json['url'] as String,
    icon: json['icon'] as String,
    textColor: json['text_color'] as String,
    vehicle: VehicleType.fromJson(json['vehicle'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'name': instance.name,
      'short_name': instance.shortName,
      'color': instance.color,
      'agencies': instance.agencies,
      'url': instance.url,
      'icon': instance.icon,
      'text_color': instance.textColor,
      'vehicle': instance.vehicle,
    };

TransitAgency _$TransitAgencyFromJson(Map<String, dynamic> json) {
  return TransitAgency(
    name: json['name'] as String,
    url: json['url'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$TransitAgencyToJson(TransitAgency instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'phone': instance.phone,
    };

VehicleType _$VehicleTypeFromJson(Map<String, dynamic> json) {
  return VehicleType(
    name: json['name'] as String,
    type: json['type'] as String,
    icon: json['icon'] as String,
    localIcon: json['local_icon'] as String,
  );
}

Map<String, dynamic> _$VehicleTypeToJson(VehicleType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'icon': instance.icon,
      'local_icon': instance.localIcon,
    };
