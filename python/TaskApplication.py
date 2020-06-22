import ToDoList
import Application
from pydispatch import dispatcher

class TaskApplication(Application.Application):
	def __init__(self,conf_file,dbg=True):
		super(TaskApplication,self).__init__(conf_file,dbg)
		self.tasks = ToDoList.ToDoList(conf_file)
		dispatcher.connect(self.react,signal='choice_ack',sender='interface')

	def run(self):
		self.askInterface()
		running = True
		while (running == True):
			running = self.queue.get()
		print 'exiting - taskapplication'

	def format(self,payload):
		retval = payload
		return retval

	def askInterface(self):
		self.tasks.refresh()
		msg = self.tasks.tostring()
		msg = self.format(msg)
		dispatcher.send(message=msg,signal='choice_qry',sender='application')

	def react(self,message):
		stay = self.tasks.get(message).run()
		if (stay == True):
			self.askInterface()
		else:
			dispatcher.send(message='',signal='exit',sender='application')
