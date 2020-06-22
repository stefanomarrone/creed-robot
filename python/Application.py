import Logic
import DBFactory
from threading import Thread

class Application(Thread):
	def __init__(self,conf_file,dbg=True):
		Thread.__init__(self)
		factory = DBFactory.DBFactory(conf_file)
		self.taskdb = factory.generate('Tasker')
		self.logic = Logic.Logic(conf_file,dbg)
		self.debug = dbg

	def run(self):
		pass

	def dbg(self,txt):
		if (self.debug == True):
			print "[DBG-APP]: "  + txt
