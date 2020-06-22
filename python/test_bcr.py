#!/usr/bin/python

import BarcodeReaderFactory

factory = BarcodeReaderFactory.BarcodeReaderFactory('configuration.ini')
fact = factory.generate()
ret = fact.read()
print ret

