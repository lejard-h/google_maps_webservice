import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import 'core.dart';
import 'utils.dart';

part 'geocoding.g.dart';

const _geocodeUrl = '/geocode/json';

/// https://developers.google.com/maps/documentation/geocoding/start
class GoogleMapsGeocoding extends GoogleWebService {
  GoogleMapsGeocoding({
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          apiPath: _geocodeUrl,
          httpClient: httpClient,
          apiHeaders: apiHeaders,
        );

  Future<GeocodingResponse> searchByAddress(
    String address, {
    Bounds? bounds,
    String? language,
    String? region,
    List<Component> components = const [],
  }) async {
    final url = buildUrl(
      address: address,
      bounds: bounds,
      language: language,
      region: region,
      components: components,
    );
    return _decode(await doGet(url, headers: apiHeaders));
  }

  Future<GeocodingResponse> searchByComponents(
    List<Component> components, {
    Bounds? bounds,
    String? language,
    String? region,
  }) async {
    final url = buildUrl(
      bounds: bounds,
      language: language,
      region: region,
      components: components,
    );
    return _decode(await doGet(url, headers: apiHeaders));
  }

  Future<GeocodingResponse> searchByLocation(
    Location location, {
    String? language,
    List<String> resultType = const [],
    List<String> locationType = const [],
  }) async {
    final url = buildUrl(
      location: location,
      language: language,
      resultType: resultType,
      locationType: locationType,
    );

    return _decode(await doGet(url, headers: apiHeaders));
  }

  Future<GeocodingResponse> searchByPlaceId(
    String placeId, {
    String? language,
    List<String> resultType = const [],
    List<String> locationType = const [],
  }) async {
    final url = buildUrl(
      placeId: placeId,
      language: language,
      resultType: resultType,
      locationType: locationType,
    );
    return _decode(await doGet(url, headers: apiHeaders));
  }

  String buildUrl({
    String? address,
    Bounds? bounds,
    String? language,
    String? region,
    List<Component> components = const [],
    List<String> resultType = const [],
    List<String> locationType = const [],
    String? placeId,
    Location? location,
  }) {
    final params = <String, String>{};

    if (location != null) {
      params['latlng'] = location.toString();
    }

    if (placeId != null) {
      params['place_id'] = placeId;
    }

    if (address != null) {
      params['address'] = address;
    }

    if (bounds != null) {
      params['bounds'] = bounds.toString();
    }

    if (language != null) {
      params['language'] = language;
    }

    if (region != null) {
      params['region'] = region;
    }

    if (components.isNotEmpty) {
      params['components'] = components.join('|');
    }

    if (resultType.isNotEmpty) {
      params['result_type'] = resultType.join('|');
    }

    if (locationType.isNotEmpty) {
      params['location_type'] = locationType.join('|');
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url.replace(queryParameters: params).toString();
  }

  GeocodingResponse _decode(Response res) =>
      GeocodingResponse.fromJson(json.decode(res.body));
}

@JsonSerializable()
class GeocodingResponse extends GoogleResponseStatus {
  @JsonKey(defaultValue: <GeocodingResult>[])
  final List<GeocodingResult> results;

  GeocodingResponse({
    required String status,
    String? errorMessage,
    required this.results,
  }) : super(
          status: status,
          errorMessage: errorMessage,
        );

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      _$GeocodingResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GeocodingResponseToJson(this);
}

@JsonSerializable()
class GeocodingResult with StringifyJson {
  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  /// JSON formatted_address
  final String? formattedAddress;

  /// JSON address_components
  @JsonKey(defaultValue: <AddressComponent>[])
  final List<AddressComponent> addressComponents;

  /// JSON postcode_localities
  @JsonKey(defaultValue: <String>[])
  final List<String> postcodeLocalities;

  final Geometry geometry;

  /// JSON partial_match
  @JsonKey(defaultValue: false)
  final bool partialMatch;

  /// JSON place_id
  final String placeId;

  GeocodingResult({
    required this.geometry,
    required this.placeId,
    this.types = const <String>[],
    this.addressComponents = const <AddressComponent>[],
    this.postcodeLocalities = const <String>[],
    this.partialMatch = false,
    this.formattedAddress,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) =>
      _$GeocodingResultFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GeocodingResultToJson(this);
}

@JsonSerializable()
class StreetAddress with StringifyJson {
  final Geometry? geometry;
  final String? addressLine;
  final String? countryName;
  final String? countryCode;
  final String? featureName;
  final String? postalCode;
  final String? adminArea;
  final String? subAdminArea;
  final String? locality;
  final String? subLocality;

  /// Route
  final String? thoroughfare;

  /// Street Number
  final String? subThoroughfare;

  StreetAddress({
    this.geometry,
    this.addressLine,
    this.countryName,
    this.countryCode,
    this.featureName,
    this.postalCode,
    this.adminArea,
    this.subAdminArea,
    this.locality,
    this.subLocality,
    this.thoroughfare,
    this.subThoroughfare,
  });

  factory StreetAddress.fromGeocodingResult(GeocodingResult geocodingResult) {
    if (!geocodingResult.types.contains('street_address')) {
      throw ArgumentError.value('street_address type not found in result');
    }

    AddressComponent? search(String type) {
      try {
        return geocodingResult.addressComponents.firstWhere(
          (component) => component.types.contains(type),
        );
      } on StateError catch (_) {
        return null;
      }
    }

    final country = search('country');

    return StreetAddress(
      geometry: geocodingResult.geometry,
      addressLine: geocodingResult.formattedAddress,
      countryName: country?.longName,
      countryCode: country?.shortName,
      featureName:
          search('featureName')?.longName ?? geocodingResult.formattedAddress,
      postalCode: search('postal_code')?.longName,
      adminArea: search('administrative_area_level_1')?.longName,
      subAdminArea: search('administrative_area_level_2')?.longName,
      locality: search('locality')?.longName,
      subLocality:
          (search('sublocality') ?? search('sublocality_level_1'))?.longName,
      thoroughfare: search('route')?.longName,
      subThoroughfare: search('street_number')?.longName,
    );
  }

  factory StreetAddress.fromJson(Map<String, dynamic> json) =>
      _$StreetAddressFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$StreetAddressToJson(this);
}
