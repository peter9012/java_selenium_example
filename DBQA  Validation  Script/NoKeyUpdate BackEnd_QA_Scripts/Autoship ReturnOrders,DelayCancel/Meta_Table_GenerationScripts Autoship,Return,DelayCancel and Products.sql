USE [DataMigration];
GO

/****** Object:  Table [dbo].[dm_log]    Script Date: 2/8/2016 2:36:56 PM ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_PADDING ON;
GO

CREATE TABLE [dbo].[dm_log]
    (
      [test_area] [VARCHAR](MAX) NULL ,
      [test_type] [VARCHAR](MAX) NULL ,
      [rfo_column] [VARCHAR](MAX) NULL ,
      [hybris_column] [VARCHAR](MAX) NULL ,
      [hyb_key] [VARCHAR](MAX) NULL ,
      [hyb_value] [VARCHAR](MAX) NULL ,
      [rfo_key] [VARCHAR](MAX) NULL ,
      [rfo_value] [VARCHAR](MAX) NULL
    )
ON  [PRIMARY] TEXTIMAGE_ON [PRIMARY];

GO

SET ANSI_PADDING OFF;
GO

/****** Object:  Table [dbo].[map_tab]    Script Date: 2/8/2016 2:34:03 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
SET ANSI_PADDING ON;
GO
CREATE TABLE [dbo].[map_tab]
    (
      [id] [SMALLINT] NOT NULL ,
      [Schema ] [VARCHAR](225) NULL ,
      [RFO_Table] [VARCHAR](MAX) NULL ,
      [RFO_Column ] [VARCHAR](MAX) NULL ,
      [RFO_DataType ] [VARCHAR](225) NULL ,
      [RFO_Reference Table] [VARCHAR](225) NULL ,
      [Hybris_Table] [VARCHAR](MAX) NULL ,
      [Hybris_Column ] [VARCHAR](MAX) NULL ,
      [Hybris_Reference Table] [VARCHAR](225) NULL ,
      [Hybris_DataType] [VARCHAR](225) NULL ,
      [flag] [VARCHAR](225) NULL ,
      [owner] [VARCHAR](225) NULL ,
      [prev_run_err] [INT] NULL
    )
ON  [PRIMARY] TEXTIMAGE_ON [PRIMARY];

GO
SET ANSI_PADDING OFF;
GO
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 1 ,
          N'Hybris' ,
          N'Autoship' ,
          N'coalesce(enddate, ''1900-01-01'')' ,
          N'datetime' ,
          N'enddate' ,
          N'Orders' ,
          N'p_cancelationdate' ,
          N'' ,
          N'datetime' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 2 ,
          N'Hybris' ,
          N'Autoship' ,
          N'active' ,
          N'bit' ,
          N'active' ,
          N'Orders' ,
          N'p_active' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 3 ,
          N'Hybris' ,
          N'(select asp.autoshipid, asp.autoshipnumber, count(*) ordercount
from #tempact asp,
hybris.orders ord 
where asp.autoshipid = ord.autoshipid 
and ord.orderstatusid not in (1,3) 
group by asp.autoshipid, asp.autoshipnumber)a' ,
          N'coalesce(a.ordercount, 0)' ,
          N'' ,
          N'ordercount' ,
          N'Orders' ,
          N'p_ordercount' ,
          N'' ,
          N'int' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 4 ,
          N'Hybris' ,
          N'(select asp.autoshipid, asp.autoshipnumber, count(*) failurecount
from #tempact asp,
hybris.orders ord
where asp.autoshipid = ord.autoshipid 
and ord.orderstatusid in (1,3) 
group by asp.autoshipid, asp.autoshipnumber)a' ,
          N'coalesce(a.failurecount, 0)' ,
          N'' ,
          N'failurecount' ,
          N'Orders' ,
          N'p_ccfailurecount' ,
          N'' ,
          N'int' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 5 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'Use Hybris pk from user table based on RFO accountid' ,
          N'Orders' ,
          N'p_customer' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          37441
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 6 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_versionid' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 7 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_originalversion' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 8 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_fraudulent' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 9 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_potentiallyfraudulent' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 10 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'8796105932891' ,
          N'Orders' ,
          N'p_salesapplication' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 11 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'8796125855777' ,
          N'Orders' ,
          N'currencypk' ,
          N'dbo.currency' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 12 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'deliverystatuspk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 13 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'Special Value in Hybris' ,
          N'' ,
          N'globaldiscountvalues' ,
          N'' ,
          N'text' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 14 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'paymentcost' ,
          N'' ,
          N'decimal' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 15 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid, b.autoshippaymentid
from #tempact a
left join hybris.AutoshipPayment b
on a.autoshipid= b.autoshipid 

join hybris.dbo.paymentinfos c
on b.autoshippaymentid=c.pk
and b.autoshipid=c.ownerpkstring
and duplicate = 1
group by a.autoshipnumber, a.autoshipid, b.autoshippaymentid)a' ,
          N'a.AutoshipPaymentID' ,
          N'' ,
          N'AutoshipPaymentID' ,
          N'Orders' ,
          N'paymentinfopk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 16 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'paymentmodepk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 17 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'paymentstatuspk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 18 ,
          N'Hybris' ,
          N'(SELECT  t1.AutoshipNumber ,
        CASE WHEN t2.Name = ''Submitted'' THEN ''8796135030875''
             WHEN t2.Name = ''Cancelled'' THEN ''8796093284443''
             WHEN t2.Name = ''Failed'' THEN ''8796135030875''
        END AS PK
FROM    #tempact t1 ,
        RFO_Reference.AutoshipStatus t2 ,
        Hybris.dbo.vEnumerationValues t3
WHERE   t1.AutoshipStatusId = t2.AutoshipStatusId
        AND t2.Name = t3.Value
        AND t3.[Type] = ''orderstatus''
GROUP BY t1.AutoshipNumber ,
        CASE WHEN t2.Name = ''Submitted'' THEN ''8796135030875''
             WHEN t2.Name = ''Cancelled'' THEN ''8796093284443''
             WHEN t2.Name = ''Failed'' THEN ''8796135030875''
        END )a' ,
          N'a.pk' ,
          N'' ,
          N'status' ,
          N'Orders' ,
          N'statuspk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 19 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_exportstatus' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 20 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'statusinfo' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 21 ,
          N'Hybris' ,
          N'Autoship' ,
          N'[Total]' ,
          N'' ,
          N'[Total]' ,
          N'Orders' ,
          N'totalprice' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-Autoship' ,
          4
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 22 ,
          N'Hybris' ,
          N'Autoship' ,
          N'[TotalDiscount] ' ,
          N'' ,
          N'[TotalDiscount] ' ,
          N'Orders' ,
          N'totaldiscounts' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 23 ,
          N'Hybris' ,
          N'Autoship' ,
          N'a.TotalTax' ,
          N'' ,
          N'[TotalTax]' ,
          N'Orders' ,
          N'totaltax' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-Autoship' ,
          4
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 24 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_trackingid' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 25 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'824-Autoship' ,
          1373487
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 26 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_istaxcalculationfailed' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 27 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_previousdeliverymode' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 28 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'No mapping' ,
          N'' ,
          N'p_site' ,
          N'' ,
          N'bigint' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 29 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'8796093056989' ,
          N'Orders' ,
          N'p_store' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 30 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_totalamountwithouttax' ,
          N'' ,
          N'decimal' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 31 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_taxmanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 34 ,
          N'Hybris' ,
          N'Autoship' ,
          N'coalesce(CompletionDate, ''1900-01-01'')' ,
          N'' ,
          N'CompletionDate' ,
          N'Orders' ,
          N'p_ordercompletiondate' ,
          N'' ,
          N'datetime' ,
          N'c2c' ,
          N'824-Autoship' ,
          1366757
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 35 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'p_commissiondate' ,
          N'' ,
          N'datetime' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 36 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'8796093056981' ,
          N'Orders' ,
          N'p_warehouse' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 37 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'www.rodanandfields.com' ,
          N'Orders' ,
          N'p_origination' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 38 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_departmentselect' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 39 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_overridetype' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 40 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_overridereason' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 41 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'p_totalsavingforpc' ,
          N'' ,
          N'float' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 42 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'nvarchar' ,
          N'' ,
          N'Orders' ,
          N'p_createdby' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          37441
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 43 ,
          N'Hybris' ,
          N'Hybris.Autoship' ,
          N'modifiedbyuser' ,
          N'nvarchar' ,
          N'' ,
          N'Orders' ,
          N'cast(p_lastmodifiedby as nvarchar(100))' ,
          N'' ,
          N'bigint' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 44 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_taxmanuallychangedvalue' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 45 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_deliverycostmanuallychanged' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 46 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_handlingcostmanuallychanged' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 47 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_associatedorder' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 48 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_associatedtemplate' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 49 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'Use Hybris pk from user table based on RFO accountid' ,
          N'Orders' ,
          N'userpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          37441
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 50 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_rforderstatus' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 51 ,
          N'Hybris' ,
          N'(SELECT   ash.AutoShipID ,
                al.completiondate
       FROM     #tempact ash
                JOIN ( SELECT   AutoShipID ,
                                MAX(CompletionDate) AS completiondate
                                            --OrderStatusID
                       FROM     RFOperations.Hybris.Orders
                       WHERE    CountryID = 236--@CountryID
                                AND OrderStatusID NOT IN ( 1, 3 )
                       GROUP BY AutoShipID
                     ) al ON al.AutoShipID = ash.AutoShipID)a' ,
          N'a.completiondate' ,
          N'datetime' ,
          N'Lastprocessingdate' ,
          N'Orders' ,
          N'p_lastprocessingdate' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 52 ,
          N'Hybris' ,
          N'Autoship' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Orders' ,
          N'p_template' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 53 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'case when autoshiptypeid = 1 then 8796134473819 else 8796134506587 end' ,
          N'' ,
          N'frequency' ,
          N'Orders' ,
          N'p_frequency' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 54 ,
          N'Hybris' ,
          N'Autoship' ,
          N'active' ,
          N'bit' ,
          N'active' ,
          N'Orders' ,
          N'netflag' ,
          N'' ,
          N'tinyint' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 55 ,
          N'Hybris' ,
          N'Autoship' ,
          N'coalesce(testorder, '''')' ,
          N'bit' ,
          N'testorder' ,
          N'Orders' ,
          N'p_testorder' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 56 ,
          N'Hybris' ,
          N'Autoship' ,
          N'coalesce(donotship, '''')' ,
          N'bit' ,
          N'donotship' ,
          N'Orders' ,
          N'p_donotship' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 57 ,
          N'Hybris' ,
          N'Autoship' ,
          N'ConsultantID' ,
          N'bigint' ,
          N'ConsultantID' ,
          N'Orders' ,
          N'p_consultantIdReceivingCommiss' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 58 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'case when autoshiptypeid = 1 then startdate else dateadd(month, 1, startdate) end' ,
          N'' ,
          N'startdate' ,
          N'Orders' ,
          N'p_firstscheduledautoshipdate' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 59 ,
          N'Hybris' ,
          N'Autoship' ,
          N'SiteID' ,
          N'bigint' ,
          N'SiteID' ,
          N'Orders' ,
          N'p_siteid' ,
          N'' ,
          N'nvarchar' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 60 ,
          N'Hybris' ,
          N'Autoship' ,
          N'coalesce(NextRunDate, ''1900-01-01'')' ,
          N'datetime' ,
          N'NextRunDate' ,
          N'Orders' ,
          N'p_schedulingdate' ,
          N'' ,
          N'datetime' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 61 ,
          N'Hybris' ,
          N'Autoship' ,
          N'[QV]' ,
          N'' ,
          N'[QV]' ,
          N'Orders' ,
          N'p_totalqv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 62 ,
          N'Hybris' ,
          N'Autoship' ,
          N'CV' ,
          N'money' ,
          N'CV' ,
          N'Orders' ,
          N'p_totalcv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 63 ,
          N'Hybris' ,
          N'Autoship' ,
          N'[SubTotal]' ,
          N'' ,
          N'[SubTotal]' ,
          N'Orders' ,
          N'subtotal' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 64 ,
          N'Hybris' ,
          N'(select * from (select distinct autoshipid, autoshipnumber, templateid, consecutivedelaycount, row_number() over (partition by templateid order by adcl.servermodifieddate desc) rn
from #tempact asp,
 logging.autoshipdelaycancellationlog adcl
 where asp.autoshipid=adcl.templateid) tmp
where tmp.rn = 1)a' ,
          N'a.ConsecutiveDelayCount' ,
          N'' ,
          N'recent consecutivedelaycount' ,
          N'Orders' ,
          N'p_consicutivenoofdelay' ,
          N'' ,
          N'int' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 65 ,
          N'Hybris' ,
          N'(select a.autoshipid, a.autoshipnumber, b.*
from #tempact a,
logging.AutoshipDelayCancellationLog b
where a.autoshipid= b.templateid)a' ,
          N'a.DelayCount' ,
          N'' ,
          N'delaycount' ,
          N'Orders' ,
          N'p_delaycount' ,
          N'' ,
          N'int' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 66 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid, b.AutoshipPaymentAddressID
from #tempact a
left join hybris.AutoshipPaymentAddress b
on a.autoshipid= b.autoshipid)a' ,
          N'a.AutoshipPaymentAddressID' ,
          N'bigint' ,
          N'AutoshipPaymentAddressID' ,
          N'Orders' ,
          N'paymentaddresspk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 67 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.Autoshipid, coalesce(b.ShippingCost,0) as ShippingCost
from #tempact a
left join hybris.AutoshipShipment b
on a.autoshipid= b.autoshipid 
group by a.autoshipnumber, a.Autoshipid, b.ShippingCost)a' ,
          N'a.ShippingCost' ,
          N'money' ,
          N'ShippingCost' ,
          N'Orders' ,
          N'deliverycost' ,
          N'' ,
          N'decimal' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 68 ,
          N'Hybris' ,
          N'(select distinct asp.autoshipid, asp.autoshipnumber, ash.TaxOnShippingCost, ash.TaxOnHandlingCost, asp.totaltax
from #tempact asp
left join hybris.autoshipshipment ash
on asp.autoshipid=ash.autoshipid)a' ,
          N'''[<TV<0_1_0_US TOTAL TAX#'' + CAST(coalesce(a.totaltax, 0) AS NVARCHAR(20)) + ''#true#'' + ''0.0'' + ''#USD>VT>|
<TV<1_1_100001_US SHIPPING TAX#'' + CAST(coalesce(a.TaxOnShippingCost, 0) AS NVARCHAR(20)) + ''#true#''
                + CAST(coalesce(a.TaxOnShippingCost, 0) AS NVARCHAR(20)) + ''#USD>VT>|
<TV<2_1_300001_US HANDLING TAX#''
                + CAST(coalesce(a.TaxOnHandlingCost, 0) AS NVARCHAR(20)) + ''#true#''
                + CAST(coalesce(a.TaxOnHandlingCost, 0) AS NVARCHAR(20)) + ''#USD>VT>]''' ,
          N'' ,
          N'taxvalues' ,
          N'Orders' ,
          N'totaltaxvalues' ,
          N'' ,
          N'nvarchar(-1)' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 69 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid,  b.TaxonShippingCost
from #tempact a,
hybris.AutoshipShipment b
where a.autoshipid= b.autoshipid)a' ,
          N'a.TaxonShippingCost' ,
          N'money' ,
          N'TaxonShippingCost' ,
          N'Orders' ,
          N'p_deliverytaxvalues' ,
          N'' ,
          N'image' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 70 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid, b.TaxonHandlingCost
from #tempact a,
hybris.AutoshipShipment b
where a.autoshipid= b.autoshipid)a' ,
          N'a.TaxonHandlingCost' ,
          N'money' ,
          N'TaxonHandlingCost' ,
          N'Orders' ,
          N'p_handlingcosttaxvalues' ,
          N'' ,
          N'image' ,
          N'No Mapping' ,
          N'824-Autoship' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 71 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.Autoshipid, coalesce(b.HandlingCost,0) as HandlingCost
from #tempact a
left join hybris.AutoshipShipment b
on a.autoshipid= b.autoshipid 
group by a.autoshipnumber, a.Autoshipid, b.HandlingCost)a' ,
          N'a.HandlingCost' ,
          N'money' ,
          N'HandlingCost' ,
          N'Orders' ,
          N'handlingcost' ,
          N'' ,
          N'decimal' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 72 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid, b.AutoshipShippingAddressID
from #tempact a
left join hybris.AutoshipShippingAddress b
on a.autoshipid= b.autoshipid)a' ,
          N'a.AutoshipShippingAddressID' ,
          N'bigint' ,
          N'AutoshipShippingAddressID' ,
          N'Orders' ,
          N'deliveryaddresspk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 73 ,
          N'Hybris' ,
          N'Autoship' ,
          N'coalesce(taxExempt, ''0'')' ,
          N'bit' ,
          N'taxExempt' ,
          N'Orders' ,
          N'p_taxexempt' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 74 ,
          N'Hybris' ,
          N'(select distinct asp.autoshipid, asp.autoshipnumber,dm.pk as shippingmethod
from #tempact asp
left join hybris.autoshipshipment ash
on asp.autoshipid=ash.autoshipid
left join [RFO_Reference].[ShippingMethod] sm
on ash.shippingmethodid=sm.shippingmethodid
left join hybris.[dbo].[deliverymodes] dm
on sm.name=dm.code)a' ,
          N'a.ShippingMethod' ,
          N'' ,
          N'ShippingMethod' ,
          N'Orders' ,
          N'deliverymodepk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-Autoship' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 75 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.BasePrice' ,
          N'' ,
          N'BasePrice' ,
          N'OrderEntries' ,
          N'baseprice' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 76 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'calculatedflag' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 78 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'[]' ,
          N'OrderEntries' ,
          N'discountvalues' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 79 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.LineItemNo-1' ,
          N'' ,
          N'LineItemNo' ,
          N'OrderEntries' ,
          N'entrynumber' ,
          N'' ,
          N'int' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 81 ,
          N'Hybris' ,
          N'(select a.autoshipid, b.pk
from #tempact a
join Hybris.dbo.products b
on b.p_rflegacyproductid = a.ProductID 
where p_catalognumber IS NOT NULL
and p_catalog = ''8796093088344''
and p_catalogversion = ''8796093153881''
group by a.autoshipid, b.pk) a' ,
          N'a.pk' ,
          N'' ,
          N'ProductID' ,
          N'OrderEntries' ,
          N'productpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipItem' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 82 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.Quantity' ,
          N'' ,
          N'Quantity' ,
          N'OrderEntries' ,
          N'quantity' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 83 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'''[<TV<''+cast(a.lineitemno-1 as nvarchar(5))+''_1_''+cast(a.lineitemno-1 as nvarchar(5))+''_US TOTAL TAX#''+ CAST(coalesce(a.TotalTax, 0) AS NVARCHAR(20)) + ''#true#'' + ''0.0'' + ''#USD>VT>]''' ,
          N'' ,
          N'taxvalues' ,
          N'OrderEntries' ,
          N'taxvalues' ,
          N'' ,
          N'nvarchar' ,
          N'manual' ,
          N'824-AutoshipItem' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 85 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.totalprice' ,
          N'' ,
          N'totalprice' ,
          N'OrderEntries' ,
          N'totalprice' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 86 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'8796093054986' ,
          N'OrderEntries' ,
          N'unitpk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 87 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'giveawayflag' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 88 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'rejectedflag' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 89 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'Autoship' ,
          N'' ,
          N'AutoshipId' ,
          N'OrderEntries' ,
          N'orderpk' ,
          N'' ,
          N'bigint' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 90 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_chosenvendor' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 91 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_deliveryaddress' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 92 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_deliverymode' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 93 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_nameddeliverydate' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 94 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_quantitystatus' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 97 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_isreturned' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 99 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.ServerModifiedDate' ,
          N'' ,
          N'ModifiedTime' ,
          N'OrderEntries' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'datetime' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 100 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.QV' ,
          N'' ,
          N'QV' ,
          N'OrderEntries' ,
          N'p_qv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 101 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.CV' ,
          N'' ,
          N'CV' ,
          N'OrderEntries' ,
          N'p_cv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 102 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.RetailProfit' ,
          N'' ,
          N'RetailProfit' ,
          N'OrderEntries' ,
          N'p_retailprofit' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 103 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'coalesce(a.WholeSaleprice, 0)' ,
          N'' ,
          N'WholeSaleprice' ,
          N'OrderEntries' ,
          N'p_wholesaleprice' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 104 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_basepricemanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 106 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_cvmanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 107 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_qvmanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 108 ,
          N'Hybris' ,
          N'AutoshipItem' ,
          N'a.TaxablePrice' ,
          N'' ,
          N'TaxablePrice' ,
          N'OrderEntries' ,
          N'p_taxableprice' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 109 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_restockingfees' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
GO
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 110 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_restockingfeetax' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 111 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'oldprice' ,
          N'' ,
          N'decimal' ,
          N'defaults' ,
          N'824-AutoshipItem' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 112 ,
          N'Hybris' ,
          N'Sites' ,
          N'SiteID' ,
          N'BigInt' ,
          N'' ,
          N'Users' ,
          N'P_siteId' ,
          N'' ,
          N'' ,
          N'C2C' ,
          N'817-Sites' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 113 ,
          N'Hybris' ,
          N'Sites' ,
          N'AccountID' ,
          N'BigInt' ,
          N'Values loaded from Account Table' ,
          N'Users' ,
          N'P_rfaccountid' ,
          N'' ,
          N'' ,
          N'C2C' ,
          N'817-Sites' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 114 ,
          N'Hybris' ,
          N'Sites' ,
          N'SitePrefix' ,
          N'Nvarchar(255)' ,
          N'' ,
          N'Users' ,
          N'p_customurlprefix' ,
          N'' ,
          N'' ,
          N'C2C' ,
          N'817-Sites' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 115 ,
          N'Hybris' ,
          N'Sites' ,
          N'StartDate' ,
          N'datetime' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 116 ,
          N'Hybris' ,
          N'Sites' ,
          N'EndDate' ,
          N'datetime' ,
          N'Do we only migrate accounts with NULL end date?' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 117 ,
          N'Hybris' ,
          N'Sites' ,
          N'ServerModifiedDate' ,
          N'datetime' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 118 ,
          N'Hybris' ,
          N'Sites' ,
          N'ChangedByApplication' ,
          N'nvarchar(250)' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_UpdatedByApplication' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122063
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 119 ,
          N'Hybris' ,
          N'Sites' ,
          N'ChangedByUser' ,
          N'nvarchar(250)' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_updatedbyuser' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122063
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 120 ,
          N'Hybris' ,
          N'Sites' ,
          N'Active' ,
          N'bit' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 121 ,
          N'Hybris' ,
          N'Sites' ,
          N'ExpirationDate' ,
          N'datetime' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_expirationdate' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          2
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 122 ,
          N'Hybris' ,
          N'Sites' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 123 ,
          N'Hybris' ,
          N'(select a.accountid,b.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b
 Where a.siteId=b.siteid) a' ,
          N'SiteURLID' ,
          N'bigint' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 124 ,
          N'Hybris' ,
          N'(select a.accountid,b.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b
 Where a.siteId=b.siteid) a' ,
          N'SiteDomainID' ,
          N'bigint' ,
          N'Hybris has all NULL Value,skiped ' ,
          N'users' ,
          N'p_domain' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 125 ,
          N'Hybris' ,
          N'(select a.accountid,b.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b
 Where a.siteId=b.siteid) a' ,
          N'SiteID' ,
          N'bigint' ,
          N'Not to be mapped.' ,
          N'users' ,
          N'p_siteid' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 126 ,
          N'Hybris' ,
          N'(select a.accountid,b.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b
 Where a.siteId=b.siteid) a' ,
          N'ServerModifiedDate' ,
          N'datetime' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 127 ,
          N'Hybris' ,
          N'(select a.accountid,b.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b
 Where a.siteId=b.siteid) a' ,
          N'ChangedByApplication' ,
          N'nvarchar(250)' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_UpdatedByApplication' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 128 ,
          N'Hybris' ,
          N'(select a.accountid,b.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b
 Where a.siteId=b.siteid) a' ,
          N'ChangedByUser' ,
          N'nvarchar(250)' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_updatedbyuser' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 129 ,
          N'Hybris' ,
          N'(select a.accountid,c.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b,
 rfoperations.Hybris.siteDomain c
 Where a.siteId=b.siteid
  and B.siteDomainID=C.SiteDomainID) a' ,
          N'SiteDomainID' ,
          N'bigint' ,
          N'Hybris has all NULL Value,skiped ' ,
          N'users' ,
          N'p_domain' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 130 ,
          N'Hybris' ,
          N'(select a.accountid,c.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b,
 rfoperations.Hybris.siteDomain c
 Where a.siteId=b.siteid
  and B.siteDomainID=C.SiteDomainID) a' ,
          N'Code' ,
          N'nvarchar(50)' ,
          N'Identifier to differentiate COM or BIZ.' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 131 ,
          N'Hybris' ,
          N'(select a.accountid,c.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b,
 rfoperations.Hybris.siteDomain c
 Where a.siteId=b.siteid
  and B.siteDomainID=C.SiteDomainID) a' ,
          N'Name' ,
          N'nvarchar(255)' ,
          N'Values myrandf.com OR myrandf.biz' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 132 ,
          N'Hybris' ,
          N'(select a.accountid,c.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b,
 rfoperations.Hybris.siteDomain c
 Where a.siteId=b.siteid
  and B.siteDomainID=C.SiteDomainID) a' ,
          N'ServerModifiedDate' ,
          N'datetime' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 133 ,
          N'Hybris' ,
          N'(select a.accountid,c.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b,
 rfoperations.Hybris.siteDomain c
 Where a.siteId=b.siteid
  and B.siteDomainID=C.SiteDomainID) a' ,
          N'ChangedByApplication' ,
          N'nvarchar(250)' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_UpdatedByApplication' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 134 ,
          N'Hybris' ,
          N'(select a.accountid,c.* from rfoperations.Hybris.sites a,
 rfoperations.hybris.siteURLs b,
 rfoperations.Hybris.siteDomain c
 Where a.siteId=b.siteid
  and B.siteDomainID=C.SiteDomainID) a' ,
          N'ChangedByUser' ,
          N'nvarchar(250)' ,
          N'Value loaded from Account Table.' ,
          N'users' ,
          N'p_updatedbyuser' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'817-sites' ,
          122064
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 135 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'a.returnordernumber' ,
          N'' ,
          N'returnordernumber' ,
          N'ReturnRequest' ,
          N'p_code' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          21
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 136 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'returnordernumber' ,
          N'' ,
          N'returnordernumber' ,
          N'ReturnRequest' ,
          N'p_rma' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 137 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'8796125855777' ,
          N'ReturnRequest' ,
          N'p_currency' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 138 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'a.OrderID' ,
          N'' ,
          N'OrderID' ,
          N'ReturnRequest' ,
          N'p_order' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          166899
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 139 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'total' ,
          N'' ,
          N'totalamt' ,
          N'ReturnRequest' ,
          N'p_totalAmountToRefund' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          21
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 140 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'total' ,
          N'' ,
          N'totalamt' ,
          N'ReturnRequest ' ,
          N'p_totalAmountRefunded   ' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          21
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 141 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'ReturnRequest' ,
          N'p_shouldRefundShippingPrice' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 142 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'ReturnRequest' ,
          N'p_refundShippingPrice' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 143 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'ReturnRequest' ,
          N'p_refundedShippingPriceTax' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 144 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'www.rodanandfields.com' ,
          N'ReturnRequest' ,
          N'p_origination' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 145 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'user' ,
          N'ReturnRequest' ,
          N'p_createdBy' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-Returns' ,
          21
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 146 ,
          N'Hybris' ,
          N'(select b.notes, a.returnorderid
from #tempact a
left join hybris.ReturnNotes b
on a.returnorderid=b.returnorderid)a' ,
          N'a.notes' ,
          N'' ,
          N'notes' ,
          N'ReturnRequest' ,
          N'p_returnnotes' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-Returns' ,
          1356
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 147 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'ReturnOrderID' ,
          N'' ,
          N'ReturnOrderID' ,
          N'ReturnRequest' ,
          N'p_returnorder' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 148 ,
          N'Hybris' ,
          N'(select distinct a.returnorderid, case when name = ''Legacy POS Order RETURN'' then 8796135587931  when name = ''Legacy Call Tag'' then 8796135620699
   when name = ''Legacy Customer RETURN'' then 8796135653467
  when name = ''Legacy Refused'' then 8796135686235
   when name = ''Legacy Charge Back of Credit Card Charge'' then 8796135719003 end as returntypeid
from hybris.returnorder a,
hybris.returnitem b,
rfo_reference.returntype c
where a.returnorderid=b.returnorderid
and b.[ReturnTypeID]=c.returntypeid
and a.countryid = 236) a' ,
          N'a.ReturnTypeID' ,
          N'' ,
          N'[RFO_Reference].[ReturnType]' ,
          N'ReturnRequest' ,
          N'p_returnType' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-Returns' ,
          139863
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 149 ,
          N'Hybris' ,
          N'(select distinct t1.returnorderid, t1.OrderId, t3.pk
FROM #tempact t1,
RFO_Reference.ReturnReason t2,
Hybris.dbo.vEnumerationValues t3,
hybris.ReturnItem t4
where t1.returnorderid=t4.returnorderid
and t4.ReturnReasonId = t2.ReturnReasonId
and t2.Name = t3.Value
and t3.[Type] = ''RFRefundReason''
group by t1.returnorderid, t1.OrderId, t3.pk)a' ,
          N'a.pk' ,
          N'' ,
          N'ReturnReason' ,
          N'ReturnRequest' ,
          N'p_returnReason' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-Returns' ,
          165733
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 150 ,
          N'Hybris' ,
          N'(select t1.returnorderid, t1.OrderItemID, t2.pk as action
FROM #tempact t1,
Hybris.dbo.vEnumerationValues t2
where t1.action = t2.value
and t2.[Type] = ''ReturnAction''
group by t1.returnorderid, t1.OrderItemID, t2.pk)a' ,
          N'a.Action' ,
          N'' ,
          N'action' ,
          N'ReturnEntry' ,
          N'p_action' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnItems' ,
          190
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 151 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'ReturnRequest' ,
          N'p_returnentiretax' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 152 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'ReturnRequest' ,
          N'p_returnentireshipping' ,
          N'p_returnentireshipping' ,
          N'' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 153 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'[ReceivedQuantity]' ,
          N'' ,
          N'ReceivedQuantity' ,
          N'ReturnEntry' ,
          N'p_receivedQuantity' ,
          N'ReturnEntry' ,
          N'p_receivedQuantity' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 154 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'ReturnEntry' ,
          N'p_reachedDate' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 155 ,
          N'Hybris' ,
          N'(select t1.returnorderid, t1.OrderItemID, t2.pk as [status]
FROM #tempact t1,
Hybris.dbo.vEnumerationValues t2,
RFO_Reference.ReturnStatus t3
where t1.ReturnStatusID = t3.ReturnStatusID
AND t3.name=t2.value
and t2.[Type] = ''ReturnStatus''
group by t1.returnorderid, t1.OrderItemID, t2.pk)a' ,
          N'a.status' ,
          N'' ,
          N'status' ,
          N'ReturnEntry' ,
          N'p_status' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 158 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'templateId' ,
          N'bigint' ,
          N'' ,
          N'autoshiplogs' ,
          N'P_templateid' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'985-ASDC' ,
          17
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 159 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'accountId' ,
          N'bigint' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_rfaccountid' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'985-ASDC' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 160 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'delayCount' ,
          N'int' ,
          N'Hybris Default=0, RFO NULL, PASSED' ,
          N'autoshiplogs' ,
          N'p_totaldelaycount' ,
          N'' ,
          N'int' ,
          N'c2c' ,
          N'985-ASDC' ,
          5637
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 161 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'delayType' ,
          N'int' ,
          N'Hybris Default=0, RFO NULL, PASSED' ,
          N'autoshiplogs' ,
          N'p_delaytype' ,
          N'' ,
          N'int' ,
          N'c2c' ,
          N'985-ASDC' ,
          5637
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 162 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'status' ,
          N'nvarchar(500)' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_status' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'985-ASDC' ,
          2555
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 163 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'logDate' ,
          N'datetime' ,
          N'cast(logdate  as date)' ,
          N'autoshiplogs' ,
          N'p_logdate' ,
          N'' ,
          N'date' ,
          N'c2c' ,
          N'985-ASDC' ,
          9180
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 164 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'reason' ,
          N'nvarchar(500)' ,
          N'Hybris converting character to HTML increasing length,DATA-1405' ,
          N'autoshiplogs' ,
          N'p_reason' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'985-ASDC' ,
          1
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 165 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'daysSinceLastAutoship' ,
          N'int' ,
          N'Hybris Default=0, RFO NULL, PASSED' ,
          N'autoshiplogs' ,
          N'p_dayssincelastautoship' ,
          N'' ,
          N'int' ,
          N'c2c' ,
          N'985-ASDC' ,
          1
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 166 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'originalOrderDate' ,
          N'datetime' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_originalorderdate' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'985-ASDC' ,
          5356
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 167 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'newDate' ,
          N'datetime' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_newDate' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'985-ASDC' ,
          33
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 168 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'consecutiveDelayCount' ,
          N'int' ,
          N'Hybris Default=0, RFO NULL, PASSED' ,
          N'autoshiplogs' ,
          N'p_consecutivedelaycount' ,
          N'' ,
          N'int' ,
          N'c2c' ,
          N'985-ASDC' ,
          2555
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 169 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'orderTotalCount' ,
          N'int' ,
          N'Hybris Default=0, RFO NULL, PASSED' ,
          N'autoshiplogs' ,
          N'p_ordertotalcount' ,
          N'' ,
          N'int' ,
          N'c2c' ,
          N'985-ASDC' ,
          2
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 170 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'tookOrderAfterDelay' ,
          N'bit' ,
          N'Hybris Default=0, RFO NULL, PASSED' ,
          N'autoshiplogs' ,
          N'p_tookorderafterdelay' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'985-ASDC' ,
          2555
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 171 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'selfService' ,
          N'bit' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_selfservice' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'985-ASDC' ,
          1
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 172 ,
          N'logging' ,
          N'(select distinct a.[autoshipDelayCancellationLogId],a.AccountId, c.*
from rfoperations.logging.autoshipDelayCancellationLog a
JOIN rfoperations.[RFO_Accounts].[AccountBase]b ON a.accountid=b.AccountID
join rfoperations.[RFO_Reference].[AccountType] c ON b.AccountTypeID=c.accounttypeid)a' ,
          N'Name' ,
          N'nvarchar(500)' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_usertype' ,
          N'' ,
          N'nvarchar(255)' ,
          N'Manual' ,
          N'985-ASDC' ,
          7541
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 173 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'userName' ,
          N'nvarchar(500)' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_username' ,
          N'' ,
          N'nvarchar(255)' ,
          N'c2c' ,
          N'985-ASDC' ,
          2555
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 174 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'CancellationMethodId' ,
          N'int' ,
          N'REFERENCES [RFO_Reference].[CancelingMethod] ([CancelingMethodId])' ,
          N'N/A' ,
          N'N/A' ,
          N'' ,
          N'' ,
          N'N/A' ,
          N'985-ASDC' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 175 ,
          N'logging' ,
          N'(select distinct a.[autoshipDelayCancellationLogId],a.AccountId, b.*
from logging.autoshipDelayCancellationLog a
join [RFO_Reference].[CancelingRequestSource] b
on a.CancellationSourceId=b.CancelingRequestSourceId) a' ,
          N'[Description]' ,
          N'NVARCHA(100)' ,
          N'' ,
          N'autoshiplogs' ,
          N'p_source ' ,
          N'' ,
          N'nvarchar(255)' ,
          N'manual' ,
          N'985-ASDC' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 176 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'ServerModifiedDate' ,
          N'datetime' ,
          N'' ,
          N'orders' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'datetime' ,
          N'Ref_Manual' ,
          N'985-ASDC' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 177 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'ChangedByApplication' ,
          N'nvarchar(500)' ,
          N'' ,
          N'users' ,
          N'p_UpdatedByApplication' ,
          N'' ,
          N'' ,
          N'Ref_Manual' ,
          N'985-ASDC' ,
          391865
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 178 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'ChangedByUser' ,
          N'nvarchar(500)' ,
          N'' ,
          N'users' ,
          N'p_updatedbyuser' ,
          N'' ,
          N'' ,
          N'Ref_Manual' ,
          N'985-ASDC' ,
          391865
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 179 ,
          N'logging' ,
          N'autoshipDelayCancellationLog' ,
          N'LastProcessingDate' ,
          N'datetime' ,
          N'' ,
          N'Orders' ,
          N'p_lastprocessingdate' ,
          N'' ,
          N'datetime' ,
          N'Ref_Manual' ,
          N'985-ASDC' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 180 ,
          N'logging' ,
          N'(select distinct a.templateid, b.*
from logging.autoshipDelayCancellationLog a
join [RFO_Reference].[CancellationReasons] b
on a.CancellationReasonId=b.CancellationReasonId) a' ,
          N'CancellationReasonID' ,
          N'bigint' ,
          N'[RFO_Reference].[CancellationReasons].name' ,
          N'' ,
          N'N/A' ,
          N'' ,
          N'' ,
          N'N/A' ,
          N'985-ASDC' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 181 ,
          N'Hybris' ,
          N'(select apa.autoshippaymentaddressid, ap.autoshipid, max(ad.addressid) pk
from #tempact ap
join hybris.autoshippaymentaddress apa
on ap.autoshipid=apa.autoshipid

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid

join RFO_Accounts.AccountContactAddresses aca
on ac.accountcontactid=aca.accountcontactid

left join RFO_Accounts.Addresses ad
on aca.addressid=ad.addressid
and IsDefault = 1 and ad.addresstypeid = 3 
group by apa.autoshippaymentaddressid, ap.autoshipid)a' ,
          N'a.pk' ,
          N'' ,
          N'AddressID' ,
          N'Addresses' ,
          N'p_rfaddressid' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'824-AutoshipPaymentAddress' ,
          1461238
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 182 ,
          N'Hybris' ,
          N'(SELECT a.* ,b.AutoshipPaymentID  FROM #tempact a
JOIN Hybris.autoshippayment b ON b.AutoshipID = a.AutoshipID)a' ,
          N'a.AutoshipPaymentID' ,
          N'' ,
          N'AutoshipID' ,
          N'Addresses' ,
          N'OwnerPkString' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipPaymentAddress' ,
          1461238
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 183 ,
          N'Migration' ,
          N'(select distinct a.AutoshipPaymentAddressID, a.AutoshipID, c.code, d.pk
from [Hybris].[AutoshipPaymentAddress] a,
#tempact b,
dbo.regionmapping c,
hybris.dbo.regions d
where a.autoshipid=b.autoshipid
and a.region=c.code
and c.code=d.isocode)a' ,
          N'a.pk' ,
          N'' ,
          N'Region' ,
          N'Addresses' ,
          N'regionpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipPaymentAddress' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 184 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Addresses' ,
          N'p_Billingaddress' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'824-AutoshipPaymentAddress' ,
          1461238
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 185 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'Telephone' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_Phone1' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          348
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 186 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'Locale' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_town' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          383
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 187 ,
          N'' ,
          N'' ,
          N'countryid' ,
          N'' ,
          N'8796100624418' ,
          N'Addresses' ,
          N'countrypk' ,
          N'' ,
          N'nvarchar(225)' ,
          N'defaults' ,
          N'824-AutoshipPaymentAddress' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 188 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'Address1' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_streetname' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          494
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 189 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'AddressLine2' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_streetnumber' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          349
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 190 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'PostalCode' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_postalCode' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          348
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 191 ,
          N'RFO_Accounts' ,
          N'(select apa.autoshippaymentaddressid, ap.autoshipid, birthday
from #tempact ap
join hybris.autoshippaymentaddress apa
on ap.autoshipid=apa.autoshipid 

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid
group by apa.autoshippaymentaddressid, ap.autoshipid, birthday)a' ,
          N'a.birthday' ,
          N'' ,
          N'Birthday' ,
          N'Addresses' ,
          N'p_dateofbirth' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'824-AutoshipPaymentAddress' ,
          1340224
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 192 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'FirstName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_firstname' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          362
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 193 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'MiddleName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_MiddleName' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          348
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 194 ,
          N'Hybris' ,
          N'AutoshipPaymentAddress' ,
          N'LastName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_LastName' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'824-AutoshipPaymentAddress' ,
          436
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 195 ,
          N'RFO_Accounts' ,
          N'(select apa.autoshippaymentaddressid, ap.autoshipid, 
case when [GenderId] = 1 then ''8796093874267''
     when [GenderId] = 2 then ''8796093841499'' else null end Gender
from #tempact ap
join hybris.autoshippaymentaddress apa
on ap.autoshipid=apa.autoshipid

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid
group by apa.autoshippaymentaddressid, ap.autoshipid, [GenderId])a' ,
          N'a.Gender' ,
          N'' ,
          N'GenderId' ,
          N'Addresses' ,
          N'p_Gender' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'824-AutoshipPaymentAddress' ,
          348
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 196 ,
          N'Hybris' ,
          N'(SELECT  apa.AutoshipShippingAddressID ,
        ap.AutoshipID ,
        MAX(ad.AddressID) pk
FROM    #tempact ap        
        JOIN Hybris.AutoshipShippingAddress apa ON ap.AutoshipID = apa.AutoShipID
        JOIN RFO_Accounts.AccountContacts ac ON ap.AccountID = ac.AccountId
        JOIN RFO_Accounts.AccountContactAddresses aca ON ac.AccountContactId = aca.AccountContactId
        LEFT JOIN RFO_Accounts.Addresses ad ON aca.AddressID = ad.AddressID
                                               AND IsDefault = 1
                                               AND ad.AddressTypeID = 2
GROUP BY apa.AutoshipShippingAddressID ,
        ap.AutoshipID)a' ,
          N'a.pk' ,
          N'' ,
          N'AddressID' ,
          N'Addresses' ,
          N'p_rfaddressid' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'824-AutoshipShippingAddress' ,
          1461848
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 197 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'AutoshipID' ,
          N'' ,
          N'AutoshipID' ,
          N'Addresses' ,
          N'OwnerPkString' ,
          N'' ,
          N'bigint' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 198 ,
          N'Migration' ,
          N'(select distinct a.AutoshipShippingAddressID, a.AutoshipID, c.code, d.pk
from [Hybris].[AutoshipShippingAddress] a,
#tempact b,
dbo.regionmapping c,
hybris.dbo.regions d
where a.autoshipid=b.autoshipid
and a.region=c.code
and c.code=d.isocode)a' ,
          N'a.pk' ,
          N'' ,
          N'Region' ,
          N'Addresses' ,
          N'regionpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipShippingAddress' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 199 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Addresses' ,
          N'p_Billingaddress' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'824-AutoshipShippingAddress' ,
          1461848
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 200 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'Telephone' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_Phone1' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 201 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'Locale' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_town' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          2
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 202 ,
          N'' ,
          N'' ,
          N'countryid' ,
          N'' ,
          N'8796100624418' ,
          N'Addresses' ,
          N'countrypk' ,
          N'' ,
          N'nvarchar(225)' ,
          N'defaults' ,
          N'824-AutoshipShippingAddress' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 203 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'Address1' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_streetname' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          77
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 204 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'AddressLine2' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_streetnumber' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          7
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 205 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'PostalCode' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_postalCode' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 206 ,
          N'RFO_Accounts' ,
          N'(select apa.autoshipShippingaddressid, ap.autoshipid, birthday
from #tempact ap
join hybris.autoshipShippingaddress apa
on ap.autoshipid=apa.autoshipid 

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid
group by apa.autoshipShippingaddressid, ap.autoshipid, birthday)a' ,
          N'a.birthday' ,
          N'' ,
          N'Birthday' ,
          N'Addresses' ,
          N'p_dateofbirth' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'824-AutoshipShippingAddress' ,
          1340617
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 207 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'FirstName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_firstname' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          28
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 208 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'MiddleName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_MiddleName' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 209 ,
          N'Hybris' ,
          N'AutoshipShippingAddress' ,
          N'LastName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_LastName' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'824-AutoshipShippingAddress' ,
          22858
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 210 ,
          N'RFO_Accounts' ,
          N'(select apa.autoshipShippingaddressid, ap.autoshipid, 
case when [GenderId] = 1 then ''8796093874267''
     when [GenderId] = 2 then ''8796093841499'' else null end Gender
from #tempact ap
join hybris.autoshipShippingaddress apa
on ap.autoshipid=apa.autoshipid
join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid
group by apa.autoshipShippingaddressid, ap.autoshipid, [GenderId])a' ,
          N'a.Gender' ,
          N'' ,
          N'GenderId' ,
          N'Addresses' ,
          N'p_Gender' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'824-AutoshipShippingAddress' ,
          40692
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 211 ,
          N'Hybris' ,
          N'AutoshipPayment' ,
          N'AutoshipPaymentID' ,
          N'' ,
          N'AutoshipPaymentID' ,
          N'paymentinfos' ,
          N'pk' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
GO
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 212 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'pk' ,
          N'paymentinfos' ,
          N'userpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          349
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 213 ,
          N'[RFO_Accounts]' ,
          N'(select t1.autoshipid,  t1.autoshippaymentid, max(t2.paymentprofileid) paymentprofileid
from #tempact t1
join rfo_accounts.paymentprofiles t2
on t1.accountid=t2.accountid
GROUP BY t1.autoshipid,  t1.autoshippaymentid)a' ,
          N'a.paymentprofileid' ,
          N'' ,
          N'paymentprofileid' ,
          N'paymentinfos' ,
          N'p_rfaccountpaymentmethodid' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          495968
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 214 ,
          N'Hybris' ,
          N'(select t1.autoshipid,  t1.autoshippaymentid, t2.paymentprofileid, [dbo].[DecryptTripleDES](t3.AccountNumber)  as ''number''
from #tempact t1
join rfo_accounts.paymentprofiles t2
on t1.accountid=t2.accountid

join [RodanFieldsLive].[dbo].[OrderPayments] t3
on t1.code=t3.orderpaymentid
where ltrim(rtrim(accountnumber)) <> '''' and accountnumber <> ''HDCm5F9HLZ6JyWpnoVViLw==''
and (ltrim(rtrim(billingfirstname)) <> '''' or ltrim(rtrim(billinglastname)) <> '''')
group by t1.autoshipid, t1.autoshippaymentid, t2.paymentprofileid, t3.AccountNumber)a' ,
          N'a.number' ,
          N'' ,
          N'creditcardnumber' ,
          N'paymentinfos' ,
          N'p_number' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 215 ,
          N'Hybris' ,
          N'AutoshipPayment' ,
          N'Expmonth' ,
          N'' ,
          N'Expmonth' ,
          N'paymentinfos' ,
          N'p_validToMonth' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 216 ,
          N'Hybris' ,
          N'AutoshipPayment' ,
          N'ExpYear' ,
          N'' ,
          N'ExpYear' ,
          N'paymentinfos' ,
          N'p_validToYear' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 217 ,
          N'Hybris' ,
          N'(select t1.autoshipid, t1.autoshippaymentid, CONCAT(BillingFirstName, '' '', BillingLastName) as Name
from #tempact t1
join RFO_Accounts.AccountContacts t2
on t1.accountid=t2.accountid

join [RodanFieldsLive].[dbo].[OrderPayments] t3
on t1.code=t3.orderpaymentid
where ltrim(rtrim(accountnumber)) <> '''' and accountnumber <> ''HDCm5F9HLZ6JyWpnoVViLw==''
and (ltrim(rtrim(billingfirstname)) <> '''' or ltrim(rtrim(billinglastname)) <> ''''))a' ,
          N'a.Name' ,
          N'' ,
          N'Name' ,
          N'paymentinfos' ,
          N'p_ccOwner' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 218 ,
          N'Hybris' ,
          N'(select t1.autoshipid, t1.autoshippaymentid, t3.pk as paymenttype
from #tempact t1
join [RFO_Reference].[CreditCardVendors] t2
on t1.Vendorid=t2.VendorID
join Hybris..vEnumerationValues t3
on t3.value=t2.Name
group by t1.autoshipid, t1.autoshippaymentid, t3.pk)a' ,
          N'a.paymenttype' ,
          N'' ,
          N'paymenttype' ,
          N'paymentinfos' ,
          N'p_type' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          6334
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 219 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'AutoshipID' ,
          N'' ,
          N'AutoshipID' ,
          N'paymentinfos' ,
          N'OwnerPkString' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 220 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'Hybris-DM' ,
          N'paymentinfos' ,
          N'p_sourcename' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 221 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'1' ,
          N'paymentinfos' ,
          N'duplicate' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 222 ,
          N'Hybris' ,
          N'(select t1.autoshipid, t1.autoshippaymentid, t2.[AutoshipPaymentAddressID]
from #tempact t1
join [Hybris].[AutoshipPaymentAddress] t2
on t1.[AutoshipID]=t2.[AutoshipID]) a' ,
          N'a.AutoshipPaymentAddressID' ,
          N'' ,
          N'AutoshipPaymentAddressID' ,
          N'paymentinfos' ,
          N'p_billingaddress' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'824-AutoshipPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 223 ,
          N'' ,
          N'(SELECT a.AutoshipID,a.AutoshipNumber,hpi.pk AS Originalpk  FROM #tempact a
			JOIN Hybris.autoship rat ON a.autoshipId=rat.AutoshipID
			JOIN Hybris..users u ON u.p_rfaccountid=CAST(rat.AccountID AS NVARCHAR)
			JOIN Hybris..paymentinfos hpi ON hpi.OwnerPkString=u.pk AND hpi.duplicate=0)a' ,
          N'a.originalpk' ,
          N'' ,
          N'PK of Accountlevel PaymentInfos' ,
          N'paymentinfos' ,
          N'originalpk' ,
          N'' ,
          N'' ,
          N'Manual' ,
          N'824-AutoshipPaymentInfo' ,
          99435
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 224 ,
          N'Hybris' ,
          N'Hybris.Autoship' ,
          N'modifiedbyuser' ,
          N'nvarchar' ,
          N'' ,
          N'Orders' ,
          N'cast(p_lastmodifiedby as nvarchar(100))' ,
          N'' ,
          N'bigint' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 225 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'8796125855777' ,
          N'Orders' ,
          N'currencypk' ,
          N'dbo.currency' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 226 ,
          N'Hybris' ,
          N'(select a.returnorderid, a.orderid, b.OrderShippingAddressID
from #tempact a
left join hybris.OrderShippingAddress b
on a.orderid= b.orderid)a' ,
          N'a.OrderShippingAddressID' ,
          N'bigint' ,
          N'OrderShippingAddressID' ,
          N'Orders' ,
          N'deliveryaddresspk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          166795
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 227 ,
          N'Hybris' ,
          N'(select a.returnorderid, a.orderid, coalesce(b.ShippingCost,0) as ShippingCost
from #tempact a
left join hybris.OrderShipment b
on a.orderid= b.orderid 
group by a.returnorderid, a.orderid, b.ShippingCost)a' ,
          N'a.ShippingCost' ,
          N'money' ,
          N'ShippingCost' ,
          N'Orders' ,
          N'deliverycost' ,
          N'' ,
          N'decimal' ,
          N'manual' ,
          N'853-Returns' ,
          6
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 228 ,
          N'Hybris' ,
          N'(select distinct asp.returnorderid, asp.orderid, dm.pk as shippingmethod
from #tempact asp
left join hybris.ordershipment ash
on asp.orderid=ash.orderid
left join [RFO_Reference].[ShippingMethod] sm
on ash.shippingmethodid=sm.shippingmethodid
left join hybris.[dbo].[deliverymodes] dm
on sm.name=dm.code)a' ,
          N'a.ShippingMethod' ,
          N'' ,
          N'ShippingMethod' ,
          N'Orders' ,
          N'deliverymodepk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 229 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'deliverystatuspk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 230 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'Special Value in Hybris' ,
          N'Orders' ,
          N'globaldiscountvalues' ,
          N'' ,
          N'text' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 231 ,
          N'Hybris' ,
          N'(select a.returnorderid, a.orderid, coalesce(b.HandlingCost,0) as HandlingCost
from #tempact a
left join hybris.orderShipment b
on a.orderid= b.orderid 
group by a.returnorderid, a.orderid, b.HandlingCost)a' ,
          N'a.HandlingCost' ,
          N'money' ,
          N'HandlingCost' ,
          N'Orders' ,
          N'handlingcost' ,
          N'' ,
          N'decimal' ,
          N'manual' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 232 ,
          N'Hybris' ,
          N'Autoship' ,
          N'active' ,
          N'bit' ,
          N'active' ,
          N'Orders' ,
          N'netflag' ,
          N'' ,
          N'tinyint' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 233 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_active' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 234 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'a.OrderID' ,
          N'bigint' ,
          N'OrderID' ,
          N'Orders' ,
          N'p_associatedorder' ,
          N'' ,
          N'bigint' ,
          N'c2c' ,
          N'853-Returns' ,
          166920
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 235 ,
          N'Hybris' ,
          N'(select distinct a.returnorderid, b.autoshipid
from #tempact a
JOIN hybris.orders b
on a.orderid=b.orderid)a' ,
          N'a.autoshipid' ,
          N'' ,
          N'autoshipid' ,
          N'Orders' ,
          N'p_associatedtemplate' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          99986
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 236 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_cancelationdate' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 237 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_ccfailurecount' ,
          N'' ,
          N'int' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 238 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'Orders' ,
          N'p_commissiondate' ,
          N'' ,
          N'datetime' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 239 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_consicutivenoofdelay' ,
          N'' ,
          N'int' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 240 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'[ConsultantID]' ,
          N'bigint' ,
          N'ConsultantID' ,
          N'Orders' ,
          N'p_consultantIdReceivingCommiss' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 241 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'nvarchar' ,
          N'user' ,
          N'Orders' ,
          N'p_createdby' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 242 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_customer' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 243 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_delaycount' ,
          N'' ,
          N'int' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 244 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Orders' ,
          N'p_deliverycostmanuallychanged' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'853-Returns' ,
          120372
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 245 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid,  b.TaxonShippingCost
from #tempact a,
hybris.AutoshipShipment b
where a.autoshipid= b.autoshipid)a' ,
          N'a.TaxonShippingCost' ,
          N'money' ,
          N'TaxonShippingCost' ,
          N'Orders' ,
          N'p_deliverytaxvalues' ,
          N'' ,
          N'image' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 246 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_departmentselect' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 247 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'coalesce(donotship,0)' ,
          N'bit' ,
          N'donotship' ,
          N'Orders' ,
          N'p_donotship' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 248 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_exportstatus' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 249 ,
          N'Hybris' ,
          N'(select distinct a.returnorderid, a.orderid, c.autoshiptypeid, c.startdate,case when autoshiptypeid = 1 then startdate else dateadd(month, 1, startdate) end as firstscheduledate
from #tempact a
join hybris.orders b
on a.orderid=b.orderid

join hybris.autoship c
on b.autoshipid=c.autoshipid
and c.countryid =236)a' ,
          N'a.firstscheduledate' ,
          N'' ,
          N'firstscheduledate' ,
          N'Orders' ,
          N'p_firstscheduledautoshipdate' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'853-Returns' ,
          22780
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 250 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_fraudulent' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 251 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_frequency' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 252 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Orders' ,
          N'p_handlingcostmanuallychanged' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'853-Returns' ,
          120372
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 253 ,
          N'Hybris' ,
          N'(select a.autoshipnumber, a.autoshipid, b.TaxonHandlingCost
from #tempact a,
hybris.AutoshipShipment b
where a.autoshipid= b.autoshipid)a' ,
          N'a.TaxonHandlingCost' ,
          N'money' ,
          N'TaxonHandlingCost' ,
          N'Orders' ,
          N'p_handlingcosttaxvalues' ,
          N'' ,
          N'image' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 254 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_istaxcalculationfailed' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 255 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_lastprocessingdate' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 256 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'coalesce(CompletionDate, ''1900-01-01'')' ,
          N'' ,
          N'CompletionDate' ,
          N'Orders' ,
          N'p_ordercompletiondate' ,
          N'' ,
          N'datetime' ,
          N'c2c' ,
          N'853-Returns' ,
          166334
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 257 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_ordercount' ,
          N'' ,
          N'int' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 258 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_originalversion' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 259 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NSC4' ,
          N'Orders' ,
          N'p_origination' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 260 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_overridereason' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 261 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_overridetype' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 262 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'p_potentiallyfraudulent' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 263 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_previousdeliverymode' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 264 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 265 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_rforderstatus' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 266 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'8796105932891' ,
          N'Orders' ,
          N'p_salesapplication' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 267 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_schedulingdate' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 268 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'No mapping' ,
          N'Orders' ,
          N'p_site' ,
          N'' ,
          N'bigint' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 269 ,
          N'Hybris' ,
          N'Autoship' ,
          N'SiteID' ,
          N'bigint' ,
          N'SiteID' ,
          N'Orders' ,
          N'p_siteid' ,
          N'' ,
          N'nvarchar' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 270 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'8796093056989' ,
          N'Orders' ,
          N'p_store' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 271 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_taxexempt' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 272 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Orders' ,
          N'p_taxmanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          120372
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 273 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_taxmanuallychangedvalue' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 274 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_template' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 275 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'coalesce(testorder, '''')' ,
          N'bit' ,
          N'testorder' ,
          N'Orders' ,
          N'p_testorder' ,
          N'' ,
          N'tinyint' ,
          N'c2c' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 276 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0.00000000' ,
          N'Orders' ,
          N'p_totalamountwithouttax' ,
          N'' ,
          N'decimal' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 277 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'CV' ,
          N'money' ,
          N'CV' ,
          N'Orders' ,
          N'p_totalcv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'853-Returns' ,
          20
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 278 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'[QV]' ,
          N'' ,
          N'[QV]' ,
          N'Orders' ,
          N'p_totalqv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'853-Returns' ,
          20
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 279 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'Orders' ,
          N'p_totalsavingforpc' ,
          N'' ,
          N'float' ,
          N'No Mapping' ,
          N'853-Returns' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 280 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_trackingid' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 281 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'p_versionid' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 282 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'8796093056981' ,
          N'Orders' ,
          N'p_warehouse' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 283 ,
          N'Hybris' ,
          N'(select a.returnorderid, a.orderid, b.ReturnBillingAddressID
from #tempact a
left join hybris.ReturnBillingAddress b
on a.returnorderid= b.returnorderid)a' ,
          N'a.ReturnBillingAddressID' ,
          N'bigint' ,
          N'ReturnBillingAddressID' ,
          N'Orders' ,
          N'paymentaddresspk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          120290
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 284 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'0' ,
          N'Orders' ,
          N'paymentcost' ,
          N'' ,
          N'decimal' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 285 ,
          N'Hybris' ,
          N'(select a.returnorderid, a.orderid, b.returnpaymentid
from #tempact a
left join hybris.ReturnPayment b
on a.returnorderid= b.returnorderid 

join hybris.dbo.paymentinfos c
on b.returnpaymentid=c.pk
and b.returnorderid=c.ownerpkstring
and duplicate = 1
group by a.returnorderid, a.orderid, b.returnpaymentid)a' ,
          N'a.returnpaymentid' ,
          N'bigint' ,
          N'returnpaymentid' ,
          N'Orders' ,
          N'paymentinfopk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          120372
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 286 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'paymentmodepk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 287 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'paymentstatuspk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 288 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'Orders' ,
          N'statusinfo' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 289 ,
          N'Hybris' ,
          N'(select t1.returnorderid, t1.orderid, t3.pk
FROM #tempact t1,
RFO_Reference.ReturnStatus t2,
Hybris.dbo.vEnumerationValues t3
where t1.ReturnStatusId = t2.ReturnStatusId
and t2.Name = t3.Value
and t3.[Type] = ''returnstatus''
group by t1.returnorderid, t1.orderid, t3.pk)a' ,
          N'a.pk' ,
          N'' ,
          N'status' ,
          N'Orders' ,
          N'statuspk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          120372
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 290 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'[SubTotal]' ,
          N'' ,
          N'[SubTotal]' ,
          N'Orders' ,
          N'subtotal' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-Returns' ,
          5
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 291 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'[TotalDiscount] ' ,
          N'' ,
          N'[TotalDiscount] ' ,
          N'Orders' ,
          N'totaldiscounts' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 292 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'[Total]' ,
          N'' ,
          N'[Total]' ,
          N'Orders' ,
          N'totalprice' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-Returns' ,
          8
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 293 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'a.TotalTax' ,
          N'' ,
          N'[TotalTax]' ,
          N'Orders' ,
          N'totaltax' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-Returns' ,
          3
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 294 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'''[<TV<0_1_0_US TOTAL TAX#'' + CAST(coalesce(a.[RefundedTax], 0) AS NVARCHAR(20)) + ''#true#'' + ''0.0'' + ''#USD>VT>|
<TV<1_1_100001_US SHIPPING TAX#'' + CAST(coalesce(a.[RefundedShippingCost], 0) AS NVARCHAR(20)) + ''#true#''
                + CAST(coalesce(a.[RefundedShippingCost], 0) AS NVARCHAR(20)) + ''#USD>VT>|
<TV<2_1_300001_US HANDLING TAX#''
                + CAST(coalesce(a.[RefundedHandlingCost], 0) AS NVARCHAR(20)) + ''#true#''
                + CAST(coalesce(a.[RefundedHandlingCost], 0) AS NVARCHAR(20)) + ''#USD>VT>]''' ,
          N'' ,
          N'taxvalues' ,
          N'Orders' ,
          N'totaltaxvalues' ,
          N'' ,
          N'nvarchar(-1)' ,
          N'manual' ,
          N'853-Returns' ,
          120372
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 295 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'Use Hybris pk from user table based on RFO accountid' ,
          N'Orders' ,
          N'userpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 296 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'Completiondate' ,
          N'' ,
          N'Completiondate' ,
          N'Orders' ,
          N'CreatedTS' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          166329
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 297 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'ModifiedDate' ,
          N'' ,
          N'Completiondate' ,
          N'Orders' ,
          N'ModifiedTS' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          166920
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 298 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'CompletionDate' ,
          N'' ,
          N'Completiondate' ,
          N'ReturnRequest' ,
          N'CreatedTS' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          166883
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 299 ,
          N'Hybris' ,
          N'ReturnOrder' ,
          N'ModifiedDate' ,
          N'' ,
          N'Completiondate' ,
          N'ReturnRequest' ,
          N'ModifiedTS' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-Returns' ,
          166883
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 300 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'ProcessOnDate' ,
          N'' ,
          N'ProcessOnDate' ,
          N'ReturnEntry' ,
          N'[createdTS]' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          166942
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 301 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'ProcessOnDate' ,
          N'' ,
          N'ProcessOnDate' ,
          N'ReturnEntry' ,
          N'[modifiedTS]' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          166942
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 302 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'ReturnEntry' ,
          N'[OwnerPkString]' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 303 ,
          N'Hybris' ,
          N'(SELECT t1.returnorderid, t1.OrderItemID, t2.pk
FROM #tempact t1,
hybris..returnrequest t2
WHERE t1.returnorderid=t2.P_rma
GROUP BY t1.returnorderid, t1.OrderItemID, t2.pk)a' ,
          N'a.pk' ,
          N'' ,
          N'Returnrequest' ,
          N'ReturnEntry' ,
          N'[p_returnrequest]' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 304 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'COALESCE(RestockingFee,0)' ,
          N'' ,
          N'RestockingFee' ,
          N'ReturnEntry' ,
          N'[p_restockingfee]' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 305 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'ReturnEntry' ,
          N'[p_amount]' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 306 ,
          N'Hybris' ,
          N'(SELECT t1.returnorderid, t1.OrderItemID, t2.notes
FROM #tempact t1
LEFT JOIN hybris.returnnotes t2
ON t1.returnorderid=t2.returnorderid
GROUP BY t1.returnorderid, t1.OrderItemID, t2.notes)a' ,
          N'a.notes' ,
          N'' ,
          N'notes' ,
          N'ReturnEntry' ,
          N'[p_notes]' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnItems' ,
          1275
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 307 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'[ExpectedQuantity]' ,
          N'' ,
          N'ExpectedQuantity' ,
          N'ReturnEntry' ,
          N'[p_expectedquantity]' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 308 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'ReturnEntry' ,
          N'[p_refundeddate]' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 310 ,
          N'Hybris' ,
          N'(select t1.returnorderid, t1.OrderItemID, t2.pk
FROM #tempact t1,
Hybris.dbo.vEnumerationValues t2,
RFO_Reference.ReturnReason t3
where t1.ReturnReasonID = t3.ReturnReasonID
AND t3.name=t2.value
and t2.[Type] = ''RefundReason''
group by t1.returnorderid, t1.OrderItemID, t2.pk)a' ,
          N'a.pk' ,
          N'' ,
          N'ReturnReason' ,
          N'ReturnEntry' ,
          N'[p_reason]' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnItems' ,
          166942
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 311 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'ReturnEntry' ,
          N'[p_returnonlytax]' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 312 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'[ReceivedQuantity]' ,
          N'' ,
          N'ReceivedQuantity' ,
          N'ReturnEntry' ,
          N'[p_receivedquantity]' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
GO
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 313 ,
          N'Hybris' ,
          N'ReturnItem' ,
          N'OrderItemID' ,
          N'' ,
          N'OrderItemID' ,
          N'ReturnEntry' ,
          N'[p_orderentry]' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          166942
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 315 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'ReturnEntry' ,
          N'[p_reacheddate]' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 316 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'ReturnRequest' ,
          N'[OwnerPkString]' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-Returns' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 319 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'PaymentTransactions' ,
          N'[OwnerPkString]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 320 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'PaymentTransactions' ,
          N'[p_versionid]' ,
          N'' ,
          N'nvarchar(225)' ,
          N'defaults' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 321 ,
          N'Hybris' ,
          N'(SELECT DISTINCT a.returnorderid, a.returnpaymentid, b.ReturnPaymentTransactionId, ProcessDate
FROM #tempact a
LEFT JOIN hybris.returnpaymenttransaction b
ON a.returnpaymentid=b.returnpaymentid)a' ,
          N'a.ProcessDate' ,
          N'' ,
          N'ProcessDate' ,
          N'PaymentTransactions' ,
          N'[p_refundpaymentdate]' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          156476
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 322 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'8796125855777' ,
          N'PaymentTransactions' ,
          N'[p_currency]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 323 ,
          N'Hybris' ,
          N'(SELECT DISTINCT a.returnorderid, a.returnpaymentid, b.ReturnPaymentTransactionId, a.returnordernumber+ ''_'' +CAST(a.returnpaymentid AS nvarchar) code 
FROM #tempact a
LEFT JOIN hybris.returnpaymenttransaction b
ON a.returnpaymentid=b.returnpaymentid)a' ,
          N'a.code' ,
          N'' ,
          N'code' ,
          N'PaymentTransactions' ,
          N'[p_code]' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          156476
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 324 ,
          N'Hybris' ,
          N'(SELECT a.returnorderid, b.transactionid
FROM #tempact a
LEFT JOIN hybris.returnpaymenttransaction b
ON a.returnpaymentid=b.returnpaymentid)a' ,
          N'a.transactionid' ,
          N'' ,
          N'transactionid' ,
          N'PaymentTransactions' ,
          N'[p_requestid]' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          10309
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 325 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'PaymentTransactions' ,
          N'[p_rfmodifiedtime]' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 326 ,
          N'Hybris' ,
          N'(SELECT DISTINCT a.returnorderid, a.returnpaymentid, b.ReturnPaymentTransactionId, ho.pk AS HybrisOrderPK
FROM #tempact a
JOIN Hybris..orders ho ON ho.code=a.returnorderId
LEFT JOIN hybris.returnpaymenttransaction b
ON a.returnpaymentid=b.returnpaymentid)a' ,
          N'a.HybrisOrderPK' ,
          N'' ,
          N'ReturnOrder+HybrisOrder' ,
          N'PaymentTransactions' ,
          N'[p_order]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          156476
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 327 ,
          N'Hybris' ,
          N'(SELECT DISTINCT a.returnorderid, a.returnpaymentid, c.ReturnPaymentTransactionId, b.PaymentProvider
FROM #tempact a
JOIN hybris.orderpayment b
ON a.orderid=b.orderid

LEFT JOIN hybris.returnpaymenttransaction c
ON a.returnpaymentid=c.returnpaymentid)a' ,
          N'a.PaymentProvider' ,
          N'' ,
          N'PaymentProvider' ,
          N'PaymentTransactions' ,
          N'[p_paymentprovider]' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 328 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'PaymentTransactions' ,
          N'[p_requesttoken]' ,
          N'' ,
          N'nvarchar(225)' ,
          N'NoMapping' ,
          N'853-ReturnPaymentTransaction' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 329 ,
          N'Hybris' ,
          N'(SELECT DISTINCT a.returnorderid, a.returnpaymentid, c.ReturnPaymentTransactionId, CASE WHEN b.PaymentProvider = ''Litle'' THEN p.PK ELSE NULL END info
FROM #tempact a
JOIN hybris.orderpayment b
ON a.orderid=b.orderid
LEFT JOIN Hybris..paymentinfos p ON p.code=CAST(a.returnpaymentid AS NVARCHAR)
LEFT JOIN hybris.returnpaymenttransaction c
ON a.returnpaymentid=c.returnpaymentid)a' ,
          N'a.info' ,
          N'' ,
          N'info' ,
          N'PaymentTransactions' ,
          N'[p_info]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 330 ,
          N'Hybris' ,
          N'(SELECT DISTINCT a.returnorderid, a.returnpaymentid, b.ReturnPaymentTransactionId, AmountTobeAuthorized
FROM #tempact a
LEFT JOIN hybris.returnpaymenttransaction b
ON a.returnpaymentid=b.returnpaymentid)a' ,
          N'a.AmountTobeAuthorized' ,
          N'' ,
          N'AmountTobeAuthorized' ,
          N'PaymentTransactions' ,
          N'[p_plannedamount]' ,
          N'' ,
          N'decimal(30,8)' ,
          N'manual' ,
          N'853-ReturnPaymentTransaction' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 331 ,
          N'dbo' ,
          N'productDetails' ,
          N'productID' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_rflegacyproductid' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 332 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Catalog]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_catalognumber' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 333 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Status]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_approvalStatus' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 334 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Item#]' ,
          NULL ,
          N'Only apply for Canada products' ,
          N'products' ,
          NULL ,
          NULL ,
          NULL ,
          N'N/A' ,
          N'1174-products' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 335 ,
          N'dbo' ,
          N'productDetails' ,
          N'[UPC]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_UPC' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 336 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Primary Name]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_firstname' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 337 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Secondary Name]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_lastname' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 338 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Full Name]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_fullname' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 339 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Product Type]' ,
          NULL ,
          N'Store Front not Using this, commented to Ignore DATA-1576' ,
          N'products' ,
          N'p_d_itemtype' ,
          NULL ,
          NULL ,
          N'N/A' ,
          N'1174-products' ,
          848
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 340 ,
          N'dbo' ,
          N'productDetails' ,
          N'[AvaTax System Tax Code]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_taxcode' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 341 ,
          N'dbo' ,
          N'productDetails' ,
          N'[AvaTax System Tax Code Description]' ,
          NULL ,
          N'Commented On Mappind -Program ignores it just to use tax code.' ,
          N'products' ,
          NULL ,
          NULL ,
          NULL ,
          N'N/A' ,
          N'1174-products' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 342 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Membership fee of total price]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_membershipfee' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 343 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Service fee of total price]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_servicefee' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 344 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Shipping fee of total price]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_shippingFee' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 345 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CV]' ,
          NULL ,
          NULL ,
          N'(SELECT DISTINCT a.pk,c.P_cv FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug IN (SELECT DISTINCT c.p_ug FROM hybris.dbo.pricerows))a' ,
          N'P_cv' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 346 ,
          N'dbo' ,
          N'productDetails' ,
          N'[QV]' ,
          NULL ,
          NULL ,
          N'(SELECT DISTINCT a.pk,c.P_qv FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug IN (SELECT DISTINCT c.p_ug FROM hybris.dbo.pricerows))a' ,
          N'P_qv' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 347 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Consultant]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,ISNULL(c.p_price,0) As P_price FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug=8796164423771)a' ,
          N'P_price' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 348 ,
          N'dbo' ,
          N'productDetails' ,
          N'[PreferredCustomer]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,isnull(c.p_price,0) As P_price FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug=8796164391003)a' ,
          N'p_price' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 349 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Retail]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,Isnull(c.p_price,0) As P_price FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug=8796164358235)a' ,
          N'P_price' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 350 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Consultant_Taxable]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,isnull(c.p_taxableprice,0) As P_taxableprice FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug=8796164423771)a' ,
          N'P_taxableprice' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 351 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Wholesale Price]' ,
          NULL ,
          NULL ,
          N'(SELECT DISTINCT a.pk,c.P_wholesale FROM Hybris.dbo.products a,
 Hybris.dbo.pricerows c
 WHERE a.Pk=C.P_product
 AND C.P_ug IN (SELECT DISTINCT c.p_ug FROM hybris.dbo.pricerows))a' ,
          N'P_wholesale' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 352 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Summary]' ,
          NULL ,
          N'Hybris convert Special Characters to HTML codes by getting lengths increased.' ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_summary' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          22
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 353 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Description]' ,
          NULL ,
          N'Hybris convert Special Characters to HTML codes by getting lengths increased.' ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_description' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          52
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 354 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Usage Notes]' ,
          NULL ,
          N'Hybris convert Special Characters to HTML codes by getting lengths increased.' ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_usagenote' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          46
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 355 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Ingredients]' ,
          NULL ,
          N'Hybris convert Special Characters to HTML codes by getting lengths increased.' ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_ingredients' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          32
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 356 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Base]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_baseavailability' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 357 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CRP]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_crpautoshipavailability' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 358 ,
          N'dbo' ,
          N'productDetails' ,
          N'[PC Perks]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_pcperksautoshipavailability' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 359 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Enrollment CRP Only]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_crpenrollmentonly' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 360 ,
          N'dbo' ,
          N'productDetails' ,
          N'[POS]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_posonly' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 361 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_AMP MD]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK,d.P_code
					 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
		
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 362 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_REDEFINE]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 363 ,
          N'dbo' ,
          N'productDetails' ,
          N'CAT_REVERSE' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 364 ,
          N'dbo' ,
          N'productDetails' ,
          N'CAT_UNBLEMISH' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 365 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_SOOTHE]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 366 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_ENHANCEMENTS]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 367 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_ESSENTIALS]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 368 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_ConsultantsOnly]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 369 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_Consultant-Only Business Promotion]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 370 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_Consultant-Only Event Support]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 371 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_Consultant-Only Product Promotion]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 372 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CAT_Consultant-Only Products]' ,
          NULL ,
          NULL ,
          N'(SELECT a.PK ,
       	d.p_code
 FROM   Hybris..products a ,
		Hybris..cat2prodrel c,
		Hybris..categories d
 WHERE  a.pk=c.TargetPK
		AND c.SourcePK=d.PK
       		)a' ,
          N'P_code' ,
          N'Manually Tested and Passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 373 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Country Catalog]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_catalog ' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 374 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Priority]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_productdisplaypriority' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 375 ,
          N'dbo' ,
          N'productDetails' ,
          N'[IsDefaultCRP]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_defaultcrp' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 376 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Autoship Replenishable]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_autoshipreplenishable ' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 377 ,
          N'dbo' ,
          N'productDetails' ,
          N'[PC Replacement Status]' ,
          NULL ,
          N'Declaration of Hybris column to ''AFTER'' Commented-DATA-1576' ,
          N'(SELECT a.pk,b.Code FROM hybris.dbo.products  a
					JOIN hybris.dbo.enumerationvalues b ON a.p_pcreplacedproductstatus=b.pk)a' ,
          N'code' ,
          NULL ,
          NULL ,
          N'Default' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 378 ,
          N'dbo' ,
          N'productDetails' ,
          N'[CRP Replacement Status]' ,
          NULL ,
          N'Declaration of Hybris column to ''AFTER'' Commented-DATA-1576' ,
          N'(SELECT a.pk,b.Code FROM hybris.dbo.products  a
					JOIN hybris.dbo.enumerationvalues b ON a.P_crpreplacedproductstatus=b.pk)a' ,
          N'code' ,
          NULL ,
          NULL ,
          N'Default' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 379 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Replacement Products for PC Perks]' ,
          NULL ,
          NULL ,
          N'(SELECT  b.pk,a.code FROM hybris..products a,
					 hybris..products b WHERE CAST(a.pk AS NVARCHAR(255))  =SUBSTRING(b.P_pcperkreplacementproducts,5,13))a' ,
          N'P_rflegacyproductID' ,
          N'Manually tested for repleneshiable products and passed ' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 380 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Replacement Products for CRP]' ,
          NULL ,
          NULL ,
          N'(SELECT  b.pk,a.code FROM hybris..products a,
					 hybris..products b WHERE CAST(a.pk AS NVARCHAR(255))  =SUBSTRING(b.P_crpreplacementproducts,5,13))a' ,
          N'P_rflegacyproductID' ,
          N'Manually tested for repleneshiable products and passed ' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 381 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Non-Replenishable Message for PC Perks]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_autoshipnonreplenishablemsgp' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 382 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Non-Replenishable Message for CRP]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.p_autoshipnonreplenishablemsg FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_autoshipnonreplenishablemsg' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 383 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Non-Replenishable email paragraph for PC Perks]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_pcautoshipnreplenishableemai' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 384 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Non-Replenishable email paragraph for CRP]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_crpautoshipnreplenishableema' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 385 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Replacement Reason]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_replacementreason' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 386 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Best Seller]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_bestseller' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 387 ,
          N'dbo' ,
          N'productDetails' ,
          N'[New]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_newproduct' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 388 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Not Available]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_notavailabile' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 389 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Not Available Message]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_notavailablemsg' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 390 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Special]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'p_specialmessage' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 391 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Special Message]' ,
          NULL ,
          NULL ,
          N'(SELECT a.pk,b.* FROM hybris.dbo.products a,
  Hybris.dbo.productslp b WHERE  a.pk=b.itempk)a' ,
          N'P_specialmessage ' ,
          NULL ,
          NULL ,
          N'Ref' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 392 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Low Quantity Level]' ,
          NULL ,
          N' Commented Default=True , Data-1575' ,
          N'products' ,
          N'P_lowqtylevel' ,
          N'Stella Commented Default=1,passed Data-1575' ,
          NULL ,
          N'Default' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 393 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Restockable]' ,
          NULL ,
          N'Default=True,NULL=True; DATA-1575' ,
          N'products' ,
          N'P_restockable' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          106
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 394 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Weight]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_weight' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 395 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Shippable]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'p_shippable' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 396 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Charge Shipping]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_chargeshipping' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 397 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Charge Handling]' ,
          NULL ,
          NULL ,
          N'products' ,
          N'P_chargehandling' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 398 ,
          N'dbo' ,
          N'productDetails' ,
          N'[hybrisType]' ,
          NULL ,
          NULL ,
          N'
(SELECT a.pk,b.InternalCode FROM hybris..products a
JOIN hybris..composedtypes b ON a.TypePkString=b.pk)a' ,
          N'InternalCode' ,
          NULL ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 399 ,
          N'dbo' ,
          N'productDetails' ,
          N'[IsVariant]' ,
          NULL ,
          N'Just a Logic and do not need to validate-DATA-1174 ' ,
          N'products' ,
          NULL ,
          NULL ,
          NULL ,
          N'N/A' ,
          N'1174-products' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 400 ,
          N'dbo' ,
          N'productDetails' ,
          N'[IsBase]' ,
          NULL ,
          N'  Commented TO Ignore,NOT Using it. Just a Logic Infos:DATA-1575' ,
          N'products' ,
          N'P_baseproduct' ,
          N'Stella Commented  TO Ignore,NOT Using it. Just a Logic DATA-1575' ,
          NULL ,
          N'N/A' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 401 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Variant type]' ,
          NULL ,
          N'We do not print variant type for variant itself.Commited DATA-1576' ,
          N'products' ,
          N'p_varianttype' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'1174-products' ,
          46
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 402 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Variant Parent]' ,
          NULL ,
          NULL ,
          N'(SELECT b.pk,b.P_rflegacyproductid FROM hybris..products c
					JOIN hybris..products b ON b.pk=c.p_baseproduct) a' ,
          N'P_rflegacyproductid' ,
          N'Manually Tested and passed' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 403 ,
          N'dbo' ,
          N'productDetails' ,
          N'[Variant Name]' ,
          NULL ,
          N'IF Variant Type=Tone Then Variant Name=P_tone in Hybris. Else P_shade for Shade' ,
          N'Products' ,
          N'P_tone/P_shade' ,
          N'Manually Tesed and passed.' ,
          NULL ,
          N'Manual' ,
          N'1174-products' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 414 ,
          N'Hybris' ,
          N'[ReturnPayment]' ,
          N'ReturnPaymentID' ,
          N'' ,
          N'ReturnPaymentID' ,
          N'paymentinfos' ,
          N'pk' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 415 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'pk' ,
          N'paymentinfos' ,
          N'userpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 416 ,
          N'[RFO_Accounts]' ,
          N'(select t1.returnorderid,  t1.returnpaymentid, MAX(t2.paymentprofileid) paymentprofileid
from #tempact t1
join rfo_accounts.paymentprofiles t2
on t1.accountid=t2.accountid
GROUP BY t1.returnorderid,  t1.returnpaymentid)a' ,
          N'a.paymentprofileid' ,
          N'' ,
          N'paymentprofileid' ,
          N'paymentinfos' ,
          N'p_rfaccountpaymentmethodid' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          55343
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 417 ,
          N'Hybris' ,
          N'(select t1.returnorderid,  t1.returnpaymentid, t2.paymentprofileid, [dbo].[DecryptTripleDES](t3.AccountNumber)  as ''number''
from #tempact t1
join rfo_accounts.paymentprofiles t2
on t1.accountid=t2.accountid
JOIN Hybris..paymentinfos hpi ON hpi.code=CAST(t1.ReturnPaymentID AS NVARCHAR)
join [RodanFieldsLive].[dbo].[OrderPayments] t3
on hpi.code=t3.orderpaymentid
where ltrim(rtrim(accountnumber)) <> '''' 
and (ltrim(rtrim(billingfirstname)) <> '''' or ltrim(rtrim(billinglastname)) <> '''')
group by t1.returnorderid, t1.returnpaymentid, t2.paymentprofileid, t3.AccountNumber)a' ,
          N'a.number' ,
          N'' ,
          N'creditcardnumber' ,
          N'paymentinfos' ,
          N'p_number' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 418 ,
          N'Hybris' ,
          N'ReturnPayment' ,
          N'Expmonth' ,
          N'' ,
          N'Expmonth' ,
          N'paymentinfos' ,
          N'p_validToMonth' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 419 ,
          N'Hybris' ,
          N'ReturnPayment' ,
          N'ExpYear' ,
          N'' ,
          N'ExpYear' ,
          N'paymentinfos' ,
          N'p_validToYear' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 420 ,
          N'Hybris' ,
          N'(select t1.returnorderid, t1.returnpaymentid, LTRIM(RTRIM(CONCAT(ltrim(rtrim(BillingFirstName)),'''' , ltrim(rtrim(BillingLastName))))) as Name 
from #tempact t1
join RFO_Accounts.AccountContacts t2
on t1.accountid=t2.accountid
JOIN Hybris..paymentinfos hpi 
ON hpi.code=CAST(t1.ReturnPaymentID AS NVARCHAR)
join [RodanFieldsLive].[dbo].[OrderPayments] t3
on hpi.code=t3.orderpaymentid
where ltrim(rtrim(accountnumber)) <> '''' 
and (ltrim(rtrim(billingfirstname)) <> '''' or ltrim(rtrim(billinglastname)) <> ''''))a' ,
          N'a.Name' ,
          N'' ,
          N'Name' ,
          N'paymentinfos' ,
          N'p_ccOwner' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          166785
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 421 ,
          N'Hybris' ,
          N'(select distinct t1.returnorderid, t1.returnpaymentid, t3.pk as paymenttype
from #tempact t1
join RFO_Reference.CreditCardVendors t2
on t1.Vendorid=t2.VendorID
join Hybris..vEnumerationValues t3
on t3.value=t2.name
and t3.type = ''CreditCardType''
group by t1.returnorderid, t1.returnpaymentid, t3.pk)a' ,
          N'a.paymenttype' ,
          N'' ,
          N'paymenttype' ,
          N'paymentinfos' ,
          N'p_type' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          4
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 422 ,
          N'Hybris' ,
          N'ReturnPayment' ,
          N'returnorderid' ,
          N'' ,
          N'returnorderid' ,
          N'paymentinfos' ,
          N'OwnerPkString' ,
          N'' ,
          N'bigint' ,
          N'c2c' ,
          N'853-ReturnPaymentInfo' ,
          14
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 423 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'Hybris-DM' ,
          N'paymentinfos' ,
          N'p_sourcename' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 424 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'1' ,
          N'paymentinfos' ,
          N'duplicate' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 425 ,
          N'Hybris' ,
          N'(select t1.returnorderid, t1.returnpaymentid, t2.[ReturnBillingAddressID]
from #tempact t1
join [Hybris].[ReturnBillingAddress] t2
on t1.[returnorderid]=t2.[returnorderid]) a' ,
          N'a.[ReturnBillingAddressID]' ,
          N'' ,
          N'ReturnBillingAddressID' ,
          N'paymentinfos' ,
          N'p_billingaddress' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
GO
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 426 ,
          N'' ,
          N'(SELECT t1.returnorderid,  t1.returnpaymentid,hpi.pk AS OrderOriginalPK
from  #tempact t1
JOIN Hybris..orders ho ON ho.code=t1.returnorderId AND ho.TypePkString=8796127723602
JOIN hybris..orders o ON o.pk=ho.p_associatedorder
JOIN hybris..paymentinfos hpi ON hpi.OwnerPkString=o.pk
GROUP BY t1.returnorderid,  t1.returnpaymentid,hpi.pk)a' ,
          N'a.OrderOriginalPK' ,
          N'' ,
          N'NOT NULL' ,
          N'paymentinfos' ,
          N'originalpk' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 427 ,
          N'Hybris' ,
          N'(select apa.ReturnBillingAddressID, ap.returnorderid, max(ad.addressid) pk
from #tempact ap
join hybris.ReturnBillingAddress apa
on ap.returnorderid=apa.returnorderid

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid

join RFO_Accounts.AccountContactAddresses aca
on ac.accountcontactid=aca.accountcontactid

left join RFO_Accounts.Addresses ad
on aca.addressid=ad.addressid
and IsDefault = 1 and ad.addresstypeid = 3 
group by apa.ReturnBillingAddressID, ap.returnorderid)a' ,
          N'a.pk' ,
          N'' ,
          N'AddressID' ,
          N'Addresses' ,
          N'p_rfaddressid' ,
          N'' ,
          N'nvarchar(225)' ,
          N'manual' ,
          N'853-ReturnPaymentAddress' ,
          166776
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 428 ,
          N'Hybris' ,
          N'(SELECT a.returnorderId,p.ReturnPaymentId,a.ReturnBillingAddressID  FROM #tempact a
JOIN Hybris.returnpayment p ON a.returnorderid=p.ReturnOrderID)a' ,
          N'a.ReturnPaymentId' ,
          N'' ,
          N'returnorderid' ,
          N'Addresses' ,
          N'OwnerPkString' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentAddress' ,
          33
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 429 ,
          N'Migration' ,
          N'(select distinct a.ReturnBillingAddressID, a.returnorderid, c.code, d.pk
from [Hybris].ReturnBillingAddress a,
#tempact b,
DataMigration.Migration.RegionMapping c,
hybris.dbo.regions d
where a.returnorderid=b.returnorderid
and a.region=c.code
and c.code=d.isocode)a' ,
          N'a.pk' ,
          N'' ,
          N'Region' ,
          N'Addresses' ,
          N'regionpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentAddress' ,
          2095
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 430 ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'1' ,
          N'Addresses' ,
          N'p_Billingaddress' ,
          N'' ,
          N'' ,
          N'defaults' ,
          N'853-ReturnPaymentAddress' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 431 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'Telephone' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_Phone1' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          6
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 432 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'Locale' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_town' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          1914
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 433 ,
          N'' ,
          N'' ,
          N'countryid' ,
          N'' ,
          N'8796100624418' ,
          N'Addresses' ,
          N'countrypk' ,
          N'' ,
          N'nvarchar(225)' ,
          N'defaults' ,
          N'853-ReturnPaymentAddress' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 434 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'AddressLine1' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_streetname' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          1617
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 435 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'AddressLine2' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_streetnumber' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          6
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 436 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'PostalCode' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_postalCode' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          1617
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 437 ,
          N'RFO_Accounts' ,
          N'(select apa.ReturnBillingAddressID, ap.returnorderid, birthday
from #tempact ap
join hybris.ReturnBillingAddress apa
on ap.returnorderid=apa.returnorderid 

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid
group by apa.ReturnBillingAddressID, ap.returnorderid, birthday)a' ,
          N'a.birthday' ,
          N'' ,
          N'Birthday' ,
          N'Addresses' ,
          N'p_dateofbirth' ,
          N'' ,
          N'datetime' ,
          N'manual' ,
          N'853-ReturnPaymentAddress' ,
          1440
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 438 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'FirstName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_firstname' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          1234
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 439 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'MiddleName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_MiddleName' ,
          N'' ,
          N'nvarchar(225)' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          6
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 440 ,
          N'Hybris' ,
          N'ReturnBillingAddress' ,
          N'LastName' ,
          N'' ,
          N'' ,
          N'Addresses' ,
          N'p_LastName' ,
          N'' ,
          N'' ,
          N'c2c' ,
          N'853-ReturnPaymentAddress' ,
          1304
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 441 ,
          N'RFO_Accounts' ,
          N'(select apa.ReturnBillingAddressID, ap.returnorderid,
case when [GenderId] = 1 then ''8796093874267''
     when [GenderId] = 2 then ''8796093841499'' else null end Gender
from #tempact ap
join hybris.ReturnBillingAddress apa
on ap.returnorderid=apa.returnorderid

join RFO_Accounts.AccountContacts ac 
on ap.accountid=ac.accountid
group by apa.ReturnBillingAddressID, ap.returnorderid, [GenderId])a' ,
          N'a.Gender' ,
          N'' ,
          N'GenderId' ,
          N'Addresses' ,
          N'p_Gender' ,
          N'' ,
          N'' ,
          N'manual' ,
          N'853-ReturnPaymentAddress' ,
          6
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 442 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.BasePrice' ,
          N'' ,
          N'BasePrice' ,
          N'OrderEntries' ,
          N'baseprice' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 443 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'calculatedflag' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 444 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'[]' ,
          N'OrderEntries' ,
          N'discountvalues' ,
          N'' ,
          N'nvarchar' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 445 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.LineItemNo-1 as LineItemNo' ,
          N'' ,
          N'LineItemNo' ,
          N'OrderEntries' ,
          N'entrynumber' ,
          N'' ,
          N'int' ,
          N'manual' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 446 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.pk' ,
          N'' ,
          N'ProductID' ,
          N'OrderEntries' ,
          N'productpk' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 447 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.ExpectedQuantity' ,
          N'' ,
          N'Quantity' ,
          N'OrderEntries' ,
          N'quantity' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 448 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'''[<TV<''+cast(a.lineitemno-1 as nvarchar(5))+''_1_''+cast(a.lineitemno-1 as nvarchar(5))+''_US TOTAL TAX#''+ CAST(coalesce(a.TotalTax, 0) AS NVARCHAR(20)) + ''#true#'' + ''0.0'' + ''#USD>VT>]''' ,
          N'' ,
          N'taxvalues' ,
          N'OrderEntries' ,
          N'taxvalues' ,
          N'' ,
          N'nvarchar' ,
          N'manual' ,
          N'853-ReturnItems' ,
          166730
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 449 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.totalprice' ,
          N'' ,
          N'totalprice' ,
          N'OrderEntries' ,
          N'totalprice' ,
          N'' ,
          N'decimal' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 450 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'8796093054986' ,
          N'OrderEntries' ,
          N'unitpk' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 451 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'giveawayflag' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          7
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 452 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'rejectedflag' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 453 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.ReturnOrderId' ,
          N'' ,
          N'ReturnOrderId' ,
          N'OrderEntries' ,
          N'orderpk' ,
          N'' ,
          N'bigint' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          166942
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 454 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_chosenvendor' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 455 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_deliveryaddress' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 456 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_deliverymode' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 457 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_nameddeliverydate' ,
          N'' ,
          N'datetime' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 458 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'p_quantitystatus' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 459 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_isreturned' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          7
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 460 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.ServerModifiedDate' ,
          N'' ,
          N'ModifiedTime' ,
          N'OrderEntries' ,
          N'p_rfmodifiedtime' ,
          N'' ,
          N'datetime' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          166480
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 461 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.QV' ,
          N'' ,
          N'QV' ,
          N'OrderEntries' ,
          N'p_qv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 462 ,
          N'Hybris' ,
          N'[ReturnItem]' ,
          N'a.CV' ,
          N'' ,
          N'CV' ,
          N'OrderEntries' ,
          N'p_cv' ,
          N'' ,
          N'float' ,
          N'c2c' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 463 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.RetailProfit' ,
          N'' ,
          N'RetailProfit' ,
          N'OrderEntries' ,
          N'p_retailprofit' ,
          N'' ,
          N'float' ,
          N'manual' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 464 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'coalesce(a.WholeSaleprice, 0)' ,
          N'' ,
          N'WholeSaleprice' ,
          N'OrderEntries' ,
          N'p_wholesaleprice' ,
          N'' ,
          N'float' ,
          N'manual' ,
          N'853-ReturnItems' ,
          60
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 465 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_basepricemanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          7
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 466 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_cvmanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          7
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 467 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_qvmanuallychanged' ,
          N'' ,
          N'tinyint' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          7
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 468 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.TaxablePrice' ,
          N'' ,
          N'TaxablePrice' ,
          N'OrderEntries' ,
          N'p_taxableprice' ,
          N'' ,
          N'float' ,
          N'manual' ,
          N'853-ReturnItems' ,
          57
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 469 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_restockingfees' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 470 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'0' ,
          N'OrderEntries' ,
          N'p_restockingfeetax' ,
          N'' ,
          N'float' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 471 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'OrderEntries' ,
          N'oldprice' ,
          N'' ,
          N'decimal' ,
          N'defaults' ,
          N'853-ReturnItems' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 472 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[OwnerPkString]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 473 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.paymenttransaction' ,
          N'' ,
          N'paymenttransaction' ,
          N'paymnttrnsctentries' ,
          N'[p_paymenttransaction]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          2849
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 474 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.AmountAuthorized' ,
          N'' ,
          N'AmountToBeAuthorized' ,
          N'paymnttrnsctentries' ,
          N'[p_amount]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          2847
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 475 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_versionid]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 476 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_subscriptionid]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 477 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'' ,
          N'paymnttrnsctentries' ,
          N'[p_code]' ,
          N'' ,
          N'bigint' ,
          N'NoMapping' ,
          N'853-ReturnPaymentTransactionEntries' ,
          NULL
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 478 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_modifiedbyuserid]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 479 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.ProcessDate' ,
          N'' ,
          N'ProcessDate' ,
          N'paymnttrnsctentries' ,
          N'[p_time]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          2849
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 480 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_origination]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 481 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_AvsResult]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 482 ,
          N'Hybris' ,
          N'(SELECT a.ReturnOrderId,b.pk
FROM #tempact a
JOIN hybris.dbo.vEnumerationValues b
ON a.authorizetype= CASE b.value  WHEN''AUTHORIZATION'' THEN ''AUTH_CAPTURE''
                                      WHEN ''REFUND_STANDALONE'' THEN ''CREDIT''
                                      WHEN ''CAPTURE'' THEN ''SALE''
                                      WHEN ''CANCEL'' THEN ''''
                                      ELSE b.Value END
WHERE TYPE = ''PaymentTransactionType'') a' ,
          N'a.pk' ,
          N'' ,
          N'AuthorizeType' ,
          N'paymnttrnsctentries' ,
          N'[p_type]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 483 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'8796125855777' ,
          N'paymnttrnsctentries' ,
          N'[p_currency]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 484 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.TransactionID' ,
          N'' ,
          N'TransactionID' ,
          N'paymnttrnsctentries' ,
          N'[p_requestid]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          2849
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 485 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.TransactionStatusDetails' ,
          N'' ,
          N'TransactionStatusDetails' ,
          N'paymnttrnsctentries' ,
          N'[p_transactionstatusdetails]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          153757
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 486 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_rfmodifiedtime]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 487 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.transactionStatus' ,
          N'' ,
          N'transactionStatus' ,
          N'paymnttrnsctentries' ,
          N'[p_transactionstatus]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          153757
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 488 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.ResponseCode' ,
          N'' ,
          N'ResponseCode' ,
          N'paymnttrnsctentries' ,
          N'[p_responsecode]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          153757
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 489 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.CardCodeResponse' ,
          N'' ,
          N'CardCodeResponse' ,
          N'paymnttrnsctentries' ,
          N'[p_cardcoderesponse]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          153757
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 490 ,
          N'Hybris' ,
          N'' ,
          N'' ,
          N'' ,
          N'NULL' ,
          N'paymnttrnsctentries' ,
          N'[p_custommsg]' ,
          N'' ,
          N'bigint' ,
          N'defaults' ,
          N'853-ReturnPaymentTransactionEntries' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 491 ,
          N'Hybris' ,
          N'#tempact a' ,
          N'a.ApprovalCode' ,
          N'' ,
          N'ApprovalCode' ,
          N'paymnttrnsctentries' ,
          N'[p_approvalcode]' ,
          N'' ,
          N'bigint' ,
          N'manual' ,
          N'853-ReturnPaymentTransactionEntries' ,
          153757
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 492 ,
          NULL ,
          N'#RFOUsers' ,
          N'Emailaddress' ,
          NULL ,
          NULL ,
          N'Users' ,
          N'UniqueID' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'871-users' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 493 ,
          NULL ,
          N'#RFOUsers' ,
          N'name' ,
          NULL ,
          NULL ,
          N'Users' ,
          N'name' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'871-users' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 494 ,
          NULL ,
          N'#RFOUsers' ,
          N'password' ,
          NULL ,
          NULL ,
          N'Users' ,
          N'passwd' ,
          NULL ,
          NULL ,
          N'C2C' ,
          N'871-users' ,
          0
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 495 ,
          N'Hybris' ,
          N'(SELECT t1.AutoshipID ,
        t2.AutoshipPaymentID ,
        CONCAT(SUBSTRING(t2.DisplayNumber, 1, 6),
               SUBSTRING(t2.DisplayNumber, ( LEN(t2.DisplayNumber) - 3 ), 4),
               t2.Expmonth, t2.ExpYear) AS GeneratedSubScriptionID
 FROM   Hybris.Autoship t1
        JOIN Hybris.AutoshipPayment t2 ON t1.AutoshipID = t2.AutoshipID
        JOIN RodanFieldsLive.dbo.OrderPayments t3 ON t2.AutoshipPaymentID = t3.OrderPaymentID
 WHERE  LTRIM(RTRIM(AccountNumber)) <> ''''
        AND AccountNumber <> ''HDCm5F9HLZ6JyWpnoVViLw==''
        AND ( LTRIM(RTRIM(BillingFirstName)) <> ''''
              OR LTRIM(RTRIM(BillingLastName)) <> ''''
            )
 GROUP BY t1.AutoshipID ,
        t2.AutoshipPaymentID ,
        CONCAT(SUBSTRING(t2.DisplayNumber, 1, 6),
               SUBSTRING(t2.DisplayNumber, ( LEN(t2.DisplayNumber) - 3 ), 4),
               t2.Expmonth, t2.ExpYear))a' ,
          N'a.GeneratedSubScriptionID' ,
          N'int' ,
          N'' ,
          N'paymentinfos' ,
          N'P_subscriptionID' ,
          N'' ,
          N'nvarchar(255)' ,
          N'manual' ,
          N'824-AutoshipPaymentInfo' ,
          1456966
        );
INSERT  [dbo].[map_tab]
        ( [id] ,
          [Schema ] ,
          [RFO_Table] ,
          [RFO_Column ] ,
          [RFO_DataType ] ,
          [RFO_Reference Table] ,
          [Hybris_Table] ,
          [Hybris_Column ] ,
          [Hybris_Reference Table] ,
          [Hybris_DataType] ,
          [flag] ,
          [owner] ,
          [prev_run_err]
        )
VALUES  ( 496 ,
          N'Hybris' ,
          N'(SELECT  t1.ReturnOrderID ,
        t2.ReturnPaymentId ,
        CONCAT(SUBSTRING(t2.DisplayNumber, 1, 6),
               SUBSTRING(t2.DisplayNumber, ( LEN(t2.DisplayNumber) - 3 ), 4),
               t2.Expmonth, t2.ExpYear) AS GeneratedSubScriptionID
FROM    #tempact t1
        JOIN Hybris.ReturnPayment t2 ON t1.ReturnOrderID = t2.ReturnOrderID                                       
        JOIN RodanFieldsLive.dbo.OrderPayments t3 ON t2.ReturnPaymentId = t3.OrderPaymentID
WHERE   LTRIM(RTRIM(AccountNumber)) <> ''''
        AND AccountNumber <> ''HDCm5F9HLZ6JyWpnoVViLw==''
        AND ( LTRIM(RTRIM(BillingFirstName)) <> ''''
              OR LTRIM(RTRIM(BillingLastName)) <> ''''
            )
GROUP BY t1.ReturnOrderID ,
        t2.ReturnPaymentId ,
        CONCAT(SUBSTRING(t2.DisplayNumber, 1, 6),
               SUBSTRING(t2.DisplayNumber, ( LEN(t2.DisplayNumber) - 3 ), 4),
               t2.Expmonth, t2.ExpYear))a' ,
          N'a.GeneratedSubScriptionID' ,
          N'Nvarchar(255)' ,
          N'' ,
          N'paymentinfos' ,
          N'P_subscriptionID' ,
          N'' ,
          N'Bigint' ,
          N'manual' ,
          N'853-ReturnPaymentInfo' ,
          166785
        );
