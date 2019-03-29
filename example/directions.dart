library google_maps_webservice.directions.example;

import 'dart:async';
import 'dart:io';

import 'package:google_maps_webservice/directions.dart';

final directions =
    GoogleMapsDirections(apiKey: Platform.environment['API_KEY']);

Future<void> main() async {
  DirectionsResponse res =
      await directions.directionsWithAddress('Paris, France', 'Rennes, France');

  print(res.status);
  if (res.isOkay) {
    print('${res.routes.length} routes');
    for (var r in res.routes) {
      print(r.summary);
      print(r.bounds);
    }
  } else {
    print(res.errorMessage);
  }

  directions.dispose();
}
