use real_time_scoring;
set mapred.reduce.tasks=113;


--drop table api_served_with_changed_score;
insert into table  api_served_with_changed_score
select 
a.api_date
,b.fdate
,a.client
,b.source
,a.encrypted_memberid
,a.modelid
,a.modelname
,a.score
,a.lastupdated
,a.rank
,b.minexpiry
,b.maxexpiry
,oldscore
,newscore
from 
(Select run_date as api_date, encrypted_memberid, modelid, modelname, rank, score, lastupdated, client 
from api_response_log 
where 
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day >='${hiveconf:last_day}' 
and day <'${hiveconf:current_day}'
) a 
inner join 
(select encrypted_lyl_id_no, to_date(minexpiry) as minexpiry, to_date(maxexpiry) as maxexpiry, from_unixtime(fdate_epoch, 'yyyy-MM-dd HH:mm:ss') as fdate, oldscore, newscore, modelid, source
from rts_storm_log 
where
year='${hiveconf:current_year}'
and month='${hiveconf:current_month}'
and day >='${hiveconf:storm_last_day}'
and day <'${hiveconf:last_day}'
) b
on a.encrypted_memberid = b.encrypted_lyl_id_no
and a.modelid=b.modelid
where
api_date >= b.fdate and api_date <= b.minexpiry
and b.oldscore <> b.newscore -- ensures change in score
; 

