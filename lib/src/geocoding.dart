library google_maps_webservice.geocoding.src;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'core.dart';
import 'utils.dart';

const _geocodeUrl = '/geocode/json';

/// https://developers.google.com/maps/documentation/geocoding/start
class GoogleMapsGeocoding extends GoogleWebService {
  GoogleMapsGeocoding({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          url: _geocodeUrl,
          httpClient: httpClient,
        );

  Future<GeocodingResponse> searchByAddress(
    String address, {
    Bounds bounds,
    String language,
    String region,
    List<Component> components,
  }) async {
    final url = buildUrl(
        address: address,
        bounds: bounds,
        language: language,
        region: region,
        components: components);
    return _decode(await doGet(url));
  }

  Future<GeocodingResponse> searchByComponents(
    List<Component> components, {
    Bounds bounds,
    String language,
    String region,
  }) async {
    final url = buildUrl(
        bounds: bounds,
        language: language,
        region: region,
        components: components);
    return _decode(await doGet(url));
  }

  Future<GeocodingResponse> searchByLocation(
    Location location, {
    String language,
    List<String> resultType,
    List<String> locationType,
  }) async {
    final url = buildUrl(
        location: location,
        language: language,
        resultType: resultType,
        locationType: locationType);
    return _decode(await doGet(url));
  }

  Future<GeocodingResponse> searchByPlaceId(
    String placeId, {
    String language,
    List<String> resultType,
    List<String> locationType,
  }) async {
    final url = buildUrl(
        placeId: placeId,
        language: language,
        resultType: resultType,
        locationType: locationType);
    return _decode(await doGet(url));
  }

  String buildUrl({
    String address,
    Bounds bounds,
    String language,
    String region,
    List<Component> components,
    List<String> resultType,
    List<String> locationType,
    String placeId,
    Location location,
  }) {
    final params = {
      'latlng': location,
      'place_id': placeId,
      'address': address != null ? Uri.encodeComponent(address) : null,
      'bounds': bounds,
      'language': language,
      'region': region,
      'components': components,
      'result_type': resultType,
      'location_type': locationType
    };

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url?${buildQuery(params)}';
  }

  GeocodingResponse _decode(Response res) =>
      GeocodingResponse.fromJson(json.decode(res.body));
}

class GeocodingResponse extends GoogleResponseList<GeocodingResult> {
  GeocodingResponse(
    String status,
    String errorMessage,
    List<GeocodingResult> results,
  ) : super(
          status,
          errorMessage,
          results,
        );

  factory GeocodingResponse.fromJson(Map json) => json != null
      ? GeocodingResponse(
          json['status'],
          json['error_message'],
          json['results']
              .map((r) {
                return GeocodingResult.fromJson(r);
              })
              .toList()
              .cast<GeocodingResult>())
      : null;

  @override
  Map<String, dynamic> toJson() {
    Map map = super.toJson();
    map['results'] = results?.map((r) {
      return r.toJson();
    })?.toList();
    return map;
  }
}

class GeocodingResult {
  final List<String> types;

  /// JSON formatted_address
  final String formattedAddress;

  /// JSON address_components
  final List<AddressComponent> addressComponents;

  /// JSON postcode_localities
  final List<String> postcodeLocalities;

  final Geometry geometry;

  /// JSON partial_match
  final bool partialMatch;

  /// JSON place_id
  final String placeId;

  GeocodingResult(
    this.types,
    this.formattedAddress,
    this.addressComponents,
    this.postcodeLocalities,
    this.geometry,
    this.partialMatch,
    this.placeId,
  );

  factory GeocodingResult.fromJson(Map json) => json != null
      ? GeocodingResult(
          (json['types'] as List)?.cast<String>(),
          json['formatted_address'],
          json['address_components']
              .map((addr) => AddressComponent.fromJson(addr))
              .toList()
              .cast<AddressComponent>(),
          (json['postcode_localities'] as List)?.cast<String>(),
          Geometry.fromJson(json['geometry']),
          json['partial_match'],
          json['place_id'],
        )
      : null;

  Map<String, dynamic> toJson() {
    return {
      'types': types,
      'formatted_address': formattedAddress,
      'address_components':
          addressComponents.map((addr) => addr.toJson()).toList(),
      'postcode_localities': postcodeLocalities,
      'geometry': geometry.toJson(),
      'partial_match': partialMatch,
      'place_id': placeId,
    };
  }
}

class StreetAddress {
  final Geometry geometry;
  final String addressLine;
  final String countryName;
  final String countryCode;
  final String featureName;
  final String postalCode;
  final String adminArea;
  final String subAdminArea;
  final String locality;
  final String subLocality;

  /// Route
  final String thoroughfare;

  /// Street Number
  final String subThoroughfare;

  StreetAddress(
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
  );

  factory StreetAddress.fromGeocodingResult(GeocodingResult geocodingResult) {
    if (geocodingResult == null ||
        !geocodingResult.types.contains('street_address')) return null;

    AddressComponent search(String type) {
      return geocodingResult.addressComponents.firstWhere(
        (component) => component.types.contains(type),
        orElse: () => null,
      );
    }

    final country = search('country');

    return StreetAddress(
      geocodingResult.geometry,
      geocodingResult.formattedAddress,
      country?.longName,
      country?.shortName,
      search('featureName')?.longName ?? geocodingResult.formattedAddress,
      search('postal_code')?.longName,
      search('administrative_area_level_1')?.longName,
      search('administrative_area_level_2')?.longName,
      search('locality')?.longName,
      (search('sublocality') ?? search('sublocality_level_1'))?.longName,
      search('route')?.longName,
      search('street_number')?.longName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geometry': geometry != null ? geometry.toJson() : null,
      'addressLine': addressLine,
      'countryName': countryName,
      'countryCode': countryCode,
      'featureName': featureName,
      'postalCode': postalCode,
      'adminArea': adminArea,
      'subAdminArea': subAdminArea,
      'locality': locality,
      'subLocality': subLocality,
      'thoroughfare': thoroughfare,
      'subThoroughfare': subThoroughfare,
    };
  }

  factory StreetAddress.fromJson(Map map) => map != null
      ? StreetAddress(
          Geometry.fromJson(map['geometry']),
          map['addressLine'],
          map['countryName'],
          map['countryCode'],
          map['featureName'],
          map['postalCode'],
          map['adminArea'],
          map['subAdminArea'],
          map['locality'],
          map['subLocality'],
          map['thoroughfare'],
          map['subThoroughfare'],
        )
      : null;
}
