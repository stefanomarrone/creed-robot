#!/usr/bin/python

import VisionFactory
import RobotControllerFactory
import time
import sys
import Geometry
import os

def beep(duration=1,freq=440):
	os.system('play --no-show-progress --null --channels 1 synth %s sine %f' % (duration, freq))

factory = VisionFactory.VisionFactory('configuration.ini')
vis = factory.generate()
vis.switchON()
factory = RobotControllerFactory.RobotControllerFactory('configuration.ini')
rc = factory.generate()
counter = 0
# call pusher
os.system('./pusher.py 1 0')
print "Round #" + str(counter)
counter += 1
print "Acquire"
vis.acquire()
print "Computing"
vis.compute()
m = vis.getBoxesNumber()
for i in range(0,m):
	print "Extracting " + str(i)
	pos, angle, flag = vis.getBox(i)
	if (flag == True):
		beep(1,540)
		result = rc.inbound(pos,angle)
		print "INB - 1 - " + str(result)
	else:
		beep(2,280)
vis.switchOFF()
vis.save()

