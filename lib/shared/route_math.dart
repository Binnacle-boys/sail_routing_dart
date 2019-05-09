import 'dart:math';
import 'package:vector_math/vector_math.dart';


List<double> findIntersection(
  List<double> p1,
  List<double> p2,
  List<double> p3,
  List<double> p4
) {
  double x1, x2, x3, x4;
  double y1, y2, y3, y4;

  x1 = p1[0]; y1 = p1[1];
  x2 = p2[0]; y2 = p2[1];
  x3 = p3[0]; y3 = p3[1];
  x4 = p4[0]; y4 = p4[1];

  double pxNumer = ((x1 * y2 - y1 * x2) * (x3 - x4) -
              (x1 - x2) * (x3 * y4 - y3 * x4));
  double pxDenom = ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4));
  double px = pxNumer / pxDenom;

  double pyNumer = ((x1 * y2 - y1 * x2) * (y3 - y4) -
              (y1 - y2) * (x3 * y4 - y3 * x4));
  double pyDenom = ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4));
  double py = pyNumer / pyDenom;

  return [px, py];
}

double cardinalTransform(double angle) {
  return (90 + (360 - angle)) % 360;
}

double radiansToCardinal(double rads) {
  return cardinalTransform(radToDeg(rads));
}

double degToRad(double degrees) {
  return degrees * pi / 180.0;
}

double radToDeg(double rads) {
  return rads * 180.0 / pi;
}

/// Gets angle difference while retaining sign (rotation direction)
/// returns secondAngle - firstAngle
/// Compass Bearing Mapping - Positive => Clockwise
/// Unit Circle Standard - Positive => Counterclockwise
/// This may need to be added to some helper function class
double angleDifference(firstAngle, secondAngle) {
  double difference = secondAngle - firstAngle;
  while (difference < -180) {
    difference += 360;
  }
  while (difference > 180) {
    difference -= 360;
  }
  return difference;
}

Vector2 polarDegVector(double degrees) {
  double rads = degToRad(degrees);
  return polarRadVector(rads);
}

Vector2 polarRadVector(double rads) {
  return Vector2(cos(rads), sin(rads));
}
