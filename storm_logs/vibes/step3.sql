use real_time_scoring;

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;


insert into table rts_vibes_log
partition(Year, Month, Day)   
select
    t.head_date,
    t.persist_date,
    t.topology,
    t.encrypted_lyl_id_no,
    t.success_flag,
    '${hiveconf:load_date}',
    '${hiveconf:user_created}',
    year(to_date(head_date)) as year,
    month(to_date(head_date)) as month,
    day(to_date(head_date)) as day
from rts_vibes_log_staging t
;

