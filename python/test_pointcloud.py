#!/usr/bin/python

import pypcd
import math
import numpy as np

(xh,yh) = (320, 300)
(xl,yl) = (-292, -290)
pc = pypcd.PointCloud.from_path('foo.pcd')
purged = 0
for t in pc.pc_data:
	boo = (xl < t['x']) and (t['x'] < xh) and (yl < t['y']) and (t['y'] < yh)
	if not boo:
		purged += 1
		t['x'] = None
		t['y'] = None
		t['z'] = None
print "purged " + str(purged) 
pc.save_pcd('bar.pcd')


