from pydispatch import dispatcher
from threading import Thread
from threading import Timer
from ReportDM import ReportDM

class ReportManager(Thread):
	def __init__(self,dbg,en,datamanager,send):
		Thread.__init__(self)
		self.debugFlag = dbg
		self.enabled = en
		self.interval = 3600
		self.dm = datamanager
		self.mailsender = send
		self.clock = Timer(self.interval,self.timeout)

	def core(self):
		if (self.enabled == True):
			self.dbg("Getting expired labels...")
			labels = self.dm.timeoutCheck()
			ccs = self.dm.getCCS()
			for l in labels:
				self.dbg("Producing report for label: " + l)
				s,p,m,k = self.dm.getElements(l)
				self.dbg("Sending the email for label: " + l)
				self.mailsender.send(ccs,s,m,p,k)
				self.dbg("Updating label: " + l)
				self.dm.update(l)

	def timeout(self):
		self.core()
		self.clock.cancel()
		self.clock = Timer(self.interval,self.timeout)
		self.clock.start()		

	def run(self):
		running = True
		self.core()
		while (running == True):
			self.clock.start()
			running = self.queue.get()
		self.clock.cancel()	

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-REP]: "  + txt
