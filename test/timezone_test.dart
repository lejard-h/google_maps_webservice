import 'dart:async';
import 'dart:convert';

import 'package:google_maps_webservice/timezone.dart';
import 'package:test/test.dart';

final _uri = Uri(
  scheme: 'https',
  host: 'maps.googleapis.com',
  path: 'maps/api/timezone/json',
);

Future<void> main() async {
  final apiKey = 'MY_API_KEY';

  var timeZone = GoogleMapsTimezone(apiKey: apiKey);

  tearDownAll(() {
    timeZone.dispose();
  });

  group('Google Maps Timezone', () {
    group('build url (only api key, everything else over REST/JSON POST', () {
      test('default url building with api key', () {
        final location = Location(lat: 38.908133, lng: -77.047119);
        final timestamp = 1458000;
        final language = 'en';

        expect(
          timeZone.buildUrl(
            location: location,
            timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
            language: language,
          ),
          _uri.replace(queryParameters: {
            'location': location.toString(),
            'timestamp': timestamp.toString(),
            'language': language,
            'key': apiKey,
          }).toString(),
        );
      });
    });

    test('Decode response', () {
      var response = TimezoneResponse.fromJson(_responseExample);

      expect(response.isOkay, isTrue);
      expect(response.dstOffset, 3600);
      expect(response.rawOffset, -18000);
      expect(response.timeZoneId, 'America/New_York');
      expect(response.timeZoneName, 'Eastern Daylight Time');
    });
  });
}

final _responseExample = {
  'dstOffset': 3600,
  'rawOffset': -18000,
  'status': 'OK',
  'timeZoneId': 'America/New_York',
  'timeZoneName': 'Eastern Daylight Time'
};
