import 'dart:core';

import 'package:sail_routing_dart/cart_point.dart';

class RouteModel {
  Cart_Point _start;
  Cart_Point _end;
  List<Cart_Point> _intermediate_points;
  double _wind;

  // Getters
  Cart_Point get start => this._start;
  Cart_Point get end => this._end;
  List<Cart_Point> get intermediate_points => this._intermediate_points;
  double get wind => this._wind;

  RouteModel(
      {Cart_Point start,
      Cart_Point end,
      List<Cart_Point> intermediate_points,
      double wind}) {
    this._start = start;

    this._end = end;
    this._intermediate_points = intermediate_points;
    this._wind = wind;
  }

  @override
  String toString() {
    String output = "[ROUTE]";

    output += "\n\tStart: " + _start.toString();
    output += "\n\tEnd: " + _end.toString();
    output += "\n\tWind: " + _wind.toString();
    output += "\n\tIntermediate_Points: " +
        intermediate_points.map((p) => "\n\t\t" + p.toString()).toString();
    output += "\n[/ROUTE]";
    return output;
  }
}

void main() {
  Cart_Point p = new Cart_Point(1.0, 1.0);
  print(p);
}
