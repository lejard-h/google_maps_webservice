# google_maps_webservice

[![Build Status](https://travis-ci.org/lejard-h/google_maps_webservice.svg?branch=master)](https://travis-ci.org/lejard-h/google_maps_webservice)
[![Coverage Status](https://coveralls.io/repos/github/lejard-h/google_maps_webservice/badge.svg?branch=master)](https://coveralls.io/github/lejard-h/google_maps_webservice?branch=master)

Google Maps Web Services [API](https://developers.google.com/maps/web-services)

- [x] [Geocoding](https://developers.google.com/maps/documentation/geocoding/start)
- [ ] [Places](https://developers.google.com/places/web-service/)
    - [x] nearby search
    - [x] text search
    - [x] details
    - [ ] add
    - [ ] delete
    - [ ] photo
    - [x] autocomplete
    - [x] queryautocomplete
- [x] [Directions](https://developers.google.com/maps/documentation/directions/)
- [ ] [Distance Matrix](https://developers.google.com/maps/documentation/distance-matrix/)
- [ ] [Geolocation](https://developers.google.com/maps/documentation/geolocation/intro)
- [ ] [Elevation](https://developers.google.com/maps/documentation/elevation/start)
- [ ] [Roads](https://developers.google.com/maps/documentation/roads/intro)
- [ ] [Timezone](https://developers.google.com/maps/documentation/timezone/start)


## Usage

### Geocoding

```dart
import "package:google_maps_webservice/geocoding.dart";

final geocoding = new GoogleMapsGeocoding(apiKey: "<API_KEY>");
final geocoding = new GoogleMapsGeocoding(apiKey: "<API_KEY>", httpClient: new BrowserClient());
final geocoding = new GoogleMapsGeocoding(baseUrl: "http://myProxy.com");

GeocodingResponse response = await geocoding.searchByAddress("1600 Amphitheatre Parkway, Mountain View, CA");
```

### Places

```dart
import "package:google_maps_webservice/places.dart";

final places = new GoogleMapsPlaces(apiKey: "<API_KEY>");
final places = new GoogleMapsPlaces(apiKey: "<API_KEY>", httpClient: new BrowserClient());
final places = new GoogleMapsPlaces(baseUrl: "http://myProxy.com");

PlacesSearchResponse reponse = await places.searchNearbyWithRadius(new Location(31.0424, 42.421), 500);
PlacesSearchResponse reponse = await places.searchNearbyWithRankby(new Location(31.0424, 42.421), "distance");
PlacesSearchResponse reponse = await places.searchByText("123 Main Street");

PlacesDetailsResponse response = await places.getDetailsByPlaceId("PLACE_ID");
PlacesDetailsResponse response = await places.getDetailsByReference("REF");
```

### Proxy

In case of using a proxy the baseUrl can be set.
The apiKey is not required in case the proxy sets it. (Not storing the apiKey in the app is good practice)

### Feature Requests and Issues

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/lejard-h/google_maps_webservice/issues/new
