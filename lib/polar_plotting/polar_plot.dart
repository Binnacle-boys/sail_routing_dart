import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:collection';
import 'package:quiver/iterables.dart';
import 'package:sail_routing_dart/shared/route_math.dart';
// Polar plot class generated through csv polar plot files
class PolarPlot {

  HashMap<double, HashMap<double, double>> _plot;
  Set<double> _angles;
  Set<double> _windSpeeds;
  
  /// Asynchronous initialization of the polar plot, as it reads
  /// a file from disk. Necessary before using the class,
  /// The constructor does not initialize private members.
  Future init (String filepath) async {
    final input = new File(filepath).openRead();
    _angles = Set<double>();
    _windSpeeds = Set<double>();
    // Don't like how this is a dynamic list, but don't know how to fix that yet
    var fields = await input.transform(utf8.decoder)
      .transform(new CsvToListConverter(fieldDelimiter: ";", eol: '\n', shouldParseNumbers: false))
      .toList();
    _mapInit(fields);
  }

  void printMap() {
    _plot.forEach((k, v) => {print('${k}: ${v}')});
  }

  void printWindSpeeds() {
    print(_windSpeeds);
  }

  void printAngles() {
    print(_angles);
  }

  /// Finds closest heading angle to the wind. 
  /// Arguments:
  ///   (double) windSpeed - Speed of th wind in knots
  /// Returns:
  ///   Tightest angle to the wind in degrees
  /// Notes:
  ///   - Returns double.infinity if no angles in set
  double tightestHeading(double windSpeed) {
    // Gets closest wind speed and sets tightest angle to infinity
    double plotWind =closestWindSpeed(windSpeed);
    double tightestAngle = double.infinity;

    for (double currentAngle in _angles) {
      if (_plot[currentAngle][plotWind] != 0 
        && currentAngle < tightestAngle) {
          tightestAngle = currentAngle;
      }
    }
    return tightestAngle;
  }

  /// Checks if the attempted direction is in nogo zone.
  /// Arguments:
  ///   (double) direction - Desired heading in compass bearing degrees
  ///   (double) windDirection - Wind direction in compass bearing degrees
  ///   (double) windSpeed - Wind speed in knots
  /// Returns:
  ///   (bool) : True = Sailing in nogo zone, False = Not sailing in nogo zone
  bool inNogoZone(double direction, double windDirection, double windSpeed) {
    double closestHeading = tightestHeading(windSpeed);
    if (closestHeading == double.infinity) {
      throw Iterable.empty();
    }
    double plotAngle =angleDifference((windDirection + 180) % 360, direction);
    return (plotAngle.abs() < closestHeading.abs());
  }

  /// Gets the wind speed in the plot data that is closest to 
  /// the actual wind speed.
  /// Arguments:
  ///   (double) realWindSpeed - True wind speed in knots
  /// Returns:
  ///   (double) closest valued wind speed in knots that is recorded in polar plot.
  double closestWindSpeed(double realWindSpeed) {
    double closestMatch = _windSpeeds.first;
    for (double x in _windSpeeds) {
      double currentDifference = realWindSpeed - x;
      double minDifference = realWindSpeed - closestMatch;
      if (currentDifference.abs() < minDifference.abs()) {
        closestMatch = x;
      }  
    }
    return closestMatch;
  }

  /// Gets optimal angle for going in the desired direction. Transforms 
  /// direction in to plot space to calculate the vmg. Then transforms back 
  /// to return the plot optimal absolute compass bearing. 
  /// **Note: Only capable of returning an angle that is recorded in the plot.
  /// Arguments:
  ///   (double) idealDirection - Desired dirction in degrees of compass bearing
  ///   (double) windDirection - Wind direction in degrees of compass bearing
  ///   (double) windSpeed - Wind speed in knots
  /// Returns:
  ///   (double) Absolute optimal angle in defrees of compass bearing
  double getOptimalAngle (double idealDirection, double windDirection, double windSpeed) {
    double plotIdeal = angleDifference(
        idealDirection, (windDirection + 180) % 360);
    print("Plot ideal: ${plotIdeal}");
    double direction = 1;
    if (plotIdeal < 0) {
      direction = -1;
    }
    // Getting relative plot angle
    double optimalPlotAngle = _bestAngle(plotIdeal.abs(), windSpeed);
    print("Optimal plot angle: ${optimalPlotAngle}");
    
    //Reverses plot transform
    double optmalDiff =  plotIdeal.abs() - optimalPlotAngle;
    double optimalAngle = 
      (direction  * optmalDiff + idealDirection) % 360;
    
    return optimalAngle;
  }

  

  // Sets up hash map from list of string lists
  void _mapInit (List<List<dynamic>> fields) {
    // Gets first entry in list to acquire the header
    List<dynamic> header = fields.first;
    fields.removeAt(0);
    _plot = HashMap<double, HashMap<double, double>>();
    for (var row in fields) {
      double current_angle = 0.0;
      for (List<dynamic> pair in zip([header, row])) {
        print(pair[1]);
        double rowVal = double.parse(pair[1]);
        if (pair[0] == 'twa/tws') {
          // Will be wind angle label
          // Set up new current angle lable
          current_angle = rowVal;
          _angles.add(rowVal);
          // Initialize map entry for that angle
          _plot[current_angle] = HashMap<double, double>();
        } else {
          
          // Get header column to insert to the proper wind speed entry
          // of current heading angle
          double headerCol =double.parse(pair[0]);
          _windSpeeds.add(headerCol);
          _plot[current_angle][headerCol] = rowVal;
        }
      }
    }
  }

  double _bestAngle(double idealAngle, double windSpeed) {
    double plotWind = closestWindSpeed(windSpeed);

    // Sets to first as we will be geeting th
    double vmg =_angles.first;
    for (double currentAngle in _angles) {
      double currentDiff = angleDifference(currentAngle, idealAngle);
      double vmgDiff = angleDifference(vmg, idealAngle);

      double currentCos = cos(_angleToRadians(currentDiff));
      double vmgCos =cos(_angleToRadians(vmgDiff));
      // Multiplies vector with cosine of angles to evaluate
      // Vector with highest magnitude in ideal direction
      if (currentCos * _plot[currentAngle][plotWind] > vmgCos * _plot[vmg][plotWind]) {
        vmg = currentAngle;
      }

    }
    return vmg;
  }

  double _angleToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
  void hello() {
    print("Working");
  }
}