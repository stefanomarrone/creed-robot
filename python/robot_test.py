#!/usr/bin/python

import RobotControllerFactory
import sys
import time

conf_file = sys.argv[1]
factory = RobotControllerFactory.RobotControllerFactory(conf_file)
rc = factory.generate()

