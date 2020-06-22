#!/usr/bin/python

import RobotController
import socket
import time

class RobotControllerIntegrity(RobotController.RobotController):
	def __init__(self,ipaddress,prt,mprt,dbgflag,timt,fk,trashpos):
		super(RobotControllerIntegrity,self).__init__(ipaddress,prt,mprt,dbgflag,timt,fk,trashpos)

	def setIntegrityFeatures(self, stateDB, intManager):
		self.db = stateDB
		self.im = intManager
		self.super = super(RobotControllerIntegrity,self)

	def openOutCloset(self, closet):
		self.db.on(closet)
		retval = self.im.check()
		if (retval == True):
			retval = self.super.openOutCloset(closet)
		return retval

	def getOutCloset(self, fromcloset, pos, outcloset):
		self.db.on(fromcloset)
		retval = self.im.check()
		if (retval == True):
			retval = self.super.getOutCloset(fromcloset,pos,outcloset)
			if (retval == True):
				self.db.off(fromcloset)
				retval = self.im.check()
		return retval

	def closeOutCloset(self, closet):
		retval = self.super.closeOutCloset(closet)
		if (retval == True):
			self.db.off(closet)
			retval = self.im.check()
		return retval

	def rack(self, pos, direct, closet, x_store, y_store):
		self.db.on(closet)
		self.dbg('pending list ' + str(self.db.get()))
		retval = self.im.check()
		self.dbg('integrity check ' + str(retval))
		if (retval == True):
			retval = self.super.rack(pos,direct,closet,x_store,y_store)
			self.dbg('robot operation ' + str(retval))
			if (retval == True):
				self.db.off(closet)
				self.dbg('pending list ' + str(self.db.get()))
				retval = self.im.check()
				self.dbg('integrity check ' + str(retval))
		return retval
