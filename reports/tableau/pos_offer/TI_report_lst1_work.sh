#! /bin/bash
log_dir=/logs/rts
log_file=tableau_weekly_POS_sql.logs

start_date=`date +%Y-%m-%d -d "15 day ago"`
end_date=`date +%Y-%m-%d -d "9 day ago"`
logdir='/logs/rts'
logfile='tableau_pos_offers_report.log'

current_date=`date +%Y-%m-%d`
echo ${current_date}

bteq<<EOF >> $logdir/$logfile 2>&1
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

.SET ERRORLEVEL 3807 SEVERITY 0;

DROP TABLE shc_work_tbls.ms_TI_RTS_offers;
CREATE TABLE shc_work_tbls.ms_TI_RTS_offers AS
(
    SELECT offerinstanceversionid
    FROM ti_mart_views.marketingcontact AS a
    JOIN  shc_work_tbls.RTS_ofr_cd AS b
    ON a.offerinstanceversionid=b.version_id
    WHERE contactdate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND a.TouchpointChannelAbbr IN ('KPOS')
	AND a.cobusunitdesc NOT IN ('Kmart Storewide')
    GROUP BY 1
) WITH DATA PRIMARY INDEX(offerinstanceversionid);
COLLECT STATS shc_work_tbls.ms_TI_RTS_offers INDEX(offerinstanceversionid);


---correspondence between OfferInstanceVersionID and slot
---Indicator messageind to exclude Layaway and FCP, Holiday BB, MTA

------------Table of RTS offerInstanceVersionIDs
DROP TABLE shc_work_tbls.ms_TI_RTS_offers_ind;
CREATE TABLE shc_work_tbls.ms_TI_RTS_offers_ind AS
(
    SELECT b.OfferInstanceVersionID
        , 'RTS' AS RTS_Ind
        , a.baseofferdesc
    FROM ti_mart_views.OfferInstanceVersion b
    JOIN  ti_mart_views.BaseOffer a
    ON b.baseofferid=a.baseofferid
    JOIN shc_work_tbls.ms_TI_RTS_offers c
    ON b.OfferInstanceVersionID=c.OfferInstanceVersionID
) WITH DATA PRIMARY INDEX(OfferInstanceVersionID);


DROP TABLE shc_work_tbls.ms_TI_RTS_OfID_Rule;
CREATE TABLE shc_work_tbls.ms_TI_RTS_OfID_Rule AS
(
    SELECT DISTINCT a.OfferInstanceVersionID
        , b.baseofferdesc
        ,RuleDesc
        ,RuleStrategyDesc
        ,CASE
            WHEN a.TouchpointChannelAbbr<>'KPOS' THEN 'NPOS'
            ELSE 'KPOS'
        END AS TouchpointChannelAbbr
        , 'RTS' AS MessageInd
        , 'Slot2' AS SlotInd
    FROM ti_mart_views.marketingcontact AS a
    --left join shc_work_tbls.ms_TI_RTS_offers_ind b -- only with RTS in base description - only for treatment group
    JOIN shc_work_tbls.ms_TI_RTS_offers_ind AS b
    ON a.OfferInstanceVersionID=b.OfferInstanceVersionID
    WHERE contactdate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND a.TouchpointChannelAbbr IN ('KPOS','NPOS','TPOS','SHPSRS')
    AND a.RuleDesc LIKE ('2%')
) WITH DATA PRIMARY INDEX(OfferInstanceVersionID);



-----Full issuances table

DROP TABLE shc_work_tbls.ms_TI_RTS_issuances;
CREATE MULTISET TABLE shc_work_tbls.ms_TI_RTS_issuances AS
(
    SELECT a.OfferInstanceVersionID
        , b.baseofferdesc
        , a.RuleDesc
        , a.RuleStrategyDesc
        , a.transactionid
        , a.csonumber
        , CASE
              WHEN a.TouchpointChannelAbbr<>'KPOS' THEN 'NPOS'
              ELSE 'KPOS'
          END AS TouchpointChannelAbbr
        , b.MessageInd
        , b.SlotInd
        , CASE
            WHEN a.csonumber IS NULL THEN 'NULL'
            ELSE 'Not NULL'
        END AS csonumberind --- cso NULL indicator
        , CASE 
            WHEN  a.csonumber IS NOT NULL THEN a.OfferInstanceVersionID||a.CSONumber||a.transactionid
            ELSE a.OfferInstanceVersionID||a.loyaltyid||a.transactionid
        END AS OIVD_CSO_Lyl_TrID --- kind of unique ID for an issuance
        , CASE 
            WHEN a.csonumber IS NOT NULL THEN a.OfferInstanceVersionID||a.CSONumber
            ELSE a.OfferInstanceVersionID||a.loyaltyid
        END AS OIVD_CSO_Lyl
        ,a.loyaltyid
        ,a.ContactDate
        ,a.CoBusUnitDesc
    FROM ti_mart_views.marketingcontact AS a
    LEFT JOIN shc_work_tbls.ms_TI_RTS_OfID_Rule AS b
    ON a.OfferInstanceVersionID=b.OfferInstanceVersionID
    WHERE a.contactdate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND a.TouchpointChannelAbbr IN ('KPOS','NPOS','TPOS','SHPSRS')
) WITH DATA PRIMARY INDEX(OIVD_CSO_Lyl, loyaltyid);
COLLECT STATS shc_work_tbls.ms_TI_RTS_issuances INDEX(OIVD_CSO_Lyl, loyaltyid);
HELP STATS shc_work_tbls.ms_TI_RTS_issuances;

-------redemptions (Issuance tied)------------

DROP TABLE shc_work_tbls.ms_TI_RTS_rdmpt_IT;
CREATE MULTISET TABLE shc_work_tbls.ms_TI_RTS_rdmpt_IT AS
( 
SELECT DISTINCT
	a.CustInteractionID
	, a.CSONumber
	, a.OfferInstanceVersionID
	, a.LoyaltyID AS LoyaltyID_red
	, d.loyaltyid AS loyaltyid_iss
	, CASE 
		 WHEN a.CSONumber IS NULL THEN 'NULL'
		 ELSE 'Not NULL'
	 END csonumberind
	, CASE 
		WHEN  a.csonumber IS NOT NULL THEN a.OfferInstanceVersionID||a.CSONumber
		ELSE a.OfferInstanceVersionID||a.loyaltyid
	END AS OIVD_CSO_Lyl_r --- used to join for Issuance tied
	, CASE
		WHEN d.OIVD_CSO_Lyl IS NULL THEN 'IT NULL'
		ELSE 'IT not NULL'
	END AS IT_ind 		---indicator for whether there is an IT indicator in issuance table
	, CASE
		  WHEN a.TouchpointChannelAbbr<>'KPOS' THEN 'NPOS'
		  ELSE 'KPOS'
	  END AS TouchpointChannelAbbr
	, a.RedemptionDate
	, a.IssuanceDate
	, c.SlotInd
	, c.MessageInd
	, MAX(BasketNetSalesAmt) AS NetSales
	, MAX(BasketAdjSellingMarginAmt) AS MarginAdj
	, MAX(BasketSellingMarginAmt) AS Margin
FROM ti_mart_views.tiRedemptionDetail a
JOIN shc_work_tbls.ms_TI_RTS_OfID_Rule c
ON a.OfferInstanceVersionID=c.OfferInstanceVersionID
JOIN shc_work_tbls.ms_TI_RTS_issuances d
ON d.OIVD_CSO_Lyl=OIVD_CSO_Lyl_r
---possible reasons for not being IT:
---Catalina - one CSO for offerinstanceversionid ---separate code needed
---XR should join (?)

WHERE a.RedemptionDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'+7
AND IssuanceDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
AND a.TouchpointChannelAbbr IN ('KPOS','NPOS','TPOS','SHPSRS')

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

)
WITH DATA PRIMARY INDEX (CustInteractionID, LoyaltyID_iss);

SELECT iss.TouchpointChannelAbbr
        , b.RTS_Ind
    , SUM(ZEROIFNULL(iss.issuances)) AS Issuances
    , SUM(ZEROIFNULL(rd.rdmp)) AS Redemptions
    , SUM(ZEROIFNULL(rd.NetSales)) AS NetSales
    , SUM(ZEROIFNULL(rd.adjMargin)) AS adjMargin
FROM
(
    SELECT OfferInstanceVersionID
        , TouchpointChannelAbbr
        , CoBusUnitDesc
        , COUNT(*) AS issuances
    FROM shc_work_tbls.ms_TI_RTS_issuances AS a
    WHERE ContactDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND messageind='RTS'
    GROUP BY 1,2,3
) AS iss
LEFT JOIN
(
    SELECT OfferInstanceVersionID
    , COUNT(*) AS rdmp
    , SUM(NetSales) AS NetSales
    , SUM(MarginAdj) AS adjMargin
    FROM shc_work_tbls.ms_TI_RTS_rdmpt_IT
    WHERE RedemptionDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'+7
    GROUP BY 1
) AS rd
ON iss.OfferInstanceVersionID=rd.OfferInstanceVersionID
JOIN shc_work_tbls.ms_TI_RTS_offers_ind b
ON iss.OfferInstanceVersionID=b.OfferInstanceVersionID
GROUP BY 1,2
ORDER BY 1,2;

drop table shc_work_tbls.ms_rts_ti_weekly;
create table shc_work_tbls.ms_rts_ti_weekly as (
SELECT 
	 iss.TouchpointChannelAbbr as Touchpoint
	, b.RTS_Ind
    , iss.CoBusUnitDesc
    , iss.acctg_wk
    , SUM(ZEROIFNULL(iss.issuances)) AS Issuances
    , SUM(ZEROIFNULL(rd.rdmp)) AS Redemptions
    , SUM(ZEROIFNULL(rd.NetSales)) AS NetSales
    , SUM(ZEROIFNULL(rd.adjMargin)) AS adjMargin
FROM 
(
    SELECT OfferInstanceVersionID
        , TouchpointChannelAbbr
        , CoBusUnitDesc
        , d.acctg_wk
        , COUNT(*)  AS issuances
    FROM shc_work_tbls.ms_TI_RTS_issuances AS a
    join lci_public_tbls.lcixt44_445_calendar d on a.contactdate = d.acctg_dt
    wHERE ContactDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND messageind='RTS'
    group by 1,2,3,4
) AS iss
LEFT JOIN 
(
    SELECT OfferInstanceVersionID
    , COUNT(*) AS rdmp
    , SUM(NetSales) AS NetSales
    , SUM(MarginAdj) AS adjMargin
    FROM shc_work_tbls.ms_TI_RTS_rdmpt_IT
    WHERE RedemptionDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'+7
    GROUP BY 1
) AS rd
ON iss.OfferInstanceVersionID=rd.OfferInstanceVersionID
JOIN shc_work_tbls.ms_TI_RTS_offers_ind b
ON iss.OfferInstanceVersionID=b.OfferInstanceVersionID
WHERE rts_ind='RTS'
GROUP BY 1,2,3,4
)
with DATA
primary index(Touchpoint, CoBusUnitDesc);

drop table shc_work_tbls.ms_rts_ti_weekly_all_bu;
create table shc_work_tbls.ms_rts_ti_weekly_all_bu as (
select
sum(ZEROIFNULL(issuances)) issuances_all_bu
,sum(zeroifnull(redemptions)) redemptions_all_bu
,sum(zeroifnull(netsales)) netsales_all_bu
,sum(zeroifnull(adjmargin)) adjmargin_all_bu
from
shc_work_tbls.ms_rts_ti_weekly
)
with data
primary index(issuances_all_bu,  redemptions_all_bu, netsales_all_bu,  adjmargin_all_bu)
;

drop table shc_work_tbls.ms_rts_ti_weekly_rates;
create table shc_work_tbls.ms_rts_ti_weekly_rates as (
select
acctg_wk,
cobusunitdesc,
issuances,
redemptions,
netsales,
adjmargin,
(sel issuances_all_bu from shc_work_tbls.ms_rts_ti_weekly_all_bu) as issuances_all_bu ,
(sel redemptions_all_bu from shc_work_tbls.ms_rts_ti_weekly_all_bu) as redemptions_all_bu ,
(sel netsales_all_bu from shc_work_tbls.ms_rts_ti_weekly_all_bu) as netsales_all_bu,
(sel adjmargin_all_bu from shc_work_tbls.ms_rts_ti_weekly_all_bu) as adjmargin_all_bu,
((cast(issuances as decimal(20,3)) / cast(issuances_all_bu as decimal(20,3)))*100) as rate_of_issuances,
((cast(redemptions as decimal(20,3)) / cast(issuances as decimal(20,3)))*100) as redemptions_per_issuance,
(cast(netsales as decimal(20,3)) / cast(issuances as decimal(20,3))) as netsales_per_issuance,
(cast(adjmargin as decimal(20,3)) / cast(issuances as decimal(20,3))) as adjmargin_per_issuance
from 
shc_work_tbls.ms_rts_ti_weekly
)
with data
primary index(cobusunitdesc)
;
EOF 

