'''
SVNManagerFactory: class containing the concrete factory for the SVN Manager
@author: Stefano Marrone
'''

import SVNManager
from AbstractFactory import AbstractFactory

class SVNManagerFactory(AbstractFactory):
    
    def generate(self,kind=''):
		td = self.getSection('SVNManager')
		debug_val = td['debug'] = 'True'
		url_val = td['url']
		usr_val = td['user']
		pwd_val = td['password']
		dir_val = td['dir']
		dbn_val = td['dbname']
		item_val = td['item']
		retval = SVNManager.SVNManager(dir_val,dbn_val,item_val,url_val,usr_val,pwd_val,debug_val)
		return retval
