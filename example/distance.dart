library google_maps_webservice.distance.example;

import 'dart:io';

import 'package:google_maps_webservice/distance.dart';

final GoogleDistanceMatrix distanceMatrix =
    GoogleDistanceMatrix(apiKey: Platform.environment["API_KEY"]);

main() async {
  List<Location> origins = [
    Location(23.721160, 90.394435),
    Location(23.732322, 90.385142),
  ];
  List<Location> destinations = [
    Location(23.726346, 90.377117),
    Location(23.748519, 90.403121),
  ];

  DistanceResponse responseForLocation =
      await distanceMatrix.distanceWithLocation(
    origins,
    destinations,
  );

  try {
    print('response ${responseForLocation.status}');

    if (responseForLocation.isOkay) {
      print(responseForLocation.destinationAddress.length);
      responseForLocation.results.forEach((row) {
        row.elements.forEach((element) {
          print(
              'distance ${element.distance.text} duration ${element.duration.text}');
        });
      });
    } else {
      print('ERROR: ${responseForLocation.errorMessage}');
    }
  } finally {
    distanceMatrix.dispose();
  }
}
