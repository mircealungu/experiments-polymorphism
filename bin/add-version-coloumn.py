#!/usr/bin/python

import sys
import fileinput
import re

d = {}
d ['ant-1.1_famix21'] = '1'
d ['ant-1.2_famix21'] = '2'
d ['ant-1.3_famix21'] = '3'

file = open(sys.argv[1])
for line in file:
	p = re.compile('([^,]*)')
	m = p.match(line)
	line = line [:-1] + ','+ d[m.group(1)]
	print line
