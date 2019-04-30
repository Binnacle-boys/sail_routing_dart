import 'dart:math';
import 'package:args/args.dart';
import 'cart_point.dart';
import 'route_model.dart';

import 'package:sail_routing_dart/route_writer.dart';

bool v_flag = false;

void main(List<String> args) {

  var parser = new ArgParser();
  parser.addFlag("verbose", abbr: 'v', defaultsTo: false);
  var results = parser.parse(args);
  v_flag = results['verbose'];

  Cart_Point start = new Cart_Point(0.0, 0.0);
  Cart_Point end = new Cart_Point(-1, 10.0);
  double wind = pi / 2;
  RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);

  calculateOptimal(route);
  verbose_print(route);

  RouteWriter rw = new RouteWriter();
  rw.writeToFileFromRouteModel(route: route);
  rw.run_python_plotter();
}

double euc_dist(Cart_Point a, Cart_Point b) {
  return a.toPoint().distanceTo(b.toPoint());
}

void verbose_print(dynamic s) {
  if (v_flag) {
    print(s);
  }
}

Cart_Point find_intersection(
    Cart_Point a_point, Cart_Point b_point, Cart_Point c_point, Cart_Point d_point) {
    double a1 = b_point.y - a_point.y; 
    double b1 = a_point.x - b_point.x; 
    double c1 = a1*(a_point.x) + b1*(a_point.y); 

    // Line CD represented as a2x + b2y = c2 
    double a2 = d_point.y - c_point.y; 
    double b2 = c_point.x - d_point.x; 
    double c2 = a2*(c_point.x)+ b2*(c_point.y);
    double determinant = a1*b2 - a2*b1; 

  if (determinant == 0) {
    print("find_intersection() found parallel");
    throw Error();
  } else {
    double x = (b2 * c1 - b1 * c2) / determinant;
    double y = (a1 * c2 - a2 * c1) / determinant;

    verbose_print("intersection: " + Cart_Point(x, y).toString());

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
        bool
  */
  double no_go_limit_radians = 0.610865; // Equivilant to 35 degrees

  double ngzone_upper_bound = (wind_radians + no_go_limit_radians);
  double ngzone_lower_bound = (wind_radians - no_go_limit_radians);
  verbose_print("wind lower-upper: " +
      radToDegStr(ngzone_lower_bound) +
      " <-> " +
      radToDegStr(ngzone_upper_bound));
  Point delta = p2.toPoint() - p1.toPoint();

  double tack_angle = atan2(delta.y, delta.x);
  verbose_print("pot viable tack: " + radToDegStr(tack_angle));

  if (tack_angle < 0) {
    tack_angle += pi;
  }

  verbose_print("(tack_angle > ngzone_lower_bound) => " + (tack_angle > ngzone_lower_bound).toString());
  verbose_print("(tack_angle < ngzone_upper_bound) => " + (tack_angle < ngzone_upper_bound).toString());
  return !((tack_angle > ngzone_lower_bound) && (tack_angle < ngzone_upper_bound));
}

String radToDegStr(double radians) => (radians * 57.2958).toString();

double bestTackAngle(Cart_Point start, Cart_Point goal, double wind_radians, bool invert_flag) {
  double no_go_limit_radians = 0.610865; // Equivilant to 35 degrees
  Point delta = goal.toPoint() - start.toPoint();
  double impossible_tack = atan2(delta.y, delta.x);
  verbose_print("imposs_tack  =  " + radToDegStr(impossible_tack));
  double ngzone_upper_bound = (wind_radians + no_go_limit_radians);
  double ngzone_lower_bound = (wind_radians - no_go_limit_radians);
  verbose_print("wind lower-upper: " + radToDegStr(ngzone_lower_bound) + " <-> " + radToDegStr(ngzone_upper_bound));

  var angle_from_ideal_upper = (impossible_tack - ngzone_upper_bound);
  var angle_from_ideal_lower = (impossible_tack - ngzone_lower_bound);

  verbose_print("possible tacks: " + radToDegStr(angle_from_ideal_lower) + " <-> " + radToDegStr(angle_from_ideal_upper));
  bool lower_better = (angle_from_ideal_lower < angle_from_ideal_upper);
  lower_better = (invert_flag)?  !lower_better: lower_better;

 
  return (lower_better) ? ngzone_lower_bound : ngzone_upper_bound;

  
  
}

calculateOptimal(RouteModel route) {
  List intermediate_points = new List<Cart_Point>();
  bool viable = check_viable_tack(route.start, route.end, route.wind_radians);
  if (!viable) {
    double best_tack_slope =
        bestTackAngle(route.start, route.end, route.wind_radians, false);

    verbose_print("__BEST TACK " + radToDegStr(best_tack_slope));
    // TODO this can be done better, note th +pi
    double inverse_tack_slope =
        bestTackAngle(route.end, route.start, route.wind_radians, true) + pi;
    verbose_print("__INVERSE TACK " + radToDegStr(inverse_tack_slope));

    Cart_Point start2 = Cart_Point.fromPoint(route.start.toPoint() +
        Point(cos(best_tack_slope), sin(best_tack_slope)));
    Cart_Point end2 = Cart_Point.fromPoint(route.end.toPoint() +
        Point(cos(inverse_tack_slope), sin(inverse_tack_slope)));

    verbose_print(end2);
    Cart_Point intersect =
        find_intersection(route.start, start2, route.end, end2);

    intermediate_points.add(start2);
    intermediate_points.add(intersect);
    intermediate_points.add(end2);

    route.intermediate_points = intermediate_points;
  } else {
    route.intermediate_points = [];
  }
 
}
