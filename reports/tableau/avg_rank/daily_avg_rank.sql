use real_time_scoring;
drop table api_avg_model_rank_daily;

set mapred.reduce.tasks=4;

create table if not exists api_avg_model_rank_daily (
modelname string,
year int,
month int,
day int,
daily_avg_rank decimal (10,3)
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile
;

insert into table api_avg_model_rank_daily
select 
modelname,
year,
month,
day,
avg(cast(rank as int)) as daily_avg_rank
from
api_response_log
where 
year = '${hiveconf:current_year}'
and month = '${hiveconf:current_month}'
group by
modelname, year, month, day
;
