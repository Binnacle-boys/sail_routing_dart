
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