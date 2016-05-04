#!/usr/bin/python
import sys
import smtplib
from /appl/rts/scripts/checkcount import *

sender = 'monobina.saha@searshc.com'
# receivers = ['monobina.saha@searshc.com', 'rtsteam@searshc.com']
receivers = ['monobina.saha@searshc.com']
message = ""

input_file='/staging/occasions_cnt/000000_0'
# input_file = '/Users/msaha/PycharmProjects/data/good_sample.txt'
# input_file = '/Users/msaha/PycharmProjects/data/bad_sample.txt'
input_file_handle = open(input_file, 'r')

hrs = 0
member_cnt = ""


for line in input_file_handle:
    if line is not None:
        fields = line.split(",")
        hrs = fields[2]
        member_cnt = fields[3]


        try:
            hrs = int(hrs.strip())
            member_cnt = int(member_cnt.strip())
        except:
            print("not integer value")
            continue


if is_valid(member_cnt, hrs):
    print("Success!!!")
else:
    print("Failure! sending email")
    # send failure email
    message = """Subject: There may be a problem with yesterday's RTS_STORM_LOG hive table load\n
    This is to notify that count is below normal:
    Number of distinct hours is """ + str(hrs) + " number of members loaded is " + str(member_cnt)
    try:
        smtpObj = smtplib.SMTP('smtp2010.searshc.com', 25)
        smtpObj.sendmail(sender, receivers, message)
        print("Successfully sent email")
    except:
        print("Error: unable to send email")
