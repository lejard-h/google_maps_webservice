library google_maps_webservice.places.src;

import 'dart:async';
import 'dart:convert';
import 'package:google_maps_webservice/src/core.dart';
import 'package:http/http.dart';
import 'utils.dart';

const _placesUrl = "/place";
const _nearbySearchUrl = "/nearbysearch/json";
const _textSearchUrl = "/textsearch/json";
const _detailsSearchUrl = "/details/json";
const _autocompleteUrl = "/autocomplete/json";

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
    final url = buildNearbySearchUrl(
        location: location,
        language: language,
        radius: radius,
        type: type,
        keyword: keyword,
        minprice: minprice,
        maxprice: maxprice,
        name: name);
    return _decodeSearchResponse(await _doGet(url));
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
    final url = buildNearbySearchUrl(
        location: location,
        language: language,
        type: type,
        keyword: keyword,
        minprice: minprice,
        maxprice: maxprice,
        name: name);
    return _decodeSearchResponse(await _doGet(url));
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
    final url = buildTextSearchUrl(
        query: query,
        location: location,
        language: language,
        type: type,
        radius: radius,
        minprice: minprice,
        maxprice: maxprice,
        pagetoken: pagetoken,
        opennow: opennow);
    return _decodeSearchResponse(await _doGet(url));
  }

  Future<PlacesDetailsResponse> getDetailsByPlaceId(String placeId,
      {String extensions, String language}) async {
    final url = buildDetailsUrl(
        placeId: placeId, extensions: extensions, language: language);
    return _decodeDetailsResponse(await _doGet(url));
  }

  Future<PlacesDetailsResponse> getDetailsByReference(String reference,
      {String extensions, String language}) async {
    final url = buildDetailsUrl(
        reference: reference, extensions: extensions, language: language);
    return _decodeDetailsResponse(await _doGet(url));
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

    return "$url$_nearbySearchUrl?${buildQuery(params)}";
  }

  String buildTextSearchUrl(
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

    return "$url$_textSearchUrl?${buildQuery(params)}";
  }

  String buildDetailsUrl(
      {String placeId, String reference, String extensions, String language}) {
    if (placeId != null && reference != null) {
      throw new ArgumentError(
          "You must supply either 'placeid' or 'reference'");
    }

    final params = {
      "key": apiKey,
      "placeid": placeId,
      "reference": reference,
      "language": language,
      "extensions": extensions
    };

    return "$url$_detailsSearchUrl?${buildQuery(params)}";
  }

  String buildAutocompleteUrl(
      {String input,
      num offset,
      Location location,
      num radius,
      String language,
      List<String> types,
      List<Component> components,
      bool strictbounds}) {
    final params = {
      "key": apiKey,
      "input": input != null ? Uri.encodeComponent(input) : null,
      "language": language,
      "location": location,
      "radius": radius,
      "types": types,
      "components": components,
      "strictbounds": strictbounds,
      "offset": offset
    };

    return "$url$_autocompleteUrl?${buildQuery(params)}";
  }

  Future<Response> _doGet(String url) => httpClient.get(url);
  PlacesSearchResponse _decodeSearchResponse(Response res) =>
      new PlacesSearchResponse.fromJson(JSON.decode(res.body));

  PlacesDetailsResponse _decodeDetailsResponse(Response res) =>
      new PlacesDetailsResponse.fromJson(JSON.decode(res.body));
}

class PlacesSearchResponse extends GoogleResponseList<PlacesSearchResult> {
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

class PlaceDetails {
  /// JSON address_components
  final List<AddressComponent> addressComponents;

  /// JSON adr_address
  final String adrAddress;

  /// JSON formatted_address
  final String formattedAddress;

  /// JSON formatted_phone_number
  final String formattedPhoneNumber;

  final String id;

  final String reference;

  final String icon;

  final String name;

  /// JSON place_id
  final String placeId;

  /// JSON international_phone_number
  final String internationalPhoneNumber;

  final num rating;

  final String scope;

  final List<String> types;

  final String url;

  final String vicinity;

  /// JSON utc_offset
  final num utcOffset;

  final String website;

  final List<Review> reviews;

  PlaceDetails(
      this.addressComponents,
      this.adrAddress,
      this.formattedAddress,
      this.formattedPhoneNumber,
      this.id,
      this.reference,
      this.icon,
      this.name,
      this.placeId,
      this.internationalPhoneNumber,
      this.rating,
      this.scope,
      this.types,
      this.url,
      this.vicinity,
      this.utcOffset,
      this.website,
      this.reviews);

  factory PlaceDetails.fromJson(Map json) => json != null
      ? new PlaceDetails(
          json["address_components"]
              .map((addr) => new AddressComponent.fromJson(addr))
              .toList(),
          json["adr_address"],
          json["formatted_address"],
          json["formatted_phone_number"],
          json["id"],
          json["reference"],
          json["icon"],
          json["name"],
          json["place_id"],
          json["international_phone_number"],
          json["rating"],
          json["scope"],
          json["types"],
          json["url"],
          json["vicinity"],
          json["utc_offset"],
          json["website"],
          json["reviews"].map((r) => new Review.fromJson(r)).toList(),
        )
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

class PlacesDetailsResponse extends GoogleResponse<PlaceDetails> {
  /// JSON html_attributions
  final List<String> htmlAttributions;

  PlacesDetailsResponse(String status, String errorMessage, PlaceDetails result,
      this.htmlAttributions)
      : super(status, errorMessage, result);

  factory PlacesDetailsResponse.fromJson(Map json) => json != null
      ? new PlacesDetailsResponse(json["status"], json["error_message"],
          new PlaceDetails.fromJson(json["result"]), json["html_attributions"])
      : null;
}

class Review {
  /// JSON author_name
  final String authorName;

  /// JSON author_url
  final String authorUrl;

  final String language;

  /// JSON profile_photo_url
  final String profilePhotoUrl;

  final num rating;

  /// JSON relative_time_description
  final String relativeTimeDescription;

  final String text;

  final num time;

  Review(this.authorName, this.authorUrl, this.language, this.profilePhotoUrl,
      this.rating, this.relativeTimeDescription, this.text, this.time);

  factory Review.fromJson(Map json) => json != null
      ? new Review(
          json["author_name"],
          json["author_url"],
          json["language"],
          json["profile_photo_url"],
          json["rating"],
          json["relative_time_description"],
          json["text"],
          json["time"])
      : null;
}

class PlacesAutocompleteResponse extends GoogleResponseStatus {
  final List<Prediction> predictions;

  PlacesAutocompleteResponse(
      String status, String errorMessage, this.predictions)
      : super(status, errorMessage);

  factory PlacesAutocompleteResponse.fromJson(Map json) => json != null
      ? new PlacesAutocompleteResponse(json["status"], json["error_message"],
          json["predictions"].map((p) => new Prediction.fromJson(p)).toList())
      : null;
}

class Prediction {
  final String description;
  final String id;
  final List<Term> terms;

  /// JSON place_id
  final String placeId;
  final String reference;
  final List<String> types;

  /// JSON matched_substrings
  final List<MatchedSubstrings> matchedSubstrings;

  Prediction(this.description, this.id, this.terms, this.placeId,
      this.reference, this.types, this.matchedSubstrings);

  factory Prediction.fromJson(Map json) => json != null
      ? new Prediction(
          json["description"],
          json["id"],
          json["terms"]?.map((t) => new Term.fromJson(t))?.toList(),
          json["place_id"],
          json["reference"],
          json["types"],
          json["matched_substrings"]
              ?.map((m) => new MatchedSubstrings.fromJson(m))
              ?.toList())
      : null;
}

class Term {
  final num offset;
  final String value;

  Term(this.offset, this.value);

  factory Term.fromJson(Map json) =>
      json != null ? new Term(json["offset"], json["value"]) : null;
}

class MatchedSubstrings {
  final num offset;
  final num length;

  MatchedSubstrings(this.offset, this.length);

  factory MatchedSubstrings.fromJson(Map json) => json != null
      ? new MatchedSubstrings(json["offset"], json["length"])
      : null;
}
