import 'dart:async';
import 'directions_test.dart' as directions;
import 'geocoding_test.dart' as geocoding;
import 'geolocation_test.dart' as geolocation;
import 'places_test.dart' as places;
import 'utils_test.dart' as utils;

Future<void> main() async {
  await geocoding.launch();
  await geolocation.launch();
  await places.launch();
  await directions.launch();
  await utils.launch();
}
