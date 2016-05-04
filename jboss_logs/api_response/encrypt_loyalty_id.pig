rmf /smith/rts/jboss_logs/api_response_log
REGISTER /appl/rts/jboss_logs/api_response/udf.jar;
register /appl/rts/jboss_logs/api_response/encryption.jar
define BASE64Encryption com.shc.pig.udf.BASE64Encryption();


A = LOAD '/smith/rts/jboss_logs/stream_logs'
USING PigStorage('|') AS (
run_date
,api_response
,memberId
,client
,time_taken
)
;

B = FOREACH A GENERATE 
run_date
,api_response
,memberId
,BASE64Encryption(TRIM(memberId))         
,client      
,time_taken
;

store B into '/smith/rts/jboss_logs/api_response_log' USING PigStorage('|');

set output.compression.enabled  true;
set output.compression.codec com.hadoop.compression.lzo.LzopCodec;

