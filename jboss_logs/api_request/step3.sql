use real_time_scoring;

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

--ALTER TABLE api_request_log DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}', day = '${hiveconf:current_day}');
--ALTER TABLE api_request_log DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}', day = '${hiveconf:yesterday}');

insert into table api_request_log
partition(Year, Month, Day)   
select
    trim(t.run_date),
    trim(t.request_type) as request_type,
    trim(t.api_url) as api_url,
    trim(t.tags) as tags,
    trim(t.session_id) as session_id, 
    trim(t.request_level) as request_level, 
    trim(t.lyl_id_no) as lyl_id_no,
    trim(t.client),
    '${hiveconf:load_date}',
    year(to_date(t.run_date)) as year,
    month(to_date(t.run_date)) as month,
    day(to_date(t.run_date)) as day
from api_request_log_staging t
--where
--unix_timestamp(run_date, 'yyyy-MM-dd') >= unix_timestamp(from_unixtime(unix_timestamp() -1*60*60*24, 'yyyy-MM-dd'), 'yyyy-MM-dd')
--and unix_timestamp(run_date) < unix_timestamp(from_unixtime(unix_timestamp(), 'yyyy-MM-dd'), 'yyyy-MM-dd')
;

