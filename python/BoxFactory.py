'''
RobotControllerFactory: class containing the concrete factory for the robot controller
@author: Stefano Marrone
'''

import RobotController
from AbstractFactory import AbstractFactory

class RobotControllerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		# get robot controller parmeters
		td = self.getSection('RobotController')
		debug_val = td['debug'] == 'True'
		fakecomm = td['fakecomm'] == 'True'
		ip_val = td['ip']
		port_val = int(td['port'])
		mport_val = int(td['myport'])
		tout_val = int(td['timeout'])
		# get vision parameters
		td = self.getSection('Vision')
		labs = ['x', 'y', 'z']
		temp = map(lambda x: float(td[x + '_home']),labs)
		home_pos = tuple(temp)
		temp = map(lambda x: float(td[x + '_max']),labs)
		basket_dim = tuple(temp)
		retval = RobotController.RobotController(ip_val,port_val,mport_val,timt=tout_val,dbgflag=debug_val,z_inbound=home_pos[2],basket=basket_dim,fk=fakecomm)
		return retval

