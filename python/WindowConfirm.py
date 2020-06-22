from Interface import Interface
from pydispatch import dispatcher
from Tkinter import *

class WindowConfirm(Toplevel):
	def __init__(self):
		Toplevel.__init__(self)
		self.build()
		self.retval = None

	def hide(self):
		self.withdraw()

	def getValue(self):
		return self.retval

	def commit(self):
		self.retval = True
		self.quit()

	def rollback(self):
		self.retval = False
		self.quit()

	def build(self):
		self.geometry("313x146+650+199")
		self.title(" ")
		self.configure(background="#d9d9d9")
		self.resizable(0, 0)

		self.frameSup = Frame(self)
		self.frameSup.pack()

		self.label1 = Label(self.frameSup)
		self.label1.configure(background="#d9d9d9", text="Sei sicuro?")
		self.label1.pack(ipady=32)

		self.frameInf = Frame(self)
		self.frameInf.configure(background="#d9d9d9")
		self.frameInf.pack(ipadx="3m")

		self.Button1 = Button(self.frameInf, command=self.commit)
		self.Button1.configure(background="#d9d9d9", text="CONFERMA", width=10)
		self.Button1.pack(side="left")

		self.Button2 = Button(self.frameInf, command=self.rollback)
		self.Button2.configure(background="#d9d9d9", text="ANNULLA", width=10)
		self.Button2.pack(side="right")
