use real_time_scoring;
drop table rts_storm_log;
create table rts_storm_log (
head_date  string
,tail_date   string
,fdate_epoch            bigint
,encrypted_lyl_id_no    string
,modelid                string
,oldscore               decimal(10,10)
,newscore               decimal(10,10)
,minexpiry              string
,maxexpiry              string
,source                 string
,oldpercentile          string
,newpercentile          string
)
PARTITIONED BY (Year INT, Month INT, Day INT)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;
