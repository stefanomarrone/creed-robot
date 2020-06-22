#!/usr/bin/python

import cv2

import operator
import time
import math
import random
import numpy as np
from skimage import img_as_ubyte

def genExternal(box,num,centre,radius):
	retval = list()
	counter = 0
	while (counter < num):
		rho = random.random(0,radius)
		theta = random.random(-math.pi,math.pi)
		xp = int(centre[0] + rho*math.cos(theta))
		yp = int(centre[1] + rho*math.sin(theta))
		p = (xp,yp)
		flag = Geometry.isInside(p,box)
		if (not flag):
			retval.append(p)
			counter += 1
	return retval

def genInternal(box,size):
	(x0,y0) = box[0]
	(x0,y0) = (int(x0),int(y0))
	(w,h) = box[1]
	(w,h) = (int(w/2)-1,int(h/2)-1)
	indices = range(0,size)
	x = map(lambda i: random.randint(x0-w,x0+w),indices)
	y = map(lambda i: random.randint(y0-h,y0+h),indices)
	points = map(lambda i: (x[i],y[i]),indices)
	alpha = box[2] * 0.0174533
	points = map(lambda p: roto_translate(p[0],p[1],x0,y0,alpha,w,h),points)
	return points

def roto_translate(xp,yp,x0,y0,alpharad,w=0,h=0):
	sa = math.sin(alpharad)
	ca = math.cos(alpharad)
	x = int(x0 + (xp - x0) * ca - (yp - y0) * sa)
	y = int(y0 + (xp - x0) * sa + (yp - y0) * ca)
	return (x,y)

def inside(latter,bigger,minTH,size):
	tests = genInternal(latter,size)
	tests = filter(lambda p: isInside(p,bigger),tests)
	insideRatio = float(len(tests)) / float(size)
	retval = insideRatio > minTH
	return retval
	
def isInside(M,box):
	vertices = getVertices(box)
	A, B, C, D = (vertices[0],vertices[1],vertices[2],vertices[3])
	AM = vector(A,M)
	AB = vector(A,B)
	AD = vector(A,D)
	pamab = dot(AM,AB)
	pabab = dot(AB,AB)
	pamad = dot(AM,AD)
	padad = dot(AD,AD)
	retval = (0 < pamab) and (pamab < pabab) and (0 < pamad) and (pamad < padad)
	return retval

def getVertices(box):
	(x0,y0) = box[0]
	(x0,y0) = (int(x0),int(y0))
	(w,h) = box[1]
	(w,h) = (int(w/2)-1,int(h/2)-1)
	alpha = deg2rad(box[2])
	A = (x0-w,y0-h)
	B = (x0+w,y0-h)
	C = (x0+w,y0+h)
	D = (x0-w,y0+h)
	retval = [A, B, C, D]
	retval = map(lambda v: roto_translate(v[0],v[1],x0,y0,alpha,w,h),retval)
	return retval

def deg2rad(a):
	return a * 0.0174533

def rad2deg(a):
	return a / 0.0174533

def vector(fromP,toP):
	retval = tuple(map(operator.sub, toP, fromP))
	return retval

def dot(v1,v2):
	retval = 0
	for i in range(len(v1)):
		retval += v1[i]*v2[i]
	return retval

def dist(P1,P2):
	dist = math.sqrt((P1[0] - P2[0])**2 + (P1[1] - P2[1])**2)
	return dist

def scalePoint(toscale,reference):
	dpx = toscale[0] - reference[0]
	dpy = toscale[1] - reference[1]
	retval = (px2mm(dpx),px2mm(dpy))
	return retval

def scaleAngle(alpha,w,h):
	shapeCorrectionFactor = 0
#	if (w > h):
#		shapeCorrectionFactor = 90	
#	beta = alpha + shapeCorrectionFactor
	beta = alpha
	if (alpha < -90):
		beta = 180 + alpha
	elif (alpha > 90):
		beta = alpha - 180
	theta = beta
	if (beta < -45):
		theta = beta + 90
	elif (beta > 45):
		theta = beta - 90	
	#theta = np.sign(alpha)*(180 - math.fabs(alpha) + shapeCorrectionFactor)
	return theta

def intPos2D(p):
	retval = (int(p[0]),int(p[1]))
	return retval

def px2mm(d):
	retval = d * 0.588
	return retval
