import CLIApplication
import TaskApplication
from AbstractFactory import AbstractFactory

class ApplicationFactory(AbstractFactory):

	def generate(self,kind=""):
		td = self.getSection('Application')
		dictionary = {'CLI':CLIApplication.CLIApplication,'Task':TaskApplication.TaskApplication}
		debug_val = td['debug'] == 'True'
		f = dictionary[td['kind']]
		retval = f(self.configuration_file,debug_val)
		return retval
