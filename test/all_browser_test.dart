import 'dart:async';
import 'package:http/browser_client.dart';
import 'directions_test.dart' as directions;
import 'geocoding_test.dart' as geocoding;
import 'places_test.dart' as places;

Future<void> main() async {
  await geocoding.launch(BrowserClient());
  await places.launch(BrowserClient());
  await directions.launch(BrowserClient());
}
