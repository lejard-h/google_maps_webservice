library google_maps_webservice.gelocation.example;

import 'dart:io';

import 'package:google_maps_webservice/geolocation.dart';



const API_KEY="AIzaSyAjOK53pb0_5pRlW-LW-WNjtXSZpjYqHDI";
final geolocation = new GoogleMapsGeolocation(apiKey: API_KEY);

main() async {
  var resp =  await geolocation.currentGeolocation();
  print(resp.location);
}