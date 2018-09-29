library google_maps_webservice.directions.test;

import 'dart:convert';
import 'package:google_maps_webservice/src/core.dart';
import 'package:google_maps_webservice/src/directions.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

launch([Client client]) async {
  final apiKey = "MY_API_KEY";
  GoogleMapsDirections directions = new GoogleMapsDirections(apiKey, client);

  tearDownAll(() {
    directions.dispose();
  });

  group("Google Maps Directions", () {
    group("build url", () {
      test("simple with String origin/destination", () {
        expect(
            directions.buildUrl(
                origin: "Paris, France", destination: "Marseilles, France"),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=${Uri
                .encodeComponent("Paris, France")}&destination=${Uri
                .encodeComponent("Marseilles, France")}"));
      });

      test("simple with Location origin/destination", () {
        expect(
            directions.buildUrl(
                origin: new Location(23.43, 65.1),
                destination: new Location(62.323, 53.1)),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=23.43,65.1&destination=62.323,53.1"));
      });

      test("simple with String/Location origin/destination", () {
        expect(
            directions.buildUrl(
                origin: new Location(23.43, 65.1),
                destination: "Marseilles, France"),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=23.43,65.1&destination=${Uri
                .encodeComponent("Marseilles, France")}"));
      });

      test("simple with bad type for origin/destination", () {
        try {
          directions.buildUrl(origin: 10, destination: "Marseilles, France");
        } catch (e) {
          expect((e as ArgumentError).message,
              equals("'origin' must be a '$String' or a '$Location'"));
        }

        try {
          directions.buildUrl(
              origin: new Location(23.43, 65.1), destination: 10);
        } catch (e) {
          expect((e as ArgumentError).message,
              equals("'destination' must be a '$String' or a '$Location'"));
        }
      });

      test("avoid", () {
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                avoid: RouteType.tolls),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&avoid=tolls"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                avoid: RouteType.highways),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&avoid=highways"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                avoid: RouteType.indoor),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&avoid=indoor"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                avoid: RouteType.ferries),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&avoid=ferries"));
      });

      test("travel_mode", () {
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                travelMode: TravelMode.bicycling),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&mode=bicycling"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                travelMode: TravelMode.driving),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&mode=driving"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                travelMode: TravelMode.transit),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&mode=transit"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                travelMode: TravelMode.walking),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&mode=walking"));
      });

      test("departure_time", () {
        int d = 1343641500;
        expect(
            directions.buildUrl(
                origin: "Toronto", destination: "Montreal", departureTime: d),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&departure_time=$d"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                departureTime:
                    new DateTime.fromMillisecondsSinceEpoch(d * 1000)),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&departure_time=$d"));
      });

      test("arrival_time", () {
        int d = 1343641500;
        expect(
            directions.buildUrl(
                origin: "Toronto", destination: "Montreal", arrivalTime: d),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&arrival_time=$d"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                arrivalTime: new DateTime.fromMillisecondsSinceEpoch(d * 1000)),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&arrival_time=$d"));
      });

      test("units", () {
        expect(
            directions.buildUrl(
                origin: "Toronto", destination: "Montreal", units: Unit.metric),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&units=metric"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                units: Unit.imperial),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&units=imperial"));
      });

      test("traffic_model", () {
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                trafficModel: TrafficModel.bestGuess),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&traffic_model=best_guess"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                trafficModel: TrafficModel.pessimistic),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&traffic_model=pessimistic"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                trafficModel: TrafficModel.optimistic),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&traffic_model=optimistic"));
      });

      test("transit_mode", () {
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                transitMode: [TransitMode.rail]),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&transit_mode=rail"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                transitMode: [TransitMode.bus]),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&transit_mode=bus"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                transitMode: [
                  TransitMode.tram,
                  TransitMode.train,
                  TransitMode.subway
                ]),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&transit_mode=tram|train|subway"));
      });

      test("transit_routing_preference", () {
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                transitRoutingPreference:
                    TransitRoutingPreferences.lessWalking),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&transit_routing_preference=less_walking"));
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                transitRoutingPreference:
                    TransitRoutingPreferences.fewerTransfers),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&transit_routing_preference=fewer_transfers"));
      });

      test("waypoints", () {
        expect(
            directions.buildUrl(
                origin: "Toronto",
                destination: "Montreal",
                waypoints: [
                  Waypoint.optimize(),
                  Waypoint.fromAddress("Paris"),
                  Waypoint.fromLocation(new Location(42.2, 21.3)),
                  Waypoint.fromPlaceId("ChIJ3S-JXmauEmsRUcIaWtf4MzE"),
                  Waypoint.fromEncodedPolyline("gfo}EtohhU")
                ]),
            equals(
                "https://maps.googleapis.com/maps/api/directions/json?key=$apiKey&origin=Toronto&destination=Montreal&waypoints=optimize:true|Paris|42.2,21.3|place_id:ChIJ3S-JXmauEmsRUcIaWtf4MzE|enc:gfo}EtohhU:"));
      });
    });

    test("decode response", () {
      DirectionsResponse response =
          new DirectionsResponse.fromJson(json.decode(_responseExample));

      expect(response.isOkay, isTrue);
      expect(response.routes, hasLength(equals(1)));
      expect(response.geocodedWaypoints, hasLength(equals(4)));
      expect(response.routes.first.legs, hasLength(equals(1)));
      expect(response.routes.first.legs.first.steps, hasLength(equals(1)));

      expect(response.routes.first.summary, equals("I-40 W"));
      expect(response.routes.first.copyrights,
          equals("Map data ©2010 Google, Sanborn"));
      expect(response.routes.first.waypointOrder, equals([0, 1]));
      expect(response.routes.first.bounds.northeast.lat, equals(41.8781100));
      expect(response.routes.first.bounds.northeast.lng, equals(-87.6297900));
      expect(response.routes.first.bounds.southwest.lat, equals(34.0523600));
      expect(response.routes.first.bounds.southwest.lng, equals(-118.2435600));
      expect(response.routes.first.overviewPolyline.points, equals("points"));

      expect(response.geocodedWaypoints.first.types,
          equals(["locality", "political"]));
      expect(response.geocodedWaypoints.first.placeId,
          equals("ChIJ7cv00DwsDogRAMDACa2m4K8"));
      expect(response.geocodedWaypoints.first.geocoderStatus, equals("OK"));

      expect(response.routes.first.legs.first.startAddress,
          equals("Oklahoma City, OK, USA"));
      expect(response.routes.first.legs.first.endAddress,
          equals("Los Angeles, CA, USA"));
      expect(response.routes.first.legs.first.duration.value, equals(74384));
      expect(response.routes.first.legs.first.duration.text,
          equals("20 hours 40 mins"));
      expect(response.routes.first.legs.first.distance.value, equals(2137146));
      expect(
          response.routes.first.legs.first.distance.text, equals("1,328 mi"));
      expect(response.routes.first.legs.first.startLocation.lat,
          equals(35.4675602));
      expect(response.routes.first.legs.first.startLocation.lng,
          equals(-97.5164276));
      expect(
          response.routes.first.legs.first.endLocation.lat, equals(34.0522342));
      expect(response.routes.first.legs.first.endLocation.lng,
          equals(-118.2436849));

      expect(
          response.routes.first.legs.first.steps.first.htmlInstructions,
          equals(
              "Head \u003cb\u003enorth\u003c/b\u003e on \u003cb\u003eS Morgan St\u003c/b\u003e toward \u003cb\u003eW Cermak Rd\u003c/b\u003e"));

      expect(response.routes.first.legs.first.steps.first.polyline.points,
          equals("a~l~Fjk~uOwHJy@P"));

      expect(response.routes.first.legs.first.steps.first.duration.text,
          equals("1 min"));

      expect(response.routes.first.legs.first.steps.first.duration.value,
          equals(19));

      expect(response.routes.first.legs.first.steps.first.distance.text,
          equals("0.1 mi"));

      expect(response.routes.first.legs.first.steps.first.distance.value,
          equals(207));

      expect(response.routes.first.legs.first.steps.first.startLocation.lat,
          equals(41.8507300));
      expect(response.routes.first.legs.first.steps.first.startLocation.lng,
          equals(-87.6512600));

      expect(response.routes.first.legs.first.steps.first.endLocation.lat,
          equals(41.8525800));
      expect(response.routes.first.legs.first.steps.first.endLocation.lng,
          equals(-87.6514100));

      expect(response.routes.first.legs.first.steps.first.travelMode,
          equals(TravelMode.driving));
    });

    test('Location handle all number', () {
      final loc = Location.fromJson({
        'lat': 1,
        'lng': 2.1,
      });

      expect(loc.lat, equals(1.0));
      expect(loc.lng, equals(2.1));
    });
  });
}

final _responseExample = '''
{
  "status": "OK",
  "geocoded_waypoints" : [
     {
        "geocoder_status" : "OK",
        "place_id" : "ChIJ7cv00DwsDogRAMDACa2m4K8",
        "types" : [ "locality", "political" ]
     },
     {
        "geocoder_status" : "OK",
        "place_id" : "ChIJ69Pk6jdlyIcRDqM1KDY3Fpg",
        "types" : [ "locality", "political" ]
     },
     {
        "geocoder_status" : "OK",
        "place_id" : "ChIJgdL4flSKrYcRnTpP0XQSojM",
        "types" : [ "locality", "political" ]
     },
     {
        "geocoder_status" : "OK",
        "place_id" : "ChIJE9on3F3HwoAR9AhGJW_fL-I",
        "types" : [ "locality", "political" ]
     }
  ],
  "routes": [ {
    "summary": "I-40 W",
    "legs": [ {
      "steps": [ {
        "travel_mode": "DRIVING",
        "start_location": {
          "lat": 41.8507300,
          "lng": -87.6512600
        },
        "end_location": {
          "lat": 41.8525800,
          "lng": -87.6514100
        },
        "polyline": {
          "points": "a~l~Fjk~uOwHJy@P"
        },
        "duration": {
          "value": 19,
          "text": "1 min"
        },
        "html_instructions": "Head \u003cb\u003enorth\u003c/b\u003e on \u003cb\u003eS Morgan St\u003c/b\u003e toward \u003cb\u003eW Cermak Rd\u003c/b\u003e",
        "distance": {
          "value": 207,
          "text": "0.1 mi"
        }
      }],
      "duration": {
        "value": 74384,
        "text": "20 hours 40 mins"
      },
      "distance": {
        "value": 2137146,
        "text": "1,328 mi"
      },
      "start_location": {
        "lat": 35.4675602,
        "lng": -97.5164276
      },
      "end_location": {
        "lat": 34.0522342,
        "lng": -118.2436849
      },
      "start_address": "Oklahoma City, OK, USA",
      "end_address": "Los Angeles, CA, USA"
    } ],
    "copyrights": "Map data ©2010 Google, Sanborn",
    "overview_polyline": {
      "points": "points"
    },
    "warnings": [ ],
    "waypoint_order": [ 0, 1 ],
    "bounds": {
      "southwest": {
        "lat": 34.0523600,
        "lng": -118.2435600
      },
      "northeast": {
        "lat": 41.8781100,
        "lng": -87.6297900
      }
    }
  } ]
}
''';

main() => launch();
