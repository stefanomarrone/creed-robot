import DetectionParameters
from AbstractFactory import AbstractFactory

class DPFactory(AbstractFactory):
    
    def generate(self,kind=""):
		td = self.getSection('Detection')
		retval = DetectionParameters.DetectionParameters()
		cx = float(td['canvas_x'])
		cy = float(td['canvas_y'])
		cw = float(td['canvas_w'])
		ch = float(td['canvas_h'])
		ca = float(td['canvas_a'])
		retval.canvas = ((cx,cy),(cw,ch),ca)
		ocx = float(td['optical_centre_x'])
		ocy = float(td['optical_centre_y'])
		retval.optical_centre = (ocx,ocy)
		r = int(td['highlight_red'])
		g = int(td['highlight_green'])
		b = int(td['highlight_blue'])
		retval.highlight = (r,g,b)
		bl = int(td['black'])
		retval.black = [bl,bl,bl]
		retval.polyThresh = float(td['polythresh'])
		retval.minarea = float(td['minarea'])
		retval.maxarea = float(td['maxarea'])
		retval.maxblackratio = float(td['maxblackratio'])
		retval.samplingDimension = int(td['samplingdimension'])
		retval.canvas_threshold = float(td['canvas_threshold'])
		retval.insider_threshold = float(td['insider_threshold'])
		return retval
