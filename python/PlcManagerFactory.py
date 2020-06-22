import PlcManager
import DBFactory
from AbstractFactory import AbstractFactory

class PlcManagerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		# get mail parmeters
		td = self.getSection('PLC')
		debug_val = td['debug'] == 'True'
		ip_val = td['ip']
		rack_val = td['rack']
		slot_val = td['slot']
		jar_val = td['jar']
		factory = DBFactory.DBFactory(self.configuration_file)
		sm_val = factory.generate('State')
		retval = PlcManager.PlcManager(ip_val,jar_val,rack_val,slot_val,debug_val,sm_val)
		return retval

