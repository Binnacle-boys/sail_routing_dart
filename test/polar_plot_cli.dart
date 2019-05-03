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
    
}
