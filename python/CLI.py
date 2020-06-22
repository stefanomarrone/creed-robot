from Interface import Interface
from pydispatch import dispatcher

class CLI(Interface):
	def __init__(self):
		super(CLI,self).__init__()
		dispatcher.connect(self.choice,signal='choice_qry',sender='application')

	def choice(self,message):
		temp = input(message)
		dispatcher.send(message=temp,signal='choice_ack',sender='interface')

