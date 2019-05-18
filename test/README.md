# Polar Plot Command Line ##
polar_plot_cli.dart is a command line application that run various scenarios with give CSV polar plot file. 

## Using the Command Line Application ##
This is the template for running the command line interface:
```bash
dart polar_plot_cli.dart /path/to/csv.csv
```

## What the Application Does ##
First it will generate a map for the CSV file of the various wind angles from the given plot and the wind speeds. Then it will print the interpreted map. Then it w ill print the wind angles in the map and the wind speeds. 

Once the map is made it displays results for the shared math angle difference function. It displays various combintations to understand how the function works.

Afterwards, certain values will be given to find the optimal route direction given a desired heading (Straight line from A to B) and and wind direction.

After ideal angles are tested, it also does various checks for how close the boat can go into the wind and if certain heading options are in the no go zone.

Finally, a start and end position are evaluated with the route algorithm before passing it on the route writing function. So the graphical result is written to the package path: /lib/plotted_course.png

