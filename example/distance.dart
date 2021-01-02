library google_maps_webservice.distance.example;

import 'dart:async';
import 'dart:io';

import 'package:google_maps_webservice/distance.dart';

final GoogleDistanceMatrix distanceMatrix =
    GoogleDistanceMatrix(apiKey: Platform.environment['API_KEY']);

Future<void> main() async {
  var origins = [
    Location(lat: 23.721160, lng: 90.394435),
    Location(lat: 23.732322, lng: 90.385142),
  ];
  var destinations = [
    Location(lat: 23.726346, lng: 90.377117),
    Location(lat: 23.748519, lng: 90.403121),
  ];

  var responseForLocation = await distanceMatrix.distanceWithLocation(
    origins,
    destinations,
  );

  try {
    print('response ${responseForLocation.status}');

    if (responseForLocation.isOkay) {
      print(responseForLocation.destinationAddress.length);
      for (var row in responseForLocation.results) {
        for (var element in row.elements) {
          print(
              'distance ${element.distance.text} duration ${element.duration.text}');
        }
      }
    } else {
      print('ERROR: ${responseForLocation.errorMessage}');
    }
  } finally {
    distanceMatrix.dispose();
  }
}
