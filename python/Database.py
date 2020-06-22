#!/usr/bin/python

import pg
import time
import datetime
import sys

class Database(object):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		self.ip = ipadd
		self.port = prt
		self.login = lgn
		self.password = psswd
		self.schema = schm
		self.debug = dbg
		test = self.testConnection()
		if (test == False):
			print "[FATAL ERROR]: database not present"
			sys.exit(1)

	def connect(self):
		db = None
		try:
			db = pg.DB(dbname=self.schema,host=self.ip,port=self.port,user=self.login,passwd=self.password)
		except:
			pass
		return db

	def testConnection(self):
		dd = self.connect()
		retval = False
		if (dd !=  None):
			retval = True
			dd.close()
		return retval

	def execute(self,sql):
		self.dbg(sql)
		db = self.connect()
		db.query(sql)
		db.close()

	def query(self,sql):
		self.dbg(sql)
		db = self.connect()
		qry = db.query(sql)
		rslt = qry.getresult()
		db.close()
		return rslt

	def singleValuesQuery(self,sql):
		rslt = self.query(sql)
		val = rslt[0][0]
		return val

	def getList(self,sql,maxnum = -1):
		retval = list()
		rslt = self.query(sql)
		top = len(rslt)
		if (maxnum > 0):
			top = min(maxnum,len(rslt))
		for i in range(0,top):
			retval.append(rslt[i][0])
		return retval

	def isQueryEmpty(self,sql):
		rslt = self.query(sql)
		val = (len(rslt) == 0)
		return val

	def getNextId(self,field,table):
		qry = 'select coalesce(max(' + field + '),0) from ' + table + ';'
		temp = self.singleValuesQuery(qry)
		val = int(temp) + 1
		return str(val)

	def toDate(self,plaindate):
		return "to_timestamp('" + plaindate + "','yyyy-mm-dd hh24:mi:ss')"

	def dbg(self,txt):
		if (self.debug == True):
			print "[DBG-DB]: "  + txt
