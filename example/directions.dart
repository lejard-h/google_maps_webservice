library google_maps_webservice.directions.example;

import 'package:google_maps_webservice/directions.dart';

final directions =
    new GoogleMapsDirections(apiKey: 'AIzaSyDW30A0MP3rPs3E6W2K0YRNuCDKQ6kPTco');

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
