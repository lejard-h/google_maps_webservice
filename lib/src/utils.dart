library google_maps_webservice.utils;

import 'package:http/http.dart';

const kGMapsUrl = "https://maps.googleapis.com/maps/api";

bool responseIsSuccessful(Response res) =>
    res != null && res.statusCode >= 200 && res.statusCode < 300;
