LOGON TDAdhoc.intra.searshc.com/msaha,n745tzjax2;
INSERT INTO L2_MRKTGANLYS_T.rts_liquidity_tec
(
memberid,
run_date,
modelName,
modelRank,
modelPercentile,
client,
load_dt
)
select
memberid,
run_date,
modelName,
modelRank,
percentile,
client,
current_timestamp(6)
from
shc_work_tbls.rts_liquidity_daily_tec
;

.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

collect statistics on L2_MRKTGANLYS_T.rts_liquidity_tec index (memberid);
.IF ERRORCODE <> 0 THEN .QUIT ERRORCODE;

.quit 0
