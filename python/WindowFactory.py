import Window
import DBFactory
from AbstractFactory import AbstractFactory

class WindowFactory(AbstractFactory):

	def generate(self,kind=""):
		td = self.getSection('Window')
		#tofill
		td = self.getSection('Logger')
		lfile = td['external']
		factory = DBFactory.DBFactory(self.configuration_file)
		dataman = factory.generate('Window')
		retval = Window.Window(lfile,dataman)
		return retval
