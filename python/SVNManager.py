#!/usr/bin/python

import pysvn
import datetime
import os

class SVNManager(object):
	def __init__(self,dir_val,dbn_val,item_val,url_val,usr_val,pwd_val,debug_val):
		self.dir = dir_val
		self.dbname = dbn_val
		self.item = item_val
		self.debug = debug_val
		self.url = url_val
		self.user = usr_val
		self.password = pwd_val
		self.testConnection()

	def get_login(self, realm, username, may_save):
	    return 0, self.user, self.password, True

	def addVersion(self):
		# dumb database
		filename = self.dir + "/" + self.item
		self.dbg(filename)
		cmd = "pg_dump " + self.dbname + " > " + filename
		os.system(cmd)
		# upload into svn
		client = pysvn.Client()
		client.set_default_username(self.user)
		client.set_default_password(self.password)
		client.callback_get_login = self.get_login
		arriv = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		msg = 'Dump of the ' + arriv
		client.checkin([filename],msg)

	def testConnection(self):
		retval = True
		return retval

	def toString(self):
		retval = ""
		retval += "debug:" + str(self.debug) + "\n"
		retval += "url:" + self.url + "\n"
		retval += "port:" + str(self.port) + "\n"
		retval += "user:" + self.user + "\n"
		retval += "password:" + self.password + "\n"
		retval += "item:" + self.item + "\n"
		return retval

	def dbg(self,txt):
		if (self.debug == True):
			print "[DBG-SVN]: "  + txt

