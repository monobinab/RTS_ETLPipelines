#!/usr/bin/env python
# this script parses storm log files and creates pipe delilited occasions log files
import sys
from datetime import date, timedelta, datetime
# from dateutil import parser

# input comes from STDIN (standard input)
for line in sys.stdin:
    if line is not None and "OccasionResponses" in line:
         headDate = ""
         persistDate = ""
         topology = ""
         lid = ""
         eid = ""
         custEvent = ""
         successFlag = ""
         tag = ""
         purchaseOccasion = ""
         businessUnit = ""
         SubBusinessUnit = ""

         fields = line.split("|")
         for field in fields:
               try:
                    if "OccasionResponsesDao" in field:
                        # head part
                        strTokens = field.split("OccasionResponsesDao")
                        if len(strTokens) < 2:
                            # sys.stderr.write("Error in:" + line)
                            headDate = ""
                            persistDateStr = strTokens[0]
                            persistDate = persistDateStr.lstrip("[INFO] PERSIST: ").strip()
                        else:
                            headDateStr = strTokens[0]
                            headDate = headDateStr.rstrip("a.u.d").strip()
                            persistDateStr = strTokens[1]
                            persistDate = persistDateStr.lstrip("[INFO] PERSIST: ").strip()


                    elif "Topology" in field:
                           subFields = field.split(":")
                           topology =  subFields[1].strip()
                    elif "lid" in field:
                           subFields = field.split(":")
                           lid = subFields[1].strip()
                    elif "eid" in field:
                           subFields = field.split(":")
                           eid = subFields[1].strip()
                    elif "custEvent" in field:
                           subFields = field.split(":")
                           custEvent = subFields[1].strip()
                    elif "successFlag" in field:
                           subFields = field.split(":")
                           successFlag = subFields[1].strip()
                    elif "tag" in field:
                           subFields = field.split(":")
                           tag = subFields[1].strip()
                    elif "purchaseOccasion" in field:
                           subFields = field.split(":")
                           purchaseOccasion = subFields[1].strip()
                    elif "businessUnit" in field:
                          subFields = field.split(":")
                          businessUnit = subFields[1].strip()
                    elif "SubBusinessUnit" in field:
                          subFields = field.split(":")
                          SubBusinessUnit = subFields[1].strip()
               except:
                    #do nothing
                    continue;
                    #raise;
                    #print('%s' % ("error:"+line))
         outputline = headDate + "|" + persistDate + "|" + topology + "|" + lid + "|" + eid + "|" + custEvent + "|" + successFlag + "|" + tag + "|" + purchaseOccasion + "|" + businessUnit + "|" + SubBusinessUnit
         print('%s' % (outputline))
