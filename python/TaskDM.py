#!/usr/bin/python

import Database
import pg
import time
import datetime
import sys

class TaskDM(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(TaskDM,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)

	def getBasketByDoc(self,docid):
		qry = 'select i.id from inbound as i where i.document_id = ' + str(docid) + ';'
		retval = self.getList(qry)
		return retval

	def getFreeIndound(self):
		qry = 'select distinct(u.did) from to_upload as u;'
		retval = self.getList(qry)
		return retval

	def getUploadTasks(self):
		retval = list()
		qry = 'select o.bid, o.did from to_upload as o;'
		rslt = self.query(qry)
		for i in range(0,len(rslt)):
			t = (rslt[i][0],rslt[i][1])
			retval.append(t)
		return retval

	def getDownloadTasks(self):
		retval = list()
		qry = 'select o.id, o.department, o.email, o.arrivedate from to_download as o;'
		rslt = self.query(qry)
		for i in range(0,len(rslt)):
			t = (rslt[i][0],rslt[i][1],rslt[i][2],rslt[i][3])
			retval.append(t)
		return retval

	def getFreeOutbound(self):
		qry = 'select u.id from to_download as u;'
		retval = self.getList(qry)
		return retval

