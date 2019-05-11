## Running From Flutter ##
First import the required files with:
```dart
import 'package:sail_routing_dart/route.dart';
import 'package:sail_routing_dart/cart_point.dart';
```
This will give you the data types you need.\\
#### Calculating Routes ####
To calculate a route, first we need to create a route. The constructor should giv you hints but heres an example:
```dart
  CartPoint start = new CartPoint(0.0, 0.0);
  CartPoint end = new CartPoint(1.0, -10.2);
  double wind = 3 * pi / 2;
  RouteModel route = new RouteModel(start: start, end: end, wind_radians: wind);
```
The constructor will take care of the rest. To see the route it calculated, add `print(route)` which gives a full print-out of the route including any intermediate points the route calculation added if any. Will look something like this:
```
[ROUTE]
        Start: x: 0.0   y: 0.0
        End: x: 1.0     y: -10.2
        wind_radians: 4.71238898038469
        IntermediatePoints: (
                x: 0.5735762412306388   y: -0.8191521809137372, 
                x: 4.071056634450088    y: -5.814074365385329, 
                x: 1.573576241230639    y: -9.380847819086263)
[/ROUTE]
```


## Single Tack Routing ##
#### String whoToBlame() => 'Daniel'; ####
Run the single tack implementation of the algorithm on a hard-coded route with:
```bash
dart lib/calc_route.dart -v
```
'v' flag is for verbose mode.
The route will be displayed in `lib/plotted_course.png`

## Polar Plot Routing ##
This process uses polar plots of sail boats to obtain the optimal sailing route based on a polar plot, wind speed and direction. 
### Polar Plot ###
A number of sail boats use polar plots to determine a boat's speed in respect to wind speed and direction. CSVs are used to generate a polar plot object in order to determine optimal headings. A sample CSV file is contained in the assets folder of the library and this file is sourced from here: http://jieter.github.io/orc-data/site/csvplot.html
To construct a polar plot object use the following code:
```dart
PolarPlot plot = PolarPlot();

// Must be initialized as it is an async process
await plot.init("path/to/csvfile.csv");
```
This PolarPlot class can give the optimal heading given windDirection, desiredDirection and windSpeed:
```dart
double optimalHeading = plot.getOptimalHeading(idealDirection, windDirection, windSpeed);
```
This optimal heading is in the format of degrees and cardinal directions (0.0 is North, 90.0 is East, etc).
### Polar Routing ###
To use the polar routing, a plot will first need to be constructed from a CSV file as described above. Then it will be given to the router's construction. Using the getTransRoute, you can obtain a list of points containing the optimal path. This implementation can only give a maximum of 3 points in the route as it does not factor in obstacles or course boundaries. Also, Currently wind at 180 degrees and zero degrees are the only consistently working values for windDirection. If you'd like to do another wind angle, you may want to transform the points based on the wind before hand. 
```dart
PolarRouter pr = PolarRouter(plot);
List<List<double>> route = pr.getTransRoute(start, end, windSpeed, windDirection);
```

## Visualization ##
#### String whoToBlame() => 'Daniel'; ####

Dart doesn't have *any* good graphing package that isn't some extension or some js library like charts.js.
My quick and dirty approach (because it's just for our internal use) is something that writes all the necessary info about a course to a file and a python script that reads that file and saves a graph. 

So it goes Dart code --> plotter_data.json --> pretty_plotter.py --> plotted_course.png

If you're in the code, do something like this:
```dart
    RouteWriter rw = new RouteWriter();
    rw.writeToFile(
        start: [0.0, 1.0], 
        end: [1.0, 10.0], 
        points: <<A list of other intermediate points>>,
        wind_direction: 30.0);
    rw.run_python_plotter();
```
This should plot this course and save it in the file `lib/plotted_course.png`
To run a test from the command line, run with `dart lib/main.dart`
