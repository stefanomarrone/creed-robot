import DBFactory
import SenderFactory
from ReportManager import ReportManager
from AbstractFactory import AbstractFactory

class ReportManagerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		td = self.getSection('Report')
		debug_val = td['debug'] == 'True'
		enable_val = td['enable'] == 'True'
		factory = DBFactory.DBFactory(self.configuration_file)
		rdb = factory.generate('Report')
		factory = SenderFactory.SenderFactory(self.configuration_file)
		sender = factory.generate()
		retval = ReportManager(debug_val,enable_val,rdb,sender)
		return retval


