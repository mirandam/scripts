#!/usr/bin/python

#import os.path
from sys import argv
from sys import exit
#import re

if len(argv) == 1:
	print "No .cfg file passed as argument"
	exit(0)


CFG_FILE=argv[1]

REPORT_FILE='/tmp/hosts_nagios_report'

#clear the final report file, this is the main file
open(REPORT_FILE, 'w').close()

CFG=open(CFG_FILE,'r')

PATTERN="host_name"

#alert=[]

for line in CFG:
	if PATTERN in line:
		tempHost=line.replace(PATTERN,'').replace(' ','').replace('\n','').replace('\t','').replace('\r','')
		#alert.append(tempHost)
		if tempHost[0]!='#':			
			f_report = open(REPORT_FILE,'a')
			f_report.write(tempHost + ",") 
f_report.close()
msg = "List of hosts file is: " + REPORT_FILE + "\nDo you want to open it? (y or n): "
opt = raw_input(msg)
if opt == 'y':
	print open(REPORT_FILE,'r').read()
#print alert
#print alert[0]
