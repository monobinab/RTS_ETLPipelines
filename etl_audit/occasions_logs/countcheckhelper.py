import sys

def checkcount(member_cnt, hrs):
	if  member_cnt < 1000 or hrs < 24:
            goodResultFound = False;
            print("will send email because count is less than expected")
	    return False;
        else:
            goodResultFound = goodResultFound and True
	    return True;
