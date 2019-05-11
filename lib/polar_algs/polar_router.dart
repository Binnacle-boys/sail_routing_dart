/// Polar Router
/// Algorithm class that gets a route based on a polar plot
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

  /// Get route that has only been tested with wind at 180 degrees; 
  /// should transform based on wind direction to handle other cases.
  /// Arguments:
  ///   (List<double>) start - Starting point in cartesian space
  ///   (List<double>) end - End point where boat wants to go
  ///   (double) windSpeed - Wind speed in knots
  ///   (double) windDirection - Wind direction - Cardinal directions in degrees
  /// Returns:
  ///   (List<List<double>>) - List of points that specify where the boat should go   
  List<List<double>> getTransRoute(
    List<double> start,
    List<double> end,
    double windSpeed,
    double windDirection
  ) {
    var route = List<List<double>>();
    route.add(start);
    // Get the route

    // Get the desired angle
    double desiredAngle = atan2(end[1] - start[1], end[0] - start[0]);
    double desiredDirection = radiansToCardinal(desiredAngle);

    // Get optimal direction
    double vmgDirection = _polarPlot.getOptimalAngle(desiredDirection, windDirection, windSpeed);
    
    // Evaluate if straight from a to b is more optimal than taking tack
    double desiredDiff = angleDifference(vmgDirection, desiredDirection).abs();
    bool desiredPossible = ! _polarPlot.inNogoZone(desiredDirection, windDirection, windSpeed);
    if (desiredDiff > minDiff || !desiredPossible) {
      print("Should tack...");
      print("vmg direction: ${vmgDirection}");
      print("desiredDirection: ${desiredDirection}");
      print("Desired Difference: ${desiredDiff} ");
      print("DesiredPossible = ${desiredPossible}");
      // Case: Should tack
      // Construct vectors
      Vector2 startVec = Vector2(start[0], start[1]);
      Vector2 endVec = Vector2(end[0], end[1]);

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
    // End should always be the last point
    route.add(end);
    return route;
  }

}