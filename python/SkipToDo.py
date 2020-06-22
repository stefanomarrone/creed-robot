#!/usr/bin/python

import ToDo

class SkipToDo(ToDo.ToDo):
	def __init__(self,conf_file):
		super(SkipToDo,self).__init__(conf_file)
		self.header = 'Refresh the list'
		self.kind = 'Skip'

	def run(self):
		return True
