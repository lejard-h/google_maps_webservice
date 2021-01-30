import 'dart:async';
import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import 'core.dart';
import 'utils.dart';

part 'timezone.g.dart';

const _timezoneUrl = '/timezone/json';

/// https://developers.google.com/maps/documentation/timezone/start
class GoogleMapsTimezone extends GoogleWebService {
  GoogleMapsTimezone({
    String? apiKey,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          apiPath: _timezoneUrl,
          httpClient: httpClient,
          apiHeaders: apiHeaders,
        );

  /// Retrieves time zone information for the specified location and the timestamp.
  /// If the language is specified, the time zone name will be localized to that
  /// langauge.
  Future<TimezoneResponse> getByLocation(
    Location location, {
    DateTime? timestamp,
    String? language,
  }) async {
    final requestUrl = buildUrl(
      location: location,
      timestamp: timestamp,
      language: language,
    );
    return _decode(await doGet(requestUrl, headers: apiHeaders));
  }

  String buildUrl({
    required Location location,
    DateTime? timestamp,
    String? language,
  }) {
    timestamp ??= DateTime.now();

    final params = <String, String>{
      'location': location.toString(),
      'timestamp': (timestamp.millisecondsSinceEpoch ~/ 1000).toString(),
    };

    if (language != null) {
      params['language'] = language;
    }

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey!);
    }

    return url.replace(queryParameters: params).toString();
  }

  TimezoneResponse _decode(Response res) =>
      TimezoneResponse.fromJson(json.decode(res.body));
}

@JsonSerializable(fieldRename: FieldRename.none)
class TimezoneResponse extends GoogleResponseStatus {
  /// The offset for daylight-savings time in seconds.
  final int dstOffset;

  /// The offset from UTC (in seconds) for the given location.
  final int rawOffset;

  /// A string containing the ID of the time zone,
  /// such as "America/Los_Angeles" or "Australia/Sydney".
  final String timeZoneId;

  /// A string containing the long form name of the time zone.
  /// This field will be localized if the language parameter is set.
  /// eg. "Pacific Daylight Time" or "Australian Eastern Daylight Time".
  final String timeZoneName;

  TimezoneResponse({
    required String status,
    String? errorMessage,
    required this.dstOffset,
    required this.rawOffset,
    required this.timeZoneId,
    required this.timeZoneName,
  }) : super(status: status, errorMessage: errorMessage);

  factory TimezoneResponse.fromJson(Map<String, dynamic> json) =>
      _$TimezoneResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TimezoneResponseToJson(this);
}
