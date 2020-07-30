import 'dart:async';
import 'dart:convert';

import 'package:google_maps_webservice/timezone.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final apiKey = 'MY_API_KEY';

  var timeZone = GoogleMapsTimezone(apiKey: apiKey);

  tearDownAll(() {
    timeZone.dispose();
  });

  group('Google Maps Timezone', () {
    group('build url (only api key, everything else over REST/JSON POST', () {
      test('default url building with api key', () {
        final location = Location(38.908133, -77.047119);
        final timestamp = 1458000;
        final language = 'en';

        expect(
            timeZone.buildUrl(
                location,
                DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
                language),
            'https://maps.googleapis.com/maps/api/timezone/json?'
            'location=$location&timestamp=$timestamp&'
            'language=$language&key=MY_API_KEY');
      });
    });

    test('Decode response', () {
      var response = TimezoneResponse.fromJson(json.decode(_responseExample));

      expect(response.isOkay, isTrue);
      expect(response.result.dstOffset, 3600);
      expect(response.result.rawOffset, -18000);
      expect(response.result.timeZoneId, 'America/New_York');
      expect(response.result.timeZoneName, 'Eastern Daylight Time');
    });
    test('encode response', () {
      var decoded = json.decode(_responseExample);
      var recoded = TimezoneResponse.fromJson(decoded).toJson();
      // toJson is not implemented in TimezoneResponse, using parent's impl.
      for (var i in recoded.keys)
        expect(recoded[i], decoded[i]);
    });
  });
}

final _responseExample = '''
{
   "dstOffset" : 3600,
   "rawOffset" : -18000,
   "status" : "OK",
   "timeZoneId" : "America/New_York",
   "timeZoneName" : "Eastern Daylight Time"
}''';
