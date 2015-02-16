#!/usr/bin/python

#import os.path
from sys import argv
#import re

# Get arguments function
def get_arg(index):
	if len(argv) > index :
		return argv[index]
	else:
		return False

CFG_FILE=get_arg(1)

REPORT_FILE='/tmp/no_pd_report.csv'

#clear the final report file, this is the main file
open(REPORT_FILE, 'w').close()

CFG=open(CFG_FILE,'r')

alert=[]
for line in CFG:
	if line.find('}') ==0:
		print "****************** END OF ALERT *******************"
	alert.append(line)	
	
#print test
#if 'define' in alert:
#	print "this alert contains"
#print alert[0]