#!/usr/bin/python

import socket
import time
import RobotControllerFactory
import SVNManagerFactory
import DBFactory
import CognexControllerFactory
import MailManagerFactory
import BarcodeReaderFactory
import Inbound
import CodeManager
import GripManager

def dbg(txt):
	print "[DBG-LOG]: " + txt

conf_file = 'configuration_sliced.ini'
factory = MailManagerFactory.MailManagerFactory(conf_file)
mail = factory.generate()
factory = RobotControllerFactory.RobotControllerFactory(conf_file)
rc = factory.generate()
factory = DBFactory.DBFactory(conf_file)
db = factory.generate('Inbound')
factory = BarcodeReaderFactory.BarcodeReaderFactory(conf_file)
bcr = factory.generate()
mail.start()
time.sleep(3)
docId = '1001'
baskets = db.getBasketByDoc(docId)
print "Ecco le ceste di carico disponibili per il codice indicato:\n"
print baskets
basketId = '2'
toload = db.getItemsByIndound(basketId) # getting the list of the element to load from the database
maxpieces = len(toload)
loaded = list()
trashed = list()
cm = CodeManager.CodeManager(bcr,rc) # Code manager: it could change in future
gm = GripManager.GripManager(db)
counter = 0
stopflag = False
while (stopflag == False):
	aiccode, side = cm.read() #reading the barcode
	dbg("Ho letto il codice " + aiccode)
	pid = db.getPackByCode(aiccode,basketId) # getting the id in the database
	dbg("Pacchetto del carico " + str(pid))
	grip_pos, grip_orientation = gm.compute(aiccode,side) #computing the approaching strategy
	dbg("Il pacchetto da prelevare e' al punto " + str(grip_pos))
	dbg("Il pacchetto da prelevare e' al lato " + str(grip_orientation))
	(closet,x_buff,y_buff) = db.getBufferInfoByCode(pid)
	dbg("Il cassetto e' il " + str(closet))
	dbg("In posizione (" + str(x_buff) + "," + str(y_buff) + ")")
	check = (closet != None)
	if (check == True):
		# check the presence of the item in the load document
		if (pid in toload):
			# the element is to load into the rack since it is present in the load document
			check = rc.rack(grip_pos, grip_orientation, closet, x_buff, y_buff) #ask robot to move the piece
			if (check == True):
				db.setPlace(pid) #set the piece in the database as posed
				dbg("pid = " + str(pid) + " loaded")
				toload.remove(pid) #move the element from the 'toload' list to the retval one
				loaded.append(pid) #move the element from the 'toload' list to the retval one
		else:
			# the element is to trash
			dbg("pid = " + str(pid) + " trashed")
			check = rc.trash(grip_pos,grip_orientation)
			trashed.append(aiccode)
		if (check == False):
			dbg("Errore Movimento Robot")
	counter += 1
	stopflag = stopflag or (counter == maxpieces)
db.changeUploadTime(basketId) # set upload time of the inbound
dbg("Loaded > " + str(loaded))
dbg("Not Found > " + str(toload))
dbg("Unexpected > " + str(trashed))
