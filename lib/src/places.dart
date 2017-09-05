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

  Future<PlacesSearchResponse> searchNearbyWithRadius(Location location, num radius,
      {String type,
        String keyword,
        String language,
        num minprice,
        num maxprice,
        String name}) async {
    String url = builNearbySearchUrl(
        location: location,
        language: language,
        radius: radius,
        type: type,
        keyword: keyword,
        minprice: minprice,
        maxprice: maxprice,
        name: name);
    Response res = await httpClient.get(url);
    return new PlacesSearchResponse.fromJson(JSON.decode(res.body));
  }

  Future<PlacesSearchResponse> searchNearbyWithRankBy(Location location,
      String rankby, {
        String type,
        String keyword,
        String language,
        num minprice,
        num maxprice,
        String name,
      }) async {
    String url = builNearbySearchUrl(
        location: location,
        language: language,
        type: type,
        keyword: keyword,
        minprice: minprice,
        maxprice: maxprice,
        name: name);
    Response res = await httpClient.get(url);
    return new PlacesSearchResponse.fromJson(JSON.decode(res.body));
  }

  String builNearbySearchUrl({Location location,
    num radius,
    String type,
    String keyword,
    String language,
    num minprice,
    num maxprice,
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
      "minprice": minprice,
      "maxprice": maxprice,
      "name": name,
      "rankby": rankby,
      "pagetoken": pagetoken
    };

    return "$url/nearbysearch/json?${buildQuery(params)}";
  }
}

class PlacesSearchResponse extends GoogleResponse<PlacesSearchResult> {
  /// JSON html_attributions
  final List<String> htmlAttributions;

  /// JSON next_page_token
  final String nextPageToken;

  PlacesSearchResponse(String status,
      String errorMessage,
      List<PlacesSearchResult> results,
      this.htmlAttributions,
      this.nextPageToken)
      : super(status, errorMessage, results);

  factory PlacesSearchResponse.fromJson(Map jsonMap) =>
      new PlacesSearchResponse(
          jsonMap["status"],
          jsonMap["error_message"],
          jsonMap["results"]
              .map((r) => new PlacesSearchResult.fromJson(r))
              .toList(),
          jsonMap["html_attributions"],
          jsonMap["next_page_token"]);
}

class PlacesSearchResult {
  PlacesSearchResult();

  factory PlacesSearchResult.fromJson(Map jsonMap) => new PlacesSearchResult();
}
