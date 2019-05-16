import 'dart:io';
import 'dart:async';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';
import 'package:sail_routing_dart/polar_algs/polar_router.dart';
import 'package:sail_routing_dart/route_writer.dart';
import 'package:sail_routing_dart/shared/route_math.dart';

Future main (List<String> arguments) async {
    exitCode = 0;
    print("hey look at my arguments! ");
    for (final arg in arguments) {
        print(arg);
    }
    var plot = PolarPlot();
    await plot.init(arguments[0]);
    plot.hello();
    print("Generated hash map from csv: ");
    plot.printMap();
    print("Angles: ");
    plot.printAngles();
    print("Wind speeds: ");
    plot.printWindSpeeds();

    print("270 - 360:");
    print(angleDifference(360.0, 270.0));
    print("20 - 90");
    print(angleDifference(90.0, 20.0));
    print("90 - 20");
    print(angleDifference(20.0, 90.0));
    print("10 - 340");
    print(angleDifference(340.0, 10.0));

    double windSpeed = 6.0;
    double idealHeading = 60.0;
    double windHeading = 45.0;
    print("Wind speed: ${windSpeed}, Wind Dir: ${windHeading}, Ideal Heading: ${idealHeading}...Optimal: ");
    print(plot.getOptimalAngle(idealHeading, windHeading, windSpeed));
    print("tighestAngle of wind speed ${windSpeed}: ");
    print(plot.tightestHeading(windSpeed));
    double idealHeading2 = 0.0;
    double windHeading2 = 90.0;
    print("In no go zone? ${idealHeading2}, ${windHeading2}: ");
    print(plot.inNogoZone(idealHeading2, windHeading2, windSpeed));
    idealHeading2 = 0.0;
    windHeading2 = 180.0;
    print("In no go zone? ${idealHeading2}, ${windHeading2}: ");
    print(plot.inNogoZone(idealHeading2, windHeading2, windSpeed));

    PolarRouter pr = PolarRouter(plot);
    List<List<double>> route = pr.getTransRoute([-122.014897, 36.947452], [-122.015333, 36.951860], windSpeed, 180.0);
    RouteWriter rW = RouteWriter();
    rW.writeToFile(
      start: route.first, end: route.last, points: route, wind_direction: 3.14);
    rW.run_python_plotter();


    


}
