import 'dart:async';
import 'dart:convert';

import 'package:google_maps_webservice/geolocation.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final apiKey = 'MY_API_KEY';

  var geolocation = GoogleMapsGeolocation(apiKey: apiKey);

  tearDownAll(() {
    geolocation.dispose();
  });

  group('Google Maps Geolocation', () {
    group('build url (only api key, everything else over REST/JSON POST', () {
      test('default url building with api key', () {
        expect(
          geolocation.buildUrl(),
          'https://www.googleapis.com/geolocation/v1/geolocate?key=MY_API_KEY',
        );
      });
    });

    test('Decode response', () {
      var response = GeolocationResponse.fromJson(_responseExample);

      expect(response.isOkay, isTrue);
      expect(response.location?.lat, 33.3632256);
      expect(response.location?.lng, -117.0874871);
      expect(response.accuracy, 20);
    });

    test('Decode response with error', () {
      var response = GeolocationResponse.fromJson(_errorExample);

      expect(response.isOkay, isFalse);
      expect(response.error?.errors.length, 1);
      expect(response.error?.code, 400);
      expect(response.error?.message, 'Parse Error');
    });
  });
}

final _responseExample = {
  'location': {'lat': 33.3632256, 'lng': -117.0874871},
  'accuracy': 20
};

final _errorExample = {
  'error': {
    'errors': [
      {
        'domain': 'global',
        'reason': 'parseError',
        'message': 'Parse Error',
      }
    ],
    'code': 400,
    'message': 'Parse Error'
  }
};
