#!/usr/bin/python

import time
import glob, os
import sys

maxnum = int(sys.argv[1])
sleeptime = int(sys.argv[2])
limit = 100 if maxnum == 0 else maxnum
flag = True
while (flag):
	counter = 0
	os.system('rm -f /home/stefano/Scrivania/sink/*')
	if (maxnum != 0):
		flag = False
	while (counter < limit):
		temp = str(counter)
		while (len(temp)<3):
			temp = '0' + temp
		os.system('cp /home/stefano/Scrivania/source/scene-' + temp + '* /home/stefano/Scrivania/sink/')
		time.sleep(sleeptime)
		counter = counter + 1
	

