import sys
import smtplib

sender = 'monobina.saha@searshc.com'
receivers = ['monobina.saha@searshc.com', 'rtsteam@searshc.com']
message = ""

input_file='/staging/teradata_response_cnt_02_25_2016.csv'
# input_file = '/Users/msaha/PycharmProjects/data/good_sample.txt'
# input_file = '/Users/msaha/PycharmProjects/data/bad_sample.txt'
input_file_handle = open(input_file, 'r')

minhour = ""
hrs = 0
maxhour = ""
member_cnt = ""
storm_count_list = []

goodResultFound = True;

for line in input_file_handle:
    if line is not None:
        fields = line.split(",")
        minhour = fields[0]
        maxhour = fields[1]
        hrs = fields[2]
        member_cnt = fields[3]

        print(minhour + " " + maxhour + " " + hrs + " " + member_cnt);
        # Skip the line with garbage data
        # if minhour == "\\N":
        #    print("empty data")
        #    continue

        try:
            hrs = int(hrs.strip())
            member_cnt = int(member_cnt.strip())
        except:
            print("not integer value")
            goodResultFound = False
            continue

        if member_cnt < 1000000 and hrs < 24:
            goodResultFound = False;
            print("will send email because count is less than expected")
        else:
            goodResultFound = goodResultFound and True


if goodResultFound:
    print("Success!!!")
else:
    print("Failure! sending email")
    # send failure email
    message = """Subject: There may be a problem with yesterday's API_RESPONSE_LOG hive table load\n
    This is to notify that count is below normal:
    Number of distinct hours is """ + str(hrs) + " number of members loaded is " + str(member_cnt)
    try:
        smtpObj = smtplib.SMTP('smtp2010.searshc.com', 25)
        smtpObj.sendmail(sender, receivers, message)
        print("Successfully sent email")
    except:
        print("Error: unable to send email")
