USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[uspAutoshipHeader_CRP_PC_BULK]    Script Date: 3/27/2017 4:05:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbqa].[uspAutoshipHeader_CRP_PC_BULK]
AS
    BEGIN

		
--+++++++++++++++++++++++++++++++++++++++++
-- LOADING TEMP TABLES SOURCE AND TARGET
--+++++++++++++++++++++++++++++++++++++++++




        IF OBJECT_ID('TEMPDB.dbo.#RFO') IS NOT NULL
            DROP TABLE  #RFO;
        IF OBJECT_ID('TEMPDB.dbo.#Hybris') IS NOT NULL
            DROP TABLE #Hybris;
        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing



        DECLARE @SourceCount INT ,
            @TargetCount INT ,
            @message NVARCHAR(MAX) ,
            @Flows NVARCHAR(50)= 'Data Migration Delta-2' ,
            @owner NVARCHAR(50)= 'CRP_PC_Autoship' ,
            @Key NVARCHAR(25)= 'AutoshipNumber' ,
            @ValidationType NVARCHAR(50)= 'Counts' 

        SET NOCOUNT ON 

        SET @message = CONCAT('STEP: 1. RFO Data is  Loading.', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message
	
        SELECT  CASE WHEN a.AutoshipTypeID = 1 THEN 'PC'
                     WHEN a.AutoshipTypeID = 2 THEN 'CRP'
                     WHEN a.AutoshipTypeID = 3 THEN 'PULSE'
                END AS AutoshipTypeID ,--	Typepkstring
                a.AccountID ,--	p_user
                a.Active ,--	p_active
                a.SubTotal ,--	p_subtotal
                a.Total ,--	p_totalprice
                a.QV ,--	p_qv
                a.CV ,--	p_cv
                a.StartDate ,--	createdTS
                a.NextRunDate ,--	p_nextrundate
                a.TaxExempt ,--	p_istaxexempt
                a.ServerModifiedDate ,--	ModifiedTS
                a.ConsultantID ,--	p_ordersponsorid
                a.AutoshipNumber [RFOKey] ,--	p_code
                a.TotalTax ,--	p_totaltax
                a.TotalDiscount ,--	P_totaldiscounts
                a.donotship ,--	p_donotship
                ( aus.HandlingCost + aus.ShippingCost ) AS ShippingCost ,--	p_deliverycost
                ( aus.TaxOnHandlingCost + aus.TaxOnShippingCost ) AS TaxOnShippingCost--	p_taxonshippingcost  
                ,
                ROW_NUMBER() OVER ( PARTITION BY a.AccountID, AutoshipTypeID ORDER BY a.DateModified DESC, a.ServerModifiedDate DESC ) AS RN
        INTO    #RFO       
		--	SELECT a.AccountID,COUNT(a.AccountID)
		--SELECT COUNT(a.AutoshipID)--1657792
        FROM    RFOperations_03232017.Hybris.Autoship a
                JOIN RFOperations_03232017.RFO_Accounts.AccountRF rf ON rf.AccountID = a.AccountID
                JOIN ( SELECT DISTINCT
                                ap.AutoshipID
                       FROM     RFOperations_03232017.Hybris.AutoshipPayment ap
                                JOIN RFOperations_03232017.Hybris.AutoshipShipment os ON os.AutoshipID = ap.AutoshipID
                                                              AND ISNULL(ap.Token,
                                                              '') <> ''
                                JOIN RFOperations_03232017.Hybris.AutoshipItem oi ON oi.AutoshipId = ap.AutoshipID
                                JOIN RFOperations_03232017.Hybris.AutoshipShippingAddress asa ON asa.AutoShipID = ap.AutoshipID
                                JOIN RFOperations_03232017.Hybris.AutoshipPaymentAddress apa ON apa.AutoShipID = ap.AutoshipID
                     ) ap ON ap.AutoshipID = a.AutoshipID  --AND a.AccountID = 2083918
                LEFT  JOIN ( SELECT DISTINCT
                                    AutoshipID ,
                                    SUM(ShippingCost) ShippingCost ,
                                    SUM(TaxOnShippingCost) TaxOnShippingCost ,
                                    SUM(HandlingCost) HandlingCost ,
                                    SUM(TaxOnHandlingCost) TaxOnHandlingCost
                             FROM   RFOperations_03232017.Hybris.AutoshipShipment
                             GROUP BY AutoshipID
                           ) aus ON aus.AutoshipID = a.AutoshipID
        WHERE   a.Active = 1
                AND rf.Active = 1
                AND a.AutoshipTypeID IN ( 1, 2 )
                AND EXISTS ( SELECT 1
                             FROM   Hybris.dbo.users u
                                    JOIN Hybris.dbo.enumerationvalues v ON v.pk = u.p_accountstatus
                                                             -- AND v.Code = 'Active'
                             WHERE  u.p_customerid = a.accountId )
                AND NOT EXISTS ( SELECT 1
                                 FROM   RFOperations_03232017.Hybris.Autoship at
                                        JOIN RFOperations_03232017.RFO_Accounts.AccountBase b ON b.AccountID = at.AccountID
                                 WHERE  at.AutoshipID = a.AutoshipID
                                        AND ( ( at.AutoshipTypeID = 1
                                                AND b.AccountTypeID <> 2
                                              )
                                              OR ( at.AutoshipTypeID = 2
                                                   AND b.AccountTypeID <> 1
                                                 )
                                            ) )
                AND NOT EXISTS ( SELECT 1
                                 FROM   RFOperations_03232017.Hybris.AutoshipItem ai
                                 WHERE  ai.AutoshipId = a.AutoshipID
                                        AND ai.Quantity = 0 )
			 
					
        --GROUP BY a.AccountID
        --HAVING  COUNT(a.AccountID) > 1

        DELETE  FROM #RFO
        WHERE   RN > 1  --- Deleting Duplicate active tempates.

	
        SET @message = CONCAT('STEP: 2. Hybris Data is  Loading.', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT  CASE c.p_ordertype
                  WHEN 'CONSULTANT AUTOSHIP TEMPLATE' THEN 'CRP'
                  WHEN 'PC AUTOSHIP TEMPLATE' THEN 'PC'
                  ELSE c.p_ordertype
                END AS Typepkstring ,--	AutoshipTypeID
                CAST(u.p_customerid AS BIGINT) AS p_user ,--	AccountID
                cj.p_active ,--	Active  -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Need Mapping 
                p_subtotal ,--	SubTotal
                p_totalprice ,--	Total
                p_totalsv ,--	QV
                p_cv ,--	CV
                c.createdTS ,--	StartDate
                p_expirationtime AS p_nextrundate ,--	NextRunDate -- It is Calculated by Job tables.
                c.p_taxexempt AS p_istaxexempt ,--	TaxExempt
                c.ModifiedTS ,--	ServerModifiedDate
                ct.Code AS p_status ,-- TEmplate Status.
                CAST(cons.p_customerid AS BIGINT) AS p_ordersponsorid ,--	ConsultantID
                SUBSTRING(c.p_code, CHARINDEX('-', c.p_code, 1) + 1,
                          ( LEN(c.p_code) - CHARINDEX('-', c.p_code, 1) )) AS HybrisKey ,--	AutoshipNumber
                p_totaltax ,--	TotalTax
                P_totaldiscounts ,--	TotalDiscount
                p_donotship ,--	donotship
                p_deliverycost ,--	ShippingCost
                p_taxondeliverycost AS p_taxonshippingcost	--	TaxOnShippingCost      
        INTO    #Hybris
		--SELECT COUNT(distinct c.p_code)--,c.P_code
        FROM    Hybris.dbo.Carts c --3515601
                JOIN Hybris.dbo.enumerationvalues ct ON ct.pk = c.p_cartcronjobstatus
                JOIN Hybris.dbo.users u ON u.pk = c.p_user  --3515601 
                LEFT JOIN Hybris.dbo.enumerationvalues acs ON acs.pk = u.p_accountstatus
                LEFT JOIN Hybris.dbo.cronjobs cj ON cj.p_cart = c.PK
                LEFT JOIN Hybris.dbo.users cons ON cons.pk = c.p_consultantdetails
        WHERE   c.p_code LIKE 'scheduledcart%'
                AND c.p_ordertype IN ( 'CONSULTANT AUTOSHIP TEMPLATE',
                                       'PC AUTOSHIP TEMPLATE' )


        SET @message = CONCAT(' STEP:3.Creating Indexes in temps', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message  
		
		
        CREATE CLUSTERED INDEX cls_RFO ON #RFO(RFOKey)
        CREATE CLUSTERED INDEX cls_Hybris ON  #Hybris(HybrisKey)

	


--++++++++++++++++++++++++++++++++++++
-- TOTAL COUNT VALIDATION
--++++++++++++++++++++++++++++++++++++

        SET @message = CONCAT('STEP: 4.initiating COUNT Validation  ',
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
        VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                  @ValidationType , -- ValidationTypes - nvarchar(50)
                  @owner , -- Owner - nvarchar(50)
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
-- RFO Autoship Duplicate Vaidation.
--++++++++++++++++++--++++++++++++++++++

        SET @message = CONCAT(' STEP: 5.initiating DUPLICATE Need to updaete Scripts ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

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
                GROUP BY RFOKey
                HAVING  COUNT(RFOKey) > 1

        INSERT  INTO @DUP
                ( [key] ,
                  SourceFrom
                )
                SELECT  HybrisKey ,
                        'Hybris' AS [SourceFrom]
                FROM    #Hybris
                GROUP BY HybrisKey
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

        SET @message = CONCAT('STEP: 6.initiating MISSING Validation ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

--US Autoship SCTOTG  MISSING VALIDATION 
        SELECT  a.[RFOKey] ,
                b.[HybrisKey] ,
                CASE WHEN a.[RFOKey] IS NULL
                     THEN 'MissingInRFO-LoadedExtraInHybris'
                     WHEN b.[HybrisKey] IS NULL
                     THEN 'MissingInHybris-NotLoadedInHybris'
                END AS [Missing From ]
        INTO    #Missing
        FROM    #RFO a
                FULL OUTER JOIN #Hybris b ON a.[RFOKey] = b.[HybrisKey]
        WHERE   a.[RFOKey] IS NULL
                OR b.[HybrisKey] IS NULL

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
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
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
                        @Flows , -- FlowTypes - nvarchar(50)
                        @Owner , -- Owner - nvarchar(50)
                        [Missing From ] , -- Flag - nvarchar(10)
                        N'' , -- SourceColumn - nvarchar(50)
                        N'' , -- TargetColumn - nvarchar(50)
                        @Key , -- Key - nvarchar(50)
                        [RFOKey] , -- SourceValue - nvarchar(50)
                        [HybrisKey]
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
                        [RFOKey] , -- SourceValue - nvarchar(50)
                        [HybrisKey]
                FROM    #Missing
                WHERE   [Missing From ] = 'MissingInHybris-NotLoadedInHybris'
      
		


--++++++++++++++++++++++++++++++++++++++++++++++++++
 --VALIDATION STARTING FOR END TO END 
--++++++++++++++++++++++++++++++++++++++++++++++++++
		
      	





        SET @message = CONCAT('STEP: 7.Removing Issues for END TO END Validaion',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        DELETE  a
        FROM    #RFO a
                JOIN #missing m ON m.RFOkey = a.RFOKey


        DELETE  a
        FROM    #Hybris a
                JOIN #missing m ON m.HybrisKey = a.HybrisKey	
        DELETE  a
        FROM    #RFO a
                JOIN @Dup m ON m.[key] = a.RFOKey
        DELETE  a
        FROM    #Hybris a
                JOIN @Dup m ON m.[key] = a.Hybriskey



        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing  
        DELETE  @Dup;



        SET @sourceCount = 0
        SELECT  @sourceCount = COUNT(RFOKey)
        FROM    #RFO a
                JOIN #Hybris b ON a.RFOKey = b.HybrisKey

        SET @message = CONCAT(' STEP: 8. Total Record Counts for End to End = ',
                              CAST(@SourceCount AS NVARCHAR(25)), CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message



  
        IF OBJECT_ID('Tempdb.dbo.#Temp') IS NOT NULL
            DROP TABLE #Temp			
        SELECT  * ,
                ROW_NUMBER() OVER ( ORDER BY mapID ) AS [RowNumber]
        INTO    #Temp
        FROM    dbqa.Map_tab
        WHERE   [Owner] = 'Autoship'
                AND [flag] IN ( 'c2c', 'ref', 'default' )


		
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
                SET @Message = CONCAT('STEP: 9. Validation Started For Columnt To Column with  total fields= ',
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