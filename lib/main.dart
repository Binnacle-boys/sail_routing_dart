library sail_routing_dart;

import 'package:sail_routing_dart/grapher.dart';
import 'dart:math';

import 'package:sail_routing_dart/cart_point.dart';
import 'package:sail_routing_dart/route_model.dart';

void main() {
  CartPoint start = new CartPoint(0.0, 0.0);
  CartPoint end = new CartPoint(1.0, -10.2);
  double wind = 3 * pi / 2;
  RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);
  print(route);
}
