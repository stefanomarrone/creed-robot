#!/usr/bin/python

import RobotControllerFactory

factory = RobotControllerFactory.RobotControllerFactory('configuration.ini')
rc = factory.generate()
rc.openOutCloset('P03')
rc.getOutCloset('C06',(150,150),'P03','0')
rc.getOutCloset('C07',(150,150),'P03','1')


