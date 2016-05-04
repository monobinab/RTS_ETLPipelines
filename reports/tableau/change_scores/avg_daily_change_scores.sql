use real_time_scoring;
SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

drop table rts_avg_scores;
create table rts_avg_scores (
modelname string,
run_date varchar(10),
avg_oldscore string,
avg_newscore string,
avg_oldpercentile string,
avg_newpercentile string
)
row format delimited
fields terminated by ','
lines terminated by '\n'
stored as  textfile
;

insert into table rts_avg_scores 
select
b.modelname,
cast(head_date as char(10)) as run_date,
avg(a.oldscore) as avg_oldscore,
avg(a.newscore) as avg_newscore,
avg(a.oldpercentile) as avg_oldpercentile,
avg(a.newpercentile) as avg_newpercentile
from
rts_storm_log a 
left outer join rts_msmmodels b on a.modelid = b.modelid
where year='${hiveconf:current_year}' 
and month='${hiveconf:current_month}' 
--and day >='${hiveconf:last_day}'
and (a.oldscore is not null and a.newscore is not null)
and cast(head_date as char(10)) is not null
group by
modelname, cast(head_date as char(10))
;

drop table rts_avg_change_in_scores;
create table rts_avg_change_in_scores (
modelname string,
run_date varchar(10),
--avg_oldscore string,
--avg_newscore string,
--avg_oldpercentile string,
--avg_newpercentile string,
change_from_oldscore decimal(10,3),
change_from_oldpercentile decimal(10,3)
)
row format delimited
fields terminated by ','
lines terminated by '\n'
STORED AS textfile
;

insert into table rts_avg_change_in_scores 
select
modelname,
run_date,
--avg_oldscore,
--avg_newscore,
--avg_oldpercentile,
--avg_newpercentile,
avg(cast((avg_newscore - avg_oldscore) as decimal (10,3))) as change_from_oldscore,
avg(cast((avg_newpercentile - avg_oldpercentile) as decimal(10,3))) as change_from_oldpercentile
from
rts_avg_scores a 
where length(run_date)=10
group by run_date, modelname
;

