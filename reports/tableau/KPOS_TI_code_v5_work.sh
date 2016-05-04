#! /bin/bash
current_day=`date +%-d`
log_dir=/logs/rts
log_file=tableau_weekly_POS_sql.logs

start_date=`date +%Y-%m-%d -d "61 day ago"`
echo ${start_date}
end_date=`date +%Y-%m-%d -d "1 day ago"`
echo ${end_date}
logdir='/logs/rts'
echo ${logdir}
logfile='tableau_pos_offers_report.log'
echo ${logfile}

echo ${current_day}

bteq<<EOF
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

DROP TABLE shc_work_tbls.ms_TI_RTS_offers;
CREATE TABLE shc_work_tbls.ms_TI_RTS_offers AS
(
    SELECT offerinstanceversionid
    FROM ti_mart_views.marketingcontact AS a
    WHERE contactdate 
    BETWEEN DATE'${start_date}' AND DATE'${end_date}'
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
) WITH DATA PRIMARY INDEX (CustInteractionID, LoyaltyID_iss);


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
SELECT contactdate
	, iss.TouchpointChannelAbbr
	, b.RTS_Ind
    , iss.CoBusUnitDesc
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
WHERE rts_ind='RTS'
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
)
with DATA
primary index(Touchpoint);


EOF
