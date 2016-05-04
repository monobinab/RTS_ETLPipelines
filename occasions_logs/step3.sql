use real_time_scoring;

--SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;

--ALTER TABLE rts_email_contact_history DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}', day = '${hiveconf:current_day}');
--ALTER TABLE rts_email_contact_history DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}', day = '${hiveconf:yesterday}');

insert into table rts_email_contact_history
partition(Year, Month, Day)   
select
    t.run_date,
    t.persist_date,
    t.topology,
    t.lid,
    t.eid,
    t.cust_event,
    t.success_flag,
    t.occasion_tag,
    t.purchase_occasion,
    '${hiveconf:load_date}' as load_dt,
    t.businessUnit,
    t.subBusinessUnit,
    year(to_date(t.run_date)) as year,
    month(to_date(t.run_date)) as month,
    day(to_date(t.run_date)) as day
from rts_email_contact_history_staging t
;

