// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlacesSearchResponse _$PlacesSearchResponseFromJson(
        Map<String, dynamic> json) =>
    PlacesSearchResponse(
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => PlacesSearchResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      htmlAttributions: (json['html_attributions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      nextPageToken: json['next_page_token'] as String?,
    );

Map<String, dynamic> _$PlacesSearchResponseToJson(
        PlacesSearchResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'results': instance.results,
      'html_attributions': instance.htmlAttributions,
      'next_page_token': instance.nextPageToken,
    };

PlacesSearchResult _$PlacesSearchResultFromJson(Map<String, dynamic> json) =>
    PlacesSearchResult(
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
      priceLevel: $enumDecodeNullable(_$PriceLevelEnumMap, json['price_level']),
      rating: json['rating'] as num?,
      vicinity: json['vicinity'] as String?,
    );

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

const _$PriceLevelEnumMap = {
  PriceLevel.free: 0,
  PriceLevel.inexpensive: 1,
  PriceLevel.moderate: 2,
  PriceLevel.expensive: 3,
  PriceLevel.veryExpensive: 4,
};

PlaceDetails _$PlaceDetailsFromJson(Map<String, dynamic> json) => PlaceDetails(
      adrAddress: json['adr_address'] as String?,
      name: json['name'] as String,
      placeId: json['place_id'] as String,
      utcOffset: json['utc_offset'] as num?,
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
      priceLevel: $enumDecodeNullable(_$PriceLevelEnumMap, json['price_level']),
      scope: json['scope'] as String?,
      url: json['url'] as String?,
      vicinity: json['vicinity'] as String?,
      website: json['website'] as String?,
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      businessStatus: json['business_status'] as String?,
      curbsidePickup: json['curbside_pickup'] as bool?,
      delivery: json['delivery'] as bool?,
      dineIn: json['dine_in'] as bool?,
      editorialSummary: json['editorial_summary'] == null
          ? null
          : PlaceEditorialSummary.fromJson(
              json['editorial_summary'] as Map<String, dynamic>),
      iconBackgroundColor: json['icon_background_color'] as String?,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String?,
      plusCode: json['plus_code'] == null
          ? null
          : PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>),
      reservable: json['reservable'] as bool?,
      servesBeer: json['serves_beer'] as bool?,
      servesBreakfast: json['serves_breakfast'] as bool?,
      servesBrunch: json['serves_brunch'] as bool?,
      servesDinner: json['serves_dinner'] as bool?,
      servesLunch: json['serves_lunch'] as bool?,
      servesVegetarianFood: json['serves_vegetarian_food'] as bool?,
      servesWine: json['serves_wine'] as bool?,
      takeout: json['takeout'] as bool?,
      userRatingsTotal: json['user_ratings_total'] as int?,
      wheelChairAccessibleEntrance:
          json['wheel_chair_accessible_entrance'] as bool?,
    );

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
      'plus_code': instance.plusCode,
      'reservable': instance.reservable,
      'serves_beer': instance.servesBeer,
      'serves_breakfast': instance.servesBreakfast,
      'serves_brunch': instance.servesBrunch,
      'serves_dinner': instance.servesDinner,
      'serves_lunch': instance.servesLunch,
      'serves_vegetarian_food': instance.servesVegetarianFood,
      'serves_wine': instance.servesWine,
      'takeout': instance.takeout,
      'user_ratings_total': instance.userRatingsTotal,
      'wheel_chair_accessible_entrance': instance.wheelChairAccessibleEntrance,
      'business_status': instance.businessStatus,
      'curbside_pickup': instance.curbsidePickup,
      'delivery': instance.delivery,
      'dine_in': instance.dineIn,
      'editorial_summary': instance.editorialSummary,
      'icon_background_color': instance.iconBackgroundColor,
      'icon_mask_base_uri': instance.iconMaskBaseUri,
    };

OpeningHoursDetail _$OpeningHoursDetailFromJson(Map<String, dynamic> json) =>
    OpeningHoursDetail(
      openNow: json['open_now'] as bool? ?? false,
      periods: (json['periods'] as List<dynamic>?)
              ?.map(
                  (e) => OpeningHoursPeriod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weekdayText: (json['weekday_text'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$OpeningHoursDetailToJson(OpeningHoursDetail instance) =>
    <String, dynamic>{
      'open_now': instance.openNow,
      'periods': instance.periods,
      'weekday_text': instance.weekdayText,
    };

PlaceEditorialSummary _$PlaceEditorialSummaryFromJson(
        Map<String, dynamic> json) =>
    PlaceEditorialSummary(
      language: json['language'] as String?,
      overview: json['overview'] as String?,
    );

Map<String, dynamic> _$PlaceEditorialSummaryToJson(
        PlaceEditorialSummary instance) =>
    <String, dynamic>{
      'language': instance.language,
      'overview': instance.overview,
    };

PlusCode _$PlusCodeFromJson(Map<String, dynamic> json) => PlusCode(
      globalCode: json['global_code'] as String,
      compoundCode: json['compound_code'] as String?,
    );

Map<String, dynamic> _$PlusCodeToJson(PlusCode instance) => <String, dynamic>{
      'global_code': instance.globalCode,
      'compound_code': instance.compoundCode,
    };

OpeningHoursPeriodDate _$OpeningHoursPeriodDateFromJson(
        Map<String, dynamic> json) =>
    OpeningHoursPeriodDate(
      day: json['day'] as int,
      time: json['time'] as String,
    );

Map<String, dynamic> _$OpeningHoursPeriodDateToJson(
        OpeningHoursPeriodDate instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
    };

OpeningHoursPeriod _$OpeningHoursPeriodFromJson(Map<String, dynamic> json) =>
    OpeningHoursPeriod(
      open: json['open'] == null
          ? null
          : OpeningHoursPeriodDate.fromJson(
              json['open'] as Map<String, dynamic>),
      close: json['close'] == null
          ? null
          : OpeningHoursPeriodDate.fromJson(
              json['close'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpeningHoursPeriodToJson(OpeningHoursPeriod instance) =>
    <String, dynamic>{
      'open': instance.open,
      'close': instance.close,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      photoReference: json['photo_reference'] as String,
      height: json['height'] as num,
      width: json['width'] as num,
      htmlAttributions: (json['html_attributions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'photo_reference': instance.photoReference,
      'height': instance.height,
      'width': instance.width,
      'html_attributions': instance.htmlAttributions,
    };

AlternativeId _$AlternativeIdFromJson(Map<String, dynamic> json) =>
    AlternativeId(
      placeId: json['place_id'] as String,
      scope: json['scope'] as String,
    );

Map<String, dynamic> _$AlternativeIdToJson(AlternativeId instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'scope': instance.scope,
    };

PlacesDetailsResponse _$PlacesDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    PlacesDetailsResponse(
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
      result: PlaceDetails.fromJson(json['result'] as Map<String, dynamic>),
      htmlAttributions: (json['html_attributions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$PlacesDetailsResponseToJson(
        PlacesDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'result': instance.result,
      'html_attributions': instance.htmlAttributions,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      authorName: json['author_name'] as String,
      authorUrl: json['author_url'] as String,
      language: json['language'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String,
      rating: json['rating'] as num,
      relativeTimeDescription: json['relative_time_description'] as String,
      text: json['text'] as String,
      time: json['time'] as num,
    );

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
        Map<String, dynamic> json) =>
    PlacesAutocompleteResponse(
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
      predictions: (json['predictions'] as List<dynamic>?)
              ?.map((e) => Prediction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PlacesAutocompleteResponseToJson(
        PlacesAutocompleteResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'predictions': instance.predictions,
    };

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
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

Term _$TermFromJson(Map<String, dynamic> json) => Term(
      offset: json['offset'] as num,
      value: json['value'] as String,
    );

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'offset': instance.offset,
      'value': instance.value,
    };

MatchedSubstring _$MatchedSubstringFromJson(Map<String, dynamic> json) =>
    MatchedSubstring(
      offset: json['offset'] as num,
      length: json['length'] as num,
    );

Map<String, dynamic> _$MatchedSubstringToJson(MatchedSubstring instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'length': instance.length,
    };

StructuredFormatting _$StructuredFormattingFromJson(
        Map<String, dynamic> json) =>
    StructuredFormatting(
      mainText: json['main_text'] as String,
      mainTextMatchedSubstrings: (json['main_text_matched_substrings']
                  as List<dynamic>?)
              ?.map((e) => MatchedSubstring.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      secondaryText: json['secondary_text'] as String?,
    );

Map<String, dynamic> _$StructuredFormattingToJson(
        StructuredFormatting instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'main_text_matched_substrings': instance.mainTextMatchedSubstrings,
      'secondary_text': instance.secondaryText,
    };
