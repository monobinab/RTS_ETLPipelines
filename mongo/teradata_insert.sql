LOGON TDAdhoc.intra.searshc.com/msaha,n745tzjax2;
INSERT INTO L2_MRKTGANLYS_T.roc_RTS_OccasionResponses
(
lyl_id_no,
l_id,
eml_ad_id,
tag,
send_dt,
load_ts,
topology
)
select
x.lyl_id_no,
a.encrypted_lid as l_id,
cast(a.eid as int) as eml_ad_id,
a.tag,
cast(SUBSTR(a.record_ts, 1, 10) as date) as send_dt,
current_timestamp(0) as load_ts,
a.topology
from
shc_work_tbls.occasionResponses_daily a
left outer join L2_MRKTGANLYS_T.roc_RTS_l_id_xref AS x
ON a.encrypted_lid=x.l_id
WHERE a.encrypted_lid<>'l_id'
;

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

collect statistics on L2_MRKTGANLYS_T.roc_RTS_OccasionResponses index (l_id, load_ts);

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

collect statistics on L2_MRKTGANLYS_T.roc_RTS_OccasionResponses index (lyl_id_no);

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

.quit 0
