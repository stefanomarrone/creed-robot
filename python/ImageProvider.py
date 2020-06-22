import time
import cv2
import glob, os

class ImageProvider(object):
	def __init__(self,p,fheader,ftrailer):
		self.path = p
		self.fileheader = fheader
		self.filetrailer = ftrailer
		self.sides = {'left': ftrailer + '0', 'right': ftrailer + '1', 'main': '', 'pcd': ''}
		self.counterstring = '000'
		self.clearAll()

	def getFrame(self):
		self.getCounterString()
		againFlag = True
		while (againFlag):
			try:
				self.synchronize()
				cloudname = self.getFileName('pcd','.pcd')
				imgs = ['left', 'right', 'main']
				imgs = map(lambda i: self.getFileName(i),imgs)
				imgs = map(lambda i: cv2.imread(i),imgs)
				map(lambda i: i.shape,imgs)
				l_frame, r_frame, main_frame = tuple(imgs)
				againFlag = False
			except Exception as e:
				header = '[ImageProvider-getFrame]'
				errmsg = e.message if hasattr(e,'message') else e  
				print(header + ' ' + errmsg)
				time.sleep(1)
		return r_frame, l_frame, main_frame, cloudname

	def synchronize(self):
		flag  = False
		while (not flag):
			teststring = self.path + '/' + self.fileheader + self.counterstring + '*'
			time.sleep(0.5)
			loaded = glob.glob(teststring)
			flag = len(loaded) == 4
			self.getCounterString()

	def getCounterString(self):
		maxpad = int(self.counterstring)
		flist = glob.glob(self.path + '/*.pcd')
		#print flist
		for f in flist:
			temp = f.split(self.fileheader)[1]
			temp = temp.split(self.filetrailer)[0]
			temp = temp.split('.')[0]
			val = int(temp)
			if (maxpad < val):
				maxpad = val
				self.counterstring = temp

	def getFileName(self,side,ext='.png'):
		fname = self.path + '/' + self.fileheader + self.counterstring + self.sides[side] + ext
		return fname
		
	def genPad(self,num):
		retval = str(num)
		while (len(retval)<3):
			retval = '0' + retval
		return retval

#	def clearDir(self):
#		for f in glob.glob(self.path + '/*.png'):
#			os.remove(f)

	def clearAll(self):
		for f in glob.glob(self.path + '/*'):
			os.remove(f)

