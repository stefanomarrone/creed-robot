import GUI
import CLI
from AbstractFactory import AbstractFactory

class InterfaceFactory(AbstractFactory):

	def generate(self,kind=""):
		td = self.getSection('Application')
		f = td['interface']
		if (f == 'CLI'):
			retval = CLI.CLI()
		else:
			td = self.getSection('GUI')
			di = int(td['intervaldata'])
			si = int(td['intervalscreen'])
			ri = int(td['intervalrequest'])
			oi = int(td['lines_output'])
			retval = GUI.GUI(di,si,ri,oi)
		return retval
