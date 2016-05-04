#! /bin/bash
cd /home/auto/msaha/rts/api/final/audit
sql_dir=/home/auto/msaha/rts/api/final/audit
sql_file=get_count_by_client.sql
yesterday=$(date '+%-d' -d "1 day ago")

current_month=`date +%-m`
current_year=`date +%Y`

fexp<<EOF 
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

.logtable shc_work_tbls.teradata_response_cnt_log;

.SYSTEM 'rm -f /staging/teradata_response_cnt.csv';

.begin export sessions 1;

.EXPORT MODE RECORD FORMAT TEXT OUTFILE /staging/teradata_response_cnt.csv;

select
trim(coalesce(min(a.hr),0))
||','||trim(coalesce(max(a.hr),0)) 
||','||trim(coalesce(count(distinct(a.hr)),0)) 
||','||trim(coalesce(sum(members_cnt),0)) 
from
(
select
extract (hour from (run_date)) as hr,
count(memberid) members_cnt ,
client client
from L2_MRKTGANLYS_T.rts_api_response
where
cast(run_date as char(10)) = (current_date - 1)
and modelrank = 1
group by extract (hour from (run_date)), client
) a
;

.END EXPORT;
.SYSTEM 'cut -b3- /staging/teradata_response_cnt.csv > /staging/teradata_response_cnt_`date +%m"_"%d"_"%Y`.csv';
.LOGOFF;
EOF
