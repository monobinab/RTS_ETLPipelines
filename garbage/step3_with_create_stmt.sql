use real_time_scoring;

add jar /home/auto/msaha/rts/api/final/joda-time-2.3.jar;
add jar /home/auto/msaha/rts/api/final/brickhouse-0.7.0.jar;

create temporary function json_map as 'brickhouse.udf.json.JsonMapUDF';
create temporary function json_split as 'brickhouse.udf.json.JsonSplitUDF';

/*
--create just once and keep inserting from staging table for incremetal data
--while inserting drop targetted partition first and then insert specifying targeted partition for faster loading
create table if not exists api_response_log_all (
run_date timestamp,
client string,
memberId string,
modelName string,  
rank string,
time_taken string, 
status string, 
statusCode string, 
lastUpdated string,
modelId string,
category string, 
tag string,
tagId string,
score string,
totalScore string,
percentile string,
scorePercentile string,
index string)
PARTITIONED BY (Year INT, Month INT, Day INT)
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile
;
*/

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

ALTER TABLE rts_api_response_log_pt DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '{hiveconf:current_month}', day = '{hiveconf:current_day}');
ALTER TABLE rts_api_response_log_pt DROP IF EXISTS PARTITION(year = '${hiveconf:current_year}', month = '{hiveconf:current_month}', day = '{hiveconf:yesterday}');

insert into table api_response_log_all
partition(Year, Month, Day)   
select
    t.run_date,
    t.client,
    COALESCE(t.lyl_id_no, v1.memberId, v1.memberId2) as memberId,
    COALESCE(v3.modelName, v3.modelName2) as modelName, 
    COALESCE(v3.rank, v3.rank2) as rank, 
    t.time_taken,
    v1.status,
    v1.statusCode,
    v1.lastUpdated,
    --COALESCE(v1.scoresInfo, v1.rankedModels) as scoreJson
    v3.modelId, 
    v3.category, v3.tag, v3.tagId, v3.score, v3.totalScore, v3.percentile, v3.scorePercentile, 
    v3.index,
    year(to_date(run_date)) as year,
    month(to_date(run_date)) as month,
    day(to_date(run_date)) as day
from rts_api_response_log_staging t
lateral view json_tuple(api_response, 'status', 'statusCode', 'memberId', 'MemberId', 'lastUpdated', 'scoresInfo', 'Ranked Models') v1 as status, statusCode, memberId, memberId2, lastUpdated, scoresInfo, rankedModels
    lateral view explode(json_split(COALESCE(v1.scoresInfo, v1.rankedModels))) v2 as scoreInfo
        lateral view json_tuple(v2.scoreInfo, 'modelId',  'ModelName', 'modelName', 'category', 'tag', 'tagId', 'score', 'totalScore', 'percentile', 'scorePercentile', 'Rank', 'rank', 'index') v3  as modelId, modelName, modelName2, category, tag, tagId, score, totalScore, percentile, scorePercentile, rank, rank2, index 
;

