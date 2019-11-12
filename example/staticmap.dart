library google_maps_webservice.staticmap.example;

import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/staticmap.dart';

final apiKey = 'APIKEY';

void main() {
  StaticMap staticMap = StaticMap(
    apiKey,
    markers: List.from([
      Location(23.721160, 90.394435),
      Location(23.732322, 90.385142),]
    ),
    path: Path(
      enc: 'svh~F`j}uOusC`bD', 
      color: 'black',
    ),
    scale: 'false'
  );


  // @override
  //   Widget build(BuildContext context) {
  //     return Container(
  //       child: Image.network(staticMap.getUrl())
  //     );
  //   }


}