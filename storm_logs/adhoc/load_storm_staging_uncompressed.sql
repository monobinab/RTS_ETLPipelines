SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

use real_time_scoring;
drop table rts_storm_log_staging;

create table if not exists rts_storm_log_staging (
head_date string,
tail_date string,
lid string,
modelId string,
oldScore string,
newScore string,
minExpiry string,
maxExpiry string,
source string,
old_percentile string,
new_percentile string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;

LOAD DATA local INPATH '/staging/msaha/storm_1122.txt.lzo' INTO TABLE real_time_scoring.rts_storm_log_staging;
--load data inpath '/tmp/adhoc_storm_2/part*' into table real_time_scoring.rts_storm_log_staging;
