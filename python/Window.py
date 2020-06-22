import sys
import time
from pydispatch import dispatcher
from WindowConfigure import WindowConfigure
from WindowConfirm import WindowConfirm
from Tkinter import *

class Window():
	def __init__(self,lfile,cdb,dbgf=True):
		self.logfile = lfile
		self.debugFlag = dbgf
		self.db = cdb
		self.runningflag = True
		dispatcher.connect(self.getvalue,signal='gui.getvalue',sender='interface')
		dispatcher.connect(self.kill,signal='gui.kill',sender='interface')
		dispatcher.connect(self.refresh,signal='gui.refresh.outputs',sender='interface')
		self.root = Tk()
		self.root.resizable(0,0)
		self.buildCommands()
		self.bts = [self.cfgButton, self.bckButton, self.rfshButton, self.goButton, self.exButton]
		self.disable()

	def kill(self):
		self.runningflag = False
		self.root.destroy()

	def refresh(self,message):
		if (self.runningflag == True):
			numlines = int(message)
			fp = open(self.logfile,'r')
			line = ''
			self.text2.delete(1.0,END)
			for i in range(0,numlines):
				line += fp.readline()
			self.text2.insert(END,line)
			self.root.update()

	def getvalue(self,message):
		if (self.runningflag == True):
			self.list.delete(0, END)
			for item in message.splitlines():
				self.list.insert(END, item)
			self.enable()

	def configWin(self):
		self.hide()
		confwin = WindowConfigure(self.db)
		confwin.mainloop()
		confwin.hide()
		self.show()
		self.root.mainloop()

	def funzioneBackup(self):
		dispatcher.send(message='B',signal='gui.response',sender='window')

	def funzioneGo(self):
		self.hide()
		confwin = WindowConfirm()
		confwin.mainloop()
		answer = confwin.getValue()
		confwin.hide()
		if (answer == True):
			commandID = self.list.curselection()[0]
			dispatcher.send(message=str(commandID),signal='gui.response',sender='window')
		self.show()
		self.root.mainloop()

	def funzioneRefresh(self):
		dispatcher.send(message='R',signal='gui.response',sender='window')

	def funzioneExit(self):
		self.hide()
		confwin = WindowConfirm()
		confwin.mainloop()
		answer = confwin.getValue()
		confwin.hide()
		if (answer == True):
			dispatcher.send(message='X',signal='gui.response', sender='window')
		else:
			self.show()
			self.root.mainloop()

	def hide(self):
		self.root.withdraw()

	def show(self):
		self.root.update()
		self.root.deiconify()

	def enable(self):
		map(lambda x: x.configure(state=NORMAL),self.bts)

	def disable(self):
		map(lambda x: x.configure(state=DISABLED),self.bts)

	def buildCommands(self):
		self.framePrincipale = self.root
		self.framePrincipale.geometry("617x450+430+107")
		self.framePrincipale.title("Il Robot")
		self.framePrincipale.configure(background="white")

		self.frame1 = Frame(self.framePrincipale)
		self.frame1.place(relx=0.081, rely=0.156, relheight=0.589, relwidth=0.365)
		self.frame1.configure(relief='groove', borderwidth="2", width=225)

		self.list = Listbox(self.frame1, selectmode=SINGLE, width=20)
		self.list.pack(fill=BOTH, expand=YES)

		self.frame2 = Frame(self.framePrincipale)
		self.frame2.place(relx=0.551, rely=0.156, relheight=0.589, relwidth=0.365)
		self.frame2.configure(relief='groove', borderwidth="2", width=225)

		self.text2 = Text(self.frame2)
		self.text2.configure(bg="white", wrap='word')
		self.text2.pack(fill=BOTH, expand=YES)
		
		self.label1 = Label(self.framePrincipale)
		self.label1.place(relx=0.11, rely=0.022, relheight=0.096, relwidth=0.3)
		self.label1.configure(bg="white", text="COMANDI", font="Helvetica 18 bold", width=190)

		self.label2 = Label(self.framePrincipale)
		self.label2.place(relx=0.58, rely=0.022, relheight=0.096, relwidth=0.3)
		self.label2.configure(bg="white", text="OUTPUT", font="Helvetica 18 bold", width=190)

		self.frameInferiore = Frame(self.framePrincipale)
		self.frameInferiore.place(relx=0.081, rely=0.778, relheight=0.167, relwidth=0.835)
		self.frameInferiore.configure(bg="white", width=565)

		self.frameInferioreSinistro1 = Frame(self.frameInferiore)
		self.frameInferioreSinistro1.configure(bg="white")
		self.frameInferioreSinistro1.pack(side="left", ipadx="5m")
		self.cfgButton = Button(self.frameInferioreSinistro1)
		self.cfgButton.configure(text="*", font="Helvetica 10 bold", width=3, command=self.configWin, pady="1m")
		self.cfgButton.pack(side="left")

		self.frameInferioreSinistro2 = Frame(self.frameInferiore)
		self.frameInferioreSinistro2.configure(bg="white")
		self.frameInferioreSinistro2.pack(side="left", ipadx="5m")
		self.bckButton = Button(self.frameInferioreSinistro2)
		self.bckButton.configure(text="BACKUP", font="Helvetica 10 bold", width=9, pady="1m", command=self.funzioneBackup)
		self.bckButton.pack(side="left")

		self.frameInferioreSinistro3 = Frame(self.frameInferiore)
		self.frameInferioreSinistro3.configure(bg="white")
		self.frameInferioreSinistro3.pack(side="left", ipadx="5m")
		self.rfshButton = Button(self.frameInferioreSinistro3)
		self.rfshButton.configure(text="REFRESH", font="Helvetica 10 bold", width=9, pady="1m", command=self.funzioneRefresh)
		self.rfshButton.pack(side="left")

		self.frameInferioreSinistro4 = Frame(self.frameInferiore)
		self.frameInferioreSinistro4.configure(bg="white")
		self.frameInferioreSinistro4.pack(side="left", ipadx="5m")
		self.goButton = Button(self.frameInferioreSinistro4)
		self.goButton.configure(text="GO", font="Helvetica 10 bold", width=9, pady="1m", command=self.funzioneGo)
		self.goButton.pack(side="left")

		self.frameInferioreSinistro5 = Frame(self.frameInferiore)
		self.frameInferioreSinistro5.configure(bg="white")
		self.frameInferioreSinistro5.pack(side="left", ipadx="5m")
		self.exButton = Button(self.frameInferioreSinistro5)
		self.exButton.configure(text="EXIT", font="Helvetica 10 bold", width=9, pady="1m", command=self.funzioneExit)
		self.exButton.pack(side="left")

	def dbg(self, txt):
		if (self.debugFlag == True):
			print "[DBG-WIN]: " + txt
