.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

drop table shc_work_tbls.responsys_eml_sent_last_wk;
create table shc_work_tbls.responsys_eml_sent_last_wk as (
select 
memberid,
eml_ad_id,  
eml_cnt_cd, 
eml_cnt_dt, 
eml_cnt_ts,
c.day_of_week, 
run_date, 
client, 
modelName,
modelrank, 
post_campaign,  
cpg_id
from 
(select * from lci_dw_views.eml_rsp_cpg_comm 
where eml_cnt_dt > (current_date -7) 
and eml_cnt_cd = 'S' and cpg_id = 2003156
) a
join  
(select * from L2_MRKTGANLYS_T.rts_api_response  where  modelrank = 1 and client like '%TI_BATCH%') b 
on a.lyl_id_no = b.memberid and cast(run_date as date format 'YYYY-MM-DD') > eml_cnt_dt -7 
join 
sys_calendar.calendar c on a.eml_cnt_dt = c.calendar_date
where 
c.day_of_week = 3 --for Tuesday as RTS sends email only on Tuesdays
)
with data
primary index(eml_ad_id, eml_cnt_dt, memberid ,run_date ,modelName ,modelRank)
;

drop table shc_work_tbls.responsys_eml_open_last_wk;
create table shc_work_tbls.responsys_eml_open_last_wk as (
select
b.memberid,
b.eml_ad_id,
a.eml_cnt_cd,
a.eml_cnt_dt,
a.eml_cnt_ts,
modelName,
modelrank,
a.post_campaign,
a.cpg_id
from
(select * from lci_dw_views.eml_rsp_cpg_comm
where eml_cnt_dt > (current_date -7) 
and eml_cnt_cd = 'O' and cpg_id = 2003156
) a
join
shc_work_tbls.responsys_eml_sent_last_wk b on a.lyl_id_no = b.memberid and a.eml_ad_id = b.eml_ad_id and a.post_campaign=b.post_campaign
)
with data
primary index(eml_ad_id, eml_cnt_dt,  memberid ,modelName ,modelRank)
;

create table shc_work_tbls.email_send_open_history as (
select a.memberid, a.eml_ad_id, a.eml_cnt_dt as eml_sent_dt, a.eml_cnt_ts as eml_sent_ts, b.eml_cnt_dt as eml_opened_dt, b.eml_cnt_ts as eml_opened_ts, a.eml_cnt_cd as eml_sent, b.eml_cnt_cd as eml_opened
FROM  shc_work_tbls.responsys_eml_sent_last_wk a
join shc_work_tbls.responsys_eml_open_last_wk b on a.memberid = b.memberid and a.eml_ad_id = b.eml_ad_id and a.post_campaign = b.post_campaign
)
with data
primary index(memberid, eml_ad_id, eml_sent_dt, eml_opened_dt)
;

create table shc_work_tbls.email_send_rate as (
select
count(*)  as sent_cnt,
eml_sent_dt,
eml_sent
from
shc_work_tbls.email_send_open_history
group by eml_sent_dt, eml_sent
)
with data
primary index (eml_sent_dt, eml_sent);

create table shc_work_tbls.email_open_rate as (
select
count(*) as opened_cnt,
eml_opened_dt,
eml_opened
from
shc_work_tbls.email_send_open_history
group by eml_opened_dt, eml_opened
)
with data
primary index (eml_opened_dt, eml_opened);
