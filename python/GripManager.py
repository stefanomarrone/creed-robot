#!/usr/bin/python

class GripManager(object):
	def __init__(self,db):
		self.database = db

	def compute(self,code,a,s):
		h,l,d,g = self.database.getItemInfo(code)
		h = float(h)
		l = float(l)
		d = float(d)
		if (a == 0):
			pp = (l/2,h/2,d)
		else:
			pp = (h/2,l/2,d)
		return pp,g
