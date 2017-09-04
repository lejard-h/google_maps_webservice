library google_maps_webservice.geocoding.src;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'utils.dart';

const _geocodeUrl = "$kGMapsUrl/geocode/json";

class GoogleMapsGeocoding {
  final Client _httpClient;
  final String _url;

  GoogleMapsGeocoding(String apiKey, [Client httpClient])
      : _url = "$_geocodeUrl?key=${apiKey}",
        _httpClient = httpClient ?? new Client();

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

    Response res = await _httpClient.get(url);
    return new GeocodingResponse.fromJson(JSON.decode(res.body));
  }

  Future<GeocodingResponse> searchByComponents(List<Component> components,
      {Bounds bounds, String language, String region}) async {
    String url = buildUrl(
        bounds: bounds,
        language: language,
        region: region,
        components: components);

    Response res = await _httpClient.get(url);
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
    Response res = await _httpClient.get(url);
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
    Response res = await _httpClient.get(url);
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
    String url = _addAddress(_url, address);
    url = _addComponents(url, components);
    url = _addBounds(url, bounds);
    url = _addLanguage(url, language);
    url = _addRegion(url, region);
    url = _addResultType(url, resultType);
    url = _addLocationType(url, locationType);
    url = _addPlaceId(url, placeId);
    url = _addLocation(url, location);
    return url;
  }

  String _addLocation(String url, Location location) =>
      location == null ? url : "$url&latlng=${location.lat},${location.lng}";

  String _addPlaceId(String url, String placeId) =>
      placeId == null ? url : "$url&place_id=$placeId";

  String _addAddress(String url, String address) =>
      address == null ? url : "$url&address=${Uri.encodeComponent(address)}";

  String _addBounds(String url, Bounds bounds) => bounds == null
      ? url
      : "$url&bounds=${bounds.northeast.lat},${bounds.northeast.lng}|${bounds.southwest.lat},${bounds.southwest
          .lng}";

  String _addLanguage(String url, String lang) =>
      lang == null ? url : "$url&language=$lang";

  String _addRegion(String url, String region) =>
      region == null ? url : "$url&region=$region";

  String _addComponents(String url, List<Component> components) =>
      components == null || components.isEmpty
          ? url
          : "$url&components=${components.map((c) => c.toParam()).join("|")}";

  String _addResultType(String url, List<String> resultType) =>
      resultType == null || resultType.isEmpty
          ? url
          : "$url&result_type=${resultType.join("|")}";

  String _addLocationType(String url, List<String> locationType) =>
      locationType == null || locationType.isEmpty
          ? url
          : "$url&location_type=${locationType.join("|")}";
}

class GeocodingResponse {
  static const statusOkay = "OK";
  static const statusZeroResults = "ZERO_RESULTS";
  static const statusOverQueryLimit = "OVER_QUERY_LIMIT";
  static const statusRequestDenied = "REQUEST_DENIED";
  static const statusInvalidRequest = "INVALID_REQUEST";
  static const statusUnknownError = "UNKNOWN_ERROR";

  final String status;

  /// JSON error_message
  final String errorMessage;

  final List<GeocodingResult> results;

  GeocodingResponse(this.status, this.errorMessage, this.results);

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

class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map jsonMap) =>
      new Location(jsonMap["lat"], jsonMap["lng"]);
}

class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds(this.northeast, this.southwest);

  factory Bounds.fromJson(Map jsonMap) => new Bounds(
      new Location.fromJson(jsonMap["northeast"]),
      new Location.fromJson(jsonMap["southwest"]));
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

  String toParam() => "$component:${Uri.encodeComponent(value)}";
}
