library google_maps_webservice.utils;

import 'package:meta/meta.dart';
import 'package:http/http.dart';

const kGMapsUrl = "https://maps.googleapis.com/maps/api";

bool responseIsSuccessful(Response res) =>
    res != null && res.statusCode >= 200 && res.statusCode < 300;


abstract class GoogleWebService {
  @protected
  final Client _httpClient;

  @protected
  final String _url;

  String get url => _url;

  Client get httpClient => _httpClient;

  GoogleWebService(String apiKey, String url, [Client httpClient])
      : _url = "$kGMapsUrl$url?key=${apiKey}",
        _httpClient = httpClient ?? new Client();

  @protected
  String buildQuery(Map<String, dynamic> params) {
    final query = [];
    params.forEach((key, val) {
      if (val != null) {
        if (val is Iterable) {
          query.add("$key=${val.map((v) => v.toString()).join("|")}");
        } else {
          query.add("$key=${val.toString()}");
        }
      }
    });
    return query.join("&");
  }
}