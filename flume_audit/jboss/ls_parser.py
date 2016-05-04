#!/usr/bin/python
file1="/appl/rts/flume_audit/jboss/incoming_jboss_files_snapshot_old.txt"
file1_handle=open(file1).readlines()
firstline=file1_handle.pop(0)

for line in file1_handle:
        fields = line.split(' ')

        file_permission = fields[0].strip()
        number_of_links = fields[4].strip()
        owner_name = fields[5].strip()
        owner_group = fields[6].strip()
        filesize = fields[7].strip()
        create_date = fields[8].strip()
        create_time = fields[9].strip()
        filename = fields[10].strip()
        output_line = str(file_permission) + "|" + str(number_of_links) + "|" + str(owner_name) + "|" + str(owner_group) + "|"+ str(filesize) + "|" + str(create_date) + "|" + str(create_time) + "|" + str(filename)
        print output_line

