import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';
import 'package:quiver/iterables.dart';
// Polar plot class generated through csv polar plot files
class PolarPlot {

  HashMap<double, HashMap<double, double>> _plot;
  // Must be called to intialize the plot
  Future init (String filepath) async {
    final input = new File(filepath).openRead();
    var fields = await input.transform(utf8.decoder).transform(new CsvToListConverter(fieldDelimiter: ";", eol: '\n', shouldParseNumbers: false)).toList();
    _map_init(fields);
    for (var x in fields) {
      for(var y in x) {
        print(y.toString());
      }
      print("List break");
      
    }
    print(_plot);
  }

  // Sets up hash map from list of string lists
  void _map_init (List<List<dynamic>> fields) {
    // Gets first entry in list to acquire the header
    List<dynamic> header = fields.first;
    fields.removeAt(0);
    _plot = HashMap<double, HashMap<double, double>>();
    for (var row in fields) {
      double current_angle = 0.0;
      for (List<dynamic> pair in zip([header, row])) {
        print(pair[1]);
        double row_val = double.parse(pair[1]);
        if (pair[0] == 'twa/tws') {
          // Will be wind angle label
          // Set up new current angle lable
          current_angle = row_val;
          // Initialize map entry for that angle
          _plot[current_angle] = HashMap<double, double>();
        } else {
          // Get header column to insert to the proper wind speed entry
          // of current heading angle
          double header_col =double.parse(pair[0]);
          _plot[current_angle][header_col] = row_val;
        }
      }
    }
  }
  void hello() {
    print("Working");
  }
}