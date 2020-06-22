#!/usr/bin/python

import ToDo
import DBFactory
import SenderFactory

class DownloadToDo(ToDo.ToDo):
	def __init__(self,conf_file,docc,dept,email,arrive):
		super(DownloadToDo,self).__init__(conf_file)
		self.doc = docc
		self.dept = dept
		self.email = email
		self.arrive = arrive
		factory = DBFactory.DBFactory(conf_file)
		self.db = factory.generate('Report')
		factory = SenderFactory.SenderFactory(conf_file)
		self.ss = factory.generate()
		self.header = 'Scarico Robot: ' + str(self.email) + ' dal ' + self.dept + " del " + str(arrive)
		self.kind = 'DOWNLOAD'

	def genReport(self,doc):
		cesta = self.db.getCesta(doc)
		retval = 'Report relativo al documento di scarico ' + str(self.doc) + '\n'
		retval += "I pezzi sono stati depositati nella cesta di scarico " +  cesta + " e possono essere ritirati\n"
		retval += 'Il robot.\n'
		return retval

	def run(self):
		check = self.logic.outbound(self.doc)
		if (check == True):
			report = self.genReport(self.doc)
			ccs = self.db.getCCS()
			self.ss.quickSend(self.email,ccs,"[Scarico Robot] Resoconto",report,None)
		return check
