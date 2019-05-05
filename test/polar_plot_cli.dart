import 'dart:io';
import 'dart:async';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';

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
    print(plot.angleDifference(360.0, 270.0));
    print("20 - 90");
    print(plot.angleDifference(90.0, 20.0));
    print("90 - 20");
    print(plot.angleDifference(20.0, 90.0));
    print("10 - 340");
    print(plot.angleDifference(340.0, 10.0));

    double windSpeed = 6.0;
    double idealHeading = 0.0;
    double windHeading = 180.0;
    print("Wind speed: ${windSpeed}, Wind Dir: ${windHeading}, Ideal Heading: ${idealHeading}...Optimal: ");
    print(plot.getOptimalAngle(idealHeading, windHeading, windSpeed));
        

    
}
