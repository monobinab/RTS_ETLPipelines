LOGON TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

--CREATE TABLE L2_MRKTGANLYS_T.RTS_membermdtags (
--      lyl_id_no DECIMAL(16,0),
--      l_id CHAR(28),
--      tag_nm varchar(50),
--      effective_dt date format 'YYYY-MM-DD',
--      expiry_dt date format  'YYYY-MM-DD',
--      load_ts timestamp(0)
--      )
--      primary index(l_id, tag_nm, effective_dt)
--;

--historical load
--INSERT INTO L2_MRKTGANLYS_T.RTS_membermdtags
--(
--lyl_id_no,
--l_id,
--tag_nm,
--effective_dt,
--expiry_dt,
--load_ts
--)
--select
--x.lyl_id_no,
--a.encrypted_lid as l_id,
--a.tag_nm,
--a.effective_dt,
--a.expiry_dt,
--current_timestamp(0) as load_ts
--from
--shc_work_tbls.mdtags_daily a
--left outer join L2_MRKTGANLYS_T.roc_RTS_l_id_xref AS x
--ON a.encrypted_lid=x.l_id
--;

--incremental load
INSERT INTO L2_MRKTGANLYS_T.RTS_membermdtags
(
lyl_id_no,
l_id,
tag_nm,
effective_dt,
expiry_dt,
load_ts
)
select
x.lyl_id_no,
a.encrypted_lid as l_id,
a.tag_nm,
a.effective_dt,
a.expiry_dt,
current_timestamp(0) as load_ts
from
shc_work_tbls.mdtags_daily a
left outer join L2_MRKTGANLYS_T.roc_RTS_l_id_xref AS x
ON a.encrypted_lid=x.l_id
WHERE 
a.encrypted_lid<>'l_id'
and a.tag_nm<>'tag_nm'
and a.effective_dt<>'effective_dt'
;

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

collect statistics on L2_MRKTGANLYS_T.RTS_membermdtags index (l_id, tag_nm, effective_dt);

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

collect statistics on L2_MRKTGANLYS_T.RTS_membermdtags index (l_id);

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

.quit 0
