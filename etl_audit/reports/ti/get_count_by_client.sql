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
extract (hour from (run_date)) as hr,
count(memberid) members_cnt ,
client
from L2_MRKTGANLYS_T.rts_api_response
where
cast(run_date as char(10)) = (current_date - 1)
and modelrank = 1
group by extract (hour from (run_date)), client
order by hr, client
) a
;

