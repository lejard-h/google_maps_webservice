import 'package:google_maps_webservice/distance.dart';

class Path {
  String color;
  String enc;

  Path({
    this.color,
    this.enc,
  });

  @override
  String toString() {
    return 'color:$color|enc:$enc';
  }
}

class StaticMap {
  final String polyEncode;
  final List<Location> markers;
  final String _apiKey;
  final String zoom;
  final String size;
  final String center;
  final String scale;
  final Path path;
  final String mapType;

  StaticMap(this._apiKey,
      {this.polyEncode,
      this.markers,
      this.zoom = '',
      this.size = '580x267',
      this.center = '',
      this.scale = 'false',
      this.path,
      this.mapType = 'roadmap'})
      : assert(
          size.contains('x'),
        );

  String getUrl() {
    final params = <String, dynamic>{};
    if (path != null) {
      params['path'] = path.toString();
    }
    if (markers?.isNotEmpty ?? false) {
      params['markers'] = markers.map((l) => '|${l.lat},${l.lng}').toList();
    }

    params.addAll({
      'key': _apiKey,
      'size': size,
      'center': center,
      'zoom': zoom,
      'scale': scale,
      'mapType': mapType
    });
    print(params);
    return Uri(
            scheme: 'https',
            host: 'maps.googleapis.com',
            path: 'maps/api/staticmap',
            queryParameters: params)
        .toString();
  }
}
