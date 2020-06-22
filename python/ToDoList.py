import ToDoFactory

class ToDoList(object):
	def __init__(self,conf_file):
		self.factory = ToDoFactory.ToDoFactory(conf_file)
		self.refresh()

	def refresh(self):
		self.tasklist = self.factory.generate()

	def tostring(self):
		keys = sorted(self.tasklist.keys())
		retval = ''
		for k in keys:
			try:
				i = int(k)
				task = self.tasklist[k]
				temp = task.tostring()
				retval += "#" + k + "\t" + temp + '\n'				
			except Exception as e:
				pass
		return retval

	def get(self,i):
		t = self.tasklist[i]
		return t

	def getRemove(self,i):
		t = self.tasklist.pop(i)
		return t

	def remove(self,i):
		del self.tasklist[i]
