USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[uspReturnItem_BULK]    Script Date: 3/30/2017 11:18:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbqa].[uspReturnItem_BULK]
AS
    BEGIN



        IF OBJECT_ID('TEMPDB.dbo. #RFO') IS NOT NULL
            DROP TABLE  #RFO;
        IF OBJECT_ID('TEMPDB.dbo.#Hybris') IS NOT NULL
            DROP TABLE #Hybris;
        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing



        DECLARE @SourceCount INT ,
            @TargetCount INT ,
            @message NVARCHAR(MAX) ,
            @Flows NVARCHAR(50)= 'Data Migration' ,
            @owner NVARCHAR(50)= 'Return_Items_Delta_23March' ,
            @Key NVARCHAR(25)= 'ReturnNumber' ,
            @ValidationType NVARCHAR(50)= 'Counts'

        SET NOCOUNT ON 

        SET @message = CONCAT(' STEP: 1.RFOSource Table Started to Load.',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT  ri.ReturnItemID ,
                ri.ExpectedQuantity ,--	p_expectedquantity
                ri.CV ,--	p_cv
                ri.QV ,--	p_qv
                --ri.ReceivedQuantity ,--	p_Receivedquantity
                ABS(ri.BasePrice) BasePrice ,--	p_baseprice
                ABS(ri.TotalPrice) TotalPrice ,--	p_totalprice
                 ISNULL(Tax.TaxAmount,'0.0000') AS totaltax ,--	p_taxvaluesinternal
                ri.ReceivedQuantity ,--	p_quentity
                ro.ReturnOrderNumber AS [RFOKey] ,--	p_order
                ri.ReturnReasonID ,--	p_reason
               rs.Name AS ReturnStatusID ,--	p_status
                rn.Notes AS ReturnNotes ,--	p_notes
                [Action] ,--	p_action
                p.SKU AS ProductID ,--	p_product
                --	p_returnrequest
                ri.OrderItemID --	p_orderentry
                ,
                ro.OrderID
     INTO    #RFO
	 -- SELECT COUNT(ri.ReturnItemID)
        FROM    RFOperations_03152017.Hybris.ReturnItem ri
                JOIN RFOperations_03152017.Hybris.ReturnOrder ro ON ro.ReturnOrderID = ri.ReturnOrderID 
                /*
				JOIN RFOperations_03152017.Hybris.orders o ON o.OrderID = ro.OrderID
                                                   --  AND ro.ReturnOrderNumber = '28255022'
                JOIN RFOperations_03152017.Hybris.OrderItem oi ON oi.OrderId = o.OrderID
                                                         AND oi.OrderItemID = ri.OrderItemID -- Only those items which is in OrderItems table.
														 */
                JOIN RFOperations_03152017.Hybris.ProductBase p ON p.productID = ri.ProductID
                LEFT  JOIN ( SELECT ReturnOrderID ,
                                    MAX(Notes) Notes
                             FROM   RFOperations_03152017.Hybris.ReturnNotes
                             GROUP BY ReturnOrderID
                           ) rn ON rn.ReturnOrderID = ro.ReturnOrderID  -- ReturnOrder Has Duplicate Notes.
                LEFT JOIN ( SELECT  SUM(TaxAmount) TaxAmount ,
                                    ReturnItemID
                            FROM    RFOperations_03152017.Hybris.ReturnItemTax
                            GROUP BY ReturnItemID
                          ) tax ON tax.ReturnItemID = ri.ReturnItemID
						  LEFT JOIN RFOperations_03232017.RFO_Reference.ReturnStatus rs ON rs.ReturnStatusId = ri.ReturnStatusID
        WHERE   ro.ReturnStatusID = 5 -- Success Return only.
                AND EXISTS ( SELECT 1
                             FROM   Hybris.dbo.orders ho
                             WHERE  ho.p_code = ro.ReturnOrderNumber
                                    AND ho.p_ordertype = 'Return' )--586156

													   


        SET @message = CONCAT('STEP: 2. Target Table Started to Load',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message
	
        SELECT   e.p_expectedquantity ,--	ExpectedQuantity
                re.p_sv ,--	CV
                re.p_qv ,--	QV
                p_Receivedquantity ,--	ReceivedQuantity
                p_baseprice ,--	BasePrice
                re.p_totalprice ,--	TotalPrice
              --  p_taxvaluesinternal ,--	totaltax
                re.p_quantity ,--	ReceivedQuantity
                ro.p_code AS [HybrisKey] ,--	ReturnOrderID
                p_reason ,--	ReturnReasonID
                t.Code AS p_status ,--	ReturnStatusID
                e.p_notes ,--	ReturnNotes
                a.Code AS p_action ,--	Action
                p.p_code AS p_product ,--	ProductID
                e.p_returnrequest ,--	
                e.p_orderentry --	OrderItemID
                ,
                p.pk AS ProductPk,  --- Duplicate Check Purpose ProductName same for different ProductPK.
				re.pk AS ReturnItemPK
       INTO    #Hybris
		--SELECT COUNT(re.PK)
        FROM    Hybris.dbo.orderentries re
                JOIN Hybris.dbo.orders ro ON ro.pk = re.p_order
                                             AND ro.p_ordertype = 'RETURN'
                LEFT JOIN Hybris.dbo.returnentry e ON e.OwnerPkString = ro.pk
                LEFT JOIN Hybris.dbo.products p ON p.pk = re.p_product
                LEFT JOIN Hybris.dbo.returnrequest rr ON rr.p_rma = ro.p_code
                LEFT JOIN Hybris.dbo.enumerationvalues t ON t.pk = ro.p_status
                LEFT JOIN Hybris.dbo.enumerationvalues a ON a.pk = e.p_action
				WHERE EXISTS ( SELECT 1
                             FROM  RFOperations_03152017.Hybris.ReturnOrder ho
                             WHERE  ho.ReturnOrderNumber = ro.p_code
                                    AND ro.p_ordertype = 'Return' AND ho.ReturnStatusID=5 )--586156
				



        SET @message = CONCAT(' STEP:3.Creating Indexes in Temps', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message  
		
		
        CREATE CLUSTERED INDEX cls_RFO ON #RFO(RFOKey)
        CREATE CLUSTERED INDEX cls_Hybris ON  #Hybris(HybrisKey)

    

--++++++++++++++++++++++++++++++++++++
-- TOTAL COUNT VALIDATION
--++++++++++++++++++++++++++++++++++++

        SET @message = CONCAT(' STEP: 4.initiating COUNT Validation  ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT  @SourceCount = COUNT(ReturnItemId)
        FROM    #RFO
        SELECT  @TargetCount = COUNT(ReturnItemPK)
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

        SET @message = CONCAT(' STEP: 5.initiating DUPLICATE Need to updaete Scripts   ',
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
                GROUP BY RFOKey ,
                        ProductID
                HAVING  COUNT(RFOKey) > 1

        INSERT  INTO @DUP
                ( [key] ,
                  SourceFrom
                )
                SELECT  HybrisKey ,
                        'Hybris' AS [SourceFrom]
                FROM    #Hybris
                GROUP BY HybrisKey ,
                        ProductPk
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
        SET @message = CONCAT(' STEP: 6.initiating MISSING Validation now ',
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
                     THEN CONCAT(@owner, '_Not Loaded in hybris')
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

      	
        IF OBJECT_ID('Tempdb.dbo.#Temp') IS NOT NULL
            DROP TABLE #Temp
	

	
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

        DELETE  a
        FROM    #RFO a
                JOIN @Dup m ON m.[key] = a.RFOKey
        DELETE  a
        FROM    #Hybris a
                JOIN @Dup m ON m.[key] = a.Hybriskey


        IF OBJECT_ID('tempdb.dbo.#Missing') IS NOT NULL
            DROP TABLE #Missing
        IF OBJECT_ID('tempdb.dbo.#MixMatch') IS NOT NULL
            DROP TABLE #MixMatch  
 
        SET @sourceCount = 0
        SELECT  @sourceCount = COUNT(DISTINCT b.ReturnItemPk)
        FROM    #RFO a
                JOIN #Hybris b ON a.RFOKey = b.HybrisKey

        SET @message = CONCAT(' STEP: 9. Total Record Counts for End to End = ',
                              CAST(@SourceCount AS NVARCHAR(25)), CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message




        SELECT  * ,
                ROW_NUMBER() OVER ( ORDER BY mapID ) AS [RowNumber]
        INTO    #Temp
        FROM    dbqa.Map_tab
        WHERE   [Owner] = 'ReturnItem'
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