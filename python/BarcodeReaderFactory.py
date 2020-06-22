'''
@author: Stefano Marrone
'''

import BarcodeReader
from AbstractFactory import AbstractFactory

class BarcodeReaderFactory(AbstractFactory):
    
    def generate(self,kind=''):
		td = self.getSection('BarcodeReader')
		debug_val = td['debug'] == 'True'
		fakecomm = td['fakecomm'] == 'True'
		ip_val = td['ip']
		port_val = int(td['port'])
		tr_val = int(td['trials'])
		slp_val = int(td['sleep'])
		dlp = td['dll_path']
		dln = td['dll_name']
		retval = BarcodeReader.BarcodeReader(ipaddress=ip_val, prt=port_val, dbgflag=debug_val, tr=tr_val, slp=slp_val, fk=fakecomm, dllp=dlp, dlln=dln)
		return retval

	
