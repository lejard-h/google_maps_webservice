library google_maps_webservice.utils;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

final kGMapsUrl = Uri.parse('https://maps.googleapis.com/maps/api');

abstract class GoogleWebService {
  @protected
  final Client _httpClient;

  @protected
  late final Uri _url;

  @protected
  final String? _apiKey;

  @protected
  final Map<String, String>? _apiHeaders;

  Uri get url => _url;

  Client get httpClient => _httpClient;

  String? get apiKey => _apiKey;

  Map<String, String>? get apiHeaders => _apiHeaders;

  GoogleWebService({
    String? apiKey,
    required String apiPath,
    String? baseUrl,
    Client? httpClient,
    Map<String, String>? apiHeaders,
  })  : _httpClient = httpClient ?? Client(),
        _apiKey = apiKey,
        _apiHeaders = apiHeaders {
    var uri = kGMapsUrl;

    if (baseUrl != null) {
      uri = Uri.parse(baseUrl);
    }

    _url = uri.replace(path: '${uri.path}$apiPath');
  }

  @protected
  String buildQuery(Map<String, dynamic> params) {
    final query = [];
    params.forEach((key, val) {
      if (val != null) {
        if (val is Iterable) {
          query.add("$key=${val.map((v) => v.toString()).join("|")}");
        } else {
          query.add('$key=${val.toString()}');
        }
      }
    });
    return query.join('&');
  }

  void dispose() => httpClient.close();

  @protected
  Future<Response> doGet(String url, {Map<String, String>? headers}) {
    return httpClient.get(Uri.parse(url), headers: headers);
  }

  @protected
  Future<Response> doPost(
    String url,
    String body, {
    Map<String, String>? headers,
  }) {
    final postHeaders = {
      'Content-type': 'application/json',
    };
    if (headers != null) postHeaders.addAll(headers);
    return httpClient.post(Uri.parse(url), body: body, headers: postHeaders);
  }
}

DateTime dayTimeToDateTime(int day, String time) {
  if (time.length < 4) {
    throw ArgumentError(
        "'time' is not a valid string. It must be four integers.");
  }

  day = day == 0 ? DateTime.sunday : day;

  final now = DateTime.now();
  final mondayOfThisWeek = now.day - now.weekday;
  final computedWeekday = mondayOfThisWeek + day;

  final hour = int.parse(time.substring(0, 2));
  final minute = int.parse(time.substring(2));

  return DateTime.utc(now.year, now.month, computedWeekday, hour, minute);
}

final _jsonEncoder = JsonEncoder.withIndent(' ');

mixin StringifyJson {
  Map<String, dynamic> toJson();

  @override
  String toString() => '$runtimeType ${_jsonEncoder.convert(this)}';
}
