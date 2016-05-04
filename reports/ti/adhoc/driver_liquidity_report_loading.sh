#! /bin/bash
cd /appl/rts/reports/ti
cat /staging/rts/liquidity_report_daily/* > /staging/rts/liquidity_dailyreport_combined.txt
echo ret_code=$? > /logs/rts/liquidity_dailyreport_combined.log
case ${ret_code} in
     *) printf "\nRTS liquidity TI files combine job Failed\n with Return Code=${ret_code}"| mailx -s "Files combine job Failed"  rtsteam$searshc.com
     exit 1 ;;
esac

