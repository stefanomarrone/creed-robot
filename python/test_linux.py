#!/usr/bin/python

from threading import Timer
import sys
import time
import RobotControllerFactory
import PlcManagerFactory

conf_file = sys.argv[1]
factory = PlcManagerFactory.PlcManagerFactory(conf_file)
plc = factory.generate()
plc.start()
factory = RobotControllerFactory.RobotControllerFactory(conf_file)
rc = factory.generate()
rc.openOutCloset('A06')
rc.closeOutCloset('A06')
rc.rack((0.0,0.0,0.0),0,'A06',0.0,0.0)
print 'End of test'

