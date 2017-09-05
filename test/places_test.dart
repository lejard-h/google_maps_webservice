library google_maps_webservice.places.test;

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:google_maps_webservice/places.dart';

launch([Client client]) async {
  final apiKey = "MY_API_KEY";
  GoogleMapsPlaces places = new GoogleMapsPlaces(apiKey, client);

  group("Google Maps Places", () {
    group("bearbysearch", () {
      test("build basic url", () {
        String url = places.builNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362), radius: 500);

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500"));
      });

      test("build url with type and keyword", () {
        String url = places.builNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            type: "restaurant",
            keyword: "cruise");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise"));
      });

      test("build url with language", () {
        String url = places.builNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            language: "fr");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&language=fr"));
      });

      test("build url with min and maxprice", () {
        String url = places.builNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            minprice: 0,
            maxprice: 4);

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&minprice=0&maxprice=4"));
      });

      test("build url with name", () {
        String url = places.builNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            name: "cruise");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&name=cruise"));
      });

      test("build url with rankby", () {
        String url = places.builNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            rankby: "distance",
            name: "cruise");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&name=cruise&rankby=distance"));
      });

      test("build url with rankby without required params", () {
        try {
          places.builNearbySearchUrl(
              location: new Location(-33.8670522, 151.1957362),
              rankby: "distance",
              name: "cruise");
        } catch (e) {
          expect(
              (e as ArgumentError).message,
              equals(
                  "If 'rankby=distance' is specified, then one or more of 'keyword', 'name', or 'type' is required."));
        }
      });

      test("build url with rankby and radius", () {
        try {
          places.builNearbySearchUrl(
              location: new Location(-33.8670522, 151.1957362),
              radius: 500,
              rankby: "distance");
        } catch (e) {
          expect(
              (e as ArgumentError).message,
              equals(
                  "'rankby' must not be included if 'radius' is specified."));
        }
      });
    });

    group("textsearch", () {});

    group("radarsearch", () {});

    group("details", () {});

    group("add", () {});

    group("delete", () {});

    group("photo", () {});

    group("autocomplete", () {});

    group("queryautocomplete", () {});
  });
}
