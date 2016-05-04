bteq</appl/rts/reports/tableau/pos_offer/TI_ofr_cds.sql > /logs/rts/TI_ofr_cd.log
ret_code=$?
case ${ret_code} in
     0) printf "\nPOS Offer TI Offer code table create job successful \n" >> /logs/rts/TI_ofr_cd.log;;
     *) printf "\nPOS Offer TI Offer code table create job failed\n" >> /logs/rts/TI_ofr_cd.log
     echo "\nPOS Offer TI Offer code table create job failed with Return Code=${ret_code}\n"| mailx -s "Report POS Offer TI Offer code job Failed" -a /logs/rts/TI_ofr_cd.log rtsteam@searshc.com
     exit 1 ;;
esac

sh /appl/rts/reports/tableau/pos_offer/TI_report_lst1_work.sh > /logs/rts/tableau_pos_offers_report.log
ret_code=$?
case ${ret_code} in
     0) printf "\nReport POS Offers final table create job successful \n" >> /logs/rts/tableau_pos_offers_report.log;;
     *) printf "\nReport POS Offers final table create job failed\n" >> /logs/rts/tableau_pos_offers_report.log
     echo "\nReport POS Offers final table create job failed with Return Code=${ret_code}\n"| mailx -s "Report POS Offers final table create job Failed" -a /logs/rts/tableau_pos_offers_report.log msaha@searshc.com
     exit 1 ;;
esac
