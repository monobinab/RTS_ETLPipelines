use real_time_scoring;

drop table api_response_log_tec_staging;
create table api_response_log_tec_staging (
memberid string,
run_date string,
modelid string,
modelname string,
client string
)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile
;

insert into table api_response_log_tec_staging
select
memberid,
run_date,
modelid,
modelname,
client
from
api_response_log
where
to_date(run_date) >= '${hiveconf:start_date}'
and rank = '1' 
and client in ('RTS_TEC','TEC_ON_OPEN','TEC_CACHE')
and (modelname is not null or modelid is not null)
;
