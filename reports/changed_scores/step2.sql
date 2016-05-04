use real_time_scoring;
set mapred.reduce.tasks=10;
--drop table storm_serve_count;

--create table storm_serve_count
--(
--fdate string,
--source string,
--client,
--chg_cnt
--)
--row format delimited
--fields terminated by '|'
--lines terminated by '\n'
--stored as textfile
--;


insert into table storm_serve_count
select
to_date(fdate) as fdate,
source,
client,
count(*) as chg_cnt
from
api_served_with_changed_score
group by to_date(fdate), source, client;
