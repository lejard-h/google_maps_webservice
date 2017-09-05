library google_maps_webservice.places.test;

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:google_maps_webservice/places.dart';

launch([Client client]) async {
  final apiKey = "MY_API_KEY";
  GoogleMapsPlaces places = new GoogleMapsPlaces(apiKey, client);

  group("Google Maps Places", () {
    group("nearbysearch build url", () {
      test("basic", () {
        String url = places.buildNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362), radius: 500);

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500"));
      });

      test("with type and keyword", () {
        String url = places.buildNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            type: "restaurant",
            keyword: "cruise");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise"));
      });

      test("with language", () {
        String url = places.buildNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            language: "fr");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&language=fr"));
      });

      test("with min and maxprice", () {
        String url = places.buildNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            minprice: PriceLevel.free,
            maxprice: PriceLevel.veryExpensive);

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&minprice=0&maxprice=4"));
      });

      test("build url with name", () {
        String url = places.buildNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            radius: 500,
            name: "cruise");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&radius=500&name=cruise"));
      });

      test("with rankby", () {
        String url = places.buildNearbySearchUrl(
            location: new Location(-33.8670522, 151.1957362),
            rankby: "distance",
            name: "cruise");

        expect(
            url,
            equals(
                "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$apiKey&location=-33.8670522,151.1957362&name=cruise&rankby=distance"));
      });

      test("with rankby without required params", () {
        try {
          places.buildNearbySearchUrl(
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

      test("with rankby and radius", () {
        try {
          places.buildNearbySearchUrl(
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

    group("textsearch build url", () {
      test("basic", () {
        expect(
            places.buildTextSearchUrl(query: "123 Main Street"),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}"));
      });

      test("with location", () {
        expect(
            places.buildTextSearchUrl(
                query: "123 Main Street",
                location: new Location(-33.8670522, 151.1957362)),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&location=-33.8670522,151.1957362"));
      });

      test("with radius", () {
        expect(
            places.buildTextSearchUrl(query: "123 Main Street", radius: 500),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&radius=500"));
      });

      test("with language", () {
        expect(
            places.buildTextSearchUrl(query: "123 Main Street", language: "fr"),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&language=fr"));
      });

      test("with minprice and maxprice", () {
        expect(
            places.buildTextSearchUrl(
                query: "123 Main Street",
                minprice: PriceLevel.free,
                maxprice: PriceLevel.veryExpensive),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&minprice=0&maxprice=4"));
      });

      test("with opennow", () {
        expect(
            places.buildTextSearchUrl(query: "123 Main Street", opennow: true),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&opennow=true"));
      });

      test("with pagetoken", () {
        expect(
            places.buildTextSearchUrl(
                query: "123 Main Street", pagetoken: "egdsfdsfdsf"),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&pagetoken=egdsfdsfdsf"));
      });

      test("with type", () {
        expect(
            places.buildTextSearchUrl(
                query: "123 Main Street", type: "hospital"),
            equals(
                "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&query=${Uri.encodeComponent("123 Main Street")}&type=hospital"));
      });
    });

    group("details", () {});

    group("add", () {});

    group("delete", () {});

    group("photo", () {});

    group("autocomplete", () {});

    group("queryautocomplete", () {});
  });
}
