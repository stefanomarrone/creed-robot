#!/usr/bin/python

import VisionFactory
import time
import sys
import os

iterations = int(sys.argv[1])
factory = VisionFactory.VisionFactory('configuration.ini')
vis = factory.generate()
counter = 0
for i in range(0,iterations):
	# call pusher
	os.system('./pusher.py 1 0')
	print "Round #" + str(counter)
	counter += 1
	print "acquire"
	vis.acquire()
	print "compute"
	vis.compute()
	print "isempty"
	isempty = vis.isEmpty()
	#print "Is empty " + str(isempty)
	print "getNext"
	pos, angle = vis.getNext()
	print pos
	print angle
