#!/usr/bin/python

import ToDo

class BackupToDo(ToDo.ToDo):
	def __init__(self,conf_file):
		super(BackupToDo,self).__init__(conf_file)
		self.header = 'Backup database'
		self.kind = 'BACKUP'

	def run(self):
		self.logic.backup()
		return True
