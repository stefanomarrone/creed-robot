#!/usr/bin/python

import BarcodeReaderFactory
import RobotControllerFactory
import DBFactory
import CodeManager
import GripManager
import time
import sys
import os

factory = DBFactory.DBFactory('configuration.ini')
db = factory.generate('Inbound')
factory = RobotControllerFactory.RobotControllerFactory('configuration.ini')
rc = factory.generate()
factory = BarcodeReaderFactory.BarcodeReaderFactory('configuration.ini')
bcr = factory.generate()
cm = CodeManager.CodeManager(bcr)
gm = GripManager.GripManager(db)


aiccode, side = cm.read()
grip_pos, grip_orientation = gm.compute(aiccode,side)
(closet,x_buff,y_buff) = db.getBufferInfoByCode(pid)

