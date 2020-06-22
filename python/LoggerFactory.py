from Logger import Logger
from AbstractFactory import AbstractFactory

class LoggerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		td = self.getSection('Logger')
		iname = td['internal']
		ename = td['external']
		retval = Logger(iname,ename)
		return retval

