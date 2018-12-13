library google_maps_webservice.places.autocomplete.example;

import 'dart:io';
import 'package:google_maps_webservice/places.dart';

final places = new GoogleMapsPlaces(apiKey: Platform.environment["API_KEY"]);

main() async {
  String sessionToken = "xyzabc_1234";
  PlacesAutocompleteResponse res = await places.autocomplete("Amoeba", sessionToken: sessionToken);

  if (res.isOkay) {
    // list autocomplete prediction
    res.predictions.forEach((Prediction p) {
      print("- ${p.description}");
    });

    // get detail of the first result
    PlacesDetailsResponse details =
        await places.getDetailsByPlaceId(res.predictions.first.placeId, sessionToken: sessionToken);

    print("\nDetails :");
    print(details.result.formattedAddress);
    print(details.result.formattedPhoneNumber);
    print(details.result.url);
  } else {
    print(res.errorMessage);
  }

  places.dispose();
}
