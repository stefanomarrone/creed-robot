from threading import Thread

class Interface(Thread):
	def __init__(self):
		Thread.__init__(self)

	def run(self):
		running = True
		while (running == True):
			running = self.queue.get()
