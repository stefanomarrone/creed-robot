'''
CognexControllerFactory: class containing the concrete factory for the robot controller
@author: Stefano Marrone
'''

import CognexController
from AbstractFactory import AbstractFactory

class CognexControllerFactory(AbstractFactory):
    
    def generate(self,kind=''):
		# get cognex controller parmeters
		td = self.getSection('Cognex')
		debug_val = td['debug'] == 'True'
		fakecomm = td['fakecomm'] == 'True'
		ip_val = td['ip']
		port_val = int(td['port'])
		tout_val = int(td['timeout'])
		xr = float(td['x_ref'])
		yr = float(td['y_ref'])
		zr = float(td['z_ref'])
		origin = (xr,yr,zr)
		retval = CognexController.CognexController(ip_val,port_val,timt=tout_val,dbgflag=debug_val,ref=origin,fk=fakecomm)
		return retval

