import socket
import sys

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
print 'sock'
sock.bind(('192.168.1.6',2000))
print 'bind'

for i in range(0,10):
	data, addr = sock.recvfrom(1000)
	print data
	print addr

sock.close()

