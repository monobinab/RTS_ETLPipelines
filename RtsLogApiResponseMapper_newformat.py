#!/usr/bin/env python
#this script create requests
import sys
import datetime
#from os.path import basename
#import csv

#responsefile_new = open('testresponse.txt', 'w')
#responsefile_old = open('oldresponse.txt', 'w')

# input comes from STDIN (standard input)
for line in sys.stdin:
	if "|" not in line:
		#responsefile_old.write(line);
		#sys.stderr.write("File in old format:");
        	continue;

	else:
		if  'api: response | {"status":"success"' in line:
			strTokens = line.split(": api: response ");
			dateStr = strTokens[0];
			if dateStr is not None:
				dateStr_1 = dateStr.lstrip("PERSIST:").strip();
				current_format = "%a %b %d %H:%M:%S %Z %Y"
				dateStr_2 = datetime.datetime.strptime(dateStr_1, current_format) 
				dateStr_3 = str(dateStr_2)
				#final_format = "%Y-%m-%d %H:%M:%S"
				#dateStr_3 = datetime.datetime.strptime(dateStr_2, final_format)			
			
			apiStr = strTokens[1];
					
			line = dateStr_3.strip() + apiStr.strip()
			#newline_1 = dateStr_2.strip() + apiStr;
			#responsefile_new.write(line);
			print '%s' % (line);
