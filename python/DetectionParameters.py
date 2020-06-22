#!/usr/bin/python

class DetectionParameters():
	def __init__(self):
		self.canvas = ((650,420),(900,750),0.0)
		self.optical_centre = (705,414)
		self.highlight = (0,255,0)
		self.black = [23,23,23]
		self.polyThresh = 0.2
		self.minarea = 5000.0
		self.maxarea = 50000.0
		self.maxblackratio = 0.2
		self.samplingDimension = 1000
		self.canvas_threshold = 0.9
		self.insider_threshold = 0.7

	def prt(self):
		print "canvas: " + str(self.canvas)
		print "optical_centre: " + str(self.optical_centre)
		print "highlight: " + str(self.highlight)
		print "black: " + str(self.black)
		print "polyThresh: " + str(self.polyThresh)
		print "minarea: " + str(self.minarea)
		print "maxarea: " + str(self.maxarea)
		print "maxblackratio: " + str(self.maxblackratio)
		print "samplingDimension: " + str(self.samplingDimension)
		print "canvas_threshold: " + str(self.canvas_threshold)
		print "insider_threshold: " + str(self.insider_threshold)

