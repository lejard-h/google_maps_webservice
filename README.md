<p align="center">
<a href="https://github.com/lejard-h/google_maps_webservice/actions?query=workflow%3ADart"><img src="https://github.com/lejard-h/google_maps_webservice/workflows/Dart/badge.svg?branch=master" alt="Build Status"></a>
<a href="https://codecov.io/gh/lejard-h/google_maps_webserviced"><img src="https://codecov.io/gh/lejard-h/google_maps_webservice/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/lejard-h/google_maps_webservice"><img src="https://img.shields.io/github/stars/lejard-h/google_maps_webservice.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://www.buymeacoffee.com/lejardh" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="25px"></a>
</p>

# google_maps_webservice

## General Information

This is the Dart Library for Google Maps Webservices.
You can find the Google Maps Platform Documentation [here](https://developers.google.com/maps/web-services), but if you're new to this, you may want to start [here](https://developers.google.com/maps/gmp-get-started).

## API Key

To use this library you need a **Web** API key. Follow [these](https://developers.google.com/places/web-service/get-api-key) steps to acquire the key relevant to your particular Dart application.

These keys are not to be used individually as Android or iOS API keys, but they are instead meant to be used in your Dart application.

## Availables API

- [x] [Geocoding](https://developers.google.com/maps/documentation/geocoding/start)
- [ ] [Places](https://developers.google.com/places/web-service/)
  - [x] nearby search
  - [x] text search
  - [x] details
  - [ ] add
  - [ ] delete
  - [x] photo
  - [x] autocomplete
  - [x] queryautocomplete
- [x] [Directions](https://developers.google.com/maps/documentation/directions/)
- [x] [Distance Matrix](https://developers.google.com/maps/documentation/distance-matrix/)
- [ ] [Geolocation](https://developers.google.com/maps/documentation/geolocation/intro)
- [ ] [Elevation](https://developers.google.com/maps/documentation/elevation/start)
- [ ] [Roads](https://developers.google.com/maps/documentation/roads/intro)
- [x] [Timezone](https://developers.google.com/maps/documentation/timezone/start)
- [x] [Static Map](https://developers.google.com/maps/documentation/maps-static/dev-guide)

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

PlacesSearchResponse response = await places.searchNearbyWithRadius(new Location(lat: 31.0424, lng: 42.421), 500);
PlacesSearchResponse response = await places.searchNearbyWithRankby(new Location(lat: 31.0424, lng: 42.421), "distance");
PlacesSearchResponse response = await places.searchByText("123 Main Street");

PlacesDetailsResponse response = await places.getDetailsByPlaceId("PLACE_ID");
PlacesDetailsResponse response = await places.getDetailsByReference("REF");
```

### Timezone

```dart
import "package:google_maps_webservice/timezone.dart";

final timezone = new GoogleMapsTimezone(apiKey: "<API_KEY>");
final timezone = new GoogleMapsTimezone(apiKey: "<API_KEY>", httpClient: new BrowserClient());
final timezone = new GoogleMapsTimezone(baseUrl: "http://myProxy.com");

TimezoneResponse response = await timezone.getByLocation(new Location(lat: 31.0424, lng: 42.421));
TimezoneResponse response = await timezone.getByLocation(new Location(lat: 31.0424, lng: 42.421), timestamp: DateTime.utc(2019, 4, 24));
TimezoneResponse response = await timezone.getByLocation(new Location(lat: 31.0424, lng: 42.421), timestamp: DateTime.utc(2019, 4, 24), language: 'es');
```

### Static Map

```dart

  StaticMap mapStatic = StaticMap(
    apiKey,
    markers: List.from([
      Location(lat: 23.721160, lng: 90.394435),
      Location(lat: 23.732322, lng: 90.385142),]
    ),
    path: Path(
      enc: 'svh~F`j}uOusC`bD',
      color: 'black',
    ),
    scale: 'false'
  )

  String url = mapStatic.getUrl();

  Image.network(url)


```

### Proxy

In case of using a proxy the baseUrl can be set.
The apiKey is not required in case the proxy sets it. (Not storing the apiKey in the app is good practice)

### Feature Requests and Issues

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/lejard-h/google_maps_webservice/issues/new
