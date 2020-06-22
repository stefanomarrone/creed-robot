import pg
import time
import datetime
import Database
import sys

class StateManager(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(StateManager,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)

	def on(self,state):
		stmt = "insert into global values('" + state + "');"
		self.execute(stmt)

	def off(self,state):
		stmt = "delete from global where state = '" + state + "';" 
		self.execute(stmt)

	def err(self):
		stmt = "delete from global;" 
		self.execute(stmt)
		self.on('ERR')		

	def isErr(self):
		retval = False
		ocs = self.get()
		retval = (ocs[0] == 'ERR')
		return retval

	def get(self):
		sql = 'select state from global;';
		rslt = self.getList(sql)
		return rslt

	def checkAvailableOutCloset(self):
		sql = "select count(*) from availableCloset;"
		cnt = self.singleValuesQuery(sql)
		return (cnt > 0)

