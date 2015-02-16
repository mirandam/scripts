#!/usr/bin/python

from os import system


system("nslookup manueltest | grep Name | cut -d: -f2 | sed -e 's/[ \t]*//'")