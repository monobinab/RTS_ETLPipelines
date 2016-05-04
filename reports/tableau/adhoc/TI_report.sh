#! /bin/bash
current_day=`date +%-d`
log_dir=/logs/rts
log_file=tableau_weekly_POS_sql.logs

start_date=`date +%Y-%m-%d -d "7 day ago"`
end_date=`date +%Y-%m-%d -d "1 day ago"`
logdir='/logs/rts'
logfile='tableau_pos_offers_report.log'

echo ${current_day}

bteq<<EOF > $logdir/$logfile 2>&1
.logon  TDAdhoc.intra.searshc.com/msaha,n745tzjax2;

DROP TABLE shc_work_tbls.ms_TI_RTS_offers;
CREATE TABLE shc_work_tbls.ms_TI_RTS_offers AS
(
    SELECT offerinstanceversionid
    FROM ti_mart_views.marketingcontact AS a
    JOIN  shc_work_tbls.RTS_ofr_cd AS b
    ON a.offerinstanceversionid=b.version_id
    WHERE contactdate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND a.TouchpointChannelAbbr IN ('KPOS','NPOS','TPOS','SHPSRS')
    GROUP BY 1
) WITH DATA PRIMARY INDEX(offerinstanceversionid);
COLLECT STATS shc_work_tbls.ms_TI_RTS_offers INDEX(offerinstanceversionid);



DROP TABLE shc_work_tbls.ms_TI_RTS_offers_ind;
CREATE TABLE shc_work_tbls.ms_TI_RTS_offers_ind AS
(
    SELECT c.offerinstanceversionid
        , CASE
            WHEN a.baseofferdesc LIKE ('% RTS') THEN 'RTS'
            ELSE 'Regular'
        END AS rts_ind
        , a.baseofferdesc
    FROM shc_work_tbls.ms_TI_RTS_offers c
    LEFT JOIN ti_mart_views.OfferInstanceVersion b
    ON c.offerinstanceversionid=b.offerinstanceversionid
    LEFT JOIN  ti_mart_views.BaseOffer a
    ON b.baseofferid=a.baseofferid
) WITH DATA PRIMARY INDEX(offerinstanceversionid);
COLLECT STATS shc_work_tbls.ms_TI_RTS_offers_ind INDEX(offerinstanceversionid);




--------------------------------------------------------------------
DROP TABLE shc_work_tbls.ms_TI_RTS_Cust;
CREATE TABLE shc_work_tbls.ms_TI_RTS_Cust AS
(
		SELECT
		lyl_id_no

		FROM  LCI_DW_VIEWS.SALES_TRAN_TBL a

		WHERE day_DT BETWEEN DATE'${start_date}' AND DATE'${end_date}'
		AND lyl_id_no IS NOT NULL
		AND lyl_id_no>9

		GROUP BY 1
UNION		
		SELECT
		lyl_id_no

		FROM crm_perm_tbls.SYWR_Sears_sales_ptd a

		WHERE TRS_DT BETWEEN DATE'${start_date}' AND DATE'${end_date}'
		AND lyl_id_no IS NOT NULL
		AND lyl_id_no>9

		GROUP BY 1
UNION
	
		SELECT loyaltyid
		FROM ti_mart_views.marketingcontact
		WHERE contactdate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
		AND loyaltyid IS NOT NULL
		AND loyaltyid>9
		GROUP BY 1  

)
WITH DATA PRIMARY INDEX (lyl_id_no); 

------Table of members with Treatment/Control by flags
DROP TABLE shc_work_tbls.ms_TI_RTS_ActCust;
CREATE TABLE shc_work_tbls.ms_TI_RTS_ActCust AS
(
    SELECT DISTINCT a.lyl_id_no
        , b.flag2_k AS kposflag
        , c.SEL_TP
        , d.flag3_s AS nposflag
        , CASE
            WHEN kposflag IS NULL THEN 'KPOS Default'
            WHEN kposflag='R' THEN 'KPOS RTS'
            WHEN kposflag='X' THEN 'KPOS Regular'
        ELSE 'Other'
        END AS kposind
        , CASE
            WHEN nposflag IS NULL THEN 'NPOS Default'
            WHEN nposflag='R' THEN 'NPOS RTS'
            WHEN nposflag='C' THEN 'NPOS Regular'
        ELSE 'Other'
        END AS nposind
        ---assume that new members (sel_tp NULL) are all treated as Treatment
        , CASE
        WHEN SEL_TP='C' THEN 'UCG'
        ELSE 'Treatment'
        END AS ucgind
    FROM shc_work_tbls.ms_TI_RTS_Cust a
    LEFT JOIN crm_perm_tbls.kmart_pos_Framework_Assignment b
    ON a.lyl_id_no=b.lyl_id_no
    LEFT JOIN crm_mart1_tbls.JL_POS_UNIV_LYL_TC c
    ON a.lyl_id_no=c.SRC_SYS_ID_NO
    LEFT JOIN  CRM_PERM_TBLS.SEARS_POS_FRAMEWORK_ASSIGNMENT d
    ON a.lyl_id_no=d.lyl_id_no

)
WITH DATA PRIMARY INDEX (lyl_id_no);

---correspondence between OfferInstanceVersionID and slot
---Indicator messageind to exclude Layaway and FCP, Holiday BB, MTA

------------Table of RTS offerInstanceVersionIDs
DROP TABLE shc_work_tbls.ms_TI_RTS_RTSOfferversionid;
CREATE TABLE shc_work_tbls.ms_TI_RTS_RTSOfferversionid AS
(
/*
select b.OfferInstanceVersionID
from ti_mart_views.OfferInstanceVersion b
join  ti_mart_views.BaseOffer a
on b.baseofferid=a.baseofferid
where a.baseofferdesc like ('% RTS')

---Addendum
union
select OfferInstanceVersionID
from shc_work_tbls.ms_TI_RTS_offers
*/
    SELECT b.OfferInstanceVersionID
        , CASE 
            WHEN a.baseofferdesc LIKE ('%RTS%') THEN 'RTS'
            ELSE 'Regular'
        END AS RTS_Ind
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
        ,CASE
    			WHEN (a.RuleStrategyDesc='Points Continuity Award' OR a.RuleStrategyDesc='Points Continuity Progress') THEN 'FCP'
    			WHEN a.RuleStrategyDesc='Layaway' THEN 'Layaway'
    /*			when a.RuleId in (23884,23885,23886,23887,23888,23890) then 'HolidayBB'
    			when a.RuleDesc like ('%MTA stores%') then 'MTA stores'
    			when a.OfferInstanceVersionID=700245 then 'FREE LITTLE CAESARS'
    			when SlotInd in ('Slot5','Catalina Slot1', 'Slot3') and a.RuleDesc like ('%Associate%') then 'Associate LC'
    			when OfferInstanceVersionID in
    				(
    				692375,683970,692347,683975,683938,700916,687984,700914,687983,692376,
    				687982,692380,692306,692332,692378,683934,692382,683969,683939,693395,
    				692365,683940,700912,692364,683971,683935,700913,683972,700911,692372,
    				692393,692371,683941,692392,683974,683937,683973,683936
    				) then 'Nrdm Slot5 AL'
    */
    			WHEN b.OfferInstanceVersionID IS NOT NULL THEN 'RTS'
    			ELSE 'Other'
    			END AS MessageInd
        , CASE
    			WHEN a.RuleDesc LIKE ('5%')THEN 'Slot5'			
    			WHEN a.RuleDesc LIKE ('C1%') THEN 'Catalina Slot1'
    			WHEN a.RuleDesc LIKE ('2%') THEN 'Slot2'
    			WHEN a.RuleDesc LIKE ('3%') THEN 'Slot3'
    			WHEN a.RuleDesc LIKE ('1%') THEN 'Slot1'
    			WHEN a.RuleDesc LIKE ('4%') THEN 'Slot4'
    			ELSE 'Unidentified'
    			END AS SlotInd
    FROM ti_mart_views.marketingcontact AS a
    --left join shc_work_tbls.ms_TI_RTS_RTSOfferversionid b -- only with RTS in base description - only for treatment group
    LEFT JOIN shc_work_tbls.ms_TI_RTS_offers_ind AS b
    ON a.OfferInstanceVersionID=b.OfferInstanceVersionID
    
    WHERE contactdate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND a.TouchpointChannelAbbr IN ('KPOS','NPOS','TPOS','SHPSRS')
) WITH DATA PRIMARY INDEX(OfferInstanceVersionID);


-----CHECK
/*
select *
from shc_work_tbls.ms_TI_RTS_OfID_Rule a
left join shc_work_tbls.ms_TI_RTS_RTSOfferversionid b
on a.offerinstanceversionid=b.offerinstanceversionid
where messageind='RTS' 
and slotind<>'Slot2'
*/

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
/*
-- SELECT * FROM shc_work_tbls.ms_TI_RTS_issuances SAMPLE 100;
SELECT b.RTS_ind, a.CoBusUnitDesc, a.baseofferdesc, COUNT(OIVD_CSO_Lyl) AS issuances
FROM shc_work_tbls.ms_TI_RTS_issuances AS a
JOIN shc_work_tbls.ms_TI_RTS_RTSOfferversionid AS b
ON a.OfferInstanceVersionID=b.OfferInstanceVersionID
WHERE a.CoBusUnitDesc='SEARS HOME APPLIANCES'
GROUP BY 1,2,3
ORDER BY 1,2,3;


SELECT loyaltyid, ContactDate, CoBusUnitDesc
FROM shc_work_tbls.ms_TI_RTS_issuances
WHERE TouchpointChannelAbbr='NPOS'
GROUP BY 1,2,3
ORDER BY 1,2,3
SAMPLE 1000;
*/

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

-------------------------------------------------
----KPIs-----------------------------------------
-------------------------------------------------

--Issuance by groups
--loyaltyid can be null and -9
DROP TABLE shc_work_tbls.ms_TI_RTS_iss_lyl;
CREATE TABLE shc_work_tbls.ms_TI_RTS_iss_lyl AS
(
SELECT
loyaltyid
,ContactDate
,OfferInstanceVersionID
,RuleDesc
,SlotInd
,TouchPointChannelAbbr
,MessageInd
,COUNT(*) AS issuances

FROM shc_work_tbls.ms_TI_RTS_issuances a

GROUP BY 1,2,3,4,5,6,7
)
WITH DATA PRIMARY INDEX(loyaltyid);

-----------------------------------------------------------------------
----TOTAL--------------------------------------------------------------
-----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--KPOS----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
/*
SELECT
CASE 
WHEN (a.loyaltyid IS NULL OR a.loyaltyid=-9 OR a.loyaltyid=0) THEN 'nSYWMbr'
WHEN kposind='KPOS Default' THEN 'KPOS Regular'
ELSE kposind
END AS kposind
,a.TouchPointChannelAbbr
,a.SlotInd
,a.messageind
--,count(distinct a.loyaltyid) as #CustIss
,SUM(issuances) AS issuances
,SUM(rdmp) AS redemptions
,SUM(NetSales) AS NetSales
,SUM(Margin) AS Margin
,SUM(MarginAdj) AS MarginAdj


FROM 		(SELECT loyaltyid,
			ContactDate,
			TouchPointChannelAbbr,
			SlotInd, 
			OfferInstanceVersionID,
			messageind,
			SUM(issuances) AS issuances 
			FROM shc_work_tbls.ms_TI_RTS_iss_lyl
			--where MessageInd='Other' ---exclude FCP and Layaway messages
			--where ContactDate between '2015-06-04' and current_date
			WHERE ContactDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
			GROUP BY 1,2,3,4,5,6) a
LEFT JOIN shc_work_tbls.ms_TI_RTS_ActCust c
ON a.loyaltyid=c.lyl_id_no
LEFT JOIN (SELECT loyaltyid_iss,
			IssuanceDate,
			OfferInstanceVersionID,
			COUNT(*) AS rdmp, 
			SUM(NetSales) AS netsales, 
			SUM(MarginAdj) AS MarginAdj, 
			SUM(Margin) AS Margin 
			FROM shc_work_tbls.ms_TI_RTS_rdmpt_IT
			--where MessageInd='Other'
			--where IssuanceDate between '2015-06-05' and current_dte
			WHERE IssuanceDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
			GROUP BY 1,2,3) d
ON a.loyaltyid=d.loyaltyid_iss AND a.OfferInstanceVersionID=d.OfferInstanceVersionID AND a.contactdate=d.IssuanceDate
WHERE SlotInd<>'Catalina Slot1'
AND TouchPointChannelAbbr='KPOS'
GROUP BY 1,2,3,4 ;
*/
--------------------------------------------------------------------------------------------------
--NPOS---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
/*
SELECT
CASE 
WHEN (a.loyaltyid IS NULL OR a.loyaltyid=-9 OR a.loyaltyid=0) THEN 'nSYWMbr'
WHEN nposind='NPOS Default' THEN 'NPOS Regular'
ELSE nposind
END AS nposind
,a.TouchPointChannelAbbr
,a.SlotInd
,a.messageind
--,count(distinct a.loyaltyid) as #CustIss
,SUM(issuances) AS issuances
,SUM(rdmp) AS redemptions
,SUM(NetSales) AS NetSales
,SUM(Margin) AS Margin
,SUM(MarginAdj) AS MarginAdj


FROM 		(SELECT loyaltyid,
			ContactDate,
			TouchPointChannelAbbr,
			SlotInd, 
			OfferInstanceVersionID,
			messageind,
			SUM(issuances) AS issuances 
			FROM shc_work_tbls.ms_TI_RTS_iss_lyl
			--where MessageInd='Other' ---exclude FCP and Layaway messages
			--where ContactDate between '2015-06-04' and current_date
			WHERE ContactDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
			GROUP BY 1,2,3,4,5,6) a
LEFT JOIN shc_work_tbls.ms_TI_RTS_ActCust c
ON a.loyaltyid=c.lyl_id_no
LEFT JOIN (SELECT loyaltyid_iss,
			IssuanceDate,
			OfferInstanceVersionID,
			COUNT(*) AS rdmp, 
			SUM(NetSales) AS netsales, 
			SUM(MarginAdj) AS MarginAdj, 
			SUM(Margin) AS Margin 
			FROM shc_work_tbls.ms_TI_RTS_rdmpt_IT
			--where MessageInd='Other'
			--where IssuanceDate between '2015-06-04' and current_date
			WHERE IssuanceDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
			GROUP BY 1,2,3) d
ON a.loyaltyid=d.loyaltyid_iss AND a.OfferInstanceVersionID=d.OfferInstanceVersionID AND a.contactdate=d.IssuanceDate
WHERE SlotInd<>'Catalina Slot1'
AND TouchPointChannelAbbr IN ('NPOS','TPOS','SHPSRS')
GROUP BY 1,2,3,4;

--------------Distribution-------------------------------------------


SELECT CoBusUnitDesc
    , TouchpointChannelAbbr
    , COUNT(*) AS issuances
FROM shc_work_tbls.ms_TI_RTS_issuances a
WHERE ContactDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
AND TouchpointChannelAbbr='NPOS'
AND messageind='RTS'
GROUP BY 1,2;
*/

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
JOIN shc_work_tbls.ms_TI_RTS_RTSOfferversionid b
ON iss.OfferInstanceVersionID=b.OfferInstanceVersionID
GROUP BY 1,2
ORDER BY 1,2;


drop table shc_work_tbls.ms_rts_ti_weekly;
create table shc_work_tbls.ms_rts_ti_weekly as (
SELECT iss.TouchpointChannelAbbr as touchpoint
        , b.RTS_Ind
    , iss.CoBusUnitDesc
    ,contactdate
    , SUM(ZEROIFNULL(iss.issuances)) AS Issuances
    , SUM(ZEROIFNULL(rd.rdmp)) AS Redemptions
    , SUM(ZEROIFNULL(rd.NetSales)) AS NetSales
    , SUM(ZEROIFNULL(rd.adjMargin)) AS adjMargin
FROM
(
    SELECT OfferInstanceVersionID
        , TouchpointChannelAbbr
        , CoBusUnitDesc
        , contactdate
        ,count(*) AS issuances
    FROM shc_work_tbls.ms_TI_RTS_issuances AS a
    WHERE ContactDate BETWEEN DATE '${start_date}' AND DATE'${end_date}'
    AND messageind='RTS'
    group by 1, 2, 3, 4
) AS iss
LEFT JOIN
(
    SELECT OfferInstanceVersionID
    , COUNT(*) AS rdmp
    , SUM(NetSales) AS NetSales
    , SUM(MarginAdj) AS adjMargin
    FROM shc_work_tbls.ms_TI_RTS_rdmpt_IT
    WHERE RedemptionDate BETWEEN DATE '${start_date}' AND DATE '${end_date}'
    GROUP BY 1
) AS rd
ON iss.OfferInstanceVersionID=rd.OfferInstanceVersionID
JOIN shc_work_tbls.ms_TI_RTS_RTSOfferversionid b
ON iss.OfferInstanceVersionID=b.OfferInstanceVersionID
GROUP BY 1,2,3,4
)
with DATA
primary index(Touchpoint);

/*

SELECT b.RTS_Ind
    , iss.CoBusUnitDesc
    , iss.OfferInstanceVersionID
    , iss.baseofferdesc
    , SUM(ZEROIFNULL(iss.issuances)) AS Issuances
    , SUM(ZEROIFNULL(rd.rdmp)) AS Redemptions
    , SUM(ZEROIFNULL(rd.NetSales)) AS NetSales
    , SUM(ZEROIFNULL(rd.Margin)) AS Margin
FROM 
(
    SELECT OfferInstanceVersionID
        , baseofferdesc
        , CoBusUnitDesc
        , TouchpointChannelAbbr
        , ContactDate
        , COUNT(*) AS issuances
    FROM shc_work_tbls.ms_TI_RTS_issuances AS a
    WHERE ContactDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'
    AND TouchpointChannelAbbr='NPOS'
    AND messageind='RTS'
    GROUP BY 1,2,3,4,5
) AS iss
LEFT JOIN 
(
    SELECT OfferInstanceVersionID
    , COUNT(*) AS rdmp
    , SUM(NetSales) AS NetSales
    , SUM(Margin) AS Margin
    FROM shc_work_tbls.ms_TI_RTS_rdmpt_IT
    WHERE RedemptionDate BETWEEN DATE'${start_date}' AND DATE'${end_date}'+7
    GROUP BY 1
) AS rd
ON iss.OfferInstanceVersionID=rd.OfferInstanceVersionID
--	AND iss.
JOIN shc_work_tbls.ms_TI_RTS_RTSOfferversionid b
ON iss.OfferInstanceVersionID=b.OfferInstanceVersionID
WHERE iss.TouchpointChannelAbbr<>'KPOS'
AND iss.CoBusUnitDesc='SEARS APPAREL'
GROUP BY 1,2,3,4
ORDER BY 1,2,3;

*/
EOF 


