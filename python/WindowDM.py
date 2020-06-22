import Database
import pg
import time
import datetime
import sys

class WindowDM(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(WindowDM,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)
		self.qryHours = "select d.hours from dates as d where d.label = "

	def readConfiguration(self):
		mails = self.getCCS()
		qry = self.qryHours + "'report';"
		report = self.singleValuesQuery(qry)
		report = int(report)
		qry = self.qryHours + "'expire';"
		expire = self.singleValuesQuery(qry)
		expire = int(expire)
		return (mails, report, expire)

	def writeConfiguration(self,emails,reportInterval,expireInterval):
		stmt = "delete from ccs;"
		self.execute(stmt)
		txtmails = map(lambda x: "('" + x + "')",emails)
		txtmails = reduce(lambda x,y: x + "," + y,txtmails)
		stmt = "insert into ccs values" + txtmails + ";"
		self.execute(stmt)
		stmt = "update dates set hours = " + str(expireInterval) + " where label = 'expire';"
		self.execute(stmt)
		stmt = "update dates set hours = " + str(reportInterval) + " where label = 'report';"
		self.execute(stmt)
		
	def readMessages(self):
		pass		

	def readStatus(self):
		pass

	def getCCS(self):
		qry = 'select mail from ccs;'
		mails = self.getList(qry)
		return mails
