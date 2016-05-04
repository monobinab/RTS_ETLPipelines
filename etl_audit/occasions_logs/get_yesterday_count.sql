use real_time_scoring;
insert overwrite local directory '/staging/occasions_cnt'
row format delimited
fields terminated by ',' 
select
min(a.hr) as min_hr,
max(a.hr) as max_hr,
count(distinct(a.hr)) as distinct_count_of_errors,
sum(members_cnt) as sum_members
from
(
select 
hour(run_date) as hr,
count(lid) members_cnt
from rts_email_contact_history
where
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day='${hiveconf:yesterday}'
group by hour(run_date)
order by hr
) a
;

