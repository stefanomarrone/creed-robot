import Database
import pg
import time
import datetime
import sys

class ReportDM(Database.Database):
	def __init__(self, ipadd, prt, lgn, psswd, schm, dbg):
		super(ReportDM,self).__init__(ipadd, prt, lgn, psswd, schm, dbg)
		self.dict = dict()
		self.dict['expire'] = ('Report dei medicinali in scadenza (7gg)',"select d.description, p.batch, p.expire, b.closet from drug as d join package as p on (p.drug = d.id) join upload as u on (u.package = p.id) join buffer as b on (u.buffer = b.id) where p.state = 'loaded' and (extract(days from now()) - extract(days from p.expire) >= 7);",'In allgato il report dei medicinali in scadenza.\n Il robot.','scadenza')
		self.dict['report'] = ('Report dei medicinali in magazzino',"select d.description, p.batch, p.expire, b.closet from drug as d join package as p on (p.drug = d.id) join upload as u on (u.package = p.id) join buffer as b on (u.buffer = b.id) where p.state = 'loaded';",'In allgato il report dei medicinali in magazzino.\n Il robot.','magazzino')

	def timeout(self,label):
		qry = "select extract(hours from now()) - extract(hours from l.lasttime) >= l.hours from dates as l where l.label = '" + label + "';"
		is_timeout = self.singleValuesQuery(qry)
		retval = (str(is_timeout) == 'True')
		return retval
		
	def update(self,label):
		sql = "update dates set lasttime = now() where label = '" + label + "';"
		self.execute(sql)		

	def timeoutCheck(self):
		qry = 'select label from dates;'
		labels = self.getList(qry)
		labels = filter(lambda l: self.timeout(l),labels)
		return labels

	def getProductInfo(self,lst):
		str_list = '(' + str(lst)[1:-1] + ')'
		qry = 'select d.code, d.description, p.batch, p.expire from drug as d join package as p on (p.drug = d.id) where p.id in ' + str_list + ";"
		result = self.query(qry)
		retval = "Codice,Descrizione,Lotto,Scadenza\n"
		for r in result:
			retval += r[0] + ',' + r[1] + ',' + r[2] + ',' + str(r[3]) + '\n'
		return retval

	def row2str(self,row):
		retval = reduce(lambda x,y: str(x) + ';' + str(y),row) + ';'
		return retval

	def genReport(self,qry):
		rslt = self.query(qry)
		top = len(rslt)
		retval = ''
		if (top > 0):
			retval = "Medicinale;Lotto;Scadenza;Cassetto;\n"
			for i in range(0,top):
				row = rslt[i]
				retval += self.row2str(row) + ';\n'
		return retval

	def getElements(self,label):
		subject = self.dict[label][0]
		qry = self.dict[label][1]
		msg = self.dict[label][2]
		payload = self.genReport(qry)
		kind = self.dict[label][3]
		return subject,payload,msg,kind

	def getCesta(self,doc):
		qry = 'select o.outbox from outbound as o where o.id = ' + str(doc) + ';'
		basket = self.singleValuesQuery(qry)
		return basket

	def getCCS(self):
		qry = 'select mail from ccs;'
		mails = self.getList(qry)
		return mails

	def getInboundAddress(self,basket):
		qry = "select i.address from inbound as i join upload as u on (u.inbound = i.id) where u.id = " + str(basket) + ";"
		address = self.singleValuesQuery(qry)
		return address

