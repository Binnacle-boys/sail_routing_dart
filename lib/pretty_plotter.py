#!/usr/bin/env python3
'''-------------------------------------
plotter.py

#TODO could use some error catching 
-------------------------------------- 
'''
import os
import matplotlib.pyplot as plt
import yaml
from math import cos, sin
import matplotlib

matplotlib.use('Agg')

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)


file = open('plotter_data.json')
dataMap = yaml.safe_load(file)
final_map = {}
for d in dataMap:
    final_map.update(d)
for k, v in final_map.items():
    print(k, v)

# Reorder the points with a list of x's and a list of y's
allpoints = [final_map["start"]] + final_map["points"] + [final_map["end"]]
x_row_major = [p[0] for p in allpoints]
y_row_major = [p[1] for p in allpoints]

ax = plt.axes()
wind_radians = final_map["wind_direction"]
wind_label = "Wind: " + '%.3f' % final_map["wind_direction"] + " radians"
# Where the start of the wind arrow is drawn (top center)
wind_origin = (max(x_row_major)//2, max(y_row_major)*.85)

# Draw wind arrow and label
ax.arrow(wind_origin[0], wind_origin[1], cos(wind_radians), sin(
    wind_radians), width=0.1, fill=None, fc='k', ec='k')
ax.annotate(wind_label, xy=wind_origin, color='b', backgroundcolor='w')

# Draw line connecting all points
plt.plot(x_row_major, y_row_major, color='k')

# Draw start and end points in green and red respsectively
plt.scatter(final_map["start"][0], final_map["start"][1], s=50,
            zorder=100, c='g', label="Start: " + str(final_map["start"]))
plt.scatter(final_map["end"][0], final_map["end"][1], s=50,
            zorder=100, c='r', label="End: " + str(final_map["end"]))

# Draw legend
plt.legend(loc='best')
plt.xlabel('Lon')
plt.ylabel('Lat')
# make it a square
ax.set_aspect('equal', 'box')
# Save to a file, I hated having 20+ python windows open
plt.savefig(dname+"/plotted_course")
plt.close()
