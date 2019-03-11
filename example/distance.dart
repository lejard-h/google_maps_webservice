library google_maps_webservice.distance.example;

import 'package:google_maps_webservice/distance.dart';

final GoogleDistanceMatrix distanceMatrix =
    GoogleDistanceMatrix(apiKey: 'AIzaSyDW30A0MP3rPs3E6W2K0YRNuCDKQ6kPTco');

main() async {
  Location origin = Location(23.721160, 90.394435);
  Location destination = Location(23.726346, 90.377117);

  String originAddress = 'Bakshibazar,Dhaka';
  String destinationAddress = 'Banani,Dhaka';

  DistanceResponse responseForLocation =
      await distanceMatrix.distanceWithLocation(
    origin,
    destination,
  );

  try {
    print('response ${responseForLocation.status}');

    if (responseForLocation.isOkay) {
      responseForLocation.results.forEach((row) {
        row.elements.forEach((element) {
          print('distance ${element.distance.text}');
        });
      });
    } else {
      print('ERROR: ${responseForLocation.errorMessage}');
    }
  } finally {
    distanceMatrix.dispose();
  }


}
