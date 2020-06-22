
import IntegrityManager
from AbstractFactory import AbstractFactory

class IntegrityManagerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		# get mail parmeters
		td = self.getSection('Integrity')
		debug_val = td['debug'] == 'True'
		tout_val = int(td['timeout'])
		retval = IntegrityManager.IntegrityManager(tout = tout_val, dbg = debug_val)
		return retval

