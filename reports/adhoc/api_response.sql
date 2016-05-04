use real_time_scoring;
select
count(*),
month,
day
from (select distinct(memberid), mdtag, month, day from api_response_log
where month=11) a
where mdtag is not null
group by month, day
;

