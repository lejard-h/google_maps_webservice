library google_maps_webservice.directions.example;

import 'dart:io';
import 'package:google_maps_webservice/directions.dart';

final directions = new GoogleMapsDirections(apiKey: Platform.environment["API_KEY"]);

main() async {
  DirectionsResponse res =
      await directions.directionsWithAddress("Paris, France", "Rennes, France");

  print(res.status);
  if (res.isOkay) {
    print("${res.routes.length} routes");
    res.routes.forEach((Route r) {
      print(r.summary);
      print(r.bounds);
    });
  } else {
    print(res.errorMessage);
  }

  directions.dispose();
}
