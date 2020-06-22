#!/usr/bin/python

import ToDo
import DBFactory
import SenderFactory

class UploadToDo(ToDo.ToDo):
	def __init__(self,conf_file,basket,document):
		super(UploadToDo,self).__init__(conf_file)
		self.bas = basket
		self.doc = document
		factory = DBFactory.DBFactory(conf_file)
		self.db = factory.generate('Report')
		factory = SenderFactory.SenderFactory(conf_file)
		self.ss = factory.generate()
		self.header = 'Carico Robot: documento #' + str(self.doc) + " cesta di carico #" + str(self.bas)
		self.kind = 'UPLOAD'
	
	def genReport(self,l,tol,unex):
		retval = 'Report relativo al documento di carico ' + str(self.doc) + " - cesta di carico " + str(self.bas) + '\n'
		retval += 'Sono stati caricati ' + str(len(l)) + " pezzi (caricati.csv)\n"
		retval += 'Non sono stati caricati ' + str(len(tol)) + " pezzi (noncaricati.csv)\n"
		retval += 'Pezzi presenti nella cesta ma non nel documento ' + str(len(unex)) + ": puoi ritirarli nel cesto di scarto.\n"
		retval += 'Il robot.\n'
		csv_loaded = self.db.getProductInfo(l)
		csv_not_found = self.db.getProductInfo(tol)
		return retval, csv_loaded, csv_not_found

	def run(self):
		loaded, toload, trashed = self.logic.inbound(self.bas,100)
		report, pay_loaded, pay_unloaded = self.genReport(loaded, toload, trashed)
		ccs = self.db.getCCS()
		dest = self.db.getInboundAddress(self.bas)
		pays = [("caricati.csv",pay_loaded), ("noncaricati.csv",pay_unloaded)]
		self.ss.quickSend(dest,ccs,"[Carico Robot] Resoconto",report,pays)
		return True
