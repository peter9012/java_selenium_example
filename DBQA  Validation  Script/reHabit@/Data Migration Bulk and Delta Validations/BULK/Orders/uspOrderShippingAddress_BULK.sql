USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[uspOrderShippingAddress_BULK]    Script Date: 3/29/2017 5:01:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbqa].[uspOrderShippingAddress_BULK]
AS
    BEGIN

        IF OBJECT_ID('TEMPDB.dbo. #RFO') IS NOT NULL
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
            @Flows NVARCHAR(50)= 'Data Migration' ,
            @owner NVARCHAR(50)= 'Order_Shipping_Address_Delta_March23' ,
            @Key NVARCHAR(25)= 'OrderNumber' ,
            @ValidationType NVARCHAR(50)= 'Counts'

        SET NOCOUNT ON 
        SET @message = CONCAT(' STEP: 1.RFOSource Table Started to Load.',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT DISTINCT
                ro.OrderNumber AS [RFOKey] ,
                co.Alpha2Code AS CountryID ,--	p_country
                osa.FirstName ,--	p_firstname
                osa.LastName ,--	p_lastname
                Address1 ,--	p_streetname
                AddressLine2 ,--	p_streetNumber
                PostalCode ,--	p_postalcode
                Locale ,--	p_town
                Region ,--	p_region
                Telephone ,--	p_phone1
                osa.MiddleName 
        INTO    #RFO
        FROM    RFOperations_03232017.Hybris.OrderShippingAddress osa
                JOIN RFOperations_03232017.Hybris.orders ro ON ro.OrderID = osa.OrderID
                JOIN RFOperations_03232017.RFO_Reference.Countries co ON co.CountryID = osa.CountryID
        WHERE    EXISTS ( SELECT 1
                             FROM   Hybris.dbo.Orders ho
                             WHERE  ho.p_code = ro.OrderNumber
                                    AND ho.p_ordertype NOT IN ( 'RETURN',
                                                              'PULSE TEMPLATE' ) )

        SET @message = CONCAT('STEP: 2.Target Table Started to Load', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT  co.p_isocode AS p_country ,--	CountryID
                p_firstname ,--	FirstName
                p_lastname ,--	LastName
                p_streetname ,--	Address1
                p_streetNumber ,--	AddressLine2
                p_postalcode ,--	PostalCode
                p_town ,--	Locale
                re.p_isocodeshort AS p_region ,--	Region
                p_phone1 ,--	Telephone
                p_middlename ,--	MiddleName
                p_duplicate ,--	
                p_Shippingaddress ,--	
                ho.p_code AS [HybrisKey]
        INTO    #Hybris
        FROM    Hybris.dbo.addresses ad
                JOIN Hybris.dbo.orders ho ON ho.pk = ad.OwnerPkString
                LEFT JOIN Hybris.dbo.countries co ON co.pk = ad.p_country
                LEFT JOIN Hybris.dbo.regions re ON re.pk = ad.p_region
        WHERE   ad.p_shippingaddress = 1
                AND ho.p_ordertype NOT IN ( 'RETURN', 'PULSE TEMPLATE' )

        SET @message = CONCAT(' STEP:3.Creating Indexes in Temps', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message  
	
        CREATE NONCLUSTERED INDEX cls_RFO ON #RFO(RFOKey)  
        CREATE NONCLUSTERED INDEX cls_Hybris ON  #Hybris(HybrisKey)   



--++++++++++++++++++++++++++++++++++++
-- TOTAL COUNT VALIDATION
--++++++++++++++++++++++++++++++++++++

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
-- RFO  Duplicate Vaidation.
--++++++++++++++++++--++++++++++++++++++
        SET @message = CONCAT(' STEP: 5.initiating DUPLICATE  ',
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
        SET @message = CONCAT(' STEP: 6.initiating MISSING Validation',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

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
      
			
-- Default Validtion in Target Attributes




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
                     THEN CONCAT(@owner, '_ Not Loaded in hybris')
                     WHEN a.RFC < b.HBC
                     THEN CONCAT(@owner, '_ Extra Loaded in hybris')
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
                        @ValidationType , -- Flag - nvarchar(10)
                        RFOKey , -- SourceColumn - nvarchar(50)
                        HybrisKey , -- TargetColumn - nvarchar(50)
                        @Key , -- Key - nvarchar(50)
                        RFC , -- SourceValue - nvarchar(50)
                        HBC
                FROM    #MixMatch



--++++++++++++++++++++++++++++++++++++++++++++++++++
 --VALIDATION STARTING FOR END TO END 
--++++++++++++++++++++++++++++++++++++++++++++++++++
		
        SET @message = CONCAT(' STEP: 8.Removing Issues for END TO END Validaion',
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
       

        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing  
        IF OBJECT_ID('tempdb.dbo.#MixMatch') IS NOT NULL
            DROP TABLE #MixMatch  

        DELETE  @Dup;

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
        --INTO    #Temp
        FROM    dbqa.Map_tab
        WHERE   [Owner] = 'OrderShippingAddress'
                AND [flag] IN ( 'c2c', 'ref', 'default' ) AND MapID NOT IN (197,198)


		
			
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
                        SELECT  @Flag = [flag] ,
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