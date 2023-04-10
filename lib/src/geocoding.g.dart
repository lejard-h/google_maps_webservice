// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeocodingResponse _$GeocodingResponseFromJson(Map<String, dynamic> json) =>
    GeocodingResponse(
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => GeocodingResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GeocodingResponseToJson(GeocodingResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'error_message': instance.errorMessage,
      'results': instance.results,
    };

GeocodingResult _$GeocodingResultFromJson(Map<String, dynamic> json) =>
    GeocodingResult(
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      placeId: json['place_id'] as String,
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      addressComponents: (json['address_components'] as List<dynamic>?)
              ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      postcodeLocalities: (json['postcode_localities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      partialMatch: json['partial_match'] as bool? ?? false,
      formattedAddress: json['formatted_address'] as String?,
    );

Map<String, dynamic> _$GeocodingResultToJson(GeocodingResult instance) =>
    <String, dynamic>{
      'types': instance.types,
      'formatted_address': instance.formattedAddress,
      'address_components': instance.addressComponents,
      'postcode_localities': instance.postcodeLocalities,
      'geometry': instance.geometry,
      'partial_match': instance.partialMatch,
      'place_id': instance.placeId,
    };

StreetAddress _$StreetAddressFromJson(Map<String, dynamic> json) =>
    StreetAddress(
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      addressLine: json['address_line'] as String?,
      countryName: json['country_name'] as String?,
      countryCode: json['country_code'] as String?,
      featureName: json['feature_name'] as String?,
      postalCode: json['postal_code'] as String?,
      adminArea: json['admin_area'] as String?,
      subAdminArea: json['sub_admin_area'] as String?,
      locality: json['locality'] as String?,
      subLocality: json['sub_locality'] as String?,
      thoroughfare: json['thoroughfare'] as String?,
      subThoroughfare: json['sub_thoroughfare'] as String?,
    );

Map<String, dynamic> _$StreetAddressToJson(StreetAddress instance) =>
    <String, dynamic>{
      'geometry': instance.geometry,
      'address_line': instance.addressLine,
      'country_name': instance.countryName,
      'country_code': instance.countryCode,
      'feature_name': instance.featureName,
      'postal_code': instance.postalCode,
      'admin_area': instance.adminArea,
      'sub_admin_area': instance.subAdminArea,
      'locality': instance.locality,
      'sub_locality': instance.subLocality,
      'thoroughfare': instance.thoroughfare,
      'sub_thoroughfare': instance.subThoroughfare,
    };
