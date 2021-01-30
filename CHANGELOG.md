# Changelog

## 0.0.20-nullsafety.0

- Support null safety

## 0.0.19

- added optional region param to buildTextSearchUrl - @ahmedNY
- Add to allow custom headers for calling google apis - @zeshuaro

## 0.0.18

- Support `Static Map API`, thanks to @LBreitembach
- fix(autocomplete): add origin parameter to autocomplete queries, thanks to @safarmer

## 0.0.17

- Add 'region' parameter to 'getDetailsByPlaceId'
- Fix type mismatch on PlacesDetailsResponse.fromJson(json)

## 0.0.16

- Fix alternatives params

## 0.0.15

- Handle 'now' string for departure_time
- fix GeocodedWaypoint.partialMatch type (now a boolean)

## 0.0.14

- Support Timezone API, thanks to @aryzhov
- Support `fields` and `region` for place details

## 0.0.13

- Support Photos API, thanks to @domesticmouse

## 0.0.12

- Add Distance Matrix API, thanks to @1abid

## 0.0.11

- fix session token
- add pagetoken for searchNearby

## 0.0.10

- introduced configurable base url
- changed apiKey to an optional named parameter
- added session token parameter for autocomplete search

## 0.0.9

- fix partial match type in geocoding

## 0.0.8

- fix 'Int' is not double

## 0.0.7

- fix opening hours

## 0.0.6

- update dart sdk

## 0.0.5

- bug fix

## 0.0.4

- support Dart 2

## 0.0.3

- parse Geometry field in place details response

## 0.0.2

- Directions API

## 0.0.1

- Geocoding API
- Places API
