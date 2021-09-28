import 'core.dart';

class Path {
  final String? color;
  final String? enc;

  Path({
    this.color,
    this.enc,
  });

  @override
  String toString() {
    return [
      color != null ? 'color:$color' : null,
      enc != null ? 'enc:$enc' : null,
    ].where((v) => v != null).join('|');
  }
}

// TOOD should extends GoogleWebService
class StaticMap {
  final String? polyEncode;
  final List<Location> markers;
  final String _apiKey;
  final String? zoom;
  final String size;
  final String? center;
  final int scale;
  final Path? path;
  final String mapType;

  StaticMap(
    this._apiKey, {
    this.polyEncode,
    this.markers = const [],
    this.zoom,
    this.size = '580x267',
    this.center,
    this.scale = 1,
    this.path,
    this.mapType = 'roadmap',
  }) : assert(
          size.contains('x'),
        );

  String getUrl() {
    final params = <String, String>{};
    if (path != null) {
      params['path'] = path.toString();
    }
    if (markers.isNotEmpty) {
      params['markers'] = markers.join('|');
    }

    final z = zoom;
    if (z != null && z.isNotEmpty) {
      params['zoom'] = z;
    }

    if (scale != 1) {
      params['scale'] = scale.toString();
    }

    final c = center;
    if (c != null && c.isNotEmpty) {
      params['center'] = c;
    }

    params.addAll({
      'key': _apiKey,
      'size': size,
      'mapType': mapType,
    });
    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: 'maps/api/staticmap',
      queryParameters: params,
    ).toString();
  }
}
