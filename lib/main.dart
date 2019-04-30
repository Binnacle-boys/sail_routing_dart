library sail_routing_dart;

import 'package:sail_routing_dart/cart_point.dart';
import 'package:sail_routing_dart/route_model.dart';

import 'dart:math';

import 'package:sail_routing_dart/route_writer.dart';

void main() {
  double wind_radians = 2 * pi - 0.01;
  double no_go_limit_radians = 0.610865; // Equivilant to 35 degrees

  double wind_upper = (wind_radians + no_go_limit_radians) % (2 * pi);
  double wind_lower = (wind_radians - no_go_limit_radians) % (2 * pi);
  // wind_lower += wind_lower < 0 ? 2 * pi : 0;
  wind_lower *= 57.2958;
  wind_upper *= 57.2958;
  no_go_limit_radians *= 57.2958;
  print(wind_lower.toString() + ", " + wind_upper.toString());
  print(no_go_limit_radians);
}
//   Cart_Point start = new Cart_Point(0.0, 0.0);
//   Cart_Point end = new Cart_Point(9.0, 10.0);

//   double wind = 5 * pi / 4;

//   RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);
//   print(route);

//   RouteWriter rw = new RouteWriter();
//   rw.writeToFileFromRouteModel(route: route);
//   rw.run_python_plotter();
// }
