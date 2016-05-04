use real_time_scoring;
set mapred.reduce.tasks=113;

drop table api_calls_scores_lastmonth;
create table api_calls_scores_lastmonth as 
select
count(*) as intransaction_cnt,
to_date(run_date) as run_date
from 
api_response_log 
where 
year = '${hiveconf:start_year}'
and month = '${hiveconf:start_month}'
and (client like '%TI_POS%' or client like '%TI_KPOS%') 
and rank =1 
and (unix_timestamp(run_date) - unix_timestamp(lastupdated)) <= 3600 --checking for updated scores in last 3 hrs before api call is made 
group by to_date(run_date)
;

drop table api_calls_scores_currentmonth;
create table api_calls_scores_currentmonth as
select
count(*) as intransaction_cnt,
to_date(run_date) as run_date
from
api_response_log
where
year = '${hiveconf:end_year}'
and month = '${hiveconf:end_month}'
and (client like '%TI_POS%' or client like '%TI_KPOS%')
and rank =1
and (unix_timestamp(run_date) - unix_timestamp(lastupdated)) <= 3600 --checking for updated scores in last 3 hrs before api call is made
group by to_date(run_date)
;

drop table api_calls_scores;
create table api_calls_scores as
select
intransaction_cnt,
run_date
from
api_calls_scores_currentmonth
union all
select
intransaction_cnt,
run_date
from
api_calls_scores_lastmonth
;
