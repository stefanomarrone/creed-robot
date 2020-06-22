'''
RobotControllerFactory: class containing the concrete factory for the robot controller
@author: Stefano Marrone
'''
import IntegrityManagerFactory 
import RobotController
import RobotControllerIntegrity
import DBFactory
from AbstractFactory import AbstractFactory

class RobotControllerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		handlers = {'simple': self.generateSimple, 'integrity': self.generateIntegrity}
		# get robot controller parmeters
		td = self.getSection('RobotController')
		debug_val = td['debug'] == 'True'
		fakecomm = td['fakecomm'] == 'True'
		ip_val = td['ip']
		port_val = int(td['port'])
		xt = float(td['x_trash'])
		yt = float(td['y_trash'])
		zt = float(td['z_trash'])
		mport_val = int(td['myport'])
		tout_val = int(td['timeout'])
		# kind parameter
		knd_val = td['kind']
		handler = handlers[knd_val]
		tpos = (xt,yt,zt)
		retval = handler(ip_val,port_val,mport_val,debug_val,tout_val,fakecomm,tpos)
		return retval

    def generateSimple(self,ip_val,port_val,mport_val,dbgflag,timt,fk,trashpos):
		retval = RobotController.RobotController(ip_val,port_val,mport_val,dbgflag,timt,fk,trashpos)
		return retval

    def generateIntegrity(self,ip_val,port_val,mport_val,dbgflag,timt,fk,trashpos):
		retval = RobotControllerIntegrity.RobotControllerIntegrity(ip_val,port_val,mport_val,dbgflag,timt,fk,trashpos)
		factory = DBFactory.DBFactory(self.configuration_file)
		db = factory.generate('State')
		factory = IntegrityManagerFactory.IntegrityManagerFactory(self.configuration_file)
		im = factory.generate()
		retval.setIntegrityFeatures(db,im)
		return retval
