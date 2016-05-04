rmf /tmp/api_response_uncompressed_0209
REGISTER /appl/rts/jboss_logs/api_response/udf.jar;


A = LOAD '/tmp/api_response_0209_streamlogs'
USING PigStorage('|') AS (
run_date
,api_response
,memberId
,client
,time_taken
)
;

C =  FILTER A BY (TRIM(client) == 'TI_KPOS');
D = LIMIT C 100;

store C into '/tmp/api_response_uncompressed_0209' USING PigStorage('|');

set output.compression.enabled  false;
set output.compression.codec com.hadoop.compression.lzo.LzopCodec;
