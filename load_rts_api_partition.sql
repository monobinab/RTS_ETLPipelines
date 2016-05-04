
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

use real_time_scoring;
ALTER TABLE rts_api_response_log DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '{hiveconf:current_month}');

insert into table real_time_scoring.rts_api_response_log
PARTITION(Year, Month)
select 
run_date,
api_response,
time_taken,
lyl_id_no,
client,
year(to_date(run_date)),
month(to_date(run_date))
from real_time_scoring.rts_api_response_log_staging;

drop table real_time_scoring.rts_api_response_log_flat;
create table real_time_scoring.rts_api_response_log_flat as
select a.run_date, a.status, a.statusCode, a.memberId, a.lastUpdated, a.time_taken, a.lyl_id_no, a.client, b.*
from (
    select 
        run_date, 
        get_json_object(api_response, '$.status') as status, 
        get_json_object(api_response, '$.statusCode') as statusCode,
        get_json_object(api_response, '$.memberId') as memberId,
        get_json_object(api_response, '$.lastUpdated') as lastUpdated, 
        time_taken, 
        lyl_id_no, 
        client,
        regexp_replace(regexp_replace(get_json_object(api_response, '$.scoresInfo'), '\\\},\\\{', '\\\}\\\|\\\{'), '^\\\[|\\\]$', '') as scoresInfo
    from real_time_scoring.rts_api_response_log
) a
lateral view explode(split(a.scoresInfo, '\\\|')) b as scoresInfo
;

