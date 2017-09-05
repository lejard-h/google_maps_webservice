library google_maps_webservice.places.src;

import 'dart:async';
import 'dart:convert';
import 'package:google_maps_webservice/src/core.dart';
import 'package:http/http.dart';
import 'utils.dart';

const _placesUrl = "/place";

/// https://developers.google.com/places/web-service/
class GoogleMapsPlaces extends GoogleWebService {
  GoogleMapsPlaces(String apiKey, [Client httpClient])
      : super(apiKey, _placesUrl, httpClient);

  Future<PlacesSearchResponse> searchNearbyWithRadius(
      Location location, num radius,
      {String type,
      String keyword,
      String language,
      PriceLevel minprice,
      PriceLevel maxprice,
      String name}) async {
    String url = buildNearbySearchUrl(
        location: location,
        language: language,
        radius: radius,
        type: type,
        keyword: keyword,
        minprice: minprice,
        maxprice: maxprice,
        name: name);
    return _decode(await _doGet(url));
  }

  Future<PlacesSearchResponse> searchNearbyWithRankBy(
    Location location,
    String rankby, {
    String type,
    String keyword,
    String language,
    PriceLevel minprice,
    PriceLevel maxprice,
    String name,
  }) async {
    String url = buildNearbySearchUrl(
        location: location,
        language: language,
        type: type,
        keyword: keyword,
        minprice: minprice,
        maxprice: maxprice,
        name: name);
    return _decode(await _doGet(url));
  }

  Future<PlacesSearchResponse> searchByText(String query,
      {Location location,
      num radius,
      PriceLevel minprice,
      PriceLevel maxprice,
      bool opennow,
      String type,
      String pagetoken,
      String language}) async {
    String url = buildTextSearchUrl(
        query: query,
        location: location,
        language: language,
        type: type,
        radius: radius,
        minprice: minprice,
        maxprice: maxprice,
        pagetoken: pagetoken,
        opennow: opennow);
    return _decode(await _doGet(url));
  }

  String buildNearbySearchUrl(
      {Location location,
      num radius,
      String type,
      String keyword,
      String language,
      PriceLevel minprice,
      PriceLevel maxprice,
      String name,
      String rankby,
      String pagetoken}) {
    if (radius != null && rankby != null) {
      throw new ArgumentError(
          "'rankby' must not be included if 'radius' is specified.");
    }

    if (rankby == "distance" &&
        keyword == null &&
        type == null &&
        name == null) {
      throw new ArgumentError(
          "If 'rankby=distance' is specified, then one or more of 'keyword', 'name', or 'type' is required.");
    }

    final params = {
      "key": apiKey,
      "location": location,
      "radius": radius,
      "language": language,
      "type": type,
      "keyword": keyword,
      "minprice": minprice?.index,
      "maxprice": maxprice?.index,
      "name": name,
      "rankby": rankby,
      "pagetoken": pagetoken
    };

    return "$url/nearbysearch/json?${buildQuery(params)}";
  }

  buildTextSearchUrl(
      {String query,
      Location location,
      num radius,
      PriceLevel minprice,
      PriceLevel maxprice,
      bool opennow,
      String type,
      String pagetoken,
      String language}) {
    final params = {
      "key": apiKey,
      "query": query != null ? Uri.encodeComponent(query) : null,
      "language": language,
      "location": location,
      "radius": radius,
      "minprice": minprice?.index,
      "maxprice": maxprice?.index,
      "opennow": opennow,
      "type": type,
      "pagetoken": pagetoken
    };

    return "$url/textsearch/json?${buildQuery(params)}";
  }

  Future<Response> _doGet(String url) => httpClient.get(url);
  PlacesSearchResponse _decode(Response res) =>
      new PlacesSearchResponse.fromJson(JSON.decode(res.body));
}

class PlacesSearchResponse extends GoogleResponse<PlacesSearchResult> {
  /// JSON html_attributions
  final List<String> htmlAttributions;

  /// JSON next_page_token
  final String nextPageToken;

  PlacesSearchResponse(
      String status,
      String errorMessage,
      List<PlacesSearchResult> results,
      this.htmlAttributions,
      this.nextPageToken)
      : super(status, errorMessage, results);

  factory PlacesSearchResponse.fromJson(Map json) => json != null
      ? new PlacesSearchResponse(
          json["status"],
          json["error_message"],
          json["results"]
              .map((r) => new PlacesSearchResult.fromJson(r))
              .toList(),
          json["html_attributions"],
          json["next_page_token"])
      : null;
}

class PlacesSearchResult {
  final String icon;
  final Geometry geometry;
  final String name;

  /// JSON opening_hours
  final OpeningHours openingHours;

  final List<Photo> photos;

  /// JSON place_id
  final String placeId;

  final String scope;

  /// JSON alt_ids
  final List<AlternativeId> altIds;

  /// JSON price_level
  final PriceLevel priceLevel;

  final num rating;

  final List<String> types;

  final String vicinity;

  /// JSON formatted_address
  final String formattedAddress;

  /// JSON permanently_closed
  final bool permanentlyClosed;

  final String id;

  final String reference;

  PlacesSearchResult(
      this.icon,
      this.geometry,
      this.name,
      this.openingHours,
      this.photos,
      this.placeId,
      this.scope,
      this.altIds,
      this.priceLevel,
      this.rating,
      this.types,
      this.vicinity,
      this.formattedAddress,
      this.permanentlyClosed,
      this.id,
      this.reference);

  factory PlacesSearchResult.fromJson(Map json) => json != null
      ? new PlacesSearchResult(
          json["icon"],
          new Geometry.fromJson(json["geometry"]),
          json["name"],
          new OpeningHours.fromJson(json["opening_hours"]),
          json["photos"]?.map((p) => new Photo.fromJson(p))?.toList(),
          json["place_id"],
          json["scope"],
          json["alt_ids"]?.map((a) => new AlternativeId.fromJson(a))?.toList(),
          json["price_level"] != null
              ? PriceLevel.values.elementAt(json["price_level"])
              : null,
          json["rating"],
          json["types"],
          json["vicinity"],
          json["formatted_address"],
          json["permanently_closed"],
          json["id"],
          json["reference"])
      : null;
}

class OpeningHours {
  /// JSON open_now
  final bool openNow;

  OpeningHours(this.openNow);

  factory OpeningHours.fromJson(Map json) =>
      json != null ? new OpeningHours(json["open_now"]) : null;
}

class Photo {
  /// JSON photo_reference
  final String photoReference;
  final num height;
  final num width;

  /// JSON html_attributions
  final List<String> htmlAttributions;

  Photo(this.photoReference, this.height, this.width, this.htmlAttributions);

  factory Photo.fromJson(Map json) => json != null
      ? new Photo(json["photo_reference"], json["height"], json["width"],
          json["html_attributions"])
      : null;
}

class AlternativeId {
  /// JSON place_id
  final String placeId;

  final String scope;

  AlternativeId(this.placeId, this.scope);

  factory AlternativeId.fromJson(Map json) =>
      json != null ? new AlternativeId(json["place_id"], json["scope"]) : null;
}

enum PriceLevel { free, inexpensive, moderate, expensive, veryExpensive }
