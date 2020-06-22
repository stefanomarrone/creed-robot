#!/usr/bin/python

import pandas as pd
import Database
import DBFactory
import sys
import time
import csv
import datetime

class Inbound(object):
	def __init__(self,db):
		self.database = db

	def dateConvert(self,d):
		x = d.dt.strftime('%Y-%m-%d')
		return x
	
	def decode(self,csv_file):
		retval = list()
		csv_reader = csv.reader(csv_file,delimiter=',')
		linecounter = 0
		for row in csv_reader:
			if (linecounter > 0):
				if (row != []):
					nome = row[0]
					aic = row[1]
					lotto = row[2]
					scadenza = datetime.datetime.strptime(row[3], '%d/%m/%Y')
					qta = int(row[4])
					t = (nome,aic,lotto,scadenza,qta)
					retval.append(t)
			else:
				header = reduce(lambda x,y: x + ';' + y, row) + ';Cesta;\n'
			linecounter += 1		
		return retval, header

	def encode(self,dictionary):
		retval = ''
		for key in dictionary.keys():
			for e in dictionary[key]:
				t = (e[0], e[1], e[2], str(e[3]), e[4], key)
				row = reduce(lambda x,y: str(x) + ';' + str(y),list(t)) + ';\n'
				retval += row
		return retval

	def load(self,code,sender,filename):
		orders, row = self.decode(filename)
		baskets = self.database.requestInbound(code,sender,orders)
		report = row + self.encode(baskets)
		return report

	def fastload(self,code):
		qry = "select u.package from inbound as i join upload as u on (u.inbound = i.id) where i.document_id = " + str(code) + ";"
		ps = self.database.getList(qry)
		map(lambda x: self.database.setPlace(x),ps)
		qry = "select i.id from inbound as i where i.document_id = " + str(code) + ";"
		bs = self.database.getList(qry)
		map(lambda x: self.database.changeUploadTime(x),bs)

