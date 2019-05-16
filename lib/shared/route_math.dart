/// Common Route Math used in Sailing Algorithms
/// Author: Nicholas Kalscheuer
import 'dart:math';
import 'package:vector_math/vector_math.dart';


/// Finds the intersection of 2 lines, p1 & p2 create one line and p3 & p4 make up the other
/// Uses vectors rather than Lists
/// Arguments:
///   (Vector2) p1 - A point on the first line 
///   (Vector2) p2 - A point on the first line 
///   (Vector2) p3 - A point on the second line 
///   (Vector2) p4 - A point on the second line 
/// Returns:
///   (Vector2) point where the two lines intersect 
Vector2 findVecIntersection(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4
) {
  List<double> intPoint =findIntersection([p1.x,p1.y], [p2.x, p2.y], [p3.x, p3.y], [p4.x, p4.y]);
  return Vector2(intPoint[0], intPoint[1]);
}

/// Finds the intersection of 2 lines, p1 & p2 create one line and p3 & p4 make up the other
/// 
/// Arguments:
///   (List<double>) p1 - A point on the first line ([0] - x,  [1] - y)
///   (List<double>) p2 - A point on the first line ([0] - x,  [1] - y)
///   (List<double>) p3 - A point on the second line ([0] - x,  [1] - y)
///   (List<double>) p4 - A point on the second line ([0] - x,  [1] - y)
/// Returns:
///   (List<double>) point where the two lines intersect ([0] - x,  [1] - y)
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

/// Transforms back or forward from cardinal directions to polar space - works both ways
/// Arguments:
///   (double) angle - Angle in degrees from either polar space or cardinal direction
/// Returns:
///   (double) angle - The opposite in degrees
double cardinalTransform(double angle) {
  return (90 + (360 - angle)) % 360;
}

/// Transforms back or forward from cardinal directions to polar space - works both ways
/// Arguments:
///   (double) angle - Angle in radians from either polar space or cardinal direction
/// Returns:
///   (double) angle - The opposite in degrees
double radiansToCardinal(double rads) {
  return cardinalTransform(radToDeg(rads));
}

/// Converts degrees to radians
double degToRad(double degrees) {
  return degrees * pi / 180.0;
}

/// Converts radians to degrees
double radToDeg(double rads) {
  return rads * 180.0 / pi;
}

/// Gets angle difference while retaining sign (rotation direction)
/// returns secondAngle - firstAngle
/// Compass Bearing Mapping - Positive => Clockwise
/// Unit Circle Standard - Positive => Counterclockwise
/// Note: Doesn't use modulus as to retain the sign of the angle
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

/// Creates a vector based on the polar angle of dergrees
/// Arguments:
///   (double) degrees - Angle of degrees in standard polar space
/// Returns:
///   (Vector2) A unit vector based on the angle given 
Vector2 polarDegVector(double degrees) {
  double rads = degToRad(degrees);
  return polarRadVector(rads);
}

/// Creates a vector based on the polar angle in radians
/// Arguments:
///   (double) rads - Radians of what the vector will be pointed in polar space
/// Returns:
///   (Vector2) A unit vector based on the angle given
Vector2 polarRadVector(double rads) {
  return Vector2(cos(rads), sin(rads));
}

/// Generates a List of length 2 from a Vector2
/// Arguments:
///   (Vector2) vec - 2 dimensional vector that will be used to make the list
/// Returns:
///   (List<double>) List with x at index 0, y at index 1 
List<double> listToVec(Vector2 vec) {
  return [vec.x, vec.y];
}

