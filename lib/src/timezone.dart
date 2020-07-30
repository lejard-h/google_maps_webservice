library google_maps_webservice.timezone.src;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'core.dart';
import 'utils.dart';

const _timezoneUrl = '/timezone/json';

/// https://developers.google.com/maps/documentation/timezone/start
class GoogleMapsTimezone extends GoogleWebService {
  GoogleMapsTimezone({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          url: _timezoneUrl,
          httpClient: httpClient,
        );

  /// Retrieves time zone information for the specified location and the timestamp.
  /// If the language is specified, the time zone name will be localized to that
  /// langauge.
  Future<TimezoneResponse> getByLocation(
    Location location, {
    DateTime timestamp,
    String language,
  }) async {
    final requestUrl = buildUrl(location, timestamp, language);
    return _decode(await doGet(requestUrl));
  }

  String buildUrl(
    Location location,
    DateTime timestamp,
    String language,
  ) {
    final params = {
      'location': location,
      'timestamp':
          (timestamp ?? DateTime.now()).toUtc().millisecondsSinceEpoch ~/ 1000,
    };

    if (language != null) {
      params['language'] = language;
    }

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url?${buildQuery(params)}';
  }

  TimezoneResponse _decode(Response res) =>
      TimezoneResponse.fromJson(json.decode(res.body));
}

class TimezoneResponse extends GoogleResponse<TimezoneResult> {
  TimezoneResponse(
    String status,
    String errorMessage,
    TimezoneResult result,
  ) : super(
          status,
          errorMessage,
          result,
        );

  factory TimezoneResponse.fromJson(Map json) => json != null
      ? TimezoneResponse(json['status'], json['errorMessage'],
          json['status'] == 'OK' ? TimezoneResult.fromJson(json) : null)
      : null;

  @override
  Map<String, dynamic> toJson() {
    var map = result.toJson();
    map['status'] = status;
    return map;
  }
}

class TimezoneResult {
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

  TimezoneResult(
      {this.dstOffset, this.rawOffset, this.timeZoneId, this.timeZoneName});

  factory TimezoneResult.fromJson(Map json) => json != null
      ? TimezoneResult(
          dstOffset: json['dstOffset'],
          rawOffset: json['rawOffset'],
          timeZoneId: json['timeZoneId'],
          timeZoneName: json['timeZoneName'],
        )
      : null;

  Map<String, dynamic> toJson() {
    return {
      'dstOffset': dstOffset,
      'rawOffset': rawOffset,
      'timeZoneId': timeZoneId,
      'timeZoneName': timeZoneName,
    };
  }
}
