library sail_routing_dart;

import 'package:sail_routing_dart/cart_point.dart';
import 'package:sail_routing_dart/route_model.dart';

import 'dart:math';

import 'package:sail_routing_dart/route_writer.dart';

void main() {
  Cart_Point start = new Cart_Point(0.0, 10.0);
  Cart_Point end = new Cart_Point(9.0, 10.0);
  List<Cart_Point> intermediate_points = new List();
  for (var x = 0.0; x < 10; x++) {
    var y = (x * Random.secure().nextDouble()) % 100;
    intermediate_points.add(new Cart_Point(x, y));
  }
  double wind = 0.0;
  RouteModel route = new RouteModel(
      start: start,
      end: end,
      intermediate_points: intermediate_points,
      wind: wind);
  print(route);

  RouteWriter rw = new RouteWriter();
  rw.writeToFileFromRouteModel(route: route);
  rw.run_python_plotter();
}
