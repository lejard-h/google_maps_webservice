library google_maps_webservice.geolocation.test;

import 'dart:async';
import 'dart:convert';

import 'package:google_maps_webservice/geolocation.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

Future<void> main() async {
  await launch();
}

Future<void> launch([Client client]) async {
  final apiKey = 'MY_API_KEY';

  GoogleMapsGeolocation geolocation = GoogleMapsGeolocation(apiKey: apiKey);

  tearDownAll(() {
    geolocation.dispose();
  });

  group('Google Maps Geolocation', () {
    group('build url (only api key, everything else over REST/JSON POST', () {
      test('default url building with api key', () {
        expect(geolocation.buildUrl(),
            'https://www.googleapis.com/geolocation/v1/geolocate?key=MY_API_KEY');
      });
    });

    test('Decode response', () {
      GeolocationResponse response =
          GeolocationResponse.fromJson(json.decode(_responseExample));

      expect(response.isOkay, isTrue);
      expect(response.location.lat, 33.3632256);
      expect(response.location.lng, -117.0874871);
      expect(response.accuracy, 20);
    });
  });
}

final _responseExample = '''
{
  "location": {
    "lat": 33.3632256,
    "lng": -117.0874871
  },
  "accuracy": 20
}
''';
