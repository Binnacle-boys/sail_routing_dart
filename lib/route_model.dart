import 'dart:core';
import 'dart:math';

import 'package:sail_routing_dart/cart_point.dart';

class RouteModel {
  Cart_Point _start;
  Cart_Point _end;
  List<Cart_Point> _intermediate_points;
  double _wind_radians;

  // Getters
  Cart_Point get start => this._start;
  Cart_Point get end => this._end;
  List<Cart_Point> get intermediate_points => this._intermediate_points;
  double get wind_radians => this._wind_radians;

  void set intermediate_points(List<Cart_Point> l) =>
      this._intermediate_points = l;

  RouteModel(
      {Cart_Point start,
      Cart_Point end,
      // List<Cart_Point> intermediate_points,
      double wind_radians}) {
    this._start = start;

    this._end = end;
    this._intermediate_points = new List<Cart_Point>();
    this._wind_radians = wind_radians;
  }

  @override
  String toString() {
    String output = "[ROUTE]";

    output += "\n\tStart: " + _start.toString();
    output += "\n\tEnd: " + _end.toString();
    output += "\n\twind_radians: " + _wind_radians.toString();

    if (_intermediate_points.isNotEmpty) {
      output += "\n\tIntermediate_Points: " +
          intermediate_points.map((p) => "\n\t\t" + p.toString()).toString();
    }
    output += "\n[/ROUTE]";
    return output;
  }

  calculateOptimal() {}
}

void main() {
  Cart_Point p = new Cart_Point(1.0, 1.0);
  print(p);
}
