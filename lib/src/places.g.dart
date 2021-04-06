// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacesSearchResponse _$PlacesSearchResponseFromJson(Map<String, dynamic> json) {
  return PlacesSearchResponse(
    status: json['status'] as String,
    errorMessage: json['error_message'] as String?,
    results: (json['results'] as List<dynamic>?)
            ?.map((e) => PlacesSearchResult.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    htmlAttributions: (json['html_attributions'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    nextPageToken: json['next_page_token'] as String?,
  );
}

Map<String, dynamic> _$PlacesSearchResponseToJson(
        PlacesSearchResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'results': instance.results,
      'html_attributions': instance.htmlAttributions,
      'next_page_token': instance.nextPageToken,
    };

PlacesSearchResult _$PlacesSearchResultFromJson(Map<String, dynamic> json) {
  return PlacesSearchResult(
    id: json['id'] as String?,
    reference: json['reference'] as String,
    name: json['name'] as String,
    placeId: json['place_id'] as String,
    formattedAddress: json['formatted_address'] as String?,
    photos: (json['photos'] as List<dynamic>?)
            ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    altIds: (json['alt_ids'] as List<dynamic>?)
            ?.map((e) => AlternativeId.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    types:
        (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    permanentlyClosed: json['permanently_closed'] as bool? ?? false,
    icon: json['icon'] as String?,
    geometry: json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    openingHours: json['opening_hours'] == null
        ? null
        : OpeningHoursDetail.fromJson(
            json['opening_hours'] as Map<String, dynamic>),
    scope: json['scope'] as String?,
    priceLevel: _$enumDecodeNullable(_$PriceLevelEnumMap, json['price_level']),
    rating: json['rating'] as num?,
    vicinity: json['vicinity'] as String?,
  );
}

Map<String, dynamic> _$PlacesSearchResultToJson(PlacesSearchResult instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'geometry': instance.geometry,
      'name': instance.name,
      'opening_hours': instance.openingHours,
      'photos': instance.photos,
      'place_id': instance.placeId,
      'scope': instance.scope,
      'alt_ids': instance.altIds,
      'price_level': _$PriceLevelEnumMap[instance.priceLevel],
      'rating': instance.rating,
      'types': instance.types,
      'vicinity': instance.vicinity,
      'formatted_address': instance.formattedAddress,
      'permanently_closed': instance.permanentlyClosed,
      'id': instance.id,
      'reference': instance.reference,
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$PriceLevelEnumMap = {
  PriceLevel.free: 0,
  PriceLevel.inexpensive: 1,
  PriceLevel.moderate: 2,
  PriceLevel.expensive: 3,
  PriceLevel.veryExpensive: 4,
};

PlaceDetails _$PlaceDetailsFromJson(Map<String, dynamic> json) {
  return PlaceDetails(
    adrAddress: json['adr_address'] as String?,
    name: json['name'] as String,
    placeId: json['place_id'] as String,
    utcOffset: json['utc_offset'] as num,
    id: json['id'] as String?,
    internationalPhoneNumber: json['international_phone_number'] as String?,
    addressComponents: (json['address_components'] as List<dynamic>?)
            ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    photos: (json['photos'] as List<dynamic>?)
            ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    types:
        (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    reviews: (json['reviews'] as List<dynamic>?)
            ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    formattedAddress: json['formatted_address'] as String?,
    formattedPhoneNumber: json['formatted_phone_number'] as String?,
    reference: json['reference'] as String?,
    icon: json['icon'] as String?,
    rating: json['rating'] as num?,
    openingHours: json['opening_hours'] == null
        ? null
        : OpeningHoursDetail.fromJson(
            json['opening_hours'] as Map<String, dynamic>),
    priceLevel: _$enumDecodeNullable(_$PriceLevelEnumMap, json['price_level']),
    scope: json['scope'] as String?,
    url: json['url'] as String?,
    vicinity: json['vicinity'] as String?,
    website: json['website'] as String?,
    geometry: json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PlaceDetailsToJson(PlaceDetails instance) =>
    <String, dynamic>{
      'address_components': instance.addressComponents,
      'adr_address': instance.adrAddress,
      'formatted_address': instance.formattedAddress,
      'formatted_phone_number': instance.formattedPhoneNumber,
      'id': instance.id,
      'reference': instance.reference,
      'icon': instance.icon,
      'name': instance.name,
      'opening_hours': instance.openingHours,
      'photos': instance.photos,
      'place_id': instance.placeId,
      'international_phone_number': instance.internationalPhoneNumber,
      'price_level': _$PriceLevelEnumMap[instance.priceLevel],
      'rating': instance.rating,
      'scope': instance.scope,
      'types': instance.types,
      'url': instance.url,
      'vicinity': instance.vicinity,
      'utc_offset': instance.utcOffset,
      'website': instance.website,
      'reviews': instance.reviews,
      'geometry': instance.geometry,
    };

OpeningHoursDetail _$OpeningHoursDetailFromJson(Map<String, dynamic> json) {
  return OpeningHoursDetail(
    openNow: json['open_now'] as bool? ?? false,
    periods: (json['periods'] as List<dynamic>?)
            ?.map((e) => OpeningHoursPeriod.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    weekdayText: (json['weekday_text'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$OpeningHoursDetailToJson(OpeningHoursDetail instance) =>
    <String, dynamic>{
      'open_now': instance.openNow,
      'periods': instance.periods,
      'weekday_text': instance.weekdayText,
    };

OpeningHoursPeriodDate _$OpeningHoursPeriodDateFromJson(
    Map<String, dynamic> json) {
  return OpeningHoursPeriodDate(
    day: json['day'] as int,
    time: json['time'] as String,
  );
}

Map<String, dynamic> _$OpeningHoursPeriodDateToJson(
        OpeningHoursPeriodDate instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
    };

OpeningHoursPeriod _$OpeningHoursPeriodFromJson(Map<String, dynamic> json) {
  return OpeningHoursPeriod(
    open: json['open'] == null
        ? null
        : OpeningHoursPeriodDate.fromJson(json['open'] as Map<String, dynamic>),
    close: json['close'] == null
        ? null
        : OpeningHoursPeriodDate.fromJson(
            json['close'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OpeningHoursPeriodToJson(OpeningHoursPeriod instance) =>
    <String, dynamic>{
      'open': instance.open,
      'close': instance.close,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    photoReference: json['photo_reference'] as String,
    height: json['height'] as num,
    width: json['width'] as num,
    htmlAttributions: (json['html_attributions'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'photo_reference': instance.photoReference,
      'height': instance.height,
      'width': instance.width,
      'html_attributions': instance.htmlAttributions,
    };

AlternativeId _$AlternativeIdFromJson(Map<String, dynamic> json) {
  return AlternativeId(
    placeId: json['place_id'] as String,
    scope: json['scope'] as String,
  );
}

Map<String, dynamic> _$AlternativeIdToJson(AlternativeId instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'scope': instance.scope,
    };

PlacesDetailsResponse _$PlacesDetailsResponseFromJson(
    Map<String, dynamic> json) {
  return PlacesDetailsResponse(
    status: json['status'] as String,
    errorMessage: json['error_message'] as String?,
    result: PlaceDetails.fromJson(json['result'] as Map<String, dynamic>),
    htmlAttributions: (json['html_attributions'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$PlacesDetailsResponseToJson(
        PlacesDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'result': instance.result,
      'html_attributions': instance.htmlAttributions,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    authorName: json['author_name'] as String,
    authorUrl: json['author_url'] as String,
    language: json['language'] as String,
    profilePhotoUrl: json['profile_photo_url'] as String,
    rating: json['rating'] as num,
    relativeTimeDescription: json['relative_time_description'] as String,
    text: json['text'] as String,
    time: json['time'] as num,
  );
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'author_name': instance.authorName,
      'author_url': instance.authorUrl,
      'language': instance.language,
      'profile_photo_url': instance.profilePhotoUrl,
      'rating': instance.rating,
      'relative_time_description': instance.relativeTimeDescription,
      'text': instance.text,
      'time': instance.time,
    };

PlacesAutocompleteResponse _$PlacesAutocompleteResponseFromJson(
    Map<String, dynamic> json) {
  return PlacesAutocompleteResponse(
    status: json['status'] as String,
    errorMessage: json['error_message'] as String?,
    predictions: (json['predictions'] as List<dynamic>?)
            ?.map((e) => Prediction.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$PlacesAutocompleteResponseToJson(
        PlacesAutocompleteResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'predictions': instance.predictions,
    };

Prediction _$PredictionFromJson(Map<String, dynamic> json) {
  return Prediction(
    description: json['description'] as String?,
    id: json['id'] as String?,
    terms: (json['terms'] as List<dynamic>?)
            ?.map((e) => Term.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    distanceMeters: json['distance_meters'] as int?,
    placeId: json['place_id'] as String?,
    reference: json['reference'] as String?,
    types:
        (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    matchedSubstrings: (json['matched_substrings'] as List<dynamic>?)
            ?.map((e) => MatchedSubstring.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    structuredFormatting: json['structured_formatting'] == null
        ? null
        : StructuredFormatting.fromJson(
            json['structured_formatting'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'terms': instance.terms,
      'distance_meters': instance.distanceMeters,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'types': instance.types,
      'matched_substrings': instance.matchedSubstrings,
      'structured_formatting': instance.structuredFormatting,
    };

Term _$TermFromJson(Map<String, dynamic> json) {
  return Term(
    offset: json['offset'] as num,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'offset': instance.offset,
      'value': instance.value,
    };

MatchedSubstring _$MatchedSubstringFromJson(Map<String, dynamic> json) {
  return MatchedSubstring(
    offset: json['offset'] as num,
    length: json['length'] as num,
  );
}

Map<String, dynamic> _$MatchedSubstringToJson(MatchedSubstring instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'length': instance.length,
    };

StructuredFormatting _$StructuredFormattingFromJson(Map<String, dynamic> json) {
  return StructuredFormatting(
    mainText: json['main_text'] as String,
    mainTextMatchedSubstrings: (json['main_text_matched_substrings']
                as List<dynamic>?)
            ?.map((e) => MatchedSubstring.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    secondaryText: json['secondary_text'] as String,
  );
}

Map<String, dynamic> _$StructuredFormattingToJson(
        StructuredFormatting instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'main_text_matched_substrings': instance.mainTextMatchedSubstrings,
      'secondary_text': instance.secondaryText,
    };
