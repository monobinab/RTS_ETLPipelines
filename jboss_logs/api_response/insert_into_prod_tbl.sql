use real_time_scoring;

add jar /appl/rts/jboss_logs/api_response/joda-time-2.3.jar;
add jar /appl/rts/jboss_logs/api_response/brickhouse-0.7.0.jar;

create temporary function json_map as 'brickhouse.udf.json.JsonMapUDF';
create temporary function json_split as 'brickhouse.udf.json.JsonSplitUDF';

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

SET mapreduce.output.fileoutputformat.compress.codec=com.hadoop.compression.lzo.LzopCodec;
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress=true;
set avro.output.codec=snappy;

--ALTER TABLE api_response_log DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}', day = '${hiveconf:current_day}');
--ALTER TABLE api_response_log DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '${hiveconf:current_month}', day = '${hiveconf:yesterday}');

set mapred.reduce.tasks = 50;
insert into table api_response_log
partition(Year, Month, Day)   
select
    t.run_date as run_date,
    trim(t.client) as client, 
    trim(COALESCE(t.lyl_id_no, v1.memberId, v1.memberId2, v1.memberId3)) as memberId,
    trim(t.encrypted_lyl_id_no) as encrypted_memberid,
    trim(COALESCE(v3.modelName, v3.modelName2)) as modelName, 
    trim(COALESCE(v3.rank, v3.rank2)) as rank, 
    trim(t.time_taken) as time_taken,
    trim(v1.status) as status,
    trim(v1.statusCode) as statuscode,
    trim(v1.lastUpdated) as lastupdated,
    --COALESCE(v1.scoresInfo, v1.rankedModels) as scoreJson
    trim(v3.modelId) as modelid, 
    trim(v3.category) as category, trim(v3.tag) as tag, trim(v3.tagId) as tagId, trim(v3.score) as score, trim(v3.totalScore) as totalscore, 
    trim(coalesce(v3.percentile, v3.percentile2)) as percentile, 
    trim(v3.scorePercentile) as scorepercentile, 
    trim(v3.index) as index,
    trim(v3.mdTag) as mdtag,
    trim(coalesce(v3.occasion, v3.occasion2)) as occasion,
    trim(v3.subBusinessUnit) as subbusinessunit,
    trim(v3.businessUnit) as businessunit,
    trim(v3.scoreDate) as scoredate,
    '${hiveconf:load_date}' as load_date,
    trim(v3.buTag) as butag,
    year(to_date(run_date)) as year,
    month(to_date(run_date)) as month,
    day(to_date(run_date)) as day
from rts_api_response_log_staging_deduped t
lateral view json_tuple(api_response, 'status', 'statusCode', 'memberId', 'MemberId', 'Memberid', 'lastUpdated', 'scoresInfo', 'Ranked Models', 'rankedModels') v1 as status, statusCode, memberId, memberId2, memberId3, lastUpdated, scoresInfo, rankedModels, rankedModels1
    lateral view explode(json_split(COALESCE(v1.scoresInfo, v1.rankedModels, v1.rankedModels1))) v2 as scoreInfo
        lateral view json_tuple(v2.scoreInfo, 'modelId',  'ModelName', 'modelName', 'category', 'tag', 'tagId', 'score', 'totalScore', 'percentile', 'Percentile', 'scorePercentile', 'Rank', 'rank', 'index', 'mdTag', 'buTag', 'occassion', 'Occassion', 'subBusinessUnit', 'businessUnit', 'scoreDate') v3  as modelId, modelName, modelName2, category, tag, tagId, score, totalScore, percentile, percentile2, scorePercentile, rank, rank2, index, mdTag, buTag, occasion, occasion2, subBusinessUnit, businessUnit, scoreDate 
--where
--unix_timestamp(run_date, 'yyyy-MM-dd') >= unix_timestamp(from_unixtime(unix_timestamp() -1*60*60*24, 'yyyy-MM-dd'), 'yyyy-MM-dd')
--and unix_timestamp(run_date) < unix_timestamp(from_unixtime(unix_timestamp(), 'yyyy-MM-dd'), 'yyyy-MM-dd')
;

