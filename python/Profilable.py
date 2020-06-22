#!/usr/bin/python

import cProfile, pstats, StringIO

class Profilable(object):
	def __init__(self):
		self.sinkdir = "logs"
		self.sink = "profile" + str(self) + ".log"
		self.profiler = cProfile.Profile()
		
	def switchON(self):
		self.profiler.enable()

	def switchOFF(self):
		self.profiler.disable()

	def setOutput(self,fname):
		self.sink = fname

	def save(self,snk = None):
		# Stats formatting
		s = StringIO.StringIO()
		sortby = 'cumulative'
		ps = pstats.Stats(self.profiler, stream=s).sort_stats(sortby)
		ps.print_stats()
		# File flushing
		if (snk == None):
			snk = self.sink
		file = open(self.sinkdir + '/' + snk,'w') 
		file.write(s.getvalue()) 
		file.close() 

