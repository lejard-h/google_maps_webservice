library google_maps_webservice.distance.example;

import 'package:google_maps_webservice/distance.dart';

final GoogleDistanceMatrix distanceMatrix =
    GoogleDistanceMatrix(apiKey: 'AIzaSyDW30A0MP3rPs3E6W2K0YRNuCDKQ6kPTco');

main() {
    
    Location origin = Location(23.721160, 90.394435);
    Location destination = Location(23.726346, 90.377117);
    
    distanceMatrix.distanceWithLocation(origin, destination);
}
