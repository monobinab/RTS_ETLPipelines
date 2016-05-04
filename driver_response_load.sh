cd /home/auto/msaha/rts/api;sh response_stream.sh > ./logs/response_stream.log 2>&1

if [ $? -ne 0 ]; then

   echo "Error in /home/auto/msaha/rts/api/response_stream.sh" >> /home/auto/msaha/rts/api/logs/response_stream.log
   exit 1;
fi

cd /home/auto/msaha/rts/api;sh load_rts_api.sh > ./logs/load_rts_api.log 2>&1

if [ $? -ne 0 ]; then

   echo "Error in /home/auto/msaha/rts/api/load_rts_api.sh" >> /home/auto/msaha/rts/api/logs/load_rts_api.log
   exit 1;
fi

cd /home/auto/msaha/rts/api;sh insert_partition_log_table.sh > ./logs/insert_partition_log_table.log 2>&1

if [ $? -ne 0 ]; then

   echo "Error in /home/auto/msaha/rts/api/insert_partition_log_table.sh" >> /home/auto/msaha/rts/api/logs/insert_partition_log_table.log
   exit 1;
fi

cd /home/auto/msaha/rts/api;hive -f create_api_flat.sql > ./logs/create_api_flat.log 2>&1

if [ $? -ne 0 ]; then

   echo "Error in create_api_flat.sql" >> /home/auto/msaha/rts/api/logs/create_api_flat.log
   exit 1;
fi
~
~
