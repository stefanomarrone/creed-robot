import Database
import pg
import time
import datetime
import sys

class InboundDM(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(InboundDM,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)

	def getNewIID(self,c,mail):
		arriv = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		arriv = self.toDate(arriv)
		iid = self.getNextId('id','inbound')
		sql = "insert into inbound values(" + str(iid) + ",'" + c + "','"  + mail + "'," + arriv + ",NULL);"
		self.execute(sql)
		return iid

	def requestInbound(self,code,mail,inbound):
		retval = dict()
		iid = self.getNewIID(code,mail)
		retval[iid] = list()
		for item in inbound:
			(name,aic, batch, expire, qty) = (item[0], item[1], item[2], item[3], item[4])
			check = self.alreadyInDocument(retval[iid],item)
			if (check == True):
				iid = self.getNewIID(code,mail)
				retval[iid] = list()
			retval[iid].append(item)
			for repeat in range(0,qty):
				pid = self.addNewPackage(aic,batch,expire)
				uud = self.getNextId('id','upload')
				sql = "insert into upload values(" + str(uud) + "," + str(iid) + "," + str(pid) + ",0);"
				self.execute(sql)
		map(lambda i: self.itemsToLoad(i),retval.keys())
		return retval

	def alreadyInDocument(self,lst,item):
		counter = 0
		size = len(lst)
		found = False
		while ((not found) and (counter < size)):
			temp = lst[counter]
			found = (temp[0] == item[0]) and ((temp[1] != item[1]) or (temp[2] != item[2]))
			counter += 1
		return found

	def getItemInfo(self,code):
		qry = "select d.height, d.length, d.depth, d.gripside from drug as d where d.code = '" + code +  "';"
		infos = self.query(qry)
		return infos[0]

	# change the upload time
	def changeUploadTime(self,inbound):
		arriv = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		arriv = self.toDate(arriv)
		sql = "update inbound set upload = " + arriv + " where id = " + str(inbound) + ";"
		self.execute(sql)

	def assignSlot(self,item):
		qry = "select b.id from package as p join closetmap as cm on (cm.drug = p.drug) join buffer as b on (b.closet = cm.closet) where p.id = "
		qry += str(item)
		qry += " and b.id <> all (select u.buffer from upload as u where u.buffer <> 0);"
		val = self.singleValuesQuery(qry)
		upd = "update upload set buffer = " + str(val) + " where package = " + str(item) + ";"
		self.execute(upd)

	# load items of a specific inbound
	def itemsToLoad(self,inboundCode):
		items = self.getItemsByIndound(inboundCode)
		map(lambda i: self.assignSlot(i),items)

	# load items of a specific inbound
	def getBufferInfoByCode(self,packcode):
		qry = "select b.closet, b.x_cell, b.y_cell from upload as u join buffer as b on (b.id = u.buffer) join package as p on (p.id = u.package) where p.id = '" + str(packcode) + "';"
		rslt = self.query(qry)
		return rslt[0]

	# set a package as placed
	def setPlace(self,packcode):
		stmt = "update package set state = 'loaded' where id = " + str(packcode) + ";"
		self.execute(stmt)

	# get id of a package by its code
	def getPackByCode(self,aic,basket):
		qry = "select pk.id from package as pk join upload as u on (u.package = pk.id) join drug as d on (d.id = pk.drug) where (d.code='" + str(aic) + "') and u.inbound = " + str(basket) + ";"
		item = self.isQueryEmpty(qry)
		retval = None
		if (item != True):
			retval = self.singleValuesQuery(qry)
		return retval

	def getItemsByIndound(self,basket):
		qry = 'select u.package from upload as u where u.inbound = ' + str(basket) + ';'
		rslt = self.query(qry)
		items = map(lambda x: x[0],rslt)
		return items 

	# load items of a specific inbound
	def getBasketByDoc(self,docid):
		qry = 'select i.id from inbound as i where i.document_id = ' + str(docid) + ';'
		rslt = self.query(qry)
		items = map(lambda x: x[0],rslt)
		return items 

	# get drug id by code
	def getDrugByCode(self,code):
		qry = "select d.id from drug as d where d.code = '" + code +  "';"
		did = self.singleValuesQuery(qry)
		return did

	# add new package
	def addNewPackage(self,drugcode,batch,exp):
		did = self.getDrugByCode(drugcode)
		pid = self.getNextId('id','package')
		qry = "insert into package values(" + pid + "," + did + ",'" + batch + "','" + str(exp) + "');"
		self.execute(qry)
		return pid
