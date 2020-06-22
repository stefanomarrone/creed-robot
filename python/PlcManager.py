import subprocess
from pydispatch import dispatcher
from threading import Thread
import StateManager
import time

class PlcManager(Thread):
	def __init__(self,ip,jar,rack,slot,dbg,sm):
		Thread.__init__(self,)
		self.ipaddress = ip
		self.j = jar
		self.slt = slot
		self.rck = rack
		self.debugFlag = dbg
		self.db = sm
		dispatcher.connect(self.callback,signal='plc.query',sender='integrity')

	def jarWrapper(self,args):
		process = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		stdout, stderr = process.communicate()
		retval = stdout.startswith('True')
		return retval

	def callback(self,message):
		self.dbg('call back invoked')
		pending = self.db.get() # get the list of the open closet
		data = self.statementPreparation(pending) # preparation
		args = self.argsPreparation(data)
		check = self.jarWrapper(args)
		dispatcher.send(message=str(check),signal='plc.ack',sender='plc')

	def statementPreparation(self,ocs):
		retval = str(ocs) #todo: it must be changed
		self.dbg(str(retval))
		return retval

	def argsPreparation(self,data):
		retval = ['java', '-jar', self.j, self.ipaddress, self.rck, self.slt, data]
		return retval

	def run(self):
		running = True
		while (running == True):
			running = self.queue.get()

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-PLC]: "  + txt
