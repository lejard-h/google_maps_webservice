import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import 'core.dart';
import 'utils.dart';

part 'places.g.dart';

const _placesUrl = '/place';
const _nearbySearchUrl = '/nearbysearch/json';
const _textSearchUrl = '/textsearch/json';
const _detailsSearchUrl = '/details/json';
const _autocompleteUrl = '/autocomplete/json';
const _photoUrl = '/photo';
const _queryAutocompleteUrl = '/queryautocomplete/json';

/// https://developers.google.com/places/web-service/
class GoogleMapsPlaces extends GoogleWebService {
  GoogleMapsPlaces({
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          apiPath: _placesUrl,
          httpClient: httpClient,
          apiHeaders: apiHeaders,
        );

  Future<PlacesSearchResponse> searchNearbyWithRadius(
    Location location,
    num radius, {
    String? type,
    String? keyword,
    String? language,
    PriceLevel? minprice,
    PriceLevel? maxprice,
    String? name,
    String? pagetoken,
  }) async {
    final url = buildNearbySearchUrl(
      location: location,
      language: language,
      radius: radius,
      type: type,
      keyword: keyword,
      minprice: minprice,
      maxprice: maxprice,
      name: name,
      pagetoken: pagetoken,
    );
    return _decodeSearchResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesSearchResponse> searchNearbyWithRankBy(
    Location location,
    String rankby, {
    String? type,
    String? keyword,
    String? language,
    PriceLevel? minprice,
    PriceLevel? maxprice,
    String? name,
    String? pagetoken,
  }) async {
    final url = buildNearbySearchUrl(
      location: location,
      language: language,
      type: type,
      rankby: rankby,
      keyword: keyword,
      minprice: minprice,
      maxprice: maxprice,
      name: name,
      pagetoken: pagetoken,
    );
    return _decodeSearchResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesSearchResponse> searchByText(
    String query, {
    Location? location,
    num? radius,
    PriceLevel? minprice,
    PriceLevel? maxprice,
    bool opennow = false,
    String? type,
    String? pagetoken,
    String? language,
    String? region,
  }) async {
    final url = buildTextSearchUrl(
      query: query,
      location: location,
      language: language,
      region: region,
      type: type,
      radius: radius,
      minprice: minprice,
      maxprice: maxprice,
      pagetoken: pagetoken,
      opennow: opennow,
    );
    return _decodeSearchResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesDetailsResponse> getDetailsByPlaceId(
    String placeId, {
    String? sessionToken,
    List<String> fields = const [],
    String? language,
    String? region,
  }) async {
    final url = buildDetailsUrl(
      placeId: placeId,
      sessionToken: sessionToken,
      fields: fields,
      language: language,
      region: region,
    );
    return _decodeDetailsResponse(await doGet(url, headers: apiHeaders));
  }

  @deprecated
  Future<PlacesDetailsResponse> getDetailsByReference(
    String reference, {
    String? sessionToken,
    List<String> fields = const [],
    String? language,
  }) async {
    final url = buildDetailsUrl(
      reference: reference,
      sessionToken: sessionToken,
      fields: fields,
      language: language,
    );
    return _decodeDetailsResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesAutocompleteResponse> autocomplete(
    String input, {
    String? sessionToken,
    num? offset,
    Location? origin,
    Location? location,
    num? radius,
    String? language,
    List<String> types = const [],
    List<Component> components = const [],
    bool strictbounds = false,
    String? region,
  }) async {
    final url = buildAutocompleteUrl(
      sessionToken: sessionToken,
      input: input,
      origin: origin,
      location: location,
      offset: offset,
      radius: radius,
      language: language,
      types: types,
      components: components,
      strictbounds: strictbounds,
      region: region,
    );
    return _decodeAutocompleteResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesAutocompleteResponse> queryAutocomplete(
    String input, {
    num? offset,
    Location? location,
    num? radius,
    String? language,
  }) async {
    final url = buildQueryAutocompleteUrl(
      input: input,
      location: location,
      offset: offset,
      radius: radius,
      language: language,
    );
    return _decodeAutocompleteResponse(await doGet(url, headers: apiHeaders));
  }

  String buildNearbySearchUrl({
    Location? location,
    num? radius,
    String? type,
    String? keyword,
    String? language,
    PriceLevel? minprice,
    PriceLevel? maxprice,
    String? name,
    String? rankby,
    String? pagetoken,
  }) {
    if (radius != null && rankby != null) {
      throw ArgumentError(
          "'rankby' must not be included if 'radius' is specified.");
    }

    if (rankby == 'distance' &&
        keyword == null &&
        type == null &&
        name == null) {
      throw ArgumentError(
          "If 'rankby=distance' is specified, then one or more of 'keyword', 'name', or 'type' is required.");
    }

    final params = <String, String>{};

    if (location != null) {
      params['location'] = location.toString();
    }

    if (keyword != null) {
      params['keyword'] = keyword;
    }

    if (name != null) {
      params['name'] = name;
    }

    if (rankby != null) {
      params['rankby'] = rankby;
    }

    if (minprice != null) {
      params['minprice'] = minprice.index.toString();
    }

    if (maxprice != null) {
      params['maxprice'] = maxprice.index.toString();
    }

    if (type != null) {
      params['type'] = type;
    }

    if (pagetoken != null) {
      params['pagetoken'] = pagetoken;
    }

    if (language != null) {
      params['language'] = language;
    }

    if (radius != null) {
      params['radius'] = radius.toString();
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }
    return url
        .replace(
          path: '${url.path}$_nearbySearchUrl',
          queryParameters: params,
        )
        .toString();
  }

  String buildTextSearchUrl({
    required String query,
    Location? location,
    num? radius,
    PriceLevel? minprice,
    PriceLevel? maxprice,
    bool opennow = false,
    String? type,
    String? pagetoken,
    String? language,
    String? region,
  }) {
    final params = <String, String>{
      'query': query,
    };

    if (minprice != null) {
      params['minprice'] = minprice.index.toString();
    }

    if (maxprice != null) {
      params['maxprice'] = maxprice.index.toString();
    }

    if (opennow) {
      params['opennow'] = opennow.toString();
    }

    if (type != null) {
      params['type'] = type;
    }

    if (pagetoken != null) {
      params['pagetoken'] = pagetoken;
    }

    if (language != null) {
      params['language'] = language;
    }

    if (region != null) {
      params['region'] = region;
    }

    if (location != null) {
      params['location'] = location.toString();
    }

    if (radius != null) {
      params['radius'] = radius.toString();
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url
        .replace(
          path: '${url.path}$_textSearchUrl',
          queryParameters: params,
        )
        .toString();
  }

  String buildDetailsUrl({
    String? placeId,
    String? reference,
    String? sessionToken,
    String? language,
    List<String> fields = const [],
    String? region,
  }) {
    if (placeId != null && reference != null) {
      throw ArgumentError("You must supply either 'placeid' or 'reference'");
    }

    final params = <String, String>{};

    if (placeId != null) {
      params['placeid'] = placeId;
    }

    if (reference != null) {
      params['reference'] = reference;
    }

    if (language != null) {
      params['language'] = language;
    }

    if (region != null) {
      params['region'] = region;
    }

    if (fields.isNotEmpty) {
      params['fields'] = fields.join(',');
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    return url
        .replace(
          path: '${url.path}$_detailsSearchUrl',
          queryParameters: params,
        )
        .toString();
  }

  String buildAutocompleteUrl({
    required String input,
    String? sessionToken,
    num? offset,
    Location? origin,
    Location? location,
    num? radius,
    String? language,
    List<String> types = const [],
    List<Component> components = const [],
    bool strictbounds = false,
    String? region,
  }) {
    final params = <String, String>{
      'input': input,
    };

    if (language != null) {
      params['language'] = language;
    }

    if (origin != null) {
      params['origin'] = origin.toString();
    }

    if (location != null) {
      params['location'] = location.toString();
    }

    if (radius != null) {
      params['radius'] = radius.toString();
    }

    if (types.isNotEmpty) {
      params['types'] = types.join('|');
    }

    if (components.isNotEmpty) {
      params['components'] = components.join('|');
    }

    if (strictbounds) {
      params['strictbounds'] = strictbounds.toString();
    }

    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (region != null) {
      params['region'] = region;
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    return url
        .replace(
          path: '${url.path}$_autocompleteUrl',
          queryParameters: params,
        )
        .toString();
  }

  String buildQueryAutocompleteUrl({
    required String input,
    num? offset,
    Location? location,
    num? radius,
    String? language,
  }) {
    final params = <String, String>{
      'input': input,
    };

    if (language != null) {
      params['language'] = language;
    }

    if (location != null) {
      params['location'] = location.toString();
    }

    if (radius != null) {
      params['radius'] = radius.toString();
    }

    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url
        .replace(
          path: '${url.path}$_queryAutocompleteUrl',
          queryParameters: params,
        )
        .toString();
  }

  String buildPhotoUrl({
    required String photoReference,
    int? maxWidth,
    int? maxHeight,
  }) {
    if (maxWidth == null && maxHeight == null) {
      throw ArgumentError("You must supply 'maxWidth' or 'maxHeight'");
    }

    final params = <String, String>{
      'photoreference': photoReference,
    };

    if (maxWidth != null) {
      params['maxwidth'] = maxWidth.toString();
    }

    if (maxHeight != null) {
      params['maxheight'] = maxHeight.toString();
    }

    if (apiKey != null) {
      params['key'] = apiKey!;
    }

    return url
        .replace(
          path: '${url.path}$_photoUrl',
          queryParameters: params,
        )
        .toString();
  }

  PlacesSearchResponse _decodeSearchResponse(Response res) =>
      PlacesSearchResponse.fromJson(json.decode(res.body));

  PlacesDetailsResponse _decodeDetailsResponse(Response res) =>
      PlacesDetailsResponse.fromJson(json.decode(res.body));

  PlacesAutocompleteResponse _decodeAutocompleteResponse(Response res) =>
      PlacesAutocompleteResponse.fromJson(json.decode(res.body));
}

@JsonSerializable()
class PlacesSearchResponse extends GoogleResponseStatus {
  @JsonKey(defaultValue: [])
  final List<PlacesSearchResult> results;

  /// JSON html_attributions
  @JsonKey(defaultValue: [])
  final List<String> htmlAttributions;

  /// JSON next_page_token
  final String? nextPageToken;

  PlacesSearchResponse({
    required String status,
    String? errorMessage,
    this.results = const [],
    this.htmlAttributions = const [],
    this.nextPageToken,
  }) : super(status: status, errorMessage: errorMessage);

  factory PlacesSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PlacesSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesSearchResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class PlacesSearchResult {
  final String? icon;
  final Geometry? geometry;
  final String name;

  /// JSON opening_hours
  final OpeningHoursDetail? openingHours;

  @JsonKey(defaultValue: [])
  final List<Photo> photos;

  /// JSON place_id
  final String placeId;

  final String? scope;

  /// JSON alt_ids
  @JsonKey(defaultValue: [])
  final List<AlternativeId> altIds;

  /// JSON price_level
  final PriceLevel? priceLevel;

  final num? rating;

  @JsonKey(defaultValue: [])
  final List<String> types;

  final String? vicinity;

  /// JSON formatted_address
  final String? formattedAddress;

  /// JSON permanently_closed
  @JsonKey(defaultValue: false)
  final bool permanentlyClosed;

  final String? id;

  final String reference;

  PlacesSearchResult({
    this.id,
    required this.reference,
    required this.name,
    required this.placeId,
    this.formattedAddress,
    this.photos = const [],
    this.altIds = const [],
    this.types = const [],
    this.permanentlyClosed = false,
    this.icon,
    this.geometry,
    this.openingHours,
    this.scope,
    this.priceLevel,
    this.rating,
    this.vicinity,
  });

  factory PlacesSearchResult.fromJson(Map<String, dynamic> json) =>
      _$PlacesSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesSearchResultToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class PlaceDetails {
  /// JSON address_components
  @JsonKey(defaultValue: <AddressComponent>[])
  final List<AddressComponent> addressComponents;

  /// JSON adr_address
  final String? adrAddress;

  /// JSON formatted_address
  final String? formattedAddress;

  /// JSON formatted_phone_number
  final String? formattedPhoneNumber;

  final String? id;

  final String? reference;

  final String? icon;

  final String name;

  /// JSON opening_hours
  final OpeningHoursDetail? openingHours;

  @JsonKey(defaultValue: <Photo>[])
  final List<Photo> photos;

  /// JSON place_id
  final String placeId;

  /// JSON international_phone_number
  final String? internationalPhoneNumber;

  /// JSON price_level
  final PriceLevel? priceLevel;

  final num? rating;

  final String? scope;

  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  final String? url;

  final String? vicinity;

  /// JSON utc_offset
  final num? utcOffset;

  final String? website;

  @JsonKey(defaultValue: <Review>[])
  final List<Review> reviews;

  final Geometry? geometry;

  PlaceDetails({
    this.adrAddress,
    required this.name,
    required this.placeId,
    this.utcOffset,
    this.id,
    this.internationalPhoneNumber,
    this.addressComponents = const [],
    this.photos = const [],
    this.types = const [],
    this.reviews = const [],
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.reference,
    this.icon,
    this.rating,
    this.openingHours,
    this.priceLevel,
    this.scope,
    this.url,
    this.vicinity,
    this.website,
    this.geometry,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceDetailsToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class OpeningHoursDetail {
  @JsonKey(defaultValue: false)
  final bool openNow;

  @JsonKey(defaultValue: <OpeningHoursPeriod>[])
  final List<OpeningHoursPeriod> periods;

  @JsonKey(defaultValue: <String>[])
  final List<String> weekdayText;

  OpeningHoursDetail({
    this.openNow = false,
    this.periods = const <OpeningHoursPeriod>[],
    this.weekdayText = const <String>[],
  });

  factory OpeningHoursDetail.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursDetailFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursDetailToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class OpeningHoursPeriodDate {
  final int day;
  final String time;

  /// UTC Time
  @Deprecated('use `toDateTime()`')
  DateTime get dateTime => toDateTime();

  DateTime toDateTime() => dayTimeToDateTime(day, time);

  OpeningHoursPeriodDate({required this.day, required this.time});

  factory OpeningHoursPeriodDate.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursPeriodDateFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursPeriodDateToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class OpeningHoursPeriod {
  final OpeningHoursPeriodDate? open;
  final OpeningHoursPeriodDate? close;

  OpeningHoursPeriod({this.open, this.close});

  factory OpeningHoursPeriod.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursPeriodToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Photo {
  /// JSON photo_reference
  final String photoReference;
  final num height;
  final num width;

  /// JSON html_attributions
  @JsonKey(defaultValue: <String>[])
  final List<String> htmlAttributions;

  Photo({
    required this.photoReference,
    required this.height,
    required this.width,
    this.htmlAttributions = const <String>[],
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class AlternativeId {
  /// JSON place_id
  final String placeId;

  final String scope;

  AlternativeId({required this.placeId, required this.scope});

  factory AlternativeId.fromJson(Map<String, dynamic> json) =>
      _$AlternativeIdFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativeIdToJson(this);

  @override
  String toString() => toJson().toString();
}

enum PriceLevel {
  @JsonValue(0)
  free,

  @JsonValue(1)
  inexpensive,

  @JsonValue(2)
  moderate,

  @JsonValue(3)
  expensive,

  @JsonValue(4)
  veryExpensive,
}

@JsonSerializable()
class PlacesDetailsResponse extends GoogleResponseStatus {
  final PlaceDetails result;

  /// JSON html_attributions
  @JsonKey(defaultValue: <String>[])
  final List<String> htmlAttributions;

  PlacesDetailsResponse({
    required String status,
    String? errorMessage,
    required this.result,
    required this.htmlAttributions,
  }) : super(
          status: status,
          errorMessage: errorMessage,
        );

  factory PlacesDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$PlacesDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesDetailsResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Review {
  /// JSON author_name
  final String authorName;

  /// JSON author_url
  final String authorUrl;

  final String? language;

  /// JSON profile_photo_url
  final String profilePhotoUrl;

  final num rating;

  /// JSON relative_time_description
  final String relativeTimeDescription;

  final String text;

  final num time;

  Review({
    required this.authorName,
    required this.authorUrl,
    required this.language,
    required this.profilePhotoUrl,
    required this.rating,
    required this.relativeTimeDescription,
    required this.text,
    required this.time,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class PlacesAutocompleteResponse extends GoogleResponseStatus {
  @JsonKey(defaultValue: <Prediction>[])
  final List<Prediction> predictions;

  PlacesAutocompleteResponse({
    required String status,
    String? errorMessage,
    required this.predictions,
  }) : super(
          status: status,
          errorMessage: errorMessage,
        );

  factory PlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$PlacesAutocompleteResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesAutocompleteResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Prediction {
  final String? description;
  final String? id;

  @JsonKey(defaultValue: <Term>[])
  final List<Term> terms;

  final int? distanceMeters;

  /// JSON place_id
  final String? placeId;
  final String? reference;

  @JsonKey(defaultValue: <String>[])
  final List<String> types;

  /// JSON matched_substrings
  @JsonKey(defaultValue: <MatchedSubstring>[])
  final List<MatchedSubstring> matchedSubstrings;

  final StructuredFormatting? structuredFormatting;

  Prediction({
    this.description,
    this.id,
    this.terms = const <Term>[],
    this.distanceMeters,
    this.placeId,
    this.reference,
    this.types = const <String>[],
    this.matchedSubstrings = const <MatchedSubstring>[],
    this.structuredFormatting,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);
  Map<String, dynamic> toJson() => _$PredictionToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Term {
  final num offset;
  final String value;

  Term({
    required this.offset,
    required this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Term &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          value == other.value;

  @override
  int get hashCode => offset.hashCode ^ value.hashCode;
}

@JsonSerializable()
class MatchedSubstring {
  final num offset;
  final num length;

  MatchedSubstring({
    required this.offset,
    required this.length,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      _$MatchedSubstringFromJson(json);
  Map<String, dynamic> toJson() => _$MatchedSubstringToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedSubstring &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          length == other.length;

  @override
  int get hashCode => offset.hashCode ^ length.hashCode;
}

@JsonSerializable()
class StructuredFormatting {
  final String mainText;

  @JsonKey(defaultValue: <MatchedSubstring>[])
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting({
    required this.mainText,
    this.mainTextMatchedSubstrings = const <MatchedSubstring>[],
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      _$StructuredFormattingFromJson(json);
  Map<String, dynamic> toJson() => _$StructuredFormattingToJson(this);

  @override
  String toString() => toJson().toString();
}
