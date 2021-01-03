import 'dart:async';

import 'package:google_maps_webservice/geocoding.dart';
import 'package:test/test.dart';

final _uri = Uri(
  scheme: 'https',
  host: 'maps.googleapis.com',
  path: 'maps/api/geocode/json',
);

Future<void> main() async {
  final apiKey = 'MY_API_KEY';
  var geocoding = GoogleMapsGeocoding(apiKey: apiKey);

  tearDownAll(() {
    geocoding.dispose();
  });

  group('Google Maps Geocoding', () {
    group('build url', () {
      test('address', () {
        expect(
          geocoding.buildUrl(
            address: '1600 Amphitheatre Parkway, Mountain View, CA',
          ),
          _uri.replace(
            queryParameters: {
              'address': Uri.encodeComponent(
                '1600 Amphitheatre Parkway, Mountain View, CA',
              ),
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('address with bound', () {
        expect(
          geocoding.buildUrl(
            address: 'Winnetka',
            bounds: Bounds(
              northeast: Location(lat: 34.172684, lng: -118.604794),
              southwest: Location(lat: 34.236144, lng: -118.500938),
            ),
          ),
          _uri.replace(
            queryParameters: {
              'address': Uri.encodeComponent('Winnetka'),
              'bounds': '34.172684,-118.604794|34.236144,-118.500938',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('address with language', () {
        expect(
          geocoding.buildUrl(address: 'Paris', language: 'fr'),
          _uri.replace(
            queryParameters: {
              'address': Uri.encodeComponent('Paris'),
              'language': 'fr',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('address with region', () {
        expect(
          geocoding.buildUrl(address: 'Toledo', region: 'es'),
          _uri.replace(
            queryParameters: {
              'address': Uri.encodeComponent('Toledo'),
              'region': 'es',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('address with components', () {
        expect(
          geocoding.buildUrl(
            address: 'Spain',
            components: [Component(Component.administrativeArea, 'Toledo')],
          ),
          _uri.replace(
            queryParameters: {
              'address': Uri.encodeComponent('Spain'),
              'components': 'administrative_area:Toledo',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('location', () {
        expect(
          geocoding.buildUrl(
            location: Location(lat: 34.172684, lng: -118.604794),
          ),
          _uri.replace(
            queryParameters: {
              'latlng': '34.172684,-118.604794',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('place_id', () {
        expect(
          geocoding.buildUrl(placeId: 'f2hf1pn1rjr1'),
          _uri.replace(
            queryParameters: {
              'place_id': 'f2hf1pn1rjr1',
              'key': apiKey,
            },
          ).toString(),
        );
      });
    });

    test('decode response', () {
      var response = GeocodingResponse.fromJson(_responseExample);

      expect(response.isOkay, isTrue);
      expect(response.results, hasLength(equals(1)));
      expect(response.results.first.addressComponents, hasLength(equals(7)));
      expect(response.results.first.addressComponents.first.longName,
          equals('1600'));
      expect(response.results.first.addressComponents.first.shortName,
          equals('1600'));
      expect(response.results.first.addressComponents.first.types,
          equals(['street_number']));
      expect(response.results.first.formattedAddress,
          equals('1600 Amphitheatre Parkway, Mountain View, CA 94043, USA'));
      expect(response.results.first.geometry.location.lat, equals(37.4224764));
      expect(
          response.results.first.geometry.location.lng, equals(-122.0842499));
      expect(response.results.first.geometry.locationType, equals('ROOFTOP'));
      expect(response.results.first.geometry.viewport?.northeast.lat,
          equals(37.4238253802915));
      expect(response.results.first.geometry.viewport?.northeast.lng,
          equals(-122.0829009197085));
      expect(response.results.first.geometry.viewport?.southwest.lat,
          equals(37.4211274197085));
      expect(response.results.first.geometry.viewport?.southwest.lng,
          equals(-122.0855988802915));
      expect(response.results.first.placeId,
          equals('ChIJ2eUgeAK6j4ARbn5u_wAGqWA'));
      expect(response.results.first.types, equals(['street_address']));
    });
  });
}

final _responseExample = {
  'results': [
    {
      'address_components': [
        {
          'long_name': '1600',
          'short_name': '1600',
          'types': ['street_number']
        },
        {
          'long_name': 'Amphitheatre Pkwy',
          'short_name': 'Amphitheatre Pkwy',
          'types': ['route']
        },
        {
          'long_name': 'Mountain View',
          'short_name': 'Mountain View',
          'types': ['locality', 'political']
        },
        {
          'long_name': 'Santa Clara County',
          'short_name': 'Santa Clara County',
          'types': ['administrative_area_level_2', 'political']
        },
        {
          'long_name': 'California',
          'short_name': 'CA',
          'types': ['administrative_area_level_1', 'political']
        },
        {
          'long_name': 'United States',
          'short_name': 'US',
          'types': ['country', 'political']
        },
        {
          'long_name': '94043',
          'short_name': '94043',
          'types': ['postal_code']
        }
      ],
      'formatted_address':
          '1600 Amphitheatre Parkway, Mountain View, CA 94043, USA',
      'geometry': {
        'location': {'lat': 37.4224764, 'lng': -122.0842499},
        'location_type': 'ROOFTOP',
        'viewport': {
          'northeast': {'lat': 37.4238253802915, 'lng': -122.0829009197085},
          'southwest': {'lat': 37.4211274197085, 'lng': -122.0855988802915}
        }
      },
      'place_id': 'ChIJ2eUgeAK6j4ARbn5u_wAGqWA',
      'types': ['street_address']
    }
  ],
  'status': 'OK'
};
