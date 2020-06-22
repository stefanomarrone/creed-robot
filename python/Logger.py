from pydispatch import dispatcher
from threading import Thread
import datetime
import time

class Logger(Thread):
	def __init__(self,i_name,e_name):
		Thread.__init__(self,)
		self.iname = i_name
		self.ename = e_name
		dispatcher.connect(self.internal,signal='log.internal',sender=dispatcher.Any)
		dispatcher.connect(self.external,signal='log.external',sender=dispatcher.Any)

	def log(self,fname,message,topflag):
		f = open(fname,'a')
		if (topflag == True):
			f.seek(0)
		f.write(message)
		f.close()

	def internal(self,message):
		st = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
		self.log(self.iname,st + ' ' + message + '\n',False)

	def external(self,message):
		st = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
		self.log(self.ename,st + '\n' + message + '\n\n',True)
		self.log(self.iname,st + ' ' + message + '\n',False)

	def run(self):
		running = True
		while (running == True):
			running = self.queue.get()
