from Interface import Interface
from pydispatch import dispatcher
from Window import Window
from threading import Timer

class GUI(Interface):
	def __init__(self,dtI,scI,reI,ol):
		super(GUI,self).__init__()
		self.intervalData = dtI
		self.intervalScreen = scI
		self.intervalRequest = reI
		self.lines_output = ol
		self.lastmessage = ''
		dispatcher.connect(self.choice,signal='choice_qry',sender='application')
		dispatcher.connect(self.response,signal='gui.response',sender='window')
		self.dataClock = Timer(self.intervalData,self.timeoutData)
		self.screenClock = Timer(self.intervalScreen,self.timeoutScreen)
		self.reqClock = Timer(self.intervalRequest,self.timeoutRequest)
		self.clocks = [self.dataClock, self.screenClock, self.reqClock]

	def choice(self,message):
		self.lastmessage = message
		dispatcher.send(message=message,signal='gui.getvalue',sender='interface')

	def response(self,message):
		dispatcher.send(message=message,signal='choice_ack',sender='interface')
		
	def onExit(self):
		dispatcher.send(signal='gui.kill',sender='interface')

	def reqCore(self):
		#self.choice(self.lastmessage)
		pass

	def dataCore(self):
		msg = str(self.lines_output)
		dispatcher.send(message=msg,signal='gui.refresh.outputs',sender='interface')
		
	def screenCore(self):
		dispatcher.send(signal='gui.refresh.screen',sender='interface')

	def timeoutData(self):
		self.clockReset(self.dataCore,self.dataClock,self.timeoutData,self.intervalData)

	def timeoutRequest(self):
		self.clockReset(self.reqCore,self.reqClock,self.timeoutRequest,self.intervalRequest)

	def timeoutScreen(self):
		self.clockReset(self.screenCore,self.screenClock,self.timeoutScreen,self.intervalScreen)

	def run(self):
		running = True
		while (running == True):
			map(lambda x: x.start(),self.clocks)
			running = self.queue.get()
		dispatcher.send(signal='gui.kill',sender='interface')		
		map(lambda x: x.cancel(),self.clocks)

	def clockReset(self,core,clock,handler,interval):
		core()
		clock.cancel()
		clock = Timer(interval,handler)
		clock.start()		

