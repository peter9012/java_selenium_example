
/*********************************************************************************************************
PaymentInfo Validation Script 
Revised 12/21/2015 

Run Parts 1,2 and 3 separately 
***********************************************************************************************************/
USE DataMigration
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


SET NOCOUNT ON;
SET ANSI_WARNINGS OFF; 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



/*=================================================================================================
-- Part 1: Counts, Missing Keys, Duplicates 
================================================================================================= */


IF OBJECT_ID('DataMigration.Migration.MissingPayInfos') IS NOT NULL
    DROP TABLE DataMigration.Migration.MissingPayInfos; 

IF OBJECT_ID('TEMPDB.dbo.#PayInfoDups') IS NOT NULL
    DROP TABLE #PayInfoDups; 

SET ANSI_WARNINGS OFF; 

DECLARE @Country NVARCHAR(20)= 'US';
DECLARE @RFOCountry INT = ( SELECT  CountryID
                            FROM    RFOperations.RFO_Reference.Countries (NOLOCK)
                            WHERE   Alpha2Code = @Country
                          ) ,
    @HybCountry BIGINT = ( SELECT   PK
                           FROM     Hybris.dbo.countries (NOLOCK)
                           WHERE    isocode = 'us'
                         );


----------------------------------------------------------------------------------------------
--Counts


DECLARE @RFOPayInfo BIGINT ,
    @HYBPayInfo BIGINT;


SELECT  @RFOPayInfo = COUNT(PaymentProfileID)
FROM    RFOperations.RFO_Accounts.PaymentProfiles (NOLOCK) a
        JOIN RFOperations.RFO_Accounts.AccountBase (NOLOCK) b ON a.AccountID = b.AccountID
        JOIN RodanFieldsLive.dbo.AccountPaymentMethods c ON c.AccountPaymentMethodID = a.PaymentProfileID
		JOIN RFOperations.RFO_Accounts.Addresses ad ON ad.AddressID = c.BillingAddressID 
        JOIN Hybris.dbo.users u ON u.p_rfaccountid = CAST(a.AccountID AS VARCHAR)
WHERE   b.CountryID = @RFOCountry
        AND u.p_sourcename = 'Hybris-DM' AND PaymentProfileID <>1617224;

SELECT  @HYBPayInfo = COUNT(a.PK)
FROM    Hybris.dbo.paymentinfos (NOLOCK) a
        JOIN Hybris.dbo.users (NOLOCK) b ON b.PK = a.userpk
WHERE   b.p_country = @HybCountry
        AND a.OwnerPkString IS NOT NULL
        AND a.OwnerPkString = userpk
        AND b.p_sourcename = 'Hybris-DM'
		AND a.p_sourcename='Hybris-DM'
        AND duplicate = 0;


SELECT  'Payment Info' ,
        @RFOPayInfo AS RFO_Count ,
        @HYBPayInfo AS Hybris_Count ,
        @RFOPayInfo - @HYBPayInfo AS diff,
		CASE WHEN @RFOPayInfo >@HYBPayInfo THEN 'RFO Counts More than Hybris'
		WHEN @HYBPayInfo>@RFOPayInfo THEN 'Hybris Counts More than RFO'
		ELSE 'Count is Matching '
		END AS Rusults 

		/*							STG3		    		STG1
		 Time taken =				       					14Sec
		 RFO Counts:					    				1952698
		Hybris Counts:					     				1952701
		diff:							    				-3  
		Results:							    			+Hybris 
		 */

		
----------------------------------------------------------------------------------------------------------------------------------
-- Missing Keys 

;
WITH    CTE1
          AS ( SELECT   a.AccountID ,
                        PaymentProfileID ,
                        b.CountryID
               FROM     RFOperations.RFO_Accounts.PaymentProfiles (NOLOCK) a
                        JOIN RFOperations.RFO_Accounts.AccountBase (NOLOCK) b ON a.AccountID = b.AccountID
                        JOIN RodanFieldsLive.dbo.AccountPaymentMethods c ON c.AccountPaymentMethodID = a.PaymentProfileID
                        JOIN RFOperations.RFO_Accounts.Addresses ad ON ad.AddressID = c.BillingAddressID
                        JOIN Hybris.dbo.users u ON u.p_rfaccountid = CAST(a.AccountID AS VARCHAR)
               WHERE    b.CountryID = @RFOCountry
                        AND u.p_sourcename = 'Hybris-DM'
                        AND PaymentProfileID <> 1617224
             ),
        CTE2
          AS ( SELECT   b.PK ,
                        p_rfaccountpaymentmethodid ,
                        p_country
               FROM     Hybris.dbo.paymentinfos (NOLOCK) a
                        JOIN Hybris.dbo.users (NOLOCK) b ON b.PK = a.userpk
               WHERE    b.p_country = @HybCountry
                        AND a.OwnerPkString IS NOT NULL
                        AND a.OwnerPkString = userpk
                        AND b.p_sourcename = 'Hybris-DM'
						AND a.p_sourcename='Hybris-DM'
                        AND duplicate = 0
             )
    SELECT  e.PaymentProfileID AS RFO_PaymentProfileID ,
            f.p_rfaccountpaymentmethodid AS Hybris_rfPaymentProfileID ,
            CASE WHEN f.p_rfaccountpaymentmethodid IS NULL THEN 'Destination'
                 WHEN e.PaymentProfileID IS NULL THEN 'Source'
            END AS MissingFROM
    INTO    DataMigration.Migration.MissingPayInfos
    FROM    CTE1 e
            FULL OUTER JOIN CTE2 f ON e.PaymentProfileID = f.p_rfaccountpaymentmethodid
    WHERE   ( e.PaymentProfileID IS NULL
              OR f.p_rfaccountpaymentmethodid IS NULL
            );


SELECT  MISSINGFROM ,
        COUNT(*)
FROM    DataMigration.Migration.MissingPayInfos
GROUP BY MissingFrom;



/*

SELECT * FROM RFOperations.RFO_Accounts.PaymentProfiles a JOIN RFOperations.RFO_Accounts.CreditCardProfiles b ON b.PaymentProfileID =a.PaymentProfileID
JOIN RodanFieldsLive.dbo.AccountPaymentMethods apm ON apm.AccountPaymentMethodID = a.paymentprofileID
WHERE a.PaymentProfileID IN 
(SELECT Hybris_rfPaymentProfileID FROM DataMigration.Migration.MissingPayInfos
WHERE MissingFROM = 'Source') 


SELECT * FROM Hybris.dbo.paymentinfos
WHERE p_rfaccountpaymentmethodid IN
(SELECT Hybris_rfPaymentProfileID FROM DataMigration.Migration.MissingPayInfos
WHERE MissingFROM = 'Source') AND Duplicate =0 AND modifiedts < '2015-12-06 16:51:35.947'

SELECT p_defaultpaymentinfo,* FROM RFOperations.RFO_Accounts.PaymentProfiles a JOIN RFOperations.RFO_Accounts.CreditCardProfiles b ON b.PaymentProfileID =a.PaymentProfileID
JOIN RodanFieldsLive.dbo.AccountPaymentMethods apm ON apm.AccountPaymentMethodID = a.paymentprofileID
JOIN Hybris.dbo.Users u ON u.p_rfAccountID = CAST( apm.AccountID AS VARCHAR)
JOIN RFOperations.RFO_Accounts.Addresses ad ON ad.AddressID = b.BillingAddressID
WHERE a.PaymentProfileID IN (SELECT RFO_PaymentProfileID FROM DataMigration.Migration.MissingPayInfos
WHERE MissingFROM = 'Destination')

SELECT * FROM Hybris.dbo.paymentinfos WHERE PK = 8880334733354
WHERE p_rfaccountpaymentmethodid  IN
(SELECT RFO_PaymentProfileID FROM DataMigration.Migration.MissingPayInfos
WHERE MissingFROM = 'Destination') AND duplicate =0


*/

IF OBJECT_ID('TEMPDB.dbo.#PayInfoDups') IS NOT NULL
    DROP TABLE #PayInfoDups; 


SELECT  PaymentProfileID ,
        COUNT(a.PK) AS PaymentInfo_Dups
INTO    #PayInfoDups
FROM    Hybris.dbo.paymentinfos a
        JOIN RFOperations.RFO_Accounts.PaymentProfiles b ON a.p_rfaccountpaymentmethodid = b.PaymentProfileID
        JOIN Hybris.dbo.users c ON a.userpk = c.PK
WHERE   a.OwnerPkString = userpk
        AND c.p_country = 8796100624418
GROUP BY b.PaymentProfileID
HAVING  COUNT(a.PK) > 1; 


        SELECT  'Duplicate ' + CAST(@@ROWCOUNT AS NVARCHAR) + ' PaymentProfiles in Hybris' 
      

        SELECT  *
        FROM    #PayInfoDups;

/*
/*=================================================================================================
-- Part 2 EXCEPTS TESTS 
================================================================================================= */

IF OBJECT_ID('TEMPDB.dbo.#RFO_PayInfo') IS NOT NULL
    DROP TABLE #RFO_PayInfo;
IF OBJECT_ID('TEMPDB.dbo.#Hybris_PayInfo') IS NOT NULL
    DROP TABLE #Hybris_PayInfo;
IF OBJECT_ID('TEMPDB.dbo.#PayInfo') IS NOT NULL
    DROP TABLE #PayInfo;


-----------------------------------------------------------------------------------------------

DECLARE @Country NVARCHAR(20)= 'US';
DECLARE @RFOCountry INT = ( SELECT  CountryID
                            FROM    RFOperations.RFO_Reference.Countries (NOLOCK)
                            WHERE   Alpha2Code = @Country
                          ) ,
    @HybCountry BIGINT = ( SELECT   PK
                           FROM     Hybris.dbo.countries (NOLOCK)
                           WHERE    isocode = @Country
                         );

----------------------------------------------------------------------------------------------------------------------

--- Load PaymentInfos Excepts 
---------------------------------------------------------------------------------------------------------------------


SELECT  CAST(PP.PaymentProfileID AS NVARCHAR(100)) AS PaymentProfileID_Code ,
        CAST(PP.PaymentProfileID AS NVARCHAR(100)) AS PaymentProfileID ,
        CAST (PK AS NVARCHAR) AS Hybris_Owner ,
        CAST (PK AS NVARCHAR) AS Hybris_User ,
        CAST(PP.AccountID AS NVARCHAR(100)) AS rfAccountID	--rfAccountId
		--,CAST (ltrim(rtrim(ccp.NameOnCard ))AS NVARCHAR (100)) AS ProfileName
		--,CAST (RFOperations.[dbo].[DecryptTripleDES] (apm.AccountNumber) AS NVARCHAR (100))  AS CardNumber --, CAST (DisplayNumber AS NVARCHAR(100)) AS CardNumber--, 
		--, CAST ( ExpMonth AS NVARCHAR (100))  AS ExpMonth
		--, CAST ( ExpYear AS NVARCHAR (100))  AS ExpYear
        ,
        CAST (CCP.BillingAddressID AS NVARCHAR(100)) AS BillingAddressID ,
        CASE WHEN V.Name = 'Invalid' THEN 'Unknown'
             ELSE CAST (V.Name AS NVARCHAR(100))
        END AS Vendor
INTO    #RFO_PayInfo
FROM    RFOperations.RFO_Accounts.AccountBase (NOLOCK) AB
        JOIN RFOperations.RFO_Accounts.PaymentProfiles (NOLOCK) PP ON AB.AccountID = PP.AccountID
        JOIN RodanFieldsLive.dbo.AccountPaymentMethods apm ON apm.AccountID = AB.AccountID
                                                              AND apm.AccountPaymentMethodID = PP.PaymentProfileID
        JOIN RFOperations.RFO_Accounts.CreditCardProfiles (NOLOCK) CCP ON PP.PaymentProfileID = CCP.PaymentProfileID
        JOIN RFOperations.RFO_Reference.CreditCardVendors (NOLOCK) V ON V.VendorID = CCP.VendorID
        JOIN Hybris.dbo.users hu ON CAST(PP.AccountID AS VARCHAR) = hu.p_rfaccountid
WHERE   AB.CountryID = @RFOCountry
        AND EXISTS ( SELECT 1
                     FROM   Hybris.dbo.paymentinfos (NOLOCK) PIN
                     WHERE  PIN.p_rfaccountpaymentmethodid = CAST(PP.PaymentProfileID AS NVARCHAR)
                            AND PIN.duplicate = 0 )
        AND hu.p_sourcename = 'Hybris-DM'
	    AND EXISTS (SELECT 1 FROM RFoperations.RFo_Accounts.Addresses ad WHERE ad.AddressID =ccp.BillingAddressID);

SELECT  CAST(PIN.code AS NVARCHAR(100)) AS code ,
        CAST(p_rfaccountpaymentmethodid AS NVARCHAR(100)) AS p_rfAccountPaymentMethodID ,
        CAST (PIN.OwnerPkString AS NVARCHAR) AS OwnerPKString ,
        CAST (PIN.userpk AS NVARCHAR) AS UserPK ,
        CAST (HU.p_rfaccountid AS NVARCHAR(100)) AS p_rfAccountId
		--, CAST (p_ccowner AS NVARCHAR (100)) AS ccowner
		--, CAST (p_number AS NVARCHAR (100)) AS number
		--, CAST (p_validtomonth AS NVARCHAR (100)) AS p_validtomonth
		--, CAST (p_validtoyear AS NVARCHAR (100)) AS p_validtoyear
        ,
        CAST (p_rfaddressid AS NVARCHAR(100)) AS p_billingaddress
		, CAST ('visa' AS NVARCHAR(100)) AS p_type
       --, CASE WHEN PIN.p_type = 8796093055067
       --      THEN CAST ('amex' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796093087835
       --      THEN CAST ('visa' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796093120603
       --      THEN CAST ('master' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796093153371
       --      THEN CAST ('diners' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796104818779
       --      THEN CAST ('maestro' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796104851547
       --      THEN CAST ('switch' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796104884315
       --      THEN CAST ('mastercard_eurocard' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796136177755
       --      THEN CAST ('discover' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796136210523
       --      THEN CAST ('mastercard' AS NVARCHAR(100))
       --      WHEN PIN.p_type = 8796136243291
       --      THEN CAST ('unknown' AS NVARCHAR(100))
       -- END AS p_type
INTO    #Hybris_PayInfo
FROM    Hybris.dbo.users (NOLOCK) HU
       LEFT JOIN Hybris.dbo.paymentinfos (NOLOCK) PIN ON PIN.OwnerPkString = HU.PK
        LEFT JOIN Hybris.dbo.addresses (NOLOCK) HA ON HA.PK = PIN.p_billingaddress
WHERE   
         HU.p_sourcename = 'Hybris-DM' AND pin.Duplicate =0  AND ha.Duplicate= 0;
				   


CREATE CLUSTERED INDEX MIX_PayProfID ON #RFO_PayInfo (PaymentProfileID);
CREATE CLUSTERED INDEX MIX_PayMethID ON #Hybris_PayInfo (p_rfAccountPaymentMethodID);





SELECT  *
INTO    #PayInfo
FROM    #RFO_PayInfo
EXCEPT
SELECT  *
FROM    #Hybris_PayInfo;


CREATE CLUSTERED INDEX MIX_PayProfID1 ON #PayInfo (PaymentProfileID);


SELECT  'RFO' ,
        COUNT(*)
FROM    #RFO_PayInfo; 

SELECT  'Hybris' ,
        COUNT(*)
FROM    #Hybris_PayInfo; 

SELECT  'Excepts' ,
        COUNT(*)
FROM    #PayInfo;


*/
/*=================================================================================================
-- Part 3 Column to Column Comparisons 
================================================================================================= */
/* 

TRUNCATE TABLE  DataMigration.Migration.ErrorLog_Accounts;


DECLARE @I INT = ( SELECT   MIN(MapID)
                   FROM     DataMigration.Migration.Metadata_Accounts
                   WHERE    HybrisObject = 'PaymentInfos'
                 ) ,
    @C INT = ( SELECT   MAX(MapID)
               FROM     DataMigration.Migration.Metadata_Accounts
               WHERE    HybrisObject = 'PaymentInfos'
             ); 

DECLARE @LastRun DATETIME = '01/01/1900'

DECLARE @DesKey NVARCHAR(50); 

DECLARE @SrcKey NVARCHAR(50); 

DECLARE @Skip BIT; 

WHILE ( @I <= @C )
    BEGIN 

        SELECT  @Skip = ( SELECT    Skip
                          FROM      DataMigration.Migration.Metadata_Accounts
                          WHERE     MapID = @I
                        );


        IF ( @Skip = 1 )
            SET @I = @I + 1;

        ELSE
            BEGIN 



                DECLARE @SrcCol NVARCHAR(50) = ( SELECT RFO_Column
                                                 FROM   DataMigration.Migration.Metadata_Accounts
                                                 WHERE  MapID = @I
                                               );

                DECLARE @DesTemp NVARCHAR(50) = ( SELECT    CASE
                                                              WHEN HybrisObject = 'Users'
                                                              THEN '#Hybris_Accounts'
                                                              WHEN HybrisObject = 'Addresses'
                                                              THEN '#Hybris_Addresses'
                                                              WHEN HybrisObject = 'PaymentInfos'
                                                              THEN '#Hybris_PayInfo'
                                                            END
                                                  FROM      DataMigration.Migration.Metadata_Accounts
                                                  WHERE     MapID = @I
                                                ); 

                DECLARE @DesCol NVARCHAR(50) = ( SELECT Hybris_Column
                                                 FROM   DataMigration.Migration.Metadata_Accounts
                                                 WHERE  MapID = @I
                                               );

                SET @SrcKey = ( SELECT  RFO_Key
                                FROM    DataMigration.Migration.Metadata_Accounts
                                WHERE   MapID = @I
                              );

                SET @DesKey = ( SELECT  CASE WHEN HybrisObject = 'Users'
                                             THEN 'p_rfAccountID'
                                             WHEN HybrisObject = 'Addresses'
                                             THEN 'p_rfAddressID'
                                             WHEN HybrisObject = 'PaymentInfos'
                                             THEN 'p_rfaccountPaymentMethodID'
                                        END
                                FROM    DataMigration.Migration.Metadata_Accounts
                                WHERE   MapID = @I
                              ); 


                DECLARE @SQL1 NVARCHAR(MAX) = ( SELECT  sqlstmt
                                                FROM    DataMigration.Migration.Metadata_Accounts
                                                WHERE   MapID = @I
                                              );
                DECLARE @SQL2 NVARCHAR(MAX) = ' 
 UPDATE A 
SET a.Hybris_Value = b. ' + @DesCol
                    + ' FROM DataMigration.Migration.ErrorLog_Accounts a  JOIN '
                    + @DesTemp + ' b  ON a.RecordID= b.' + @DesKey
                    + ' WHERE a.MAPID = ' + CAST(@I AS NVARCHAR);



                DECLARE @SQL3 NVARCHAR(MAX) = --'DECLARE @ServerMod DATETIME= ' + ''''+ CAST (@ServMod AS NVARCHAR) + ''''+
                    ' INSERT INTO DataMigration.Migration.ErrorLog_Accounts (Identifier,MapID,RecordID,RFO_Value) '
                    + @SQL1 + @SQL2;

                BEGIN TRY
                    EXEC sp_executesql @SQL3, N'@ServerMod DATETIME',
                        @ServerMod = @LastRun;

                    SET @I = @I + 1;


                END TRY

                BEGIN CATCH

                    SELECT  @SQL3;

                    SET @I = @I + 1;

                END CATCH;
            END; 

    END; 





DROP INDEX MIX_PayProfID ON #RFO_PayInfo; 
DROP INDEX MIX_PayMethID ON #Hybris_PayInfo; 
DROP INDEX MIX_PayProfID1 ON #PayInfo; 


SELECT b.MapID,  b.RFO_column, COUNT(*) AS Counts
FROM DataMigration.Migration.ErrorLog_Accounts A JOIN DataMigration.Migration.Metadata_Accounts B ON a.MapID =b.MapID
GROUP BY b.MapID, RFO_Column

*/

 /********************************************************************************************************************
-- FOR TROUBLESHOOTING INDIVIDUAL Accounts 

SELECT MapID, RecordID, '['+ RFO_Value + ']', '['+ Hybris_Value + ']' FROM DataMigration.Migration.ErrorLog_Accounts
WHERE MapID =66
