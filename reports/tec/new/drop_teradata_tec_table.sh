#! /bin/bash
log_dir=/logs/rts
log_file=storewide_drop_tec_teradatatable.log


bteq<<EOF >> ${log_dir}/${log_file} 2>&1
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

.SET ERRORLEVEL 3807 SEVERITY 0;
.SET ERRORLEVEL 8 SEVERITY 0;

drop table shc_work_tbls.rts_api_response_log_tec;

CREATE TABLE shc_work_tbls.rts_api_response_log_tec
(
        lyl_id_no varchar(16)
        , rec_ts varchar(20)
        , modelId varchar(10)
        , model VARCHAR(30)
        , client VARCHAR(30)
) PRIMARY INDEX(lyl_id_no, rec_ts) INDEX (lyl_id_no);

EOF;
