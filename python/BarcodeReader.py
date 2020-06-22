#!/usr/bin/python

import sys
import random
import time
import sys, string, os
import commands
import subprocess
import StringIO
import math

class BarcodeReader(object):
	def __init__(self, ipaddress, prt, dllp, dlln, dbgflag, tr = 5, slp = 3, fk=False):
		self.debugFlag = dbgflag
		self.codes = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
		self.ip = ipaddress
		self.port = prt
		self.trials = tr
		self.sleep = slp
		self.dll_path = dllp
		self.dll_name = dlln
		self.fakecomm = fk
		self.buffersize = 1024
		self.i_fake = 0
		self.list_fake = [('111','lot1'), ('111','lot2'), ('111','lot2'), ('222','lot3'), ('222','lot3'), ('222','lot3')]
		if (self.fakecomm == True):
			self.read = self.fakeread
		else:
			self.read = self.trueread

	def fakeread(self):
		p = random.random()
		retval = ""
		if (p > 0.7):
			retval = self.list_fake[self.i_fake][1]
			self.i_fake += 1
			if (self.i_fake == 4):
				self.i_fake = 0
		return retval,0

	def decode39(self,code39):
		retval = ''
		temp = 0
		if (len(code39) == 6):
			for i in range (5,-1,-1):
				buff = self.codes.index(code39[i])
				temp += buff * (32**(5-i))
			retval = str(temp)
			while (len(retval)<9):
				retval = '0' + retval
			retval = 'A' + retval
		return retval

	def normalize(self,angle):
		d0 = math.fabs(angle)
		d90 = math.fabs(angle - 90)
		retval = 0 if (d0 < d90) else 90
		return retval

	def trueread(self):
		retval = ''
		os.remove("bcr.tmp") 
		time.sleep(self.sleep)
		outfile = open("bcr.tmp","w")
		subprocess.call(['BCR.exe', self.ip, str(self.trials), str(self.sleep)],stdout=outfile)
		outfile.close()
		time.sleep(1)
		infile = open("bcr.tmp","r")
		contents = infile.readlines()[0]
		infile.close()
		if (contents.startswith('<<<')):
			index = contents.index('>>>')
			retval = contents[3:index]
			retval = self.decode39(retval)
			i2 = contents.index('(((')
			i3 = contents.index(')))')
			angle = float(contents[i2+3:i3])
			angle = self.normalize(angle)
		return retval,angle

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-BCR]: "  + txt
