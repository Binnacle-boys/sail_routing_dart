import 'dart:math';
import 'package:args/args.dart';
import 'route_model.dart';
import 'package:sail_routing_dart/shared/route_math.dart';
import 'package:vector_math/vector_math.dart';
import 'package:sail_routing_dart/route_writer.dart';

bool v_flag = false;

// void main(List<String> args) {
//  var parser = new ArgParser();
//  parser.addFlag("verbose", abbr: 'v', defaultsTo: false);
//  var results = parser.parse(args);
//  v_flag = results['verbose'];

//  Vector2 start = new Vector2(0.0, 0.0);
//  Vector2 end = new Vector2(1.0, -10.2);
//  double wind = 3 * pi / 2;
//  RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);

//  calculateOptimal(route);
//  print(route);

//  RouteWriter rw = new RouteWriter();
//  rw.writeToFileFromRouteModel(route: route);
//  rw.run_python_plotter();
//}

double euc_dist(Vector2 a, Vector2 b) {
  return a.distanceTo(b);
}

void verbosePrint(dynamic s) {
  if (v_flag) {
    print(s);
  }
}

Vector2 find_intersection(Vector2 a_point, Vector2 b_point, Vector2 c_point, Vector2 d_point) {
  double a1 = b_point.y - a_point.y;
  double b1 = a_point.x - b_point.x;
  double c1 = a1 * (a_point.x) + b1 * (a_point.y);

  // Line CD represented as a2x + b2y = c2
  double a2 = d_point.y - c_point.y;
  double b2 = c_point.x - d_point.x;
  double c2 = a2 * (c_point.x) + b2 * (c_point.y);
  double determinant = a1 * b2 - a2 * b1;

  if (determinant == 0) {
    print("find_intersection() found parallel");
    throw Error();
  } else {
    double x = (b2 * c1 - b1 * c2) / determinant;
    double y = (a1 * c2 - a2 * c1) / determinant;

    verbosePrint("intersection: " + Vector2(x, y).toString());

    return new Vector2(x, y);
  }
}

bool check_viable_tack(Vector2 p1, Vector2 p2, double wind_radians) {
  /*
    check_viable_tack just checks if a tack from p1 -> p2 is makable (not directly upwind).
    Args:
        p1 (Vector2): Cartesian coordinates of start
        p2 (Vector2): Cartesian coordinates of end
        wind_radians (double): wind direction 
    Returns:
        bool
  */
  double no_go_limit_radians = 0.610865; // Equivilant to 35 degrees

  double ngzone_upper_bound = (wind_radians + no_go_limit_radians);
  double ngzone_lower_bound = (wind_radians - no_go_limit_radians);
  verbosePrint("wind lower-upper: " + radToDegStr(ngzone_lower_bound) + " <-> " + radToDegStr(ngzone_upper_bound));
  Vector2 delta = p2 - p1;
  double tack_angle = atan2(delta.y, delta.x);
  verbosePrint("pot viable tack: " + radToDegStr(tack_angle));
  // arctan gives values fro [-pi, pi]
  if (tack_angle < 0) {
    tack_angle += 2 * pi;
  }

  verbosePrint("(tack_angle > ngzone_lower_bound) => " + (tack_angle > ngzone_lower_bound).toString());
  verbosePrint("(tack_angle < ngzone_upper_bound) => " + (tack_angle < ngzone_upper_bound).toString());
  return !((tack_angle > ngzone_lower_bound) && (tack_angle < ngzone_upper_bound));
}

String radToDegStr(double radians) => (radians * 57.2958).toString();

double bestTackAngle(Vector2 start, Vector2 goal, double wind_radians, bool invert_flag) {
  double no_go_limit_radians = 0.610865; // Equivilant to 35 degrees
  Vector2 delta = goal - start;
  double impossible_tack = atan2(delta.y, delta.x);
  verbosePrint("imposs_tack  =  " + radToDegStr(impossible_tack));
  double ngzone_upper_bound = (wind_radians + no_go_limit_radians);
  double ngzone_lower_bound = (wind_radians - no_go_limit_radians);
  verbosePrint("wind lower-upper: " + radToDegStr(ngzone_lower_bound) + " <-> " + radToDegStr(ngzone_upper_bound));

  var angle_from_ideal_upper = (impossible_tack - ngzone_upper_bound);
  var angle_from_ideal_lower = (impossible_tack - ngzone_lower_bound);

  verbosePrint("possible tacks: " + radToDegStr(angle_from_ideal_lower) + " <-> " + radToDegStr(angle_from_ideal_upper));
  bool lower_better = (angle_from_ideal_lower < angle_from_ideal_upper);
  lower_better = (invert_flag) ? !lower_better : lower_better;

  return (lower_better) ? ngzone_lower_bound : ngzone_upper_bound;
}

calculateOptimal(RouteModel route) {
  List intermediate_points = new List<Vector2>();
  bool viable = check_viable_tack(route.start, route.end, route.wind_radians);
  if (!viable) {
    double best_tack_slope = bestTackAngle(route.start, route.end, route.wind_radians, false);

    verbosePrint("_BEST TACK " + radToDegStr(best_tack_slope));
    // TODO this can be done better, note th +pi
    double inverse_tack_slope = bestTackAngle(route.end, route.start, route.wind_radians, true) + pi;
    verbosePrint("_INVERSE TACK " + radToDegStr(inverse_tack_slope));

    Vector2 start2 = route.start + Vector2(cos(best_tack_slope), sin(best_tack_slope));
    Vector2 end2 = route.end + Vector2(cos(inverse_tack_slope), sin(inverse_tack_slope));

    verbosePrint(end2);
    Vector2 intersect = find_intersection(route.start, start2, route.end, end2);

    intermediate_points.add(start2);
    intermediate_points.add(intersect);
    intermediate_points.add(end2);

    route.intermediate_points = intermediate_points;
  } else {
    route.intermediate_points = [];
  }
}
