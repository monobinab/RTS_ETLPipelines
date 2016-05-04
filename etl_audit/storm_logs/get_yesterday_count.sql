use real_time_scoring;
insert overwrite local directory '/staging/storm_cnt'
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
hour(head_date) as hr,
count(encrypted_lyl_id_no) members_cnt
from rts_storm_log 
where
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day='${hiveconf:yesterday}'
group by hour(head_date)
order by hr
) a
;

