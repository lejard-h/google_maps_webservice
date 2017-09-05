library google_maps_webservice.geocoding.test;

import 'package:google_maps_webservice/src/utils.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:google_maps_webservice/geocoding.dart';

launch([Client client]) async {
  final apiKey = "MY_API_KEY";
  GoogleMapsGeocoding geocoding = new GoogleMapsGeocoding(apiKey, client);

  group("Google Maps Geocoding buildUrl", () {
    test("address", () {
      expect(
          geocoding.buildUrl(
              address: "1600 Amphitheatre Parkway, Mountain View, CA"),
          equals(
              "$kGMapsUrl/geocode/json?key=$apiKey&address=1600%20Amphitheatre%20Parkway%2C%20Mountain%20View%2C%20CA"));
    });

    test("address with bound", () {
      expect(
          geocoding.buildUrl(
              address: "Winnetka",
              bounds: new Bounds(new Location(34.172684, -118.604794),
                  new Location(34.236144, -118.500938))),
          equals(
              "$kGMapsUrl/geocode/json?key=$apiKey&address=Winnetka&bounds=34.172684,-118.604794|34.236144,-118.500938"));
    });

    test("address with language", () {
      expect(
          geocoding.buildUrl(address: "Paris", language: "fr"),
          equals(
              "$kGMapsUrl/geocode/json?key=$apiKey&address=Paris&language=fr"));
    });

    test("address with region", () {
      expect(
          geocoding.buildUrl(address: "Toledo", region: "es"),
          equals(
              "$kGMapsUrl/geocode/json?key=$apiKey&address=Toledo&region=es"));
    });

    test("address with components", () {
      expect(
          geocoding.buildUrl(address: "Spain", components: [
            new Component(Component.administrativeArea, "Toledo")
          ]),
          equals(
              "$kGMapsUrl/geocode/json?key=$apiKey&address=Spain&components=administrative_area:Toledo"));
    });

    test("location", () {
      expect(
          geocoding.buildUrl(location: new Location(34.172684, -118.604794)),
          equals(
              "https://maps.googleapis.com/maps/api/geocode/json?key=$apiKey&latlng=34.172684,-118.604794"));
    });

    test("place_id", () {
      expect(
          geocoding.buildUrl(placeId: "f2hf1pn1rjr1"),
          equals(
              "https://maps.googleapis.com/maps/api/geocode/json?key=$apiKey&place_id=f2hf1pn1rjr1"));
    });
  });
}
