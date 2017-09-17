import 'package:http/browser_client.dart';
import 'places_test.dart' as places;
import 'geocoding_test.dart' as geocoding;
import 'directions_test.dart' as directions;

main() {
  geocoding.launch(new BrowserClient());
  places.launch(new BrowserClient());
  directions.launch(new BrowserClient());
}
