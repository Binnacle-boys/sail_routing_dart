import 'dart:core';
import 'package:sail_routing_dart/calc_route.dart';
import 'package:sail_routing_dart/cart_point.dart';

class RouteModel {
  CartPoint _start;
  CartPoint _end;
  List<CartPoint> _intermediate_points;
  double _wind_radians;

  // Getters
  CartPoint get start => this._start;
  CartPoint get end => this._end;
  List<CartPoint> get intermediate_points => this._intermediate_points;
  double get wind_radians => this._wind_radians;

  void set intermediate_points(List<CartPoint> l) => this._intermediate_points = l;

  RouteModel({CartPoint start, CartPoint end, double wind_radians}) {
    this._start = start;

    this._end = end;
    this._intermediate_points = new List<CartPoint>();
    this._wind_radians = wind_radians;
    calculateOptimal(this);
  }

  @override
  String toString() {
    String output = "[ROUTE]";

    output += "\n\tStart: " + _start.toString();
    output += "\n\tEnd: " + _end.toString();
    output += "\n\twind_radians: " + _wind_radians.toString();

    if (_intermediate_points.isNotEmpty) {
      output += "\n\tIntermediatePoints: " + intermediate_points.map((p) => "\n\t\t" + p.toString()).toString();
    }
    output += "\n[/ROUTE]";
    return output;
  }
}
