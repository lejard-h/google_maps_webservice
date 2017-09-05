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
    String url = buildUrl(
        address: address,
        bounds: bounds,
        language: language,
        region: region,
        components: components);

    Response res = await httpClient.get(url);
    return new GeocodingResponse.fromJson(JSON.decode(res.body));
  }

  Future<GeocodingResponse> searchByComponents(List<Component> components,
      {Bounds bounds, String language, String region}) async {
    String url = buildUrl(
        bounds: bounds,
        language: language,
        region: region,
        components: components);

    Response res = await httpClient.get(url);
    return new GeocodingResponse.fromJson(JSON.decode(res.body));
  }

  Future<GeocodingResponse> searchByLocation(Location location,
      {String language,
      List<String> resultType,
      List<String> locationType}) async {
    String url = buildUrl(
        location: location,
        language: language,
        resultType: resultType,
        locationType: locationType);
    Response res = await httpClient.get(url);
    return new GeocodingResponse.fromJson(JSON.decode(res.body));
  }

  Future<GeocodingResponse> searchByPlaceId(String placeId,
      {String language,
      List<String> resultType,
      List<String> locationType}) async {
    String url = buildUrl(
        placeId: placeId,
        language: language,
        resultType: resultType,
        locationType: locationType);
    Response res = await httpClient.get(url);
    return new GeocodingResponse.fromJson(JSON.decode(res.body));
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
}

class GeocodingResponse extends GoogleResponse<GeocodingResult> {
  GeocodingResponse(
      String status, String errorMessage, List<GeocodingResult> results)
      : super(status, errorMessage, results);

  factory GeocodingResponse.fromJson(Map jsonMap) => new GeocodingResponse(
      jsonMap["status"],
      jsonMap["error_message"],
      jsonMap["results"].map((r) => new GeocodingResult.fromJson(r)).toList());
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

  factory GeocodingResult.fromJson(Map jsonMap) => new GeocodingResult(
      jsonMap["types"],
      jsonMap["formatted_address"],
      jsonMap["address_components"]
          .map((addr) => new AddressComponent.fromJson(addr))
          .toList(),
      jsonMap["postcode_localities"],
      new Geometry.fromJson(jsonMap["geometry"]),
      jsonMap["partial_match"],
      jsonMap["place_id"]);
}

class AddressComponent {
  final List<String> types;

  /// JSON long_name
  final String longName;

  /// JSON short_name
  final String shortName;

  AddressComponent(this.types, this.longName, this.shortName);

  factory AddressComponent.fromJson(Map jsonMap) => new AddressComponent(
      jsonMap["types"], jsonMap["long_name"], jsonMap["short_name"]);
}

class Geometry {
  final Location location;

  /// JSON location_type
  final String locationType;

  final Bounds viewport;

  final Bounds bounds;

  Geometry(this.location, this.locationType, this.viewport, this.bounds);

  factory Geometry.fromJson(Map jsonMap) => new Geometry(
      new Location.fromJson(jsonMap["location"]),
      jsonMap["location_type"],
      new Bounds.fromJson(jsonMap["viewport"]),
      new Bounds.fromJson(jsonMap["bounds"]));
}

class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds(this.northeast, this.southwest);

  factory Bounds.fromJson(Map jsonMap) => new Bounds(
      new Location.fromJson(jsonMap["northeast"]),
      new Location.fromJson(jsonMap["southwest"]));

  String toString() =>
      "${northeast.lat},${northeast.lng}|${southwest.lat},${southwest.lng}";
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
