use real_time_scoring;
select
count(*),
month,
day
from (select distinct(memberid), mdtag, month, day from api_response_log
where month=11 and client like '%TI%') a
group by month, day
;

