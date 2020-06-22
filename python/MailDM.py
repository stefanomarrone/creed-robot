import Database
import pg
import time
import datetime
import sys

class MailDM(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(MailDM,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)

	def isMailProcessed(self,hashcode):
		qry = "select * from mails as m where m.processed = '" + hashcode + "';"
		retval = not self.isQueryEmpty(qry)
		return retval

	def addProcessedMail(self,hashcode):
		stmt = "insert into mails values('" + hashcode + "');"
		self.execute(stmt)
