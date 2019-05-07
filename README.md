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