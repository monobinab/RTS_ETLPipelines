use real_time_scoring;
drop table if exists rts_flume_jboss_filetracker_newstatus

create table rts_flume_jboss_filetracker_newstatus (
file_permission string,
number_of_links string,
owner_name string,
owner_group string,
filesize string,
create_date string,
create_time string,
filename string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfiles
;

LOAD DATA INPATH '${hiveconf:input_directory}/part-*' INTO TABLE rts_flume_jboss_filetracker_newstatus;
