import 'geocoding_test.dart' as geocoding;
import 'package:http/browser_client.dart';
import 'places_test.dart' as places;

main() {
  geocoding.launch(new BrowserClient());
  places.launch(new BrowserClient());
}
