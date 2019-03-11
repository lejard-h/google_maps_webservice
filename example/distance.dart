library google_maps_webservice.distance.example;

import 'package:google_maps_webservice/distance.dart';

final GoogleDistanceMatrix distanceMatrix =
    GoogleDistanceMatrix(apiKey: 'AIzaSyDW30A0MP3rPs3E6W2K0YRNuCDKQ6kPTco');

main() async{

    Location origin = Location(23.721160, 90.394435);
    Location destination = Location(23.726346, 90.377117);

    String originAddress = 'Bakshibazar,Dhaka';
    String destinationAddress = 'Banani,Dhaka';

    DistanceResponse response = await distanceMatrix.distanceWithLocation(origin, destination);

    try{
      print('response ${response.status}');

      if(response.isOkay){

        response.results.forEach((element){
          print(element.elementStatus);
          /*print('distance ${element.distance.value}');
          print('duration ${element.duration.text}');*/
        });
      }else{
        print('ERROR: ${response.errorMessage}');
      }
    }finally{
      distanceMatrix.dispose();
    }

    
}
