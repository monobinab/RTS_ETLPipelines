#!/usr/bin/env python
#this script create requests
import sys
from datetime import date, timedelta, datetime
import re

#input_file = 'error_ex.txt'
#fhand = open(input_file)

# input comes from STDIN (standard input)
for line in sys.stdin:
#for line in fhand:
	try:
		date_Str = ""
		error_message = ""
		member_id = ""
		client = ""
		last_field = ""
		if line is not None and "errorCode" in line:
			fields = line.split("|")
				date_Str_1 = fields[0].rstrip(": api: response")
				#date_Str = re.sub('^[0-9a-z]*.', '', date_Str_1).lstrip("PERSIST: ").rstrip()
				date_Str_2 = date_Str_1.lstrip("PERSIST: ").rstrip()
				current_format = "%a %b %d %H:%M:%S %Z %Y"
                        	dateStr = datetime.strptime(date_Str_2, current_format)
				error_message = fields[1].strip()
				member_id = fields[2].strip()
				client = fields[3].strip()
				last_field = fields[4].strip()	
				outputline = str(date_Str) + "|" + str(error_message) + "|" + str(member_id) + "|" + str(client) + "|" + str(last_field)
		else:
			continue;
		print('%s' % (outputline))
	except:
		#do noting
		#sys.stderr.write('%s' % ("error:"+line))
		#raise
		continue;
