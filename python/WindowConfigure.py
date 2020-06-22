from Interface import Interface
from pydispatch import dispatcher
import time
from Tkinter import *

class WindowConfigure(Toplevel):
	def __init__(self,confDB):
		Toplevel.__init__(self)
		self.db = confDB
		self.build()
		self.displaydata()
		self.doneFlag = False

	def winclose(self,flag=False):
		if (flag == True):
			self.savedata()
		self.doneFlag = True
		self.quit()

	def done(self):
		return self.doneFlag

	def hide(self):
		self.withdraw()

	def show(self):
		self.update()

	def displaydata(self):
		(emails,rep,exp) = self.db.readConfiguration()
		line = ''
		for i in emails:
			line += i + '\n'
		line += '\n'
		self.text1.insert(END,line)
		self.text3.insert(END,rep)
		self.text4.insert(END,exp)

	def savedata(self):
		# capture data
		ms = self.text1.get("1.0",END)
		ms = filter(lambda x: x!='',ms.splitlines())
		rp = int(self.text3.get("1.0",END))
		ex = int(self.text4.get("1.0",END))		
		# save the data
		self.db.writeConfiguration(ms,rp,ex)

	def commit(self):
		self.winclose(True)

	def rollback(self):
		self.winclose(False)

	def build(self):
		self.geometry("420x360+400+59")
		self.title("Configurazioni")
		self.configure(background="white")
		self.resizable(0, 0)

		self.framePrincipale = Frame(self)
		self.framePrincipale.configure(bg="white")
		self.framePrincipale.pack(fill=X, ipady="1m")

		self.frameSecondo = Frame(self.framePrincipale)
		self.frameSecondo.configure(background="white")
		self.frameSecondo.pack(ipadx="23m")

		self.label1 = Label(self.frameSecondo)
		self.label1.configure(background="white" ,text="email", font="Helvetica 18", width=7)
		self.label1.pack(side="left")

		self.text1 = Text(self.frameSecondo)
		self.text1.configure(background="white")
		self.text1.configure(width=25, height=3)
		self.text1.configure(wrap='word')
		self.text1.pack(side="right")

		self.frameTerzo = Frame(self.framePrincipale)
		self.frameTerzo.pack(ipadx="5m")
		self.frameTerzo.configure(background="white")

		self.frameTerzoSinistro = Frame(self.frameTerzo, background="white")
		self.frameTerzoSinistro.pack(side="left")

		self.frameTerzoDestro = Frame(self.frameTerzo, background="white")
		self.frameTerzoDestro.pack(side="right")

		self.label2 = Label(self.frameTerzoSinistro)
		self.label2.configure(text="intervallo \n report (gg)", font="Helvetica 13")
		self.label2.configure(background="white")
		self.label2.configure(width=20, height=5)
		self.label2.pack()

		self.text3 = Text(self.frameTerzoDestro)
		self.text3.configure(background="white")
		self.text3.configure(width=20, height=3)
		self.text3.configure(wrap='word')
		self.text3.pack()

		self.frameQuarto = Frame(self.framePrincipale)
		self.frameQuarto.pack(ipadx="5m")
		self.frameQuarto.configure(background="white")

		self.frameQuartoSinistro = Frame(self.frameQuarto)
		self.frameQuartoSinistro.pack(side="left")

		self.frameQuartoDestro = Frame(self.frameQuarto)
		self.frameQuartoDestro.pack(side="right")

		self.label3 = Label(self.frameQuartoSinistro)
		self.label3.configure(text="intervallo \n scadenze (gg)", font="Helvetica 13")
		self.label3.configure(background="white")
		self.label3.configure(width=20, height=5)
		self.label3.pack()

		self.text4 = Text(self.frameQuartoDestro)
		self.text4.configure(background="white")
		self.text4.configure(width=20, height=3)
		self.text4.configure(wrap='word')
		self.text4.pack()

		self.frameQuinto = Frame(self.framePrincipale)
		self.frameQuinto.pack(ipadx="22m", ipady="2.5m")
		self.frameQuinto.configure(background="white")

		self.frameQuintoPiuDestro = Frame(self.frameQuinto)
		self.frameQuintoPiuDestro.configure(background="white")
		self.frameQuintoPiuDestro.pack(side="right", ipadx="3m")
		self.button1 = Button(self.frameQuintoPiuDestro, command=self.rollback)
		self.button1.configure(pady="1.1m")
		self.button1.configure(text="ANNULLA", font="Helvetica 12 bold")
		self.button1.configure(width=9)
		self.button1.pack(side="right")

		self.frameQuintoDestro = Frame(self.frameQuinto)
		self.frameQuintoDestro.configure(bg="white")
		self.frameQuintoDestro.pack(side="right")
		self.button2 = Button(self.frameQuinto, command=self.commit)
		self.button2.configure(pady="1.1m", text="OK", font="Helvetica 12 bold", width=9)
		self.button2.pack(side="right")

