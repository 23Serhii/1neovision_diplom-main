import 'dart:math' as math;

double calculateDistanceMeters(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = math.cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * math.asin(math.sqrt(a)) * 1000;
}

double calculateAngle(y1, y2, x1, x2) =>
    180 + math.atan2(y2 - y1, x2 - x1) * (180 / math.pi);

double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // radius of the earth in km
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.pow(math.sin(dLon / 2), 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  final distance = R * c * 1000; // distance in meters
  return distance;
}

double _toRadians(double degree) {
  return degree * math.pi / 180;
}

double calculateZoom(double sideLengthInKm, double pixelSize) {
  double metersPerPixel = sideLengthInKm * 1000 / pixelSize;
  double zoom = math.log(156543.03392 / metersPerPixel) / math.log(2);
  return zoom;
}
