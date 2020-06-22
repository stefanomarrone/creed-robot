from pydispatch import dispatcher
from smtplib import SMTP_SSL
from poplib import POP3_SSL
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from threading import Thread
from threading import Timer
import hashlib
import time
import StringIO
import io
import email
import rfc822
import Inbound
import Outbound
import email.parser
import csv

class MailManager(Thread):
	def __init__(self,mdatabase,idatabase,odatabase,psrv,pprt,pusr,ppsw,ssrv,sprt,ihead,ohead,dhead,timer,timeout,dbg,delete,send,fast):
		Thread.__init__(self)
		self.pop_host = psrv
		self.pop_port = pprt
		self.mail_user = pusr
		self.mail_pass = ppsw
		self.smtp_host = ssrv
		self.smtp_port = sprt
		self.smtp_timeout = timeout
		self.ii = ihead
		self.oo = ohead
		self.dd = dhead
		self.resetDictionary()
		self.debugFlag = dbg
		self.delFlag = delete
		self.fastflag = fast
		self.sendFlag = send
		self.idb = idatabase
		self.mdb = mdatabase
		self.odb = odatabase
		self.interval = timer
		self.clock = Timer(self.interval,self.timeout)

	def resetDictionary(self):	
		imsg = 'Questo e'' un messaggio automatico: non rispondere. In allegato il file di distribuzione dei prodotti da caricare nelle ceste di carico.\n\nSaluti,\nil robot.\n'
		omsg = 'Questo e'' un messaggio automatico: non rispondere. In allegato la lista dei medicinali che saranno disponbili.\n\nSaluti,\nil robot.\n'
		dmsg = 'Questo e'' un messaggio automatico: non rispondere. In allegato la lista dei nuovi medicinali caricati nel database e dei relativi cassetti.\n\nSaluti,\nil robot.\n'
		self.headers = dict()
		self.headers[self.ii] = (self.process_upload,list(),imsg,"_carico.csv"," richieste di carico")
		self.headers[self.oo] = (self.process_download,list(),omsg,"_scarico.csv"," richieste di scarico")
		self.headers[self.dd] = (self.process_drug,list(),dmsg,"_assegnazioni.csv"," richieste di nuovi farmaci")

	def valuableEmail(self,m):
		return m['Subject'] in self.headers.keys()

	def appendMail(self,m,t):
		f,oldl,msg,app,log = self.headers[m]
		l = list(oldl)
		l.append(t)
		self.headers[m] = (f,l,msg,app,log)

	def getListData(self,m):
		return self.headers[m]

	def getEmail(self):
		try:
			pop_server = POP3_SSL(host=self.pop_host, port=self.pop_port)
			pop_server.user(self.mail_user)
			pop_server.pass_(self.mail_pass)
			resp, items, octets = pop_server.list()
			self.dbg("Trovate " + str(len(items)) + " emails")
			for i in items:
				id, size = i.split(' ')
				resp, text, octets = pop_server.retr(id)
				raw_text = "\n".join(text)
				mail = email.message_from_string(raw_text)
				rto = mail['Return-Path']
				if (self.valuableEmail(mail)):
					# check the existence of the email
					digest = hashlib.sha256(raw_text).hexdigest()
					already_processed = self.mdb.isMailProcessed(digest)
					if (already_processed == False):
						self.mdb.addProcessedMail(digest)
						for part in mail.walk():
							if (part.get_content_type() == 'text/csv'):
								name = part.get_filename()
								cod, ext = name.split('.')
								data = part.get_payload(decode=True)
								csv_file = StringIO.StringIO(data)
								t = (rto, cod, csv_file)
								self.appendMail(mail['Subject'],t)
				if (self.delFlag == True):
					pop_server.dele(id)
			pop_server.quit()	
		except Exception as e:
			print "FAILED :" + str(e)
			exit(1)

	def process_upload(self,payload):
		sender = payload[0]
		code = payload[1]
		csv_file = payload[2]
		self.dbg("Load Inbound Document....")
		inbm = Inbound.Inbound(self.idb)
		retCSV = inbm.load(code,sender,csv_file)
		retval = (sender,code,retCSV)
		self.dbg("Inbound Document Loaded")
		if (self.fastflag == True):
			self.dbg("Fast Inbound Document....")
			inbm.fastload(code)
		return retval

	def process_drug(self,payload):
		#todo
		sender = payload[0]
		code = payload[1]
		csv_file = payload[2]
		self.dbg("Loading drugs....")
		loader = Loader.Loader(self.mdb)
		retCSV = loader.load(sender,code,csv_file)
		retval = (sender,code,retCSV)
		self.dbg("Drugs Loaded")
		return retval

	def process_download(self,payload):
		sender = payload[0]
		code = payload[1]
		csv_file = payload[2]
		self.dbg("Load Outbound Document....")
		onbm = Outbound.Outbound(self.odb)
		retCSV = onbm.download(sender,code,csv_file)
		retval = (sender,code,retCSV)
		self.dbg("Inbound Outbound Loaded")
		return retval

	def answer(self,address,content,subj,header,trailer,msgtxt,ss):
		# Prepare attachment
		csv_file = StringIO.StringIO()
		csv_file.write(content)
		# Prepare email
		msg = MIMEMultipart()
		message = "Thank you"
		msg['From'] = "stefano_ital@libero.it"
		#msg['From'] = self.mail_user
		msg['To'] = address
		msg['Subject'] = subj
		msg.attach(MIMEText(msgtxt,'plain'))
		attachname = header + trailer
		# Attach to email
		part = MIMEApplication(csv_file.getvalue(),Name=attachname)
		# After the file is closed
		part['Content-Disposition'] = 'attachment; filename=' + attachname
		msg.attach(part)
		# Send to email
		ss.sendmail(msg['From'],msg['To'],msg.as_string())
		csv_file.close()
	
	def core(self):
		self.getEmail()
		self.log()
		smtp_server = SMTP_SSL(host=self.smtp_host, port=self.smtp_port, timeout=self.smtp_timeout)
		smtp_server.login(self.mail_user,self.mail_pass)
		for k in self.headers.keys():
			f,ll,msg,file_trailer,log = self.headers[k]
			for l in ll:
				address,subj,content = f(l)
				if (self.sendFlag == True):
					self.answer(address,content,k,subj,file_trailer,msg,smtp_server)
		smtp_server.quit()
		self.resetDictionary()

	def log(self):
		keys = self.headers.keys()
		for k in keys:
			f,l,msg,app,log = self.getListData(k)
			i = len(l)
			if (i > 0):
				str_txt = "Ricevuti " + str(i) + app
				self.dbg(str_txt)
				dispatcher.send(message=str_txt,signal='log.external',sender='mailer')

	def timeout(self):
		self.core()
		self.clock.cancel()
		self.clock = Timer(self.interval,self.timeout)
		self.clock.start()		

	def run(self):
		self.dbg("Mail Manager Activated")
		running = True
		self.core()
		while (running == True):
			self.clock.start()
			running = self.queue.get()
		self.clock.cancel()	

	def dbg(self,txt):
		if (self.debugFlag == True):
			print "[DBG-MLM]: "  + txt
