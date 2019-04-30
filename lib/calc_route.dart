import 'dart:math';
import 'cart_point.dart';
import 'route_model.dart';
import 'package:sail_routing_dart/route_writer.dart';

void main() {
  Cart_Point start = new Cart_Point(0.0, 0.0);
  Cart_Point end = new Cart_Point(1.0, 10.0);
  double wind = 0.0;
  RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);

  calculateOptimal(route);
  print(route);

  RouteWriter rw = new RouteWriter();
  rw.writeToFileFromRouteModel(route: route);
  rw.run_python_plotter();
}

double euc_dist(Cart_Point a, Cart_Point b) {
  return a.toPoint().distanceTo(b.toPoint());
}

Cart_Point find_intersection(
    Cart_Point a, Cart_Point b, Cart_Point c, Cart_Point d) {
  double a1 = b.y - a.y;
  double b1 = a.x - b.x;
  double c1 = a1 * (a.x) + b1 * (a.y);

  // Line CD represented as a2x + b2y = c2
  double a2 = d.y - c.y;
  double b2 = c.x - d.x;
  double c2 = a2 * (c.x) + b2 * (c.y);

  double determinant = a1 * b2 - a2 * b1;

  if (determinant == 0) {
    print("find_intersection() found parallel");
    throw Error();
  } else {
    double x = (b2 * c1 - b1 * c2) / determinant;
    double y = (a1 * c2 - a2 * c1) / determinant;
    print("intersection of: " + Cart_Point(x, y).toString());
    return new Cart_Point(x, y);
  }
}

bool check_viable_tack(Cart_Point p1, Cart_Point p2, double wind_radians) {
  /*
    check_viable_tack just checks if a tack from p1 -> p2 is makable (not directly upwind).
    Args:
        p1 (tuple): Cartesian coordinates of start
        p2 (tuple): Cartesian coordinates of end
        wind_radians (double): wind direction 
    Returns:
        Boolean
  */
  double no_go_limit_radians = 0.610865; // Equivilant to 35 degrees

  double wind_upper = (wind_radians + no_go_limit_radians);
  double wind_lower = (wind_radians - no_go_limit_radians);

  Point delta = p2.toPoint() - p1.toPoint();

  double tack_angle = atan2(delta.y, delta.x);

  if (tack_angle < 0) {
    tack_angle += pi;
  }
  if (!((tack_angle > wind_lower) && (tack_angle < wind_upper))) {
    print("Not viable tack~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=\n\n\n");
  }

  return (tack_angle > wind_lower) && (tack_angle < wind_upper);
}

double bestTackAngle(Cart_Point start, Cart_Point goal, double wind_radians) {
  double no_go_limit_radians = 0.610865;
  Point delta = goal.toPoint() - start.toPoint();
  double impossible_tack = atan2(delta.y, delta.x);
  print("imposs  =  " + impossible_tack.toString());
  double wind_upper = (wind_radians + no_go_limit_radians);
  double wind_lower = (wind_radians - no_go_limit_radians);

  if ((impossible_tack - wind_upper) < (impossible_tack - wind_lower)) {
    return wind_upper;
  } else {
    return wind_lower;
  }
}

calculateOptimal(RouteModel route) {
  List intermediate_points = new List<Cart_Point>();
  // double ng_slope = bestTackAngle(route.start, route.end, route.wind_radians);
  if (!check_viable_tack(route.start, route.end, route.wind_radians)) {
    double best_tack_slope =
        bestTackAngle(route.start, route.end, route.wind_radians);

    print("__BEST TACK " + best_tack_slope.toString());
    double inverse_tack_slope =
        bestTackAngle(route.end, route.start, route.wind_radians) + pi;
    print("__INVERSE TACK " + inverse_tack_slope.toString());

    Cart_Point start2 = Cart_Point.fromPoint(route.start.toPoint() +
        Point(cos(best_tack_slope), sin(best_tack_slope)));
    Cart_Point end2 = Cart_Point.fromPoint(route.end.toPoint() +
        Point(1, -1)); //cos(inverse_tack_slope), sin(inverse_tack_slope)));
    Cart_Point intersect =
        find_intersection(route.start, start2, route.end, end2);

    intermediate_points.add(start2);
    intermediate_points.add(intersect);
    intermediate_points.add(end2);

    route.intermediate_points = intermediate_points;
  } else {
    route.intermediate_points = [new Cart_Point(3, 8)];
  }
  print(route.intermediate_points);
}
