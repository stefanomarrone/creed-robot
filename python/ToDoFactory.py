import ToDo
import UploadToDo
import DownloadToDo
import BackupToDo
import ExitToDo
import SkipToDo
import DBFactory
from AbstractFactory import AbstractFactory

class ToDoFactory(AbstractFactory):

	def generate(self,kind=""):
		cf = self.configuration_file
		retval = dict()
		factory = DBFactory.DBFactory(cf)
		db = factory.generate('Tasker')
		sdb = factory.generate('State')
		# exit
		retval['X'] = ExitToDo.ExitToDo(cf)
		# skip
		retval['R'] = SkipToDo.SkipToDo(cf)
		# backup
		retval['B'] = BackupToDo.BackupToDo(cf)
		# inbound
		temp = db.getUploadTasks()
		temp = map(lambda x: UploadToDo.UploadToDo(cf,x[0],x[1]),temp)
		base = len(temp)
		for i in range(0,base):
			retval[str(i)] = temp[i]
		# outbound
		if (sdb.checkAvailableOutCloset() == True):
			temp = db.getDownloadTasks()
			temp = map(lambda x: DownloadToDo.DownloadToDo(cf,x[0],x[1],x[2],x[3]),temp)
			for i in range(0,len(temp)):
				retval[str(base + i)] = temp[i]
		return retval
