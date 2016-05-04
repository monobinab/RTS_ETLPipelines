use real_time_scoring;
drop table rts_msmmodels;
create table rts_msmmodels (
modelid int,
modelname varchar(50)
)
row format delimited
fields terminated by ','
lines terminated by '\n'
stored as textfile
tblproperties("skip.header.line.count"="1");


load data local inpath '/staging/modelname_modelid_mapping.csv' into table rts_msmmodels;
