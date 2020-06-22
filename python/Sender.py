from smtplib import SMTP_SSL
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import hashlib
import time
import datetime
import StringIO
import io
import email
import csv
import rfc822

class Sender():
	def __init__(self,susr,spsw,ssrv,sprt):
		self.mail_user = susr
		self.mail_pass = spsw
		self.smtp_host = ssrv
		self.smtp_port = sprt

	def send(self,ccs,subject,msgtxt,payload,attachkind):
		smtp_server = SMTP_SSL(host=self.smtp_host, port=self.smtp_port,timeout=10)
		smtp_server.login(self.mail_user,self.mail_pass)
		# Prepare attachment
		csv_file = StringIO.StringIO()
		csv_file.write(payload)
		# Prepare email
		msg = MIMEMultipart()
		msg['From'] = self.mail_user
		msg['To'] = ccs[0]
		msg['Subject'] = subject
		msg.attach(MIMEText(msgtxt,'plain'))
		nowtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		attachname = "Report_" + attachkind + "_" + nowtime + ".csv"
		# Attach to email
		part = MIMEApplication(csv_file.getvalue(),Name=attachname)
		# After the file is closed
		part['Content-Disposition'] = 'attachment; filename=' + attachname
		msg.attach(part)
		# Send to email
		smtp_server.sendmail(msg['From'],msg['To'],msg.as_string())
		csv_file.close()
		smtp_server.quit()
		time.sleep(10)

	def quickSend(self,destination,ccs,subject,msgtxt,payload):
		smtp_server = SMTP_SSL(host=self.smtp_host, port=self.smtp_port,timeout=10)
		smtp_server.login(self.mail_user,self.mail_pass)
		# Prepare email
		msg = MIMEMultipart()
		msg['From'] = self.mail_user
		msg['To'] = destination
		msg['Subject'] = subject
		msg.attach(MIMEText(msgtxt,'plain'))
		nowtime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		# Prepare attachment
		if (payload != None):
			for p in payload:
				csv_file = StringIO.StringIO()
				csv_file.write(p[1])
				# Attach to email
				part = MIMEApplication(csv_file.getvalue(),Name=p[0])
				# After the file is closed
				part['Content-Disposition'] = 'attachment; filename=' + p[0]
				msg.attach(part)
				csv_file.close()
		# Send to email
		smtp_server.sendmail(msg['From'],msg['To'],msg.as_string())
		smtp_server.quit()
