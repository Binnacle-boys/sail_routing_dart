import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:sail_routing_dart/polar_plotting/polar_plot.dart';

void main (List<String> arguments) {
    exitCode = 0;
    print("hey look at my arguments! ");
    for (final arg in arguments) {
        print(arg);
    }
    var plot = PolarPlot();
    plot.hello();
    
}
