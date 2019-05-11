import 'dart:core';
import 'package:sail_routing_dart/calc_route.dart';
import 'package:vector_math/vector_math.dart';

class RouteModel {
  Vector2 _start;
  Vector2 _end;
  List<Vector2> _intermediate_points;
  double _wind_radians;

  // Getters
  Vector2 get start => this._start;
  Vector2 get end => this._end;
  List<Vector2> get intermediate_points => this._intermediate_points;
  double get wind_radians => this._wind_radians;

  void set intermediate_points(List<Vector2> l) => this._intermediate_points = l;

  RouteModel({Vector2 start, Vector2 end, double wind_radians}) {
    this._start = start;

    this._end = end;
    this._intermediate_points = new List<Vector2>();
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
