import 'dart:async';

import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/src/distance.dart';
import 'package:test/test.dart';

final _uri = Uri(
  scheme: 'https',
  host: 'maps.googleapis.com',
  path: 'maps/api/distancematrix/json',
);

Future<void> main() async {
  final apiKey = 'MY_API_KEY';
  var distanceMatrix = GoogleDistanceMatrix(apiKey: apiKey);

  tearDownAll(() {
    distanceMatrix.dispose();
  });

  group('Google map distance matrix', () {
    group('build url test', () {
      test('simple with String origin/destination', () {
        expect(
          distanceMatrix.buildUrl(
            origin: ['Bakshi Bazar Road, Dhaka'].toList(),
            destination: ['Rd 11, Dhaka 1212'].toList(),
          ),
          _uri.replace(
            queryParameters: {
              'origins': 'Bakshi Bazar Road, Dhaka',
              'destinations': 'Rd 11, Dhaka 1212',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('simple with Location origin/destination', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('simple with String/Location origin/destination', () {
        expect(
          distanceMatrix.buildUrl(
            origin: ['10 Girda Urdu Rd, Dhaka'].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
          ),
          _uri.replace(
            queryParameters: {
              'origins': '10 Girda Urdu Rd, Dhaka',
              'destinations': '23.762488,90.373025',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('simple with bad type for origin/destination', () {
        try {
          distanceMatrix.buildUrl(
            origin: [10.00].toList(),
            destination: ['Marseilles, France'].toList(),
          );
        } catch (e) {
          expect((e as ArgumentError).message,
              equals("'origin' must be a '$String' or a '$Location'"));
        }

        try {
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.43, lng: 65.1)].toList(),
            destination: [10].toList(),
          );
        } catch (e) {
          expect((e as ArgumentError).message,
              equals("'destination' must be a '$String' or a '$Location'"));
        }
      });

      test('avoid ', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            avoids: [RouteType.tolls, RouteType.indoor],
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'avoid': 'tolls|indoor',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('travel mode', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            travelMode: TravelMode.driving,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'mode': 'DRIVING',
              'key': apiKey,
            },
          ).toString(),
        );
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            travelMode: TravelMode.bicycling,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'mode': 'BICYCLING',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            travelMode: TravelMode.walking,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'mode': 'WALKING',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            travelMode: TravelMode.transit,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'mode': 'TRANSIT',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('language code', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            languageCode: 'Bangali',
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'language': 'Bangali',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('alternative', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            alternative: true,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'alternative': 'true',
              'key': apiKey,
            },
          ).toString(),
        );
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            alternative: false,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('unit system', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            unit: Unit.metric,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'units': 'metric',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            unit: Unit.imperial,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'units': 'imperial',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('arrival_time', () {
        var d = 1343641500;
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            arrivalTime: d,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'arrival_time': '$d',
              'key': apiKey,
            },
          ).toString(),
        );
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            arrivalTime: DateTime.fromMillisecondsSinceEpoch(d * 1000),
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'arrival_time': '$d',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('departure_time', () {
        var d = 1343641500;
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            departureTime: d,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'departure_time': '$d',
              'key': apiKey,
            },
          ).toString(),
        );
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            departureTime: DateTime.fromMillisecondsSinceEpoch(d * 1000),
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'departure_time': '$d',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('departure_time with now', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            departureTime: 'now',
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'departure_time': 'now',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('traffic model', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            trafficModel: TrafficModel.bestGuess,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'traffic_model': 'best_guess',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            trafficModel: TrafficModel.optimistic,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'traffic_model': 'optimistic',
              'key': apiKey,
            },
          ).toString(),
        );
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            trafficModel: TrafficModel.pessimistic,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'traffic_model': 'pessimistic',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('transit mode', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            transitMode: [TransitMode.bus],
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'transit_mode': 'bus',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            transitMode: [TransitMode.rail],
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'transit_mode': 'rail',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            transitMode: [
              TransitMode.rail,
              TransitMode.train,
              TransitMode.subway,
              TransitMode.tram,
            ],
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'transit_mode': 'rail|train|subway|tram',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('transit route preference', () {
        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            transitRoutingPreference: TransitRoutingPreferences.lessWalking,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'transit_routing_preference': 'less_walking',
              'key': apiKey,
            },
          ).toString(),
        );

        expect(
          distanceMatrix.buildUrl(
            origin: [Location(lat: 23.721017, lng: 90.394358)].toList(),
            destination: [Location(lat: 23.762488, lng: 90.373025)].toList(),
            transitRoutingPreference: TransitRoutingPreferences.fewerTransfers,
          ),
          _uri.replace(
            queryParameters: {
              'origins': '23.721017,90.394358',
              'destinations': '23.762488,90.373025',
              'transit_routing_preference': 'fewer_transfers',
              'key': apiKey,
            },
          ).toString(),
        );
      });

      test('decode response', () {
        var response = DistanceResponse.fromJson(_responseExample);

        expect(response.isOkay, isTrue);
        expect(response.rows, hasLength(1));
        expect(response.originAddresses, hasLength(1));
        expect(response.originAddresses.first,
            equals('Bakshi Bazar Road, Dhaka, Bangladesh'));
        expect(response.destinationAddresses, hasLength(1));
        expect(response.destinationAddresses.first,
            equals('Rd 11, Dhaka 1212, Bangladesh'));
        expect(response.rows.first.elements, hasLength(1));
        expect(response.rows.first.elements.first.duration.text,
            equals('29 mins'));
        expect(response.rows.first.elements.first.duration.value, equals(1725));
        expect(
            response.rows.first.elements.first.distance.text, equals('9.2 km'));
        expect(response.rows.first.elements.first.distance.value, equals(9247));
      });
    });
  });
}

final _responseExample = {
  'destination_addresses': ['Rd 11, Dhaka 1212, Bangladesh'],
  'origin_addresses': ['Bakshi Bazar Road, Dhaka, Bangladesh'],
  'rows': [
    {
      'elements': [
        {
          'distance': {'text': '9.2 km', 'value': 9247},
          'duration': {'text': '29 mins', 'value': 1725},
          'status': 'OK'
        }
      ]
    }
  ],
  'status': 'OK'
};
