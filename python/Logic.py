#!/usr/bin/python

import socket
import RobotControllerFactory
import SVNManagerFactory
import DBFactory
import random
import CognexControllerFactory
import MailManagerFactory
import BarcodeReaderFactory
import Inbound
import CodeManager
import GripManager

class Logic(object):
	def __init__(self,conf_file,dbg=True,fake_flag=False):
		self.conf = conf_file
		self.debug = dbg
		self.fake = fake_flag
		#self.inbound = self.fake_inbound
		#self.outbound = self.fake_outbound
		self.inbound = self.true_inbound
		self.outbound = self.true_outbound

	def backup(self):
		self.dbg("Backup - Starting")
		factory = SVNManagerFactory.SVNManagerFactory(self.conf)
		svn = factory.generate()
		svn.addVersion()
		self.dbg("Backup - end")

	def true_inbound(self,basketId,maxitem):
		# init
		factory = RobotControllerFactory.RobotControllerFactory(self.conf)
		rc = factory.generate()
		factory = DBFactory.DBFactory(self.conf)
		db = factory.generate('Inbound')
		factory = CognexControllerFactory.CognexControllerFactory(self.conf)
		vis = factory.generate()
		factory = BarcodeReaderFactory.BarcodeReaderFactory(self.conf)
		bcr = factory.generate()
		# data prepare
		toload = db.getItemsByIndound(basketId) # getting the list of the element to load from the database
		maxpieces = len(toload)
		loaded = list()
		trashed = list()
		cm = CodeManager.CodeManager(bcr,rc) # Code manager: it could change in future
		gm = GripManager.GripManager(db)
		(stopflag,position) = vis.next() #get the position of the next element in the basket
		counter = 0
		while (stopflag == False):
			check = rc.inbound(position)  #get the piece from the inbound basket and move it to the reading station
			self.dbg("Check after rc.inbound: " + str(check))
			if (check == True):
				counter += 1
				aiccode, side, angle = cm.read() #reading the barcode
				self.dbg("Letto codice BCR: " + str(aiccode))
				grip_pos, grip_orientation = gm.compute(aiccode,angle,side) #computing the approaching strategy
				pid = db.getPackByCode(aiccode,basketId) # getting the id in the database
				check = (pid != None)
				if (check == True):
					# check the presence of the item in the load document
					(closet,x_buff,y_buff) = db.getBufferInfoByCode(pid)
					# the element is to load into the rack since it is present in the load document
					check = rc.rack(grip_pos, grip_orientation, closet, x_buff, y_buff) #ask robot to move the piece
					if (check == True):
						db.setPlace(pid) #set the piece in the database as posed
						self.dbg("pid = " + str(pid) + " loaded")
						toload.remove(pid) #move the element from the 'toload' list to the retval one
						loaded.append(pid) #move the element from the 'toload' list to the retval one
				else:
					# the element is to trash
					self.dbg("pid = " + str(pid) + " trashed")
					check = rc.trash(grip_pos,grip_orientation)
					trashed.append(aiccode)
			(stopflag,position) = vis.next() #get the position of the next element in the basket
			stopflag = stopflag or (counter == maxpieces)
		db.changeUploadTime(basketId) # set upload time of the inbound
		self.dbg("Inbound - end")
		return loaded,toload,trashed

	def fake_inbound(self,basketId,maxitem):
		factory = DBFactory.DBFactory(self.conf)
		db = factory.generate('Inbound')
		toload = db.getItemsByIndound(basketId) # getting the list of the element to load from the database
		loaded = random.sample(toload, 2)
		map(lambda x: toload.remove(x),loaded)
		map(lambda x: db.setPlace(x),loaded)
		trashed = ['trashed_1', 'trashed_2']
		db.changeUploadTime(basketId)
		return loaded,toload,trashed

	def fake_outbound(self,outid):
		factory = DBFactory.DBFactory(self.conf)
		db = factory.generate('Outbound')
		toget = db.getItemsByOutbound(outid) #get the list of the packages
		toget_len = len(toget)
		if (toget_len > 0):
			closet = db.getFreeCloset() #choose a free rack
			for i in range(0,toget_len):
				pid = toget[i]
				fcloset, pos = db.getPackageToGetInfo(pid) # get all the information
				last = '0'
				if (i == (toget_len-1)):
					last = '1'
				db.updatePackageStatus(pid) #update package db information
			db.outboundPrepared(outid,closet) # update db info
		return True

	def true_outbound(self,outid):
		# init
		factory = RobotControllerFactory.RobotControllerFactory(self.conf)
		rc = factory.generate()
		factory = DBFactory.DBFactory(self.conf)
		db = factory.generate('Outbound')
		# data prepare
		toget = db.getItemsByOutbound(outid) #get the list of the packages
		toget_len = len(toget)
		if (toget_len > 0):
			closet = db.getFreeCloset() #choose a free rack
			rc.openOutCloset(closet) # open the closet
			for i in range(0,toget_len):
				pid = toget[i]
				fcloset, pos = db.getPackageToGetInfo(pid) # get all the information
				last = '0'
				if (i == (toget_len-1)):
					last = '1'
				rc.getOutCloset(fcloset,pos,closet,last) # put the package
				db.updatePackageStatus(pid) #update package db information
			db.outboundPrepared(outid,closet) # update db info
		return True

	def dbg(self,txt):
		if (self.debug == True):
			print "[DBG-LOG]: "  + txt
