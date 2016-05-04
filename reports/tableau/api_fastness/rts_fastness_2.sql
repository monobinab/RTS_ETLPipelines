use real_time_scoring;
drop table api_calls_cnt_lastmonth;
create table api_calls_cnt_lastmonth as
select
count(*) as api_calls_cnt,
to_date(run_date) as run_date
from
api_response_log
where 
year = '${hiveconf:start_year}'
and month = '${hiveconf:start_month}'
--and day between '${hiveconf:start_day}' and '${hiveconf:end_day}'
and (client like '%TI_POS%' or client like '%TI_KPOS%')
and rank = 1
group by to_date(run_date)
;

drop table api_calls_cnt_currentmonth;
create table api_calls_cnt_currentmonth as
select
count(*) as api_calls_cnt,
to_date(run_date) as run_date
from
api_response_log
where
year = '${hiveconf:end_year}'
and month = '${hiveconf:end_month}'
and (client like '%TI_POS%' or client like '%TI_KPOS%')
and rank = 1
group by to_date(run_date)
;


drop table api_calls_cnt;
create table api_calls_cnt as
select
api_calls_cnt,
run_date
from
api_calls_cnt_currentmonth
union all
select
api_calls_cnt,
run_date
from
api_calls_cnt_lastmonth
;


drop table api_calls_fastness_percentage;
create table api_calls_fastness_percentage as
select 
100*(intransaction_cnt/api_calls_cnt) as percentage_intransaction_cnt,
a.run_date
from
api_calls_cnt a
left outer join api_calls_scores b on a.run_date=b.run_date
;

