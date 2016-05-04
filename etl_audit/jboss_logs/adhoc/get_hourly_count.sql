use real_time_scoring;
insert overwrite local directory "/staging/hourly_response_cnt_'${hiveconf:current_year}'_'${hiveconf:current_month}'_'${hiveconf:yesterday}'"
row format delimited
fields terminated by ','
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
