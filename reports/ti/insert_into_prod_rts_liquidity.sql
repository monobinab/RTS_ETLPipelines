LOGON TDAdhoc.intra.searshc.com/msaha,n745tzjax2;
INSERT INTO L2_MRKTGANLYS_T.rts_api_response
(
memberid,
run_date,
modelName,
modelRank,
modelPercentile,
client,
load_dt,
api_call_time,
occasion,
mdtag
)
select
memberid,
run_date,
modelName,
modelRank,
percentile,
client,
current_timestamp(6),
time_taken,
occasion,
mdtag
from
shc_work_tbls.rts_liquidity_daily
;

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

collect statistics on L2_MRKTGANLYS_T.rts_api_response index ( memberid ,run_date ,modelName ,modelRank);
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

.quit 0
