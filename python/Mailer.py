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

class MailSender(Thread):
	def __init__(self,db,usr,psw,srv,prt):
		Thread.__init__(self)
		self.mail_user = usr
		self.mail_pass = psw
		self.smtp_host = srv
		self.smtp_port = prt
		self.db = db

	def sendUpload(self,payload,head,trailer,msgtxt,ss):
		# Prepare attachment
		csv_file = StringIO.StringIO()
		csv_file.write(payload[2])
		# Prepare email
		msg = MIMEMultipart()
		message = "Thank you"
		msg['From'] = "stefano_ital@libero.it"
		#msg['From'] = self.mail_user
		msg['To'] = payload[0]
		msg['Subject'] = head
		msg.attach(MIMEText(msgtxt,'plain'))
		attachname = payload[1] + trailer
		# Attach to email
		part = MIMEApplication(csv_file.getvalue(),Name=attachname)
		# After the file is closed
		part['Content-Disposition'] = 'attachment; filename=' + attachname
		msg.attach(part)
		# Send to email
		ss.sendmail(msg['From'],msg['To'],msg.as_string())
		csv_file.close()
	
	def core(self,):
		smtp_server = SMTP_SSL(host=self.smtp_host, port=self.smtp_port, timeout=self.smtp_timeout)
		smtp_server.login(self.mail_user,self.mail_pass)
		map(lambda x: self.answer(x,self.iih,"_carico.csv",self.imsg,smtp_server),upload)
		map(lambda x: self.answer(x,self.ooh,"_scarico.csv",self.omsg,smtp_server),download)
		smtp_server.quit()
		self.dbg("Sent")
