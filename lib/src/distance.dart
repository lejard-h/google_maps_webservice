library google_maps_webservice.distance.src;

import 'package:http/http.dart';

import 'utils.dart';
import 'core.dart';

const _distanceUrl = '/distancematrix/json';

///https://developers.google.com/maps/documentation/distance-matrix/intro
class GoogleDistanceMatrix extends GoogleWebService {
  GoogleDistanceMatrix({
    String apiKey,
    String baseUrl,
    Client httpClient,
  }) : super(
            apiKey: apiKey,
            baseUrl: baseUrl,
            url: _distanceUrl,
            httpClient: httpClient);

  void _distance(
    origin,
    destination, {
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType avoid,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) async {
    print(buildUrl(
      origin: origin,
      destination: destination,
      travelMode: travelMode,
      languageCode: languageCode,
      alternative: alternative,
      region: region,
      routeType: avoid,
      unit: unit,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    ));
  }

  void distanceWithLocation(
    Location origin,
    Location destination, {
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType avoid,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) {
    _distance(
      origin,
      destination,
      travelMode: travelMode,
      languageCode: languageCode,
      alternative: alternative,
      region: region,
      avoid: avoid,
      unit: unit,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      transitMode: transitMode,
      trafficModel: trafficModel,
      transitRoutingPreference: transitRoutingPreference,
    );
  }

  void distanceWithAddress() {}

  String buildUrl({
    origin,
    destination,
    TravelMode travelMode,
    String languageCode,
    bool alternative,
    String region,
    RouteType routeType,
    Unit unit,
    arrivalTime,
    departureTime,
    List<TransitMode> transitMode,
    TrafficModel trafficModel,
    TransitRoutingPreferences transitRoutingPreference,
  }) {
    if (origin is! Location && origin is! String) {
      throw new ArgumentError("'origin' must be a '$String' or a '$Location'");
    }
    if (destination is! Location && destination is! String) {
      throw new ArgumentError(
          "'destination' must be a '$String' or a '$Location'");
    }
    if (departureTime != null &&
        departureTime is! DateTime &&
        departureTime is! num) {
      throw new ArgumentError(
          "'departureTime' must be a '$num' or a '$DateTime'");
    }
    if (arrivalTime != null &&
        arrivalTime is! DateTime &&
        arrivalTime is! num) {
      throw new ArgumentError(
          "'arrivalTime' must be a '$num' or a '$DateTime'");
    }

    final params = {
      "origin": origin != null && origin is String
          ? Uri.encodeComponent(origin)
          : origin,
      "destination": destination != null && destination is String
          ? Uri.encodeComponent(destination)
          : destination,
    };

    if (apiKey != null) {
      params.putIfAbsent("key", () => apiKey);
    }

    return '$url?${buildQuery(params)}';
  }
}

class DistanceResponse extends GoogleResponseStatus {
  DistanceResponse(
    String status,
    String errorMsg,
  ) : super(
          status,
          errorMsg,
        );
}

enum TravelMode { driving, walking, bicycling, transit }

TravelMode stringToTravelMode(String mode) {
  if (mode.toLowerCase() == "driving") return TravelMode.driving;
  if (mode.toLowerCase() == "walking") return TravelMode.walking;
  if (mode.toLowerCase() == "bicycling") return TravelMode.bicycling;
  if (mode.toLowerCase() == "transit") return TravelMode.transit;
  return null;
}

String travelModeToString(TravelMode mode) {
  if (mode == TravelMode.driving) return "driving";
  if (mode == TravelMode.walking) return "walking";
  if (mode == TravelMode.bicycling) return "bicycling";
  if (mode == TravelMode.transit) return "transit";
  return null;
}

enum RouteType { tolls, highways, ferries, indoor }

RouteType stringToRouteType(String type) {
  if (type.toLowerCase() == "tolls") return RouteType.tolls;
  if (type.toLowerCase() == "highways") return RouteType.highways;
  if (type.toLowerCase() == "ferries") return RouteType.ferries;
  if (type.toLowerCase() == "indoor") return RouteType.indoor;
  return null;
}

String routeTypeToString(RouteType type) {
  if (type == RouteType.tolls) return "tolls";
  if (type == RouteType.highways) return "highways";
  if (type == RouteType.ferries) return "ferries";
  if (type == RouteType.indoor) return "indoor";
  return null;
}

enum Unit { metric, imperial }

Unit stringToUnit(String type) {
  if (type.toLowerCase() == "metric") return Unit.metric;
  if (type.toLowerCase() == "imperial") return Unit.imperial;
  return null;
}

String unitToString(Unit type) {
  if (type == Unit.metric) return "metric";
  if (type == Unit.imperial) return "imperial";
  return null;
}

enum TrafficModel { bestGuess, pessimistic, optimistic }

TrafficModel stringToTrafficModel(String type) {
  if (type.toLowerCase() == "best_guess") return TrafficModel.bestGuess;
  if (type.toLowerCase() == "pessimistic") return TrafficModel.pessimistic;
  if (type.toLowerCase() == "optimistic") return TrafficModel.optimistic;
  return null;
}

String trafficModelToString(TrafficModel type) {
  if (type == TrafficModel.bestGuess) return "best_guess";
  if (type == TrafficModel.pessimistic) return "pessimistic";
  if (type == TrafficModel.optimistic) return "optimistic";
  return null;
}

enum TransitMode { bus, subway, train, tram, rail }

TransitMode stringToTransitMode(String type) {
  if (type.toLowerCase() == "bus") return TransitMode.bus;
  if (type.toLowerCase() == "subway") return TransitMode.subway;
  if (type.toLowerCase() == "train") return TransitMode.train;
  if (type.toLowerCase() == "tram") return TransitMode.tram;
  if (type.toLowerCase() == "rail") return TransitMode.rail;
  return null;
}

String transitModeToString(TransitMode type) {
  if (type == TransitMode.bus) return "bus";
  if (type == TransitMode.subway) return "subway";
  if (type == TransitMode.train) return "train";
  if (type == TransitMode.tram) return "tram";
  if (type == TransitMode.rail) return "rail";
  return null;
}

enum TransitRoutingPreferences { lessWalking, fewerTransfers }

TransitRoutingPreferences stringToTransitRoutingPreferences(String type) {
  if (type.toLowerCase() == "less_walking")
    return TransitRoutingPreferences.lessWalking;
  if (type.toLowerCase() == "fewer_transfers")
    return TransitRoutingPreferences.fewerTransfers;
  return null;
}

String transitRoutingPreferencesToString(TransitRoutingPreferences type) {
  if (type == TransitRoutingPreferences.lessWalking) return "less_walking";
  if (type == TransitRoutingPreferences.fewerTransfers)
    return "fewer_transfers";
  return null;
}
