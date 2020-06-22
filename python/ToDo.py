#!/usr/bin/python

import time
import Logic

class ToDo(object):
	def __init__(self,conf_file):
		self.header = ''
		self.kind = None
		self.logic = Logic.Logic(conf_file)

	def run(self):
		return True

	def tostring(self):
		return self.header

	def kind(self):
		return self.kind

