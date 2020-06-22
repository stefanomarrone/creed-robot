#!/usr/bin/python

import cv2
import Geometry
import math



import operator
import os
import imutils
import PointCloudManager
import time
import random
import datetime
import ImageProvider
import numpy as np
from skimage import img_as_ubyte
from Profilable import Profilable

class Box():
	def __init__(self,contour,parameters,image,pointcloudprovider):
		self.dp = parameters
		self.box = cv2.minAreaRect(contour)
		self.cont = np.int0(cv2.cv.BoxPoints(self.box))
		self.img = image
		self.pcp = pointcloudprovider

	def getBox(self):
		return self.box

	def getDraw(self):
		return self.cont

	def getArea(self):
		(l,h) = self.box[1]
		return h * l

	def checkArea(self):
		a = self.getArea()
		retval = (a > self.dp.minarea) and (a < self.dp.maxarea)
		return retval

	def isNotBlack(self):
		points = Geometry.genInternal(self.box,self.dp.samplingDimension)
		points = map(lambda p: self.bounds(p),points)
		points = filter(lambda p: self.isPointBlack(p),points)
		blackratio = float(len(points))/float(self.dp.samplingDimension)
		retval = (blackratio < self.dp.maxblackratio)
		return retval

	def insider(self,lst):
		sb = self.box
		maxx = len(lst)
		dims = self.dp.samplingDimension
		ith = self.dp.insider_threshold
		counter = 0
		retval = False
		while ((counter < maxx) and (not retval)):
			candidate = lst[counter]
			cb = candidate.box
			if (cb != sb):
				retval = Geometry.inside(sb,cb,ith,dims)
			counter += 1
		return retval

	def getCentre(self):
		retval = (int(self.box[0][0]),int(self.box[0][1]))
		return retval

	def getVertices(self):
		retval = Geometry.getVertices(self.box)
		return retval

	# to delete: it will not be useful
	def getAnnotatedVertices(self):
		A, B, C, D = Geometry.getVertices(self.box)
		retval = ((A,-1,+1),(B,-1,-1),(C,+1,-1),(D,+1,+1))
		return retval

	def inCanvas(self):
		lst = [self.dp.canvas]
		thresh = self.dp.canvas_threshold
		dim = self.dp.samplingDimension
		retval = Geometry.inside(self.box,self.dp.canvas,thresh,dim)
		return retval

	def improve(self):
		#box = self.box
		#points = self.getVertices()
		#stopcriteria = False
		#while (not stopcriteria):
		#	for p in points:
		#		if (not self.isPointBlack(p)):					
		#			tests = Geometry.genExternal(box,num,p,radius)
			####tOOOODOOOO
		retval = self ##todel
		return retval

	# todo
	def getAngle(self):
		[A, B, C, D] = self.getVertices()
		dAB = Geometry.dist(A,B)
		dBC = Geometry.dist(B,C)
		if (dAB > dBC):
			P = A
			Q = B
		else:
			P = B
			Q = C
		num = Q[1] - P[1]
		den = Q[0] - P[0]
		angle = 90.0
		if (den != 0):
			angle = Geometry.rad2deg(math.atan(float(num)/float(den)))
		return angle

	def extractCoordinates(self):
		posx, posy = Geometry.scalePoint(self.box[0],self.dp.optical_centre)
		posz = self.pcp.getZ(posx,posy)
		pos = (posx, posy, posz)
		return pos

	# Private methods
	def isPointBlack(self,p):
		col = self.img[int(p[1]),int(p[0])]
		retval = map(lambda i: col[i] < self.dp.black[i],range(0,3))
		retval = all(retval)
		return retval

	def bounds(self,pnt):
		maxxh, maxxw, channels = self.img.shape
		xp = max(int(pnt[0]),0)
		xp = min(xp,maxxw-1)
		yp = max(int(pnt[1]),0)
		yp = min(yp,maxxh-1)
		retval = (xp,yp)
		return retval

	def equalsTo(self,b):
		sb = self.box
		bb = b.box
		dim = self.dp.samplingDimension
		efact = 0.9
		retval = Geometry.inside(sb,bb,efact,dim) and Geometry.inside(bb,sb,efact,dim)
		return retval

