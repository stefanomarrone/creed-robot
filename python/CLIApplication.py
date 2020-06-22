#!/usr/bin/python

import Application

class CLIApplication(Application.Application):
	def __init__(self,conf_file,dbg=True):
		super(CLIApplication,self).__init__(conf_file,dbg)
		self.maxitemtoload = 20
		msgs = ["\n***", "1(Carico Cesta)", "2(Data Backup)", "3(Scarico Ordine)", "x(exit)", "***"]
		msg = map(lambda x: x + "\n", msgs)
		self.msg = reduce(lambda x,y: x + y, msg)

	def run(self):
		stay = True
		while (stay == True):
			x = raw_input(self.msg)
			if (x == '1'):
				bid = self.getBasketToLoad()
				ok,unmatched,unexpected = self.logic.inbound(bid,self.maxitemtoload)
				self.printReport(ok,unmatched,unexpected)
			elif (x == '2'):
				self.backup()
			elif (x == '3'):
				bid = self.getOrderToDownload()
				self.logic.outbound()
			elif (x == 'x'):
				stay = False
				self.dbg("Have a nice day :)")
			else:
				print "Retry, you'll be more lucky in future."
		exit(0)

	def getBasketToLoad(self):
		orders = self.taskdb.getFreeIndound()
		print "Codici di carico disponibili: " + str(orders) + '\n'
		docId = raw_input("Quale vuoi caricare?")
		baskets = self.taskdb.getBasketByDoc(docId)
		print "Ecco le ceste di carico disponibili per il codice indicato: " + str(baskets) + '\n'
		basketId = raw_input("Quale vuoi caricare?")
		return basketId

	def getOrderToDownload(self):
		orders = self.taskdb.getFreeOutbound()
		print "Codici di scarico disponibili: " + str(orders) + '\n'
		docId = raw_input("Quale vuoi scaricare?")
		return docId

