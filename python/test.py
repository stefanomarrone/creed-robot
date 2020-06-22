#!/usr/bin/python

import MasterControlProgram
import sys
from pydispatch import dispatcher

mcp = MasterControlProgram.MasterControlProgram(sys.argv[1])
mcp.start()
mcp.join()
