import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';
import 'package:quiver/iterables.dart';
// Polar plot class generated through csv polar plot files
class PolarPlot {

  HashMap<double, HashMap<double, double>> _plot;
  Set<double> _angles;
  Set<double> _windSpeeds;
  // Must be called to intialize the plot
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

  // Gets angle difference without losing sign (rotation direction)
  double angleDifference(firstAngle, secondAngle) {
    double difference = secondAngle - firstAngle;
    while (difference < -180) {
      difference += 360;
    }
    while (difference > 180) {
      difference -= 360;
    }
    return difference;
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
  void hello() {
    print("Working");
  }
}