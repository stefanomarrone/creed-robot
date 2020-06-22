'''
VisionFactory: class containing the concrete factory for the vision
@author: Stefano Marrone
'''

import Vision
from AbstractFactory import AbstractFactory

class VisionFactory(AbstractFactory):
    
    def generate(self,kind=""):
		td = self.getSection('Vision')
		xr = float(td['x_ref'])
		yr = float(td['y_ref'])
		zr = float(td['z_ref'])
		h = td['header']
		t = td['trailer']
		p = td['path']
		rot_val = td['rotation'] == 'True'
		debug_val = td['debug'] == 'True'
		livedebug_val = td['live'] == 'True'
		origin = (xr,yr,zr)
		retval = Vision.Vision(origin,h,t,p,rot_val,debug_val,livedebug_val)
		td = self.getSection('Detection')
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
		return retval

