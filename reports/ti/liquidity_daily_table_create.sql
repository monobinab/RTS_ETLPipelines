use real_time_scoring;

set mapred.reduce.tasks=10;

drop table liquidity_report_daily;
create table liquidity_report_daily (
memberid string,
run_date string,
modelName string,
rank string,
percentile string,
client string,
time_taken string,
occasion string,
mdtag string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile
;


--insert overwrite local directory '/staging/rts/liquidity_report_daily'
--insert into table liquidity_report_daily
--row format delimited
--fields terminated by '|'
--lines terminated by '\n'
--select 
--memberid, 
--run_date, 
--modelName,
--rank, 
--percentile,
--client,
--time_taken,
--occasion,
--mdtag
--from 
--real_time_scoring.api_response_log
--where 
--year='${hiveconf:current_year}'
--and month='${hiveconf:current_month}'
--and day = '${hiveconf:yesterday}'
--and (upper(trim(client)) like '%TI%' or upper(trim(client)) like '%CPS%')
--;

insert into table liquidity_report_daily
select
memberid,
run_date,
modelName,
rank,
percentile,
client,
time_taken,
occasion,
mdtag
from
real_time_scoring.api_response_log
where
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day = '${hiveconf:yesterday}'
and ((upper(trim(client)) like '%CPS%' and mdtag is not null) or (upper(trim(client)) like '%TI%'))
;
