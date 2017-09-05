library google_maps_webservice.geocoding.src;

import 'dart:async';
import 'dart:convert';
import 'package:google_maps_webservice/src/core.dart';
import 'package:http/http.dart';
import 'utils.dart';

const _geocodeUrl = "/geocode/json";

/// https://developers.google.com/maps/documentation/geocoding/start
class GoogleMapsGeocoding extends GoogleWebService {
  GoogleMapsGeocoding(String apiKey, [Client httpClient])
      : super(apiKey, _geocodeUrl, httpClient);

  Future<GeocodingResponse> searchByAddress(String address,
      {Bounds bounds,
      String language,
      String region,
      List<Component> components}) async {
    final url = buildUrl(
        address: address,
        bounds: bounds,
        language: language,
        region: region,
        components: components);
    return _decode(await _doGet(url));
  }

  Future<GeocodingResponse> searchByComponents(List<Component> components,
      {Bounds bounds, String language, String region}) async {
    final url = buildUrl(
        bounds: bounds,
        language: language,
        region: region,
        components: components);
    return _decode(await _doGet(url));
  }

  Future<GeocodingResponse> searchByLocation(Location location,
      {String language,
      List<String> resultType,
      List<String> locationType}) async {
    final url = buildUrl(
        location: location,
        language: language,
        resultType: resultType,
        locationType: locationType);
    return _decode(await _doGet(url));
  }

  Future<GeocodingResponse> searchByPlaceId(String placeId,
      {String language,
      List<String> resultType,
      List<String> locationType}) async {
    final url = buildUrl(
        placeId: placeId,
        language: language,
        resultType: resultType,
        locationType: locationType);
    return _decode(await _doGet(url));
  }

  String buildUrl(
      {String address,
      Bounds bounds,
      String language,
      String region,
      List<Component> components,
      List<String> resultType,
      List<String> locationType,
      String placeId,
      Location location}) {
    final params = {
      "key": apiKey,
      "latlng": location,
      "place_id": placeId,
      "address": address != null ? Uri.encodeComponent(address) : null,
      "bounds": bounds,
      "language": language,
      "region": region,
      "components": components,
      "result_type": resultType,
      "location_type": locationType
    };

    return "$url?${buildQuery(params)}";
  }

  GeocodingResponse _decode(Response res) =>
      new GeocodingResponse.fromJson(JSON.decode(res.body));
  Future<Response> _doGet(String url) => httpClient.get(url);
}

class GeocodingResponse extends GoogleResponseList<GeocodingResult> {
  GeocodingResponse(
      String status, String errorMessage, List<GeocodingResult> results)
      : super(status, errorMessage, results);

  factory GeocodingResponse.fromJson(Map json) => json != null
      ? new GeocodingResponse(
          json["status"],
          json["error_message"],
          json["results"].map((r) {
            return new GeocodingResult.fromJson(r);
          }).toList())
      : null;
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
  final String partialMatch;

  /// JSON place_id
  final placeId;

  GeocodingResult(this.types, this.formattedAddress, this.addressComponents,
      this.postcodeLocalities, this.geometry, this.partialMatch, this.placeId);

  factory GeocodingResult.fromJson(Map json) => json != null
      ? new GeocodingResult(
          json["types"],
          json["formatted_address"],
          json["address_components"]
              .map((addr) => new AddressComponent.fromJson(addr))
              .toList(),
          json["postcode_localities"],
          new Geometry.fromJson(json["geometry"]),
          json["partial_match"],
          json["place_id"])
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
