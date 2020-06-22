#!/usr/bin/python

from threading import Timer
from pydispatch import dispatcher
import sys

class IntegrityManager():
	def __init__(self,tout,dbg):
		self.debugFlag = dbg
		self.timeout = tout
		self.step = 0.5
		self.loopFlag = True
		self.retval = False
		dispatcher.connect(self.happyEnd,signal='plc.ack',sender='plc')

	def check(self):
		self.retval = False
		self.loopFlag = True
		self.dbg("Sending from Integrity to PLC")
		dispatcher.send(message='qry',signal='plc.query',sender='integrity')
		self.dbg("Sent from Integrity to PLC")
		maxcounter = int(self.timeout/self.step)
		counter = 0
		while (self.loopFlag == True) or (counter == maxcounter):
			time.sleep(self.step)
			counter += 1
		self.dbg('Loop finito - esito ' + str(self.retval))
		return self.retval

	def happyEnd(self,message):
		self.retval = (message == 'True')
		self.loopFlag = False

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-INT]: "  + txt

