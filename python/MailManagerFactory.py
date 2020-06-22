
import MailManager
import DBFactory
from AbstractFactory import AbstractFactory

class MailManagerFactory(AbstractFactory):
    
    def generate(self,kind=""):
		# get mail parmeters
		td = self.getSection('Mail')
		debug_val = td['debug'] == 'True'
		delete = td['delete'] == 'True'
		snd = td['send'] == 'True'
		pop3_srvr = td['pop3_srvr']
		pop3_port = int(td['pop3_port'])
		pop3_user = td['pop3_user']
		pop3_pass = td['pop3_pass']
		smtp_srvr = td['smtp_srvr']
		smtp_port = int(td['smtp_port'])
		ih = td['i_head']
		oh = td['o_head']
		dh = td['d_head']
		interval = int(td['interval'])
		timeout = int(td['timeout'])
		fastflag = td['fastinbound'] == 'True'
		factory = DBFactory.DBFactory(self.configuration_file)
		idb = factory.generate('Inbound')
		odb = factory.generate('Outbound')
		mdb = factory.generate('Mail')
		retval = MailManager.MailManager(mdatabase = mdb, idatabase = idb, odatabase = odb, psrv = pop3_srvr, pprt = pop3_port, pusr = pop3_user, ppsw = pop3_pass, ssrv = smtp_srvr, sprt = smtp_port, ihead = ih, ohead = oh, dhead = dh, timeout = timeout, timer = interval, dbg = debug_val, delete = delete, send = snd, fast = fastflag)
		return retval
