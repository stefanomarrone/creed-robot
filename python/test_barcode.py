#!/usr/bin/python

import BarcodeReaderFactory
import time
import sys
import os

factory = BarcodeReaderFactory.BarcodeReaderFactory('configuration.ini')
bcr = factory.generate()
temp,angle = bcr.read()
print temp
print angle
