import pypcd
import math
import numpy as np

class PointCloudManager(object):
	def __init__(self,area,tolerance,zdef,xmin,ymin,xmax,ymax,rot_val,debug_val):
		self.adist = area
		self.corrfact = tolerance
		self.default_z = zdef
		self.rotFlag = rot_val 
		self.dbgFlag = debug_val 
		self.xl = xmin
		self.yl = ymin
		self.xh = xmax
		self.yh = ymax
		self.cloud = None

	def load(self,pcname):
		self.cloud = pypcd.PointCloud.from_path(pcname)
		for t in self.cloud.pc_data:
			todel = (self.xl > t['x']) or (t['x'] > self.xh) or (self.yl > t['y']) or (t['y'] > self.yh)
			if todel:
				t['x'] = None
				t['y'] = None
				t['z'] = None
		#TODO
		#rotate, slice, filter

	def getZ(self,x,y):
		try:
			retval = self.default_z
			temp = self.cloud.pc_data
			temp = temp[(x-self.adist < temp['x']) & (temp['x'] < x+self.adist) & (y-self.adist < temp['y']) & (temp['y'] < y+self.adist)]
			if (len(temp) > 0):
				mz = temp['z'].mean()
				vz = temp['z'].std()
				retval = mz + self.corrfact*vz
		except Exception as e:
			header = '[PointCloudManager-getZ]'
			errmsg = e.message if hasattr(e,'message') else e  
			print(header + ' ' + errmsg)
		return retval

