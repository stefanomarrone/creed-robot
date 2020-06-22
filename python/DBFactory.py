import Database
import StateManager
import InboundDM
import MailDM
import TaskDM
import OutboundDM
import ReportDM
import WindowDM
from AbstractFactory import AbstractFactory

class DBFactory(AbstractFactory):

	def getParameters(self):
		td = self.getSection('Database')
		ip_val = td['ip']
		port_val = int(td['port'])
		login_val = td['login']
		schema_val = td['schema']
		passwd_val = td['password']
		debug_val = (td['debug'] == 'True')
		return ip_val, port_val, login_val, schema_val, passwd_val, debug_val
	
	def generate(self,kind='Database'):
		ip_val, port_val, login_val, schema_val, passwd_val, debug_val = self.getParameters()
		dictionary = {'Database':Database.Database, 'Report':ReportDM.ReportDM, 'Mail':MailDM.MailDM, 'Inbound':InboundDM.InboundDM, 'Tasker':TaskDM.TaskDM, 'Outbound':OutboundDM.OutboundDM, 'State':StateManager.StateManager, 'Window':WindowDM.WindowDM}
		f = dictionary[kind]
		retval = f(ip_val, port_val, login_val, passwd_val, schema_val, debug_val)
		return retval
