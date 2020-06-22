from ApplicationFactory import ApplicationFactory
from MailManagerFactory import MailManagerFactory
from PlcManagerFactory import PlcManagerFactory
from InterfaceFactory import InterfaceFactory
from LoggerFactory import LoggerFactory
from ReportManagerFactory import ReportManagerFactory
from WindowFactory import WindowFactory
from pydispatch import dispatcher
from Window import Window
from multiprocessing import Queue

class MasterControlProgram(object):
	def __init__(self,conf_file):
		dispatcher.connect(self.stop,signal='exit',sender=dispatcher.Any)
		functores = [LoggerFactory, ApplicationFactory, InterfaceFactory, MailManagerFactory, PlcManagerFactory, ReportManagerFactory]
		self.inifile = conf_file
		t = map(lambda f: self.generate(f,self.inifile),functores)
		self.objs = map(lambda o: o[0],t)
		self.queues = map(lambda o: o[1],t)
		self.running = True
		self.debugFlag = True

	def stop(self,message):
		self.running = False
		self.dbg('Switching down')
		print 'ora qui'
		map(lambda q: q.put(False),self.queues)
		self.dbg('Waiting for thread closing')
		map(lambda x: x.join(),self.objs)
		self.dbg('Thread closed')
		exit(0)

	def generate(self,func,conf_file):
		factory = func(conf_file)
		obj = factory.generate()
		q = Queue()
		obj.queue = q
		return (obj,q)

	def start(self):
		self.dbg('Starting threads')
		map(lambda x: x.start(),self.objs)
		self.dbg('Started threads')
		self.dbg('Startin GUI')
		self.window = self.winStarting()
		self.window.root.mainloop()
		self.dbg('Defensive - non dovrebbe passare qua')

	def winStarting(self):
		factory = WindowFactory(self.inifile)
		window = factory.generate()
		return window

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-MCP]: "  + txt
