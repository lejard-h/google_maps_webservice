library google_maps_webservice.geolocation.test;

import 'package:google_maps_webservice/geolocation.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

main() {
  launch();
}

launch([Client client]) async {
  final apiKey = "MY_API_KEY";

  GoogleMapsGeolocation geolocation =
      new GoogleMapsGeolocation(apiKey: apiKey);

  tearDownAll(() {
    geolocation.dispose();
  });

  group("Google Maps Geolocation", () {
    group("build url (only api key, everything else over REST/JSON POST", () {
      test("default url building with api key", () {
        expect(
            geolocation.buildUrl(),
            "https://www.googleapis.com/geolocation/v1/geolocate?key=MY_API_KEY");

        });
      });
  });
}