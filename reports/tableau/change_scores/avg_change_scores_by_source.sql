use real_time_scoring;
SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

drop table rts_avg_scores_by_source;
create table rts_avg_scores_by_source (
modelname string,
source string,
avg_oldscore decimal(10,3),
avg_newscore decimal(10, 3),
avg_oldpercentile decimal(10, 3),
avg_newpercentile decimal(10, 3)
)
row format delimited
fields terminated by ','
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;

insert into table rts_avg_scores_by_source 
select
b.modelname,
a.source,
avg(a.oldscore) as avg_oldscore,
avg(a.newscore) as avg_newscore,
avg(a.oldpercentile) as avg_oldpercentile,
avg(a.newpercentile) as avg_newpercentile
from
rts_storm_log a 
left outer join rts_msmmodels b on a.modelid = b.modelid
where year='${hiveconf:current_year}' 
and month='${hiveconf:current_month}' 
and (a.oldscore is not null and a.newscore is not null)
group by
modelname,source
;

drop table rts_avg_change_in_scores_by_source;
create table rts_avg_change_in_scores_by_source (
modelname string,
source string,
--avg_oldscore decimal(10,3),
--avg_newscore decimal(10, 3),
--avg_oldpercentile decimal(10, 3),
--avg_newpercentile decimal(10, 3),
change_from_oldscore decimal(10,3),
change_from_oldpercentile decimal(10,3)
)
row format delimited
fields terminated by ','
lines terminated by '\n'
STORED AS INPUTFORMAT  "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
;

insert into table rts_avg_change_in_scores_by_source 
select
modelname,
source,
--avg_oldscore,
--avg_newscore,
--avg_oldpercentile,
--avg_newpercentile,
(-(avg_oldscore - avg_newscore))/avg_oldscore as change_from_oldscore,
(-(avg_oldpercentile - avg_newpercentile))/avg_oldpercentile as change_from_oldpercentile
from
rts_avg_scores_by_source a 
;

