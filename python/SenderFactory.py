
import Sender
from AbstractFactory import AbstractFactory

class SenderFactory(AbstractFactory):
    
    def generate(self,kind=""):
		# get mail parmeters
		td = self.getSection('Mail')
		smtp_user = td['pop3_user']
		smtp_pass = td['pop3_pass']
		smtp_srvr = td['smtp_srvr']
		smtp_port = int(td['smtp_port'])
		retval = Sender.Sender(susr = smtp_user, spsw = smtp_pass, ssrv = smtp_srvr, sprt = smtp_port)
		return retval
