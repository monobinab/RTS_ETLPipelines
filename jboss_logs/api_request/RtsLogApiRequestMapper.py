#!/usr/bin/env python
#this script create requests
import sys
from datetime import date, timedelta, datetime

# input comes from STDIN (standard input)
for line in sys.stdin:
   try:
     header = ""
     persist_date = ""
     request_type = ""
     api_url = ""
     api_info = ""
     tags = ""
     session_id = ""
     level = ""
     lyl_id_no = ""
     client = ""
        #TODO: check for nulls

     if 'Incoming Request' in line:
            fields = line.split("|")
            #for field in fields:
            header = fields[0].strip()
            api_url = fields[1].strip()
            api_info = fields[2].strip()
            lyl_id_no = fields[3].strip()
            client = fields[4].strip()
            if header is not None:
               headerTokens = header.split(": api:")
               if len(headerTokens) < 2:
                  persist_date = ""
                  request_type = headerTokens[0].strip()
               else:
                  persist_date_1 = headerTokens[0].lstrip("PERSIST:")
                  persist_date_2 = persist_date_1.rstrip(":")
                  n = len(persist_date_2)
                  persist_date_3 = persist_date_2.strip()
                  
                  current_format = "%a %b %d %H:%M:%S %Z %Y"
                  persist_date = datetime.strptime(persist_date_3, current_format)
                  request_type = headerTokens[1].strip()
                  #request_type = request_type_1.lstrip(":").strip()
                  

            if api_info is not None:
                 subFields = api_info.split(",")
                 for subField in subFields:
                    if "tags" in subField:
                       sub_subFields = subField.split(":")
                       tags = sub_subFields[1].strip()
                    elif "sessionId" in subField:
                        sub_subFields = subField.split(":")
                        session_id = sub_subFields[1].strip()
                    elif "level" in subField:
                        sub_subFields = subField.split(":")
                        level = sub_subFields[1].strip()
            output_line = str(persist_date) + "|" + str(request_type) + "|" + str(api_url) + "|" + str(tags) + "|" + str(session_id) + "|" + str(level) + "|" + str(lyl_id_no) + "|" + str(client)
                    #requestFile.write(line)
            # write the results to STDOUT (standard output);
            print ('%s' % (output_line));
   except:
     continue;
     #raise;
     #print('%s' % ("error:"+ output_line))

