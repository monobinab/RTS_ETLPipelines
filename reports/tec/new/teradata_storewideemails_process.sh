#! /bin/bash
log_dir=/logs/rts
log_file=tec_storewideemails_teradata_process.log

start_date=$(date '+%Y-%m-%d' -d "7 day ago")
end_date=$(date '+%Y-%m-%d' -d "1 day ago")

echo ${start_date}
echo ${end_date}

bteq<<EOF > $log_dir/$log_file 2>&1
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

.SET ERRORLEVEL 3807 SEVERITY 0;

drop table shc_work_tbls.rts_TEC_storewide_weekly_send;
CREATE TABLE shc_work_tbls.rts_TEC_storewide_weekly_send AS
(
SELECT LYL_ID_NO, SEND_DT, SID_CODE
FROM  lci_dw_views.master_contacthist
WHERE SUBSTR(SID_CODE,1,3)='IOx'
AND
(
     SUBSTR(SID_CODE,15,6) = 'PRMFLS'
     OR      SUBSTR(SID_CODE,15,6) = 'PRMBAU'
)
AND send_dt BETWEEN DATE'${start_date}' AND DATE'${end_date}'
) WITH DATA PRIMARY INDEX(lyl_id_no,sid_code) INDEX(lyl_id_no, send_dt) INDEX(lyl_id_no);

COLLECT STATS shc_work_tbls.rts_TEC_storewide_weekly_send INDEX(lyl_id_no,sid_code);
COLLECT STATS shc_work_tbls.rts_TEC_storewide_weekly_send INDEX(lyl_id_no, send_dt);
COLLECT STATS shc_work_tbls.rts_TEC_storewide_weekly_send INDEX(lyl_id_no);
HELP STATS shc_work_tbls.rts_TEC_storewide_weekly_send;


drop table shc_work_tbls.rts_TEC_top_rec;
CREATE TABLE shc_work_tbls.rts_TEC_top_rec
(
	lyl_id_no DEC(16,0)
	, rec_ts TIMESTAMP(0)
	, modelId INT
	, model VARCHAR(30)
	, client VARCHAR(30)
) PRIMARY INDEX(lyl_id_no, rec_ts) INDEX (lyl_id_no);

INSERT	INTO  shc_work_tbls.rts_TEC_top_rec
SELECT	CAST(lyl_id_no AS DEC(16,0)) AS lyl_id_no
, CAST(TRIM(rec_ts) AS TIMESTAMP(0)) AS rec_ts
, CAST(TRIM(modelid) AS INT) AS modelid
, model AS model
, client
FROM	shc_work_tbls.rts_api_response_log_tec
WHERE	modelid<>'\N';

drop table shc_work_tbls.rts_TEC_storewide_top_rec;
create table  shc_work_tbls.rts_TEC_storewide_top_rec as
(
SELECT	a.LYL_ID_NO, a.SEND_DT, a.SID_CODE, b.modelId, b.model,
		b.rec_ts
FROM	shc_work_tbls.rts_TEC_storewide_weekly_send AS a
JOIN 
(
	SELECT m.lyl_id_no, t.SID_CODE, MAX(m.rec_ts) AS rec_ts
	FROM   shc_work_tbls.rts_TEC_top_rec AS m
	JOIN shc_work_tbls.rts_TEC_storewide_weekly_send AS t
	ON m.lyl_id_no=t.lyl_id_no
	WHERE CAST(m.rec_ts AS DATE)<= t.send_dt
	GROUP BY 1,2
) AS d
	ON	d.lyl_id_no=a.lyl_id_no
	AND	d.SID_CODE=a.SID_CODE
JOIN   shc_work_tbls.rts_TEC_top_rec AS b
	ON	d.lyl_id_no=b.lyl_id_no
	AND	d.rec_ts =b.rec_ts
	) 
WITH	DATA PRIMARY INDEX(lyl_id_no, sid_code);

--insert into l2_mrktganlys_t.roc_TEC_storewide_top_RTS_rec
--select
--LYL_ID_NO, SEND_DT, SID_CODE, modelId, model from  shc_work_tbls.roc_TEC_storewide_top_rec;


select max(send_dt), min(send_dt) from  l2_mrktganlys_t.roc_TEC_storewide_top_RTS_rec;
EOF;
