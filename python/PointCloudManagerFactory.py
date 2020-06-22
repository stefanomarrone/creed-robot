
import PointCloudManager
from AbstractFactory import AbstractFactory

class PointCloudManagerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		td = self.getSection('PointCloud')
		area = float(td['zarea'])
		tolerance = float(td['tolerance'])
		zdef = float(td['default_z'])
		xmin = float(td['xmin'])
		ymin = float(td['ymin'])
		xmax = float(td['xmax'])
		ymax = float(td['ymax'])
		rot_val = td['rotation'] == 'True'
		debug_val = td['debug'] == 'True'
		retval = PointCloudManager.PointCloudManager(area,tolerance,zdef,xmin,ymin,xmax,ymax,rot_val,debug_val)
		return retval

