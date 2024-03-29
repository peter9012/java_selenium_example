USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[uspAccountPaymentProfile_BULK]    Script Date: 3/27/2017 11:16:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbqa].[uspAccount_Payment_Addresses_BULK] ( @LoadDate DATE )
AS
    BEGIN


        SET NOCOUNT ON;

        IF OBJECT_ID('TEMPDB.dbo.#RFO') IS NOT NULL
            DROP TABLE  #RFO;
        IF OBJECT_ID('TEMPDB.dbo.#Hybris') IS NOT NULL
            DROP TABLE #Hybris;
        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing  
        IF OBJECT_ID('tempdb.dbo.#MixMatch') IS NOT NULL
            DROP TABLE #MixMatch  


      
        DECLARE @SourceCount INT ,
            @TargetCount INT ,
            @message NVARCHAR(MAX) ,
            @Flows NVARCHAR(50)= 'Data Migration Delta-2' ,
            @owner NVARCHAR(50)= 'Account_Payment_Addresses' ,
            @Key NVARCHAR(25)= 'PaymentProfiles' ,
            @ValidationType NVARCHAR(50)= 'Counts' ,
            @OrderDate DATE ,
            @HardTermDate DATE

        SET @OrderDate = DATEADD(MONTH, -18, @LoadDate) 
        SET @HardTermDate = DATEADD(MONTH, -6, @LoadDate)

        SET @message = CONCAT('STEP: 1.RFOSource Table Started to Load.',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

		
		
        SELECT  pp.PaymentProfileID RFOKey ,--PaymentProfileID_Code
                b.AccountNumber AS [p_customerNumber] ,
               -- b.AccountID AS RFOKey ,
                LTRIM(RTRIM(ISNULL(ccp.NameOnCard, a.AddressProfileName))) ProfileName , --	p_ccowner
                LTRIM(RTRIM(Token)) AS DisplayNumber , --	p_number	
                pp.IsDefault AS IsDefaultPayInfo ,
                CASE v.Name
                  WHEN 'mastercard' THEN 'master'
                  WHEN 'Visa' THEN 'Visa'
                  WHEN 'Amex' THEN 'Amex'
                  WHEN 'Discover' THEN 'Discover'
                  ELSE NULL
                END AS VendorID , --	p_type
                ExpMonth , --	p_validtomonth
                ExpYear , --	p_validtoyear
                co.Alpha2Code AS CountryID ,
                a.Region ,
                apm.PhoneNumnber AS MainNumber ,
                adh.PhoneNumnber AS HomeNumber ,
                adc.PhoneNumnber AS CellNumber ,
                CASE WHEN a.AddressTypeID = 3 THEN 1
                     ELSE 0
                END AS IsBillingAddress , --	p_billingaddress
                CASE WHEN a.AddressTypeID = 1 THEN 1
                     ELSE 0
                END AS IsContactAddress , --	p_contactaddress
                CASE WHEN a.AddressTypeID = 2 THEN 1
                     ELSE 0
                END AS IsShippingAddress , --	p_shippingaddress
                a.Locale , --	p_town
                a.AddressLine1 , --	p_streetname
                a.AddressLine2 , --	p_streennumber
                ac.FirstName , --	p_firstname
                ac.LastName , --	p_lastname
                ac.MiddleName , --	p_MiddleName
                a.PostalCode
        INTO    #RFO
        FROM    RFOperations_03232017.RFO_Accounts.AccountBase b
                JOIN RFOperations_03232017.RFO_Accounts.PaymentProfiles (NOLOCK) PP ON b.AccountID = PP.AccountID 
                --JOIN RodanFieldsLive.dbo.AccountPaymentMethods apm ON apm.AccountID = b.AccountID
                --                                              AND apm.AccountPaymentMethodID = PP.PaymentProfileID
                JOIN RFOperations_03232017.RFO_Accounts.CreditCardProfiles (NOLOCK) CCP ON PP.PaymentProfileID = CCP.PaymentProfileID
                JOIN RFOperations_03232017.RFO_Reference.CreditCardVendors (NOLOCK) V ON V.VendorID = CCP.VendorID
                JOIN RFOperations_03232017.RFO_Accounts.Addresses a ON a.AddressID = ccp.BillingAddressID
                JOIN RFOperations_03152017.RFO_Reference.Countries co ON co.CountryID = a.CountryID
                JOIN RFOperations_03152017.RFO_Accounts.AccountContactAddresses aca ON aca.AddressID = a.AddressID
                                                              AND AddressTypeID = 3 -- Billing AddressType
                JOIN RFOperations_03152017.RFO_Accounts.AccountContacts ac ON ac.AccountContactId = aca.AccountContactId
                                                              AND ac.AccountContactTypeId = 1
                LEFT JOIN ( SELECT  app.addressID ,
                                    p.PhoneNumberRaw AS PhoneNumnber
                            FROM    RFOperations_03152017.RFO_Accounts.AddressPhones app
                                    JOIN RFOperations_03152017.RFO_Accounts.Phones p ON p.PhoneID = app.PhoneId
                                                              AND p.PhoneTypeID = 3
                          ) adc ON adc.AddressId = a.AddressID
			                                               AND ac.AccountContactTypeId = 1
                LEFT JOIN ( SELECT  app.addressID ,
                                    p.PhoneNumberRaw AS PhoneNumnber
                            FROM    RFOperations_03152017.RFO_Accounts.AddressPhones app
                                    JOIN RFOperations_03152017.RFO_Accounts.Phones p ON p.PhoneID = app.PhoneId
                                                              AND p.PhoneTypeID = 3
                          ) apm ON adc.AddressId = a.AddressID
		                                               AND ac.AccountContactTypeId = 1
                LEFT JOIN ( SELECT  app.addressID ,
                                    p.PhoneNumberRaw AS PhoneNumnber
                            FROM    RFOperations_03152017.RFO_Accounts.AddressPhones app
                                    JOIN RFOperations_03152017.RFO_Accounts.Phones p ON p.PhoneID = app.PhoneId
                                                              AND p.PhoneTypeID = 3
                          ) adh ON adc.AddressId = a.AddressID
        WHERE   EXISTS ( SELECT 1
                         FROM   RFOperations_03232017.RFO_Accounts.AccountBase ab
                                JOIN RFOperations_03232017.RFO_Accounts.AccountRF rf ON ab.AccountID = rf.AccountID
                                  --  JOIN RFOperations_03232017.RFO_Reference.AccountContactType t ON t.AccountContactTypeID = ab.AccountTypeID
                         WHERE  ab.accountID = b.AccountID
                                    --AND ea.EmailAddressTypeID = 1
                                AND ab.AccountNumber <> 'AnonymousRetailAccount'
                                AND ( ab.AccountStatusID IN ( 1, 2, 8, 9 ) -- Active,Inactive,SoftVoluntary,SoftInvoluntary
                                      OR ( ab.AccountStatusID = 10
                                           AND EXISTS ( SELECT
                                                              1
                                                        FROM  RFOperations_03232017.Hybris.orders ro
                                                        WHERE ro.AccountID = ab.AccountID
                                                              AND CAST(ro.CompletionDate AS DATE) >= @HardTermDate ) --HardTerm with 6 months order
                                         )
                                      OR ( ab.AccountStatusID IN ( 3, 4, 5, 6,
                                                              7 )
                                           AND EXISTS ( SELECT
                                                              1
                                                        FROM  RFOperations_03232017.Hybris.orders ro
                                                        WHERE ro.AccountID = ab.AccountID
                                                              AND CAST(ro.CompletionDate AS DATE) >= @OrderDate )--Other Status with 18 months orders
                                         )
                                    ) )
                AND EXISTS ( SELECT 1
                             FROM   Hybris.dbo.users u
                             WHERE  u.p_customerid = b.AccountID )
/*
SELECT  *
FROM    RFOperations_03232017.RFO_Accounts.Addresses a
        RIGHT JOIN RFOperations_03232017.RFO_Accounts.CreditCardProfiles b ON a.AddressID = b.BillingAddressID
WHERE   a.AddressID IS NULL  

*/



        SET @message = CONCAT(' STEP: 2. Target Table Loading.', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message



	

        SELECT  CAST(REPLACE(p.p_code, 'AC-', '') AS BIGINT) HybrisKey ,
                --CAST(u.p_customerid AS BIGINT) AS HybrisKey ,
                p_ccowner , --	ProfileName
                LTRIM(RTRIM(p_number)) p_number , --	DisplayNumber
                ct.Code AS p_type , --	VendorID
                p_validtomonth , --	ExpMonth
                p_validtoyear , --	ExpYear
               -- p.p_billingaddress , --	BillingAddressID
               -- p_lastfourdigit , --	LastFourNumber
                ISNULL(p_cctoken, '') p_cctoken , --	cctoken
               -- p.p_original ,
              --  p.OwnerPkString ,
                CASE WHEN u.p_defaultpaymentinfo = p.pk THEN 1
                     ELSE 0
                END AS IsDefaultInfo ,
                ROW_NUMBER() OVER ( PARTITION BY p.p_code ORDER BY p.createdTS DESC ,p.pk DESC ) AS RowNumber ,
                co.p_isocode AS p_counrty , --	CountryID
                r.p_isocodeshort AS p_region , --	region
                p_phone1 , --	MainNumber
                p_phone2 , --	HomeNumber
                p_cellphone , --	CellNumber
                g.Code AS p_gender , --	GenderID
                a.p_billingaddress , --	IsBillingAddress
                p_contactaddress , --	IsContactAddress
                p_shippingaddress , --	IsShippingID
                p_town , --	Locale
                p_streetname , --	AddressLine1
                p_streetnumber , --	AddressLine2
                p_firstname , --	FirstName
                p_lastname , --	LastName
                p_MiddleName , --	MiddleName
                p_postalcode , --	PostalCode
                a.p_dateofbirth --	BirthDay   
                ,
                a.pk AS AddressPK
        INTO    #Hybris
        FROM    Hybris.dbo.users (NOLOCK) u
                JOIN Hybris.dbo.paymentinfos (NOLOCK) p ON p.OwnerPkString = u.PK
                LEFT JOIN Hybris.dbo.enumerationvalues v ON v.pk = u.p_type
                LEFT JOIN Hybris.dbo.enumerationvalues ct ON ct.pk = p.p_type
                JOIN Hybris.dbo.addresses (NOLOCK) a ON a.PK = p.p_billingaddress
                LEFT JOIN Hybris.dbo.countries co ON co.pk = a.p_country
                LEFT  JOIN Hybris.dbo.regions r ON r.pk = a.p_region
                LEFT JOIN Hybris.dbo.enumerationvalues g ON g.pk = a.p_gender
        WHERE   a.p_billingaddress = 1
                AND v.Code IN ( 'Retail', 'Preferred', 'Consultant' )
                AND u.p_uid <> 'anonymous'
                AND EXISTS ( SELECT 1
                             FROM   RFOperations_03232017.RFO_Accounts.AccountBase ab
                                    JOIN RFOperations_03232017.RFO_Accounts.AccountRF rf ON ab.AccountID = rf.AccountID
                                  --  JOIN RFOperations_03232017.RFO_Reference.AccountContactType t ON t.AccountContactTypeID = ab.AccountTypeID
                             WHERE  ab.accountID = u.p_customerid
                                    --AND ea.EmailAddressTypeID = 1
                                    AND ab.AccountNumber <> 'AnonymousRetailAccount'
                                    AND ( ab.AccountStatusID IN ( 1, 2, 8, 9 ) -- Active,Inactive,SoftVoluntary,SoftInvoluntary
                                          OR ( ab.AccountStatusID = 10
                                               AND EXISTS ( SELECT
                                                              1
                                                            FROM
                                                              RFOperations_03232017.Hybris.orders ro
                                                            WHERE
                                                              ro.AccountID = ab.AccountID
                                                              AND CAST(ro.CompletionDate AS DATE) >= @HardTermDate ) --HardTerm with 6 months order
                                             )
                                          OR ( ab.AccountStatusID IN ( 3, 4, 5,
                                                              6, 7 )
                                               AND EXISTS ( SELECT
                                                              1
                                                            FROM
                                                              RFOperations_03232017.Hybris.orders ro
                                                            WHERE
                                                              ro.AccountID = ab.AccountID
                                                              AND CAST(ro.CompletionDate AS DATE) >= @OrderDate )--Other Status with 18 months orders
                                             )
                                        ) )



DELETE #Hybris WHERE RowNumber>1

        SET @message = CONCAT(' STEP:3.Creating Index in Temp tables',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

		


        CREATE CLUSTERED INDEX cls_RFO ON  #RFO([RFOKey])
        CREATE CLUSTERED INDEX cls_Hybris ON #Hybris([HybrisKey])

/* Source to Target Total Counts */


--++++++++++++++++++++++++++++++++++++
--  Count Validation
--++++++++++++++++++++++++++++++++++++

     




        SET @message = CONCAT(' STEP: 4. COUNT Validation Started ', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


        SELECT  @SourceCount = COUNT([RFOKey])
        FROM    #RFO
        SELECT  @TargetCount = COUNT([HybrisKey])
        FROM    #Hybris

-- INSERTING LOG FOR TOTALCOUNT VALIDATION.

        INSERT  INTO dbqa.SourceTargetLog
                ( FlowTypes ,
                  ValidationTypes ,
                  [Owner] ,
                  SourceCount ,
                  TargetCount ,
                  Comments ,
                  ExecutionStatus 
                )
        VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                  @ValidationType , -- ValidationTypes - nvarchar(50)
                  @Owner , -- Owner - nvarchar(50)
                  @SourceCount , -- SourceCount - int
                  @TargetCount , -- TargetCounts - int
                  CASE WHEN @SourceCount > @TargetCount
                       THEN CONCAT('RFO Count More than HYBRIS BY ',
                                   CAST(@SourceCount - @TargetCount AS NVARCHAR(10)))
                       WHEN @SourceCount < @TargetCount
                       THEN CONCAT('HYBRIS Count More than RFO Count By ',
                                   CAST(@TargetCount - @SourceCount AS NVARCHAR(10)))
                       ELSE 'RFO and HYBRIS Counts are equal'
                  END ,
                  CASE WHEN @SourceCount = @TargetCount THEN 'PASSED'
                       ELSE 'FAILED'
                  END
                )
		

        SET @message = CONCAT('STEP: 5. DUPLICATE Validation Started ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

--++++++++++++++++++--++++++++++++++++++
--  RFO  DUPLICATE VALIDATION
--++++++++++++++++++--++++++++++++++++++

        SET @SourceCount = 0
        SET @TargetCount = 0
        SET @ValidationType = 'Duplicate'

        DECLARE @DUP TABLE
            (
              [key] NVARCHAR(225) ,
              SourceFrom NVARCHAR(225)
            );

        INSERT  INTO @DUP
                ( [key] ,
                  SourceFrom
                )
                SELECT  RFOKey ,
                        'RFO' AS [SourceFrom]
                FROM    #RFO
                GROUP BY RFOKey ,
                        ProfileName
                HAVING  COUNT(RFOKey) > 1

        INSERT  INTO @DUP
                ( [key] ,
                  SourceFrom
                )
                SELECT  HybrisKey ,
                        'Hybris' AS [SourceFrom]
                FROM    #Hybris
                GROUP BY HybrisKey ,
                        p_ccowner
                HAVING  COUNT(HybrisKey) > 1
		
        SELECT  @SourceCount = COUNT([key])
        FROM    @DUP
        WHERE   SourceFrom = 'RFO'
        SELECT  @TargetCount = COUNT([key])
        FROM    @DUP
        WHERE   SourceFrom = 'Hybris'

        INSERT  INTO dbqa.SourceTargetLog
                ( FlowTypes ,
                  ValidationTypes ,
                  [Owner] ,
                  SourceCount ,
                  TargetCount ,
                  Comments ,
                  ExecutionStatus
                )
        VALUES  ( @flows , -- FlowTypes - nvarchar(50)
                  @validationType , -- ValidationTypes - nvarchar(50)
                  @Owner , -- Owner - nvarchar(50)
                  @SourceCount , -- SourceCount - int
                  @TargetCount , -- TargetCounts - int
                  CASE WHEN @SourceCount >= 1
                            AND @TargetCount >= 1
                       THEN 'Source and Target has  Duplicates'
                       WHEN @SourceCount >= 1 THEN 'Source  has  Duplicates'
                       WHEN @TargetCount >= 1 THEN 'Target has  Duplicates'
                       ELSE 'Both has No duplicate'
                  END ,
                  CASE WHEN @SourceCount >= 1
                            OR @TargetCount >= 1 THEN 'Fail'
                       ELSE 'Passed'
                  END
                )
               


        INSERT  INTO dbqa.ErrorLog
                ( FlowTypes ,
                  Owner ,
                  Flag ,
                  SourceColumn ,
                  TargetColumn ,
                  [Key] ,
                  SourceValue ,
                  TargetValue
                )
                SELECT TOP 10
                        @Flows , -- FlowTypes - nvarchar(50)
                        @Owner , -- Owner - nvarchar(50)
                        @ValidationType , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @Key , -- Key - nvarchar(50)
                        [key] , -- SourceValue - nvarchar(50)
                        NULL
                FROM    @DUP
                WHERE   SourceFrom = 'RFO'
                UNION ALL
                SELECT TOP 10
                        @Flows , -- FlowTypes - nvarchar(50)
                        @Owner , -- Owner - nvarchar(50)
                        @ValidationType , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @Key , -- Key - nvarchar(50)
                        NULL , -- SourceValue - nvarchar(50)
                        [key]
                FROM    @DUP
                WHERE   SourceFrom = 'Hybris'       
		



--++++++++++++++++++++++++++++++++++++++++++
-- MISSING IN SOURCE AND MISSING IN TARGET 
--++++++++++++++++++++++++++++++++++++++++++

        SET @message = CONCAT('STEP: 6. MISSING Validation Started ', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


--US ACCOUNTS SCTOTG  MISSING VALIDATION 

        SELECT  a.RFOKey ,
                b.HybrisKey ,
                CASE WHEN a.RFOkey IS NULL
                     THEN 'MissingInRFO-LoadedExtraInHybris'
                     WHEN b.HybrisKey IS NULL
                     THEN 'MissingInHybris-NotLoadedInHybris'
                END AS [Missing From ]
        INTO    #Missing
        FROM    #RFO a
                FULL OUTER JOIN #Hybris b ON a.RFOKey = b.HybrisKey
        WHERE   a.RFOKey IS NULL
                OR b.HybrisKey IS NULL 



        SET @SourceCount = 0
        SET @TargetCount = 0
        SET @ValidationType = 'Missing'

        SELECT  @SourceCount = COUNT(*)
        FROM    #Missing
        WHERE   [Missing From ] = 'MissingInRFO-LoadedExtraInHybris'
        SELECT  @TargetCount = COUNT(*)
        FROM    #Missing
        WHERE   [Missing From ] = 'MissingInHybris-NotLoadedInHybris'
	
        IF ( ISNULL(@TargetCount, 0) > 0
             OR ISNULL(@SourceCount, 0) > 0
           )
            INSERT  INTO dbqa.SourceTargetLog
                    ( FlowTypes ,
                      ValidationTypes ,
                      [Owner] ,
                      SourceCount ,
                      TargetCount ,
                      Comments ,
                      ExecutionStatus
                    )
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
                      @Owner , -- Owner - nvarchar(50)
                      @SourceCount ,
                      @TargetCount , -- SourceCount - int         
                      CONCAT('RFO Missing Count=',
                             CAST(@SourceCount AS NVARCHAR(10)),
                             ' and Hybris Counts=',
                             CAST(@TargetCount AS NVARCHAR(10))) ,
                      'FAILED'
                    )
        ELSE
            INSERT  INTO dbqa.SourceTargetLog
                    ( FlowTypes ,
                      ValidationTypes ,
                      [Owner] ,
                      Comments ,
                      ExecutionStatus
                    )
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
                      @Owner , -- Owner - nvarchar(50)
                      'No Missing from RFO and Hybris' ,
                      'PASSED'
                    )

					

-- LOADING ERROR WITH SAMPLE DATA.

        INSERT  INTO dbqa.ErrorLog
                ( FlowTypes ,
                  Owner ,
                  Flag ,
                  SourceColumn ,
                  TargetColumn ,
                  [Key] ,
                  SourceValue ,
                  TargetValue
                )
                SELECT TOP 10
                        @Flows , -- FlowTypes - nvarchar(50)
                        @Owner , -- Owner - nvarchar(50)
                        [Missing From ] , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @Key , -- Key - nvarchar(50)
                        RFOKey , -- SourceValue - nvarchar(50)
                        HybrisKey
                FROM    #Missing
                WHERE   [Missing From ] = 'MissingInRFO-LoadedExtraInHybris'
                UNION
                SELECT TOP 10
                        @Flows , -- FlowTypes - nvarchar(50)
                        @Owner , -- Owner - nvarchar(50)
                        [Missing From ] , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @Key , -- Key - nvarchar(50)
                        RFOKey , -- SourceValue - nvarchar(50)
                        HybrisKey
                FROM    #Missing
                WHERE   [Missing From ] = 'MissingInHybris-NotLoadedInHybris'
			




-- MixNMatch

        SET @message = CONCAT(' STEP: 7. MIXMATCH Validation Started',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT  a.RFOKey ,
                b.[HybrisKey] ,
                RFC ,
                HBC ,
                CASE WHEN a.RFC > b.HBC
                     THEN 'paymentInfos Not Loaded in hybris'
                     WHEN a.RFC < b.HBC
                     THEN 'paymentInfos Extra Loaded in hybris'
                END AS MixMatch
        INTO    #MixMatch
        FROM    ( SELECT    RFOKey ,
                            COUNT(*) AS [RFC]
                  FROM      #RFO
                  GROUP BY  RFOKey
                ) a
                JOIN ( SELECT   HybrisKey ,
                                COUNT(*) AS [HBC]
                       FROM     #Hybris
                       GROUP BY HybrisKey
                     ) b ON a.RFOKey = b.[HybrisKey]
        WHERE   a.RFC <> b.HBC



        SET @SourceCount = 0
        SET @TargetCount = 0
        SET @ValidationType = 'MixMatch'

        SELECT  @SourceCount = COUNT(*)
        FROM    #MixMatch
 
        SELECT  @TargetCount = COUNT(*)
        FROM    #MixMatch

	
        IF ( ISNULL(@TargetCount, 0) > 0
             OR ISNULL(@SourceCount, 0) > 0
           )
            INSERT  INTO dbqa.SourceTargetLog
                    ( FlowTypes ,
                      ValidationTypes ,
                      [Owner] ,
                      SourceCount ,
                      TargetCount ,
                      Comments ,
                      ExecutionStatus
                    )
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
                      @Owner , -- Owner - nvarchar(50)
                      @SourceCount ,
                      @TargetCount , -- SourceCount - int         
                      CONCAT('RFO MixMatch Count=',
                             CAST(@SourceCount AS NVARCHAR(10)),
                             ' and Hybris Counts=',
                             CAST(@TargetCount AS NVARCHAR(10))) ,
                      'FAILED'
                    )
        ELSE
            INSERT  INTO dbqa.SourceTargetLog
                    ( FlowTypes ,
                      ValidationTypes ,
                      [Owner] ,
                      Comments ,
                      ExecutionStatus
                    )
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
                      @Owner , -- Owner - nvarchar(50)
                      'No MixMatch Counts' ,
                      'PASSED'
                    )




   
        INSERT  INTO dbqa.ErrorLog
                ( FlowTypes ,
                  Owner ,
                  Flag ,
                  SourceColumn ,
                  TargetColumn ,
                  [Key] ,
                  SourceValue ,
                  TargetValue
                )
                SELECT TOP 10
                        @Flows , -- FlowTypes - nvarchar(50)                      
                        @Owner , -- Owner - nvarchar(50)
                        @ValidationType , -- ValidationTypes - nvarchar(50)
                        RFOKey , -- SourceColumn - nvarchar(50)
                        HybrisKey , -- TargetColumn - nvarchar(50)
                        @key , -- Key - nvarchar(50)
                        ISNULL(RFC, 0) , -- SourceValue - nvarchar(50)
                        ISNULL(HBC, 0)
                FROM    #MixMatch




--++++++++++++++++++++++++++++++++++++++++++++++++++
 --VALIDATION STARTING FOR END TO END 
--++++++++++++++++++++++++++++++++++++++++++++++++++
	


        SET @message = CONCAT(' STEP: 8.Removing Issues for END TO END Validaion  ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


        DELETE  a
        FROM    #RFO a
                JOIN #Missing m ON m.RFOKey = a.RFOKey 
		

        DELETE  a
        FROM    #RFO a
                JOIN #MixMatch m ON m.RFOKey = a.RFOKey 				   
						 
			


        DELETE  a
        FROM    #Hybris a
                JOIN #Missing m ON m.HybrisKey = a.HybrisKey 

        DELETE  a
        FROM    #Hybris a
                JOIN #MixMatch m ON m.HybrisKey = a.HybrisKey 

       

	   
       
        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing  
        IF OBJECT_ID('tempdb.dbo.#MixMatch') IS NOT NULL
            DROP TABLE #MixMatch  

        DELETE  @Dup;




        SET @SourceCount = ( SELECT COUNT(DISTINCT HybrisKey)
                             FROM   #Hybris a
                                    JOIN #RFO b ON a.HybrisKey = b.RFOKey
                           )
  
      
      
        SET @message = CONCAT(' STEP: 9.Total Records for End to End= ',
                              CAST(@SourceCount AS NVARCHAR(10)), CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


        IF OBJECT_ID('Tempdb.dbo.#Temp') IS NOT NULL
            DROP TABLE #Temp
			
        SELECT  * ,
                ROW_NUMBER() OVER ( ORDER BY mapID ) AS [RowNumber]
     INTO    #Temp
        FROM    dbqa.Map_tab
        WHERE   [Owner] IN ('AccountAddresses','AccountPaymentProfiles')
                AND [flag] IN ( 'c2c', 'ref', 'def' )
				AND MapID NOT IN (39,40,41,42,43,44,45,63,64,65,52,53,54)


		
		
        DECLARE @MaxRow INT ,
            @RowNumber INT ,
            @rowCounts INT= 0 ,
            @TargetColumn NVARCHAR(50) ,
            @SourceColumn NVARCHAR(25) ,
            @flag NVARCHAR(50) ,
            @Stmt NVARCHAR(MAX);
        DECLARE @temp TABLE
            (
              [key] VARCHAR(50) ,--[Key]
              SourceValue VARCHAR(MAX) ,--[SourceColumn]
              TargetValue VARCHAR(MAX) --[TargetColumn] 
            );


        SELECT  @MaxRow = MAX(RowNumber)
        FROM    #Temp
        IF ISNULL(@MaxRow, 0) > 0
            BEGIN
                SET @Message = CONCAT('STEP: 9.Validation Started For Columnt To Column with  total fields= '
                                      + CAST(@MaxRow AS NVARCHAR(20)),
                                      CHAR(10),
                                      '-----------------------------------------------')              
                EXECUTE dbqa.uspPrintMessage @message
-- Print Message no wait.

                SET @RowNumber = 1
                WHILE ( @MaxRow >= @RowNumber )
                    BEGIN
                        SELECT  @Flag = [flag] ,
                                @TargetColumn = TargetColumn ,
                                @SourceColumn = SourceColumn ,
                                @RowNumber = RowNumber ,
                                @Stmt = [SQL Stmt]
                        FROM    #Temp
                        WHERE   RowNumber = @RowNumber

                        SET @Message = CONCAT('Column Validation Started For ',
                                              CAST(@RowNumber AS NVARCHAR(20)),
                                              '. ', @TargetColumn, CHAR(10),
                                              '-----------------------------------------------')
                        EXECUTE dbqa.uspPrintMessage @message

                        INSERT  INTO @temp
                                ( [key], SourceValue,--[SourceColumn]
                                  TargetValue  --[TargetColumn]  
                                  )
                                EXEC sp_executesql @stmt 
                        SELECT  @rowCounts = COUNT(DISTINCT [key])
                        FROM    @temp
						
                        IF @rowCounts <> 0
                            BEGIN
                                SET @Message = CONCAT('Total IssueCount=',
                                                      CAST(@rowCounts AS NVARCHAR(12)),
                                                      ' for ', @TargetColumn,
                                                      CHAR(10),
                                                      '-----------------------------------------------')
                                EXECUTE dbqa.uspPrintMessage @message


                                INSERT  INTO dbqa.SourceTargetLog
                                        ( FlowTypes ,
                                          ValidationTypes ,
                                          Owner ,
                                          SourceCount ,
                                          TargetCount ,
                                          comments ,
                                          ExecutionStatus
                                        )
                                VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                                          CONCAT(@Flag, '_EndToEnd') , -- ValidationTypes - nvarchar(50)
                                          @Owner , -- Owner - nvarchar(50)
                                          @rowCounts , -- SourceCount - int
                                          @rowCounts , -- TargetCounts - int
                                          CONCAT(@SourceColumn, ' Vs ',
                                                 @TargetColumn) , -- Defference - nvarchar(100)
                                          'FAILED'
                                        )

                                INSERT  INTO dbqa.ErrorLog
                                        ( FlowTypes ,
                                          [Owner] ,
                                          Flag ,
                                          SourceColumn ,
                                          TargetColumn ,
                                          [Key] ,
                                          SourceValue ,
                                          TargetValue
                                        )
                                        SELECT TOP 10
                                                @Flows ,
                                                @Owner ,
                                                CONCAT(@Flag, '_EndToEnd') ,
                                                @SourceColumn ,
                                                @TargetColumn ,
                                                CONCAT(@Key, '=', [Key]) ,
                                                SourceValue ,
                                                TargetValue
                                        FROM    @temp
                            END 
                        ELSE
                            BEGIN 
                                INSERT  INTO dbqa.SourceTargetLog
                                        ( FlowTypes ,
                                          ValidationTypes ,
                                          Owner ,
                                          SourceCount ,
                                          TargetCount ,
                                          comments ,
                                          ExecutionStatus
                                        )
                                VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                                          CONCAT(@Flag, '_EndToEnd') , -- ValidationTypes - nvarchar(50)
                                          @Owner , -- Owner - nvarchar(50)
                                          @rowCounts , -- SourceCount - int
                                          @rowCounts , -- TargetCounts - int
                                          CONCAT(@SourceColumn, ' Vs ',
                                                 @TargetColumn) , -- Defference - nvarchar(100)
                                          'PASSED'
                                        )
								

                            END 

                        DELETE  @temp
               -- PRINT @Stmt
                        SET @RowNumber = @RowNumber + 1

                    END 



            END
    END 

