import 'dart:async';
import 'dart:convert';

import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/src/distance.dart';
import 'package:test/test.dart';

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
                destination: ['Rd 11, Dhaka 1212'].toList()),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${Uri.encodeComponent('Bakshi Bazar Road, Dhaka')}&destinations=${Uri.encodeComponent('Rd 11, Dhaka 1212')}&key=$apiKey'));
      });

      test('simple with Location origin/destination', () {
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList()),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&key=$apiKey'));
      });

      test('simple with String/Location origin/destination', () {
        expect(
            distanceMatrix.buildUrl(
              origin: ['10 Girda Urdu Rd, Dhaka'].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${Uri.encodeComponent('10 Girda Urdu Rd, Dhaka')}&destinations=23.762488,90.373025&key=$apiKey'));
      });

      test('simple with bad type for origin/destination', () {
        try {
          distanceMatrix.buildUrl(
              origin: [10.00].toList(),
              destination: ['Marseilles, France'].toList());
        } catch (e) {
          expect((e as ArgumentError).message,
              equals("'origin' must be a '$String' or a '$Location'"));
        }

        try {
          distanceMatrix.buildUrl(
              origin: [Location(23.43, 65.1)].toList(),
              destination: [10].toList());
        } catch (e) {
          expect((e as ArgumentError).message,
              equals("'destination' must be a '$String' or a '$Location'"));
        }
      });

      test('avoid ', () {
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              routeType: RouteType.tolls,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&avoid=tolls&key=$apiKey'));
      });

      test('travel mode', () {
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              travelMode: TravelMode.driving,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&mode=driving&key=$apiKey'));
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              travelMode: TravelMode.bicycling,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&mode=bicycling&key=$apiKey'));

        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              travelMode: TravelMode.walking,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&mode=walking&key=$apiKey'));

        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              travelMode: TravelMode.transit,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&mode=transit&key=$apiKey'));
      });

      test('language code', () {
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                languageCode: 'Bangali'),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&language=Bangali&key=$apiKey'));
      });

      test('alternative', () {
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              alternative: true,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&alternative=true&key=$apiKey'));
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              alternative: false,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&alternative=false&key=$apiKey'));
      });

      test('unit system', () {
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                unit: Unit.metric),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&units=metric&key=$apiKey'));

        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                unit: Unit.imperial),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&units=imperial&key=$apiKey'));
      });

      test('arrival_time', () {
        var d = 1343641500;
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              arrivalTime: d,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&arrival_time=$d&key=$apiKey'));
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                arrivalTime: DateTime.fromMillisecondsSinceEpoch(d * 1000)),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&arrival_time=$d&key=$apiKey'));
      });

      test('departure_time', () {
        var d = 1343641500;
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              departureTime: d,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&departure_time=$d&key=$apiKey'));
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                departureTime: DateTime.fromMillisecondsSinceEpoch(d * 1000)),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&departure_time=$d&key=$apiKey'));
      });

      test('departure_time with now', () {
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                departureTime: 'now'),
            equals(
              'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&departure_time=now&key=$apiKey',
            ));
      });

      test('traffic model', () {
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                trafficModel: TrafficModel.bestGuess),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&traffic_model=best_guess&key=$apiKey'));
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                trafficModel: TrafficModel.optimistic),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&traffic_model=optimistic&key=$apiKey'));
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                trafficModel: TrafficModel.pessimistic),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&traffic_model=pessimistic&key=$apiKey'));
      });

      test('transit mode', () {
        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                transitMode: [TransitMode.bus]),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&transit_mode=bus&key=$apiKey'));

        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                transitMode: [TransitMode.rail]),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&transit_mode=rail&key=$apiKey'));

        expect(
            distanceMatrix.buildUrl(
                origin: [Location(23.721017, 90.394358)].toList(),
                destination: [Location(23.762488, 90.373025)].toList(),
                transitMode: [
                  TransitMode.rail,
                  TransitMode.train,
                  TransitMode.subway,
                  TransitMode.tram,
                ]),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&transit_mode=rail|train|subway|tram&key=$apiKey'));
      });

      test('transit route preference', () {
        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              transitRoutingPreference: TransitRoutingPreferences.lessWalking,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&transit_routing_preference=less_walking&key=$apiKey'));

        expect(
            distanceMatrix.buildUrl(
              origin: [Location(23.721017, 90.394358)].toList(),
              destination: [Location(23.762488, 90.373025)].toList(),
              transitRoutingPreference:
                  TransitRoutingPreferences.fewerTransfers,
            ),
            equals(
                'https://maps.googleapis.com/maps/api/distancematrix/json?origins=23.721017,90.394358&destinations=23.762488,90.373025&transit_routing_preference=fewer_transfers&key=$apiKey'));
      });

      test('decode response', () {
        var response = DistanceResponse.fromJson(json.decode(_responseExample));

        expect(response.isOkay, isTrue);
        expect(response.results, hasLength(1));
        expect(response.originAddress, hasLength(1));
        expect(response.originAddress.first,
            equals('Bakshi Bazar Road, Dhaka, Bangladesh'));
        expect(response.destinationAddress, hasLength(1));
        expect(response.destinationAddress.first,
            equals('Rd 11, Dhaka 1212, Bangladesh'));
        expect(response.results.first.elements, hasLength(1));
        expect(response.results.first.elements.first.duration.text,
            equals('29 mins'));
        expect(
            response.results.first.elements.first.duration.value, equals(1725));
        expect(response.results.first.elements.first.distance.text,
            equals('9.2 km'));
        expect(
            response.results.first.elements.first.distance.value, equals(9247));
      });
      test('encode response', () {
        var decoded = json.decode(_responseExample);
        var recoded = DistanceResponse.fromJson(decoded).toJson();
        // toJson is not implemented in DistanceResponse, using parent's impl.
        for (var i in recoded.keys) {
          expect(recoded[i], decoded[i]);
        }
      });
    });
  });
}

final _responseExample = '''{
   "destination_addresses": [
      "Rd 11, Dhaka 1212, Bangladesh"
   ],
   "origin_addresses": [
      "Bakshi Bazar Road, Dhaka, Bangladesh"
   ],
   "rows": [
      {
         "elements": [
            {
               "distance": {
                  "text": "9.2 km",
                  "value": 9247
               },
               "duration": {
                  "text": "29 mins",
                  "value": 1725
               },
               "status": "OK"
            }
         ]
      }
   ],
   "status": "OK"
}''';
