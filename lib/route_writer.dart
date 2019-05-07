import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sail_routing_dart/cart_point.dart';
import 'package:sail_routing_dart/route_model.dart';

class RouteWriter {
  writeToFile({List<double> start, List<double> end, List<List<double>> points, double wind_direction}) {
    List fileContents = new List();
    fileContents.add({'start': start});

    fileContents.add({'end': end});
    fileContents.add({'wind_direction': wind_direction});

    fileContents.add({'points': points});

    var myFile = new File('lib/plotter_data.json');

    var sink = myFile.openWrite();
    sink.write(json.encode(fileContents));
    sink.close();
  }

  writeToFileFromRouteModel({RouteModel route}) {
    List fileContents = new List();
    fileContents.add({'start': route.start.toList()});

    fileContents.add({'end': route.end.toList()});
    fileContents.add({'wind_direction': route.wind_radians});

    fileContents.add({'points': route.intermediate_points.map((CartPoint p) => p.toList()).toList()});

    var myFile = new File('lib/plotter_data.json');

    var sink = myFile.openWrite();
    sink.write(json.encode(fileContents));
    sink.close();
  }

  run_python_plotter() {
    Process.run('lib/pretty_plotter.py', ['']).then((ProcessResult pr) {
      if (pr.exitCode != 0) print(pr.exitCode);
      if (pr.stdout != '') print(pr.stdout);
      if (pr.stderr != '') print(pr.stderr);
    });
  }

  void test_run() {
    List l = new List<List<double>>();
    // making bogus test data
    for (var x = 0.0; x < 10; x++) {
      Map m = new Map();
      m[x] = x;
      l.add([(x * Random.secure().nextDouble()) % 100, x]);
    }
    writeToFile(start: [0.0, 1.0], end: [1.0, 10.0], points: l, wind_direction: 30.0);
    run_python_plotter();
  }
}
