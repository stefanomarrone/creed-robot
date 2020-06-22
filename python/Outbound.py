#!/usr/bin/python

import pandas as pd
import Database
import DBFactory
import sys
import time
import csv
import datetime

class Outbound(object):
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
					qta = int(row[2])
					t = (nome,aic,qta)
					retval.append(t)
			else:
				header = reduce(lambda x,y: x + ';' + y, row) + ';RIT_QNT;\n'
			linecounter += 1		
		return retval, header

	def encode(self,lista):
		retval = ''
		for item in lista:
			row = reduce(lambda x,y: str(x) + ';' + str(y),list(item)) + ';\n'
			retval += row
		return retval

	def download(self,mail,code,filename):
		orders, row = self.decode(filename)
		response = self.database.request(mail,code,orders)
		report = row + self.encode(response)
		return report

