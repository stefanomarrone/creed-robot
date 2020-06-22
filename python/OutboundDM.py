#!/usr/bin/python

import Database
import pg
import time
import datetime
import sys
from random import randrange

class OutboundDM(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(OutboundDM,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)

	# Phase 1
	def getUserByEmail(self,mail):
		retval = None
		mail = mail[1:-1]
		sql = "select D.id from dbuser as D where D.email = '" + mail + "'";
		if (self.isQueryEmpty(sql) == False):
			retval = self.singleValuesQuery(sql);
		return retval

	def reservePackage(self,oc,pc):
		sql = "insert into download values(" + str(oc) + "," + str(pc) + ");"
		self.execute(sql)
		sql = "update package set state = 'reserved' where id = " + str(pc) + ";"
		self.execute(sql)

	def insertMainRequest(self,usr,code):
		arriv = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		arriv = self.toDate(arriv)
		iid = self.getNextId('id','outbound')
		sql = "insert into outbound(id,dbuser,download) values(" + str(iid) + "," + str(usr) + "," + arriv + ");"
		self.execute(sql)
		return iid

	def insertSingle(self,code,rr):
		name, aic, qta = (rr[0],rr[1],rr[2])
		# get available packages of the aic
		qry = "select ap.id from availablepack as ap where ap.aic = '" + str(aic) + "' order by ap.expire;"
		ids = self.getList(qry,qta)
		map(lambda x: self.reservePackage(code,x),ids)
		retval = (name, aic, qta, len(ids))
		return retval

	def request(self,mail,code,req):
		retval = None
		user_code = self.getUserByEmail(mail)
		if (user_code != None):
			retval = dict()
			outbound_id = self.insertMainRequest(user_code,code)
			retval = map(lambda x: self.insertSingle(user_code,x),req)
		return retval

	# Phase 2
	def getItemsByOutbound(self,cod):
		qry = "select dw.package from download as dw where dw.outbound = " + str(cod) + ";"
		retval = self.getList(qry)
		return retval

	def getFreeCloset(self):
		qry = "select closet from availableCloset;"
		tmp = self.getList(qry)
		random_index = randrange(len(tmp))
		retval = tmp[random_index]
		return retval

	def getPackageToGetInfo(self,pid):
		qry = "select b.closet, b.x_cell, b.y_cell from drug as d join package as p on (d.id = p.drug) join upload as u on (u.package = p.id) join buffer as b on (b.id = u.buffer) where p.id = " + str(pid) + ";"
		rslt = self.query(qry)
		pos = rslt[0][1], rslt[0][2]
		cls = rslt[0][0]
		return cls, pos 

	def updatePackageStatus(self,pid):
		stmt = "update upload set buffer = 0 where package = " + str(pid) + ";"
		self.execute(stmt)
	
	def outboundPrepared(self,outid,closet):
		arriv = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		arriv = self.toDate(arriv)
		stmt = "update outbound set ready = " + arriv + " where id = " + str(outid) + ";"
		print stmt
		self.execute(stmt)
		stmt = "update outbound set outbox = '" + closet + "' where id = " + str(outid) + ";"
		print stmt
		self.execute(stmt)
