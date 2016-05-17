#! /bin/bash
log_dir=/logs/rts
log_file=tec_storewideemails_teradata_process.log
log_date=$(date '+%Y-%m-%d' -d "60 day ago")

bteq<<EOF >> $log_dir/$log_file 2>&1
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

.SET ERRORLEVEL 3807 SEVERITY 0;

delete from l2_mrktganlys_t.roc_TEC_storewide_top_RTS_rec where send_dt > date '${log_date}';

select max(send_dt), min(send_dt) from  l2_mrktganlys_t.roc_TEC_storewide_top_RTS_rec;

insert into l2_mrktganlys_t.roc_TEC_storewide_top_RTS_rec
select
LYL_ID_NO as lyl_id_no, 
SEND_DT as send_dt, 
SID_CODE as sid_code, 
modelId as modelid, 
model as model, 
current_timestamp(0) as load_ts, 
current_user as load_user 
from  shc_work_tbls.rts_TEC_storewide_top_rec;

select max(send_dt), min(send_dt) from  l2_mrktganlys_t.roc_TEC_storewide_top_RTS_rec;
EOF;

