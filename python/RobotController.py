import socket
import time

class RobotController(object):
	def __init__(self, ipaddress, prt, mprt, dbgflag, timt, fk, trashpos):
		self.debugFlag = dbgflag
		self.ip = ipaddress
		self.port = prt
		self.myport = mprt
		self.timeout = timt
		self.tpos = trashpos
		self.buffersize = 1024
		self.fakecomm = fk

	def testConnection(self):
		retval = self.sendrecv("TST","0")
		return retval

	def inbound(self, pos):
		msg = 'INB' + self.formatPos(pos) + '*' 
		response = "1"
		self.dbg("Sending: <" + msg + ">")
		check = self.sendrecv(msg,response)
		return check

	def rack(self, pos, direct, closet, x_store, y_store):
		cpos = (x_store,y_store)
		temp = self.format3DPos(pos) +  self.formatItem(direct)
		temp += self.formatItem(closet) + self.format2DPos(cpos)
		msg = 'RAK' + temp + '*' 
		response = "2"
		self.dbg("Sending: <" + msg + ">")
		check = self.sendrecv(msg,response)
		return check

	def trash(self, pos, direct):
		msg = 'TRS' + self.format3DPos(pos) +  self.formatItem(direct) + self.format3DPos(self.tpos) + '*' 
		response = "3"
		self.dbg("Sending: <" + msg + ">")
		check = self.sendrecv(msg,response)
		return check

	def openOutCloset(self, closet):
		msg = 'OPE' + self.formatItem(closet) + '*' 
		response = "4"
		self.dbg("Sending: <" + msg + ">")
		check = self.sendrecv(msg,response)
		return check

	def getOutCloset(self, fromcloset, pos, outcloset, last):
		msg = 'GET' + self.formatItem(fromcloset) + self.format2DPos(pos) + self.formatItem(outcloset) + self.formatItem(last) + '*' 
		response = "5"
		self.dbg("Sending: <" + msg + ">")
		check = self.sendrecv(msg,response)
		return check

	def closeOutCloset(self, closet): # va a morire
		msg = 'CLO' + self.formatItem(closet) + '*' 
		response = "6"
		self.dbg("Sending: <" + msg + ">")
		check = self.sendrecv(msg,response)
		return check

	def testString(self,a,b):
		retval = self.sendrecv(a,b)
		return retval

	def sendrecv(self, message, response):
		if (self.fakecomm == False):
			sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
			sock.sendto(message,(self.ip,self.port))
			sock.close()
			sock2 = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
			sock2.bind(('192.168.1.3',self.myport))
			#sock2.settimeout(self.timeout)
			data, addr = sock2.recvfrom(self.buffersize)
			sock2.close()
		else:
			data = response			
		retval = (data == response)
		if (retval == False):
			self.dbg("Mismatch in the communication")
			self.dbg("Expected: " + response)
			self.dbg("Received: " + data)
		else:
			self.dbg("Robot communication ok.")			
		return retval

	def computeHome(self, b, z):
		retval = (b[0]/2,-30,z)	
		return retval

	def formatItem(self, i):
		return "," + str(i)

	def format3DPos(self, p):
		strx = "{0:.2f}".format(p[0])
		stry = "{0:.2f}".format(p[1])
		strz = "{0:.2f}".format(p[2])
		retval = "," + strx + ',' + stry + ',' + strz
		return retval

	def format2DPos(self, p):
		strx = "{0:.2f}".format(p[0])
		stry = "{0:.2f}".format(p[1])
		retval = "," + strx + ',' + stry
		return retval

	def formatPos(self, p):
		strx = "{0:.2f}".format(p[0])
		stry = "{0:.2f}".format(p[1])
		strz = "{0:.2f}".format(p[2])
		stro = "{0:.2f}".format(p[3])
		stra = "{0:.2f}".format(p[4])
		strt = "{0:.2f}".format(p[5])
		retval = "," + strx + ',' + stry + ',' + strz + ',' + stro + ',' + stra + ',' + strt
		return retval

	def formatAngle(self, a):
		stra = "{0:.2f}".format(a)
		retval = "," + stra
		return retval

	def computeTop(self, b, z):
		retval = (b[0]/2,b[1]/2,z)	
		return retval

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-ROB]: "  + txt
