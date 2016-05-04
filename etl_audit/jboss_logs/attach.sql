use real_time_scoring;
insert overwrite local directory '/staging/api_response_cnt'
row format delimited
fields terminated by '|'
select
hour(run_date) as hr,
count(memberid) members_cnt ,
avg(cast(time_taken as int)) avg_time_taken,
client
from api_response_log
where
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day='${hiveconf:yesterday}'
and rank='1'
group by hour(run_date), client
order by hr, client
;
