use real_time_scoring;
drop table rts_liquidity_daily_tec;
create table rts_liquidity_daily_tec
(
memberid string,
run_date string,
modelName string,
rank string,
percentile string,
client string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile
;

insert into table rts_liquidity_daily_tec 
select 
memberid, 
run_date, 
modelName,
rank, 
percentile,
client
from 
real_time_scoring.api_response_log
where 
--unix_timestamp(run_date, 'yyyy-MM-dd') >= unix_timestamp(from_unixtime(unix_timestamp() -1*60*60*24, 'yyyy-MM-dd'), 'yyyy-MM-dd')
--and unix_timestamp(run_date) < unix_timestamp(from_unixtime(unix_timestamp(), 'yyyy-MM-dd'), 'yyyy-MM-dd')
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day = '${hiveconf:yesterday}'
and upper(trim(client)) like '%TEC%'
--group by 1,2,3,4
--and unix_timestamp(run_date) >= unix_timestamp(from_unixtime(unix_timestamp() -8*60*60*24, 'yyyy-MM-dd'), 'yyyy-MM-dd')
--and unix_timestamp(run_date) < unix_timestamp(from_unixtime(unix_timestamp() -1*60*60*24, 'yyyy-MM-dd'), 'yyyy-MM-dd')
--order by 1,2,3
;
