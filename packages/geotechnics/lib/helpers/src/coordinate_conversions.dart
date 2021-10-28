import 'package:proj4dart/proj4dart.dart';

Point rdToWGS84(double rdx, double rdy) {
  final point = Point(x: rdx, y: rdy);

  // EPSG:28992 definition according to https://epsg.io/
  const def =
      '+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.417,50.3319,465.552,-0.398957,0.343988,-1.8774,4.0725 +units=m +no_defs ';
  final projSrc = Projection.parse(def);
  final projDest = Projection.get('EPSG:4326')!;

  return projSrc.transform(projDest, point);
}
