#!/usr/bin/python

import operator
import os
import imutils
import time
import math
import cv2
import random
import Box
import Geometry
import datetime
import ImageProvider
import numpy as np
from skimage import img_as_ubyte
import Profilable
import PointCloudManagerFactory
import DPFactory

class Vision(Profilable.Profilable):
	def __init__(self,o,fheader,ftrailer,path,rotFlag,dbgflag = False,livedebug_val = False):
		# debugging
		self.debug = dbgflag
		self.live = livedebug_val
		self.debugCounter = 0
		self.sinkdir = 'logs/'
		# information provider
		self.provider = ImageProvider.ImageProvider(path,fheader,ftrailer)
		factory = PointCloudManagerFactory.PointCloudManagerFactory('configuration.ini')
		self.pcm = factory.generate()
		# image scaling parameters
		self.origin = o
		self.rotation = rotFlag
		self.boxes = None
		self.ppFunctores = [self.standardPP, self.thresholding]
		super(Vision,self).__init__()

	# Preprocessing functions
	def standardPP(self):
		processed = self.img.copy()
		processed = cv2.cvtColor(processed, cv2.COLOR_BGR2GRAY)
		processed = cv2.GaussianBlur(processed, (13,13), 0)
		return processed

	def thresholding(self):
		processed = self.img.copy()
		ret,processed = cv2.threshold(processed,127,255,cv2.THRESH_BINARY)
		return processed

	# Get the images from the 
	def acquire(self):
		self.right_frame, self.left_frame, self.main_frame, pcname = self.provider.getFrame()
		if (self.rotation == True):
			self.right_frame = imutils.rotate_bound(self.right_frame,180)
			self.left_frame = imutils.rotate_bound(self.left_frame,180)
			self.main_frame = imutils.rotate_bound(self.main_frame,180)
		self.pcm.load(pcname)
		self.img = self.right_frame

	# It retrieves the boxes from the image
	def genBoxes(self,ppfunction):
		# Preprocessing
		processed = ppfunction()
		# Edge Highlightning
		edged = processed.copy()
		edged = cv2.Canny(processed, 10, 200) # canny: first parameter -> greater, # canny: second parameter -> greater, less contours
		# Contours Detection
		cnts, hierarchy = cv2.findContours(edged, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
		# Boxing making
		factory = DPFactory.DPFactory('configuration.ini')
		dp = factory.generate()
		boxes = list(cnts)
		boxes = map(lambda x: Box.Box(x,dp,self.img,self.pcm),boxes)
		# Filtering 
		# [Area] Is the area in the valid range?
		boxes = filter(lambda x: x.checkArea(),boxes)
		# [Black] Is the area "totally" black?
		boxes = filter(lambda x: x.isNotBlack(),boxes)
		# [Canvas] Is the area in the legal area (the canvas)?
		boxes = filter(lambda x: x.inCanvas(),boxes)
		# [Inside] Is the area inside another one?
		boxes = filter(lambda x: not x.insider(boxes),boxes)
		return boxes

#### WRKING
	# try to improve: make a decorator
	def compute(self):
		againFlag = True
		while (againFlag):
			againFlag = False
			try:
				boxlists = map(lambda f: self.genBoxes(f),self.ppFunctores)
				boxlists = reduce(lambda x,y: self.joinBoxSets(x,y),boxlists)
				boxlists = map(lambda x: x.improve(),boxlists)
				self.boxes = boxlists
			except Exception as e:
				header = '[Vision-compute]'
				errmsg = e.message if hasattr(e,'message') else e  
				print(header + ' ' + errmsg)
				self.acquire()
				againFlag = True
		return True


	# It join two lists of boxes
	def joinBoxSets(self,a,b):
		temp = list(a)
		for x in b:
			stopFlag = False
			counter = 0
			while ((counter<len(temp)) and (not stopFlag)):
				stopFlag = x.equalsTo(temp[counter])
				counter += 1
			if not stopFlag:
				temp.append(x)
		return temp



### TODO





	def isEmpty(self):
		retval = len(self.boxes) > 0
		return retval

	def getBoxesNumber(self):
		return len(self.boxes)

	# it retrives the coordinates of the next piece to pickup in relation with the reference point
	def getNext(self):
		l = self.getBoxesNumber()
		retval = True
		p = None
		a = None
		try:
			next = random.randint(0,l-1)
			p,a = self.getBox(next)
		except Exception as e:
			header = '[Vision-getNext]'
			errmsg = e.message if hasattr(e,'message') else e  
			print(header + ' ' + errmsg)
			retval = False
		return p, a, retval

	def getBox(self,i):
		b = self.boxes[i]
		retval = True
		# debugging actions
		self.imgdbg(i)
		# coordinate extractions
		pos = b.extractCoordinates()
		ipos = (pos[1],pos[0],pos[2])
		opos = tuple(map(operator.mul, self.origin, (1,1,-1)))
		retpos = tuple(map(operator.add, ipos, opos))
		# angle
		angle = b.getAngle()
		# check if any element is NaN
		sanitylist = list(retpos)
		sanitylist.append(angle)
		sanitylist = map(lambda x: math.isnan(x),sanitylist)
		if any(sanitylist):
			raise ValueError('NaN value not expected')
			retval = False
		return retpos, angle, retval

	def imgdbg(self,index):
		if (self.debug == True):
			fname = self.experiment_log(index)
			self.debugCounter += 1
			if (self.live == True):
				self.experiment_live(fname)

	def experiment_log(self,box_index):
		temp = self.img.copy()
		# file name
		time_mark = datetime.datetime.now().strftime("on%Y-%m-%d@%H:%M")
		filename = self.sinkdir + '/TEST_' + self.namePad() + '_' + time_mark + '.png'
		# contours
		box = self.boxes[box_index]
		box_c = box.getDraw()
		frame_c = np.int0(cv2.cv.BoxPoints(self.canvas))
		cnts = [frame_c, box_c]
		cv2.drawContours(temp, cnts, -1, self.highlight, 2)
		# points
		box_centre = box.getCentre()
		opt_centre = Geometry.intPos2D(self.optical_centre)
		pts = [opt_centre, box_centre]
		map(lambda p: cv2.circle(temp,p,2,self.highlight,-1), pts)
		# flushing on the file
		cv2.imwrite(filename,temp)
		return filename

	def experiment_live(self,fn):
		img = cv2.imread(fn)
		cv2.namedWindow('feedback', cv2.WINDOW_NORMAL)
		cv2.imshow('feedback',img)
		cv2.waitKey(0)
		cv2.destroyWindow('feedback')

	def debug_boxset(self,name,boxs):
		cnts = map(lambda x: x.cont,boxs)
		temp = self.img.copy()
		cv2.drawContours(temp, cnts, -1, self.highlight, 2)
		cv2.imwrite(name + '.png',temp)

	def namePad(self):
		retval = str(self.debugCounter) 
		while (len(retval) < 3):
			retval = '0' + retval
		return retval


#	def toString(self):
#		retval = ""
#		retval += "origin: " + self.pointToString(self.origin)
#		retval += "max: " + self.pointToString(self.max)
#		retval += "reference: " + self.pointToString(self.reference)
#		retval += "debug:" + str(self.debugFlag) + "\n"
#		return retval
#
#	def pointToString(self,p):
#		retval = "(" + str(p[0]) + "," + str(p[1]) + "," + str(p[2]) + ")"
#		return retval
#
#
#	def imgDbgPts(self,name,img,cnts,pts):
#		temp = img.copy()
#		cv2.drawContours(temp, [cnts], -1, self.highlight, 2)
#		map(lambda p: cv2.circle(temp,p,2,self.highlight,-1), pts)
#		cv2.imwrite(name + '.png',temp)
#
#	def imgPts(self,name,img,pts):
#		temp = img.copy()
#		map(lambda p: cv2.circle(temp,p,1,self.highlight,-1), pts)
#		cv2.imwrite(name + '.png',temp)
#
#	def debug_box(self,b):
#		cnts = [self.derectify(b)]
#		self.imgDbg('Debug_box',self.img,cnts)
#	def dbg(self,txt):
#		if (self.debug == True):
#			print "[DBG-VS]: "  + txt

