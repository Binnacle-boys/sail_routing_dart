import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';
import 'package:sail_routing_dart/shared/route_math.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
const  minDiff = 10.0;
class PolarRouter {
  
  PolarPlot _polarPlot;
  
  PolarRouter (PolarPlot plot) {
    _polarPlot = plot;
  }

  
  List<List<double>> getTransRoute(
    List<double> start,
    List<double> end,
    double windSpeed,
    double windDirection
  ) {
    var route = List<List<double>>();
    route.add(start);
    // Get the route
    double desiredAngle = atan2(end[1] - start[1], end[0] - start[0]);
    print("desiredAngle: ${desiredAngle}");
    double desiredDirection = radiansToCardinal(desiredAngle);

    print("Desired direction: ${desiredDirection}");
    print("Wind direction: ${windDirection}");
    double vmgDirection = _polarPlot.getOptimalAngle(desiredDirection, windDirection, windSpeed);
    double desiredDiff = angleDifference(vmgDirection, desiredDirection).abs();
    bool desiredPossible = ! _polarPlot.inNogoZone(desiredDirection, windDirection, windSpeed);
    print("vmgDirection");
    print(vmgDirection);
    print("Desired Possible: ");
    print(desiredPossible);
    if (desiredDiff > minDiff || !desiredPossible) {
      // Case: Should tack
      // Construct vectors
      print("Adding extra point");
      Vector2 startVec = Vector2(start[0], start[1]);
      Vector2 endVec =Vector2(end[0], end[1]);

      double vmgAngle = cardinalTransform(vmgDirection);
      double windAngle = cardinalTransform(windDirection);

      // Getting the vectors
      Vector2 vmgVec = polarDegVector(vmgAngle);
      Vector2 windVec = polarDegVector(windAngle);
      //Perpendicular wind
      
      // Reflect vmg along wind
      Vector2 vmgReflect = vmgVec.reflected(windVec);
      vmgReflect.normalize();
      // Get another point on each line
      Vector2 startVec2 = Vector2(startVec.x + vmgVec.x, startVec.y + vmgVec.y );
      Vector2 endVec2 = Vector2(endVec.x + vmgReflect.x, endVec.y + vmgReflect.y);
      List<double> intersect = findIntersection(
        start, [startVec2.x, startVec2.y], end, [endVec2.x, endVec2.y]);
      route.add(intersect);
    }
    route.add(end);
    return route;
  }

}