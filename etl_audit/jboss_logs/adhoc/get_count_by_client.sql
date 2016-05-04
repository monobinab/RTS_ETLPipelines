use real_time_scoring;
insert overwrite local directory '/staging/response_cnt'
row format delimited
fields terminated by ',' 
select
coalesce(min(a.hr),0) as min_hr,
coalesce(max(a.hr),0) as max_hr,
coalesce(count(distinct(a.hr)),0) as distinct_count_of_hours,
coalesce(sum(members_cnt),0) as sum_members
from
(
select 
hour(run_date) as hr,
count(memberid) members_cnt ,
avg(cast(time_taken as int)) avg_time_taken, 
client 
from api_response_log 
where
--year='${hiveconf:current_year}'
year=2016
--and month='${hiveconf:current_month}'
and month=2
--and day='${hiveconf:yesterday}'
and day=19
and rank='1'
group by hour(run_date), client
order by hr, client
) a
;

