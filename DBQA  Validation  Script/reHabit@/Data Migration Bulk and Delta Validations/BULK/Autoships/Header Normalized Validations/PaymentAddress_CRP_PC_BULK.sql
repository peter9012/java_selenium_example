USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[uspAutoshipBillingAddress_BULK]    Script Date: 2/27/2017 1:30:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbqa].[uspAutoshipBillingAddress_CRP_PC_BULK]
AS
    BEGIN

        SET NOCOUNT ON;

        IF OBJECT_ID('TEMPDB.dbo.#RFO') IS NOT NULL
            DROP TABLE #RFO;
        IF OBJECT_ID('TEMPDB.dbo.#Hybris') IS NOT NULL
            DROP TABLE  #Hybris;
        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing
        IF OBJECT_ID('tempdb.dbo.#MixMatch') IS NOT NULL
            DROP TABLE #MixMatch  


        DECLARE @message NVARCHAR(100) ,
            @SourceCount INT ,
            @TargetCount INT ,
            @flows NVARCHAR(50)= 'Data Migration' ,
            @validationType NVARCHAR(50)= 'Counts' ,
            @Owner NVARCHAR(50)= 'CRP_PC_Autoship_PaymentAddresses' ,
            @key NVARCHAR(25)= 'AutoshipNumber' 

        SET @message = CONCAT(' STEP: 1.RFOSource Table Started to Load.',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

		 SELECT  a.AutoshipID ,
                a.AutoshipNumber ,
                ROW_NUMBER() OVER ( PARTITION BY AccountID, AutoshipTypeID ORDER BY ServerModifiedDate DESC ) AS RN
        INTO    #Autoship
        FROM    RFOperations_02022017.Hybris.Autoship a
                JOIN ( SELECT DISTINCT
                                ap.AutoshipID
                       FROM     RFOperations_02022017.Hybris.AutoshipPayment ap --JOIN RFOperations_02022017.Hybris.AutoshipShipment os ON os.AutoshipID = ap.AutoshipID
                                JOIN RFOperations_02022017.Hybris.AutoshipItem oi ON oi.AutoshipId = ap.AutoshipID
                                JOIN RFOperations_02022017.Hybris.AutoshipShippingAddress asa ON asa.AutoShipID = ap.AutoshipID
                                JOIN RFOperations_02022017.Hybris.AutoshipPaymentAddress apa ON apa.AutoShipID = ap.AutoshipID
                     ) ap ON ap.AutoshipID = a.AutoshipID  --AND a.AccountID = 2083918
        WHERE   a.Active = 1
                AND a.AutoshipTypeID IN ( 1, 2 )
                AND EXISTS ( SELECT 1
                             FROM   Hybris.dbo.users u
                                    LEFT JOIN Hybris.dbo.enumerationvalues v ON v.pk = u.p_accountstatus
                                                              AND v.Code = 'Active'
                             WHERE  u.p_customerid = a.accountId )
                AND NOT EXISTS ( SELECT 1
                                 FROM   RFOperations_02022017.Hybris.Autoship at
                                        JOIN RFOperations_02022017.RFO_Accounts.AccountBase b ON b.AccountID = at.AccountID
                                                              AND at.Active = 1
                                 WHERE  at.AccountID = a.AutoshipID
                                        AND ( ( at.AutoshipTypeID = 1
                                                AND b.AccountTypeID <> 2
                                              )
                                              OR ( at.AutoshipTypeID = 2
                                                   AND b.AccountTypeID <> 1
                                                 )
                                            ) )
                AND EXISTS ( SELECT 1
                             FROM   Hybris.dbo.carts c
                             WHERE  SUBSTRING(p_code,
                                              CHARINDEX('-', p_code, 1) + 1,
                                              ( LEN(p_code) - CHARINDEX('-',
                                                              p_code, 1) )) = a.AutoshipNumber
                                    AND c.p_code LIKE 'scheduledcart%' )
										        

        DELETE  FROM #Autoship
        WHERE   RN > 1

        CREATE CLUSTERED INDEX cls_AutoshipID ON #Autoship(AutoshipID)

        SELECT  a.AutoshipNumber AS [RFOKey] ,
                ISNULL(apa.FirstName,ac.FirstName) FirstName, --	p_firstname
               ISNULL(apa.LastName,ac.LastName) LastName, --	p_lastname
               co.Alpha2Code AS CountryID , --	p_country
                Address1 , --	p_streetname
                AddressLine2 , --	p_streetNumber
                PostalCode , --	p_postalcode
                Locale , --	p_town
                Region , --	p_region
                Telephone , --	p_phone1
                apa.MiddleName , --	p_middlename
                IIF(CAST(ac.Birthday AS DATE) = '1900-01-01', NULL, ac.Birthday) DateOfBirth , --	p_dateofbirth
                CASE WHEN g.Name IN ( 'Male', 'Female' ) THEN g.Name
                     ELSE NULL
                END AS GenderID  --	p_gender 
        INTO    #RFO
		-- SELECT top 100 apa.AutoshipPaymentAddressID--,COUNT(apa.AutoshipPaymentAddressID)
        FROM    RFOperations_02022017.Hybris.AutoshipPaymentAddress apa
                JOIN RFOperations_02022017.Hybris.Autoship a ON a.AutoshipID = apa.AutoshipId
                                                       AND a.Active = 1
                LEFT JOIN RFOperations_02022017.RFO_Accounts.AccountContacts ac ON ac.AccountId = a.AccountID
                                                              AND ac.AccountContactTypeId = 1
               LEFT JOIN RFOperations_02022017.RFO_Reference.Gender g ON g.GenderID = ac.GenderId
			   LEFT JOIN RFOperations_02022017.RFO_Reference.Countries co ON co.CountryID=apa.CountryID
        WHERE   EXISTS ( SELECT 1
                         FROM   #Autoship at
                         WHERE  at.AutoshipID = a.AutoshipID ) -- Migrated Templates Only.
		/*
		EXISTS ( SELECT 1
                         FROM   RFOperations.Hybris.AutoshipShippingAddress asp
                                JOIN RFOperations.Hybris.AutoshipItem ai ON ai.AutoshipID = asp.AutoShipID
                                JOIN RFOperations.Hybris.AutoshipPayment ap ON ap.AutoShipID = asp.AutoshipID
                         WHERE  asp.AutoShipID = apa.AutoshipID )
                AND EXISTS ( SELECT 1
                             FROM   Hybris.dbo.users u
                             WHERE  u.p_customerid = CAST(a.AccountID AS NVARCHAR(225)) )
              */
			  --GROUP BY apa.AutoshipPaymentAddressID
			  --HAVING count(apa.AutoshipPaymentAddressID)>1


        SET @message = CONCAT('STEP: 2.Target Table Started to Load', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message
	

        SELECT    SUBSTRING(c.p_code, CHARINDEX('-', c.p_code, 1) + 1,
                          ( LEN(c.p_code) - CHARINDEX('-', c.p_code, 1) )) AS [HybrisKey] ,
                p_firstname , --	FirstName
                p_lastname , --	LastName
                co.p_isocode AS p_country , --	CountryID
                p_streetname , --	Address1
                p_streetNumber , --	AddressLine2
                p_postalcode , --	PostalCode
                p_town , --	Locale
                r.p_isocodeshort AS p_region , --	Region
                p_phone1 , --	Telephone
                p_middlename , --	MiddleName
                p_dateofbirth , --	DateOfBirth
                g.Code AS p_gender , --	GenderID
                ad.OwnerPkString , --	 
                ad.p_billingaddress , --	 
                ad.p_duplicate
        INTO    #Hybris
        --	SELECT  COUNT(ad.pk)
        FROM    Hybris.dbo.addresses ad -- JOIN Hybris.dbo.paymentinfos pa ON pa.PK = ad.OwnerPkString
                                                 
                                                  -- AND ad.p_duplicate = 1
                JOIN Hybris.dbo.carts c ON c.p_paymentaddress = ad.PK
                                            AND ad.p_billingaddress = 1
                --JOIN Hybris.dbo.enumerationvalues ct ON ct.pk = ca.p_carttype
                --                                        AND ct.Code = 'AUTOSHIP_CART'
                --JOIN Hybris.dbo.cronjobs cj ON cj.p_cart = ca.PK
                --JOIN Hybris.dbo.composedtypes jt ON jt.pk = cj.TypePkString
                --                                    AND jt.InternalCode = 'CartToOrderCronJob'
                --JOIN Hybris.dbo.triggerscj tcj ON tcj.p_cronjob = cj.PK
                LEFT JOIN Hybris.dbo.countries co ON co.pk = ad.p_country
                LEFT JOIN Hybris.dbo.regions r ON r.pk = ad.p_region
                LEFT JOIN Hybris.dbo.enumerationvalues g ON g.pk = ad.p_gender
				  WHERE   c.p_code LIKE '%scheduledcart%'
                AND EXISTS ( SELECT 1
                             FROM   #Autoship a
                             WHERE  a.autoshipNumber = SUBSTRING(c.p_code,
                                                              CHARINDEX('-',
                                                              c.p_code, 1) + 1,
                                                              ( LEN(c.p_code)
                                                              - CHARINDEX('-',
                                                              c.p_code, 1) )) )

        SET @message = CONCAT(' STEP:3.Creating Indexes in Temps', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message  

	
        CREATE CLUSTERED INDEX cls_RFO ON #RFO ([RFOKey])
        CREATE CLUSTERED INDEX cls_Hybris ON   #Hybris ([HybrisKey])
	
		


--++++++++++++++++++++++++++++++++++++++++++++++++++++
--  COUNT, DUPLICATE AND MISSING  VALIDATION
--++++++++++++++++++++++++++++++++++++++++++++++++++++


        SET @message = CONCAT(' STEP: 4.initiating COUNT Validation  ',
                              CHAR(10),
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
        VALUES  ( @flows , -- FlowTypes - nvarchar(50)
                  @validationType , -- ValidationTypes - nvarchar(50)
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
		




		

--++++++++++++++++++--++++++++++++++++++
--  RFO  DUPLICATE VALIDATION
--++++++++++++++++++--++++++++++++++++++
        SET @message = CONCAT(' STEP: 5.initiating DUPLICATE Need to updaete Scripts   ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


--        SET @SourceCount = 0
--        SET @TargetCount = 0   
--        SET @validationType = 'Duplicate'
--        SELECT  @SourceCount = COUNT(t.Ct)
--        FROM    ( SELECT    COUNT([RFOKey]) Ct
--                  FROM      #RFO
--                  GROUP BY  [RFOKey] ,
--                            PaymentProfileID
--                  HAVING    COUNT([RFOKey]) > 1
--                ) t



--        IF ISNULL(@SourceCount, 0) > 0
--            INSERT  INTO dbqa.SourceTargetLog
--                    ( FlowTypes ,
--                      ValidationTypes ,
--                      [Owner] ,
--                      SourceCount ,
--                      Comments ,
--                      ExecutionStatus
--                    )
--            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
--                      @validationType , -- ValidationTypes - nvarchar(50)
--                      @Owner , -- Owner - nvarchar(50)
--                      @SourceCount , -- SourceCount - int         
--                      CONCAT('RFO has Duplicate', @key) ,
--                      'FAILED'
--                    )
--        ELSE
--            INSERT  INTO dbqa.SourceTargetLog
--                    ( FlowTypes ,
--                      ValidationTypes ,
--                      [Owner] ,
--                      Comments ,
--                      ExecutionStatus
--                    )
--            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
--                      @validationType , -- ValidationTypes - nvarchar(50)
--                      @Owner , -- Owner - nvarchar(50) 
--                      CONCAT('RFO has no Duplicate', @key) ,
--                      'PASSED'
--                    )




----++++++++++++++++++--+++++++++++++++++++++
---- HYBRIS DUPLICATE VAIDATION.
----++++++++++++++++++--+++++++++++++++++++++
		
		
	

--        SELECT  @TargetCount = COUNT(t.Ct)
--        FROM    ( SELECT    COUNT([HybrisKey]) Ct
--                  FROM      #Hybris
--                  GROUP BY  [HybrisKey] ,
--                            paymentInfoPK
--                  HAVING    COUNT([HybrisKey]) > 1
--                ) t



--        IF ISNULL(@TargetCount, 0) > 0
--            INSERT  INTO dbqa.SourceTargetLog
--                    ( FlowTypes ,
--                      ValidationTypes ,
--                      [Owner] ,
--                      TargetCount ,
--                      Comments ,
--                      ExecutionStatus
--                    )
--            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
--                      @validationType , -- ValidationTypes - nvarchar(50)
--                      @Owner , -- Owner - nvarchar(50)
--                      @TargetCount , -- SourceCount - int         
--                      CONCAT('Hybris has Duplicate', @key) ,
--                      'FAILED'
--                    )
--        ELSE
--            INSERT  INTO dbqa.SourceTargetLog
--                    ( FlowTypes ,
--                      ValidationTypes ,
--                      [Owner] ,
--                      Comments ,
--                      ExecutionStatus
--                    )
--            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
--                      @validationType , -- ValidationTypes - nvarchar(50)
--                      @Owner , -- Owner - nvarchar(50)
--                      CONCAT('Hybris has no  Duplicate', @key) ,
--                      'PASSED'
--                    )

		



--++++++++++++++++++++++++++++++++++++++++++
-- MISSING IN SOURCE AND MISSING IN TARGET 
--++++++++++++++++++++++++++++++++++++++++++

        SET @message = CONCAT(' STEP: 6.initiating MISSING Validation ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

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
        SET @validationtype = 'Missing'

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
            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
                      @validationType , -- ValidationTypes - nvarchar(50)
                      @owner , -- Owner - nvarchar(50)
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
            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
                      @validationType , -- ValidationTypes - nvarchar(50)
                      @owner , -- Owner - nvarchar(50)
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
                        @flows , -- FlowTypes - nvarchar(50)
                        @owner , -- Owner - nvarchar(50)
                        [Missing From ] , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @key , -- Key - nvarchar(50)
                        RFOKey , -- SourceValue - nvarchar(50)
                        HybrisKey
                FROM    #Missing
                WHERE   [Missing From ] = 'MissingInRFO-LoadedExtraInHybris'
                UNION
                SELECT TOP 10
                        @flows , -- FlowTypes - nvarchar(50)
                        @owner , -- Owner - nvarchar(50)
                        [Missing From ] , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @key , -- Key - nvarchar(50)
                        RFOKey , -- SourceValue - nvarchar(50)
                        HybrisKey
                FROM    #Missing
                WHERE   [Missing From ] = 'MissingInHybris-NotLoadedInHybris'
			




-- MixNMatch

        SET @message = CONCAT(' STEP: 7.initiating MIXMATCH Validation ',
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
        SET @validationType = 'MixMatch'

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
            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
                      @validationtype , -- ValidationTypes - nvarchar(50)
                      @owner , -- Owner - nvarchar(50)
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
            VALUES  ( @flows , -- FlowTypes - nvarchar(50)
                      @validationtype , -- ValidationTypes - nvarchar(50)
                      @owner , -- Owner - nvarchar(50)
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
                        @flows , -- FlowTypes - nvarchar(50)
                        @owner , -- Owner - nvarchar(50)
                        @validationtype , -- Flag - nvarchar(10)
                        RFOKey , -- SourceColumn - nvarchar(50)
                        HybrisKey , -- TargetColumn - nvarchar(50)
                        @key , -- Key - nvarchar(50)
                        RFC , -- SourceValue - nvarchar(50)
                        HBC
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
                JOIN #missing m ON m.RFOkey = a.RFOKey

        DELETE  a
        FROM    #RFO a
                JOIN #MixMatch m ON m.RFOkey = a.RFOKey


        DELETE  a
        FROM    #Hybris a
                JOIN #missing m ON m.HybrisKey = a.HybrisKey	

        DELETE  a
        FROM    #Hybris a
                JOIN #MixMatch m ON m.HybrisKey = a.HybrisKey	


        DROP TABLE #missing
        DROP TABLE #MixMatch
      
	  
        SET @sourceCount = 0
        SELECT  @sourceCount = COUNT(RFOKey)
        FROM    #RFO a
                JOIN #Hybris b ON a.RFOKey = b.HybrisKey

        SET @message = CONCAT(' STEP: 9. Total Record Counts for End to End = ',
                              CAST(@SourceCount AS NVARCHAR(25)), CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


        IF OBJECT_ID('Tempdb.dbo.#Temp') IS NOT NULL
            DROP TABLE #Temp
			
        SELECT  * ,
                ROW_NUMBER() OVER ( ORDER BY mapID ) AS [RowNumber]
        INTO    #Temp
        FROM    dbqa.Map_tab
        WHERE   [Owner] = 'AutoshipPaymentAddress'
                AND [flag] IN ( 'c2c', 'ref', 'def' )


			
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
                SET @Message = CONCAT('STEP: 10. Validation Started For Columnt To Column with  total fields= ',
                                      CAST(@MaxRow AS NVARCHAR(20)), CHAR(10),
                                      '-----------------------------------------------')
                   
                EXECUTE dbqa.uspPrintMessage @message


                SET @RowNumber = 1
                WHILE ( @MaxRow >= @RowNumber )
                    BEGIN
                        SELECT  --@Owner = [owner] ,
                                @Flag = [flag] ,
                                @key = [Key] ,
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
                        SELECT  @rowCounts = COUNT([key])
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




