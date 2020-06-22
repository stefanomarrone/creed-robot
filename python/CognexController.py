#!/usr/bin/python

import socket
import time
import math

class CognexController(object):
	def __init__(self, ipaddress, prt, ref, dbgflag = False, timt = 100, fk=False):
		self.debugFlag = dbgflag
		self.ip = ipaddress
		self.port = prt
		self.timeout = timt
		self.buffersize = 1024
		self.origin = ref
		self.fakecomm = fk
		self.fakecounter = 0
		self.fakelist =  ['False*1.0*2.0*3.0*4.0*5.0*6.0*', 'False*1.1*2.1*3.1*4.1*5.1*6.1*', 'False*1.2*2.2*3.2*4.2*5.2*6.2*', 'True*1.3*2.3*3.3*4.3*5.3*6.3*']
		#firstcheck = self.testConnection()
		#if (firstcheck != True):
		#	self.dbg("Something went wrong when connecting to the robot")

	def next(self):
		trials = 0
		maxtrials = 3
		msg = 'NEXT'
		stopflag = True
		self.dbg("Sending: <" + msg + ">")
		while ((stopflag == True) and (trials < maxtrials)):
			data = self.sendrecv(msg)
			tokens = data.split('*')
			self.dbg(data)
			z_read = math.fabs(float(tokens[3]))
			pos = (float(tokens[1]),float(tokens[2]),float(tokens[3]),float(tokens[4]),float(tokens[5]),float(tokens[6]))
			revpos = self.displace(pos)
			stopflag = (tokens[0]=='True') or (z_read < 3.0)
			retval = (stopflag,revpos)
			trials += 1
			self.dbg(str(retval)) 
		return retval

	def testConnection(self):
		retval = self.sendrecvtest("TST","0")
		return retval

	def sendrecvtest(self, message, expected):
		data = expected
		if (self.fakecomm == False):
			data = self.sendrecv(message)
		retval = (data == expected)
		if (retval == False):
			self.dbg("Mismatch in the communication")
			self.dbg("Expected: " + expected)
			self.dbg("Received: " + data)
		else:
			self.dbg("Cognex communication ok.")		
		return retval

	def sendrecv(self, message):
		data = ''
		if (self.fakecomm == False):
			s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
			s.connect((self.ip,self.port))
			s.send(message)
			data = s.recv(self.buffersize)
			s.close()
		else:
			data = self.fakedata()
		return data

	def displace(self,p):
                rp = (-p[1],p[0],-p[2],p[3],p[4],p[5])
                angle = self.adjust(p[5])
                retval = (rp[0]+self.origin[0],rp[1]+self.origin[1],rp[2]+self.origin[2],p[3],p[4],angle)
		return retval

	def adjust(self,angle):
		retval = angle
                if (math.fabs(angle) > 90.00):
                        if angle > 0:
                                retval = angle - 180
                        else:
                                retval = angle + 180
		return retval

	def fakedata(self):
		retval = self.fakelist[self.fakecounter]
		self.fakecounter += 1
		return retval

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-COG]: "  + txt
