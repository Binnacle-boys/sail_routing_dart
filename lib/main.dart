library sail_routing_dart;

import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:sail_routing_dart/route_model.dart';

void main() {
  Vector2 start = new Vector2(0.0, 0.0);
  Vector2 end = new Vector2(1.0, -10.2);
  double wind = 3 * pi / 2;
  RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);
  print(route);
}
