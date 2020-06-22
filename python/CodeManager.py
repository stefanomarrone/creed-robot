#!/usr/bin/python

class CodeManager(object):
	def __init__(self, bcr, rc = None):
		self.barcode = bcr
		self.robot = rc

	def validCode(self,c):
		return len(c) == 10

#	def read(self):
#		stop = False
#		side = 0
#		# it starts the procedure of reading by means of the arm of the robot
#		while (stop == False):
#			stop = not(self.robot.moveToSide(side))
#			if (stop == False):
#				code = self.barcode.read() #reading from the barcode
#				stop = self.validCode(code)
#				if (stop == False):
#					side += 1
#			else:
#				side = -1
#		return code,side

	def read(self):
		code, angle = self.barcode.read() #reading from the barcode		
		return code, 0, angle
