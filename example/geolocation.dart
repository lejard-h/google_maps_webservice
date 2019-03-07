library google_maps_webservice.gelocation.example;

import 'dart:io';

import 'package:google_maps_webservice/geolocation.dart';


final geolocation = new GoogleMapsGeolocation(apiKey: Platform.environment["AIzaSyA8N-CChgjPiNngBgwPNKJ8YMd3p5Yn8SU"]);

main() async {

  var params = {
    "considerIp": "false",
    "wifiAccessPoints": [
      {
        "macAddress": "00:25:9c:cf:1c:ac",
        "signalStrength": "-43",
        "signalToNoiseRatio": "0"
      },
      {
        "macAddress": "00:25:9c:cf:1c:ad",
        "signalStrength": "-55",
        "signalToNoiseRatio": "0"
      }
    ]
  };

  // No params -> google uses current location
  GeolocationResponse res = await geolocation.getGeolocation();

  // works with map/json
  res = await geolocation.getGeolocationFromMap(params);

  // define optional parameter explicit
  res = await geolocation.getGeolocation(considerIp: false);

  print(res.status);
  if (res.isOkay) {
    print("Latitude: ${res.location.lat}");
    print("Longitude: ${res.location.lng}");
    print("Accuracy: ${res.accuracy}");
  } else {
    print(res.errorMessage);
  }
}