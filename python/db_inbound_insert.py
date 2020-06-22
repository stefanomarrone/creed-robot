#!/usr/bin/python

import pandas as pd
import Database
import DBFactory
import sys
import time



class Inbound(object):
	def __init__(self,db):
		self.database = db

	def dateConvert(self,d):
		x = d.dt.strftime('%Y-%m-%d')
		return x
	
	def load(self,filename):
		orders = self.fromXLStoList(filename)
		map(lambda o: self.loadOrder(o),orders)

	def loadOrder(self,o):
		user = o[0]
		toload = o[1]
		iid = self.database.requestInbound(toload,user)
		self.database.itemsToLoad()

	def fromXLStoList(filename):
		xl = pd.ExcelFile(filename)
		retval = list()
		for s in xl.sheet_names:
			usr = str(s)
			df = xl.parse(usr)
			df[['Scadenza']] = df[['Scadenza']].apply(dateConvert)
			items = df.to_records().tolist()
			items = map(lambda x: ( str(x[1]), str(x[2]), x[3]), items)
			t = (usr,items)
			retval.append(t)
		return retval

if __name__ == "__main__":
	inifile = sys.argv[1]
	filename = sys.argv[2]
	dbf = DBFactory.DBFactory(inifile)
	db = dbf.generate()

