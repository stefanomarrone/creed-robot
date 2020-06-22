#!/usr/bin/python

import ToDo

class ExitToDo(ToDo.ToDo):
	def __init__(self,conf_file):
		super(ExitToDo,self).__init__(conf_file)
		self.header = 'Exit from the application'
		self.kind = 'Exit'

	def run(self):
		print 'eseguo chiusura'
		return False
