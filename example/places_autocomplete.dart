library google_maps_webservice.places.autocomplete.example;

import 'dart:async';
import 'dart:io';

import 'package:google_maps_webservice/places.dart';

final places = GoogleMapsPlaces(apiKey: Platform.environment['API_KEY']);

Future<void> main() async {
  var sessionToken = 'xyzabc_1234';
  var res = await places.autocomplete('Amoeba', sessionToken: sessionToken);

  if (res.isOkay) {
    // list autocomplete prediction
    for (var p in res.predictions) {
      print('- ${p.description}');
    }

    final placeId = res.predictions.first.placeId;
    if (placeId == null) return;

    // get detail of the first result
    var details = await places.getDetailsByPlaceId(
      placeId,
      sessionToken: sessionToken,
    );

    print('\nDetails :');
    print(details.result.formattedAddress);
    print(details.result.formattedPhoneNumber);
    print(details.result.url);
  } else {
    print(res.errorMessage);
  }

  places.dispose();
}
