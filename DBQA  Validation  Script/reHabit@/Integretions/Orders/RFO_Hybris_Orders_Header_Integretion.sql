USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[RFO_Hybris_Orders_Header_Integretion]    Script Date: 3/18/2017 10:27:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbqa].[RFO_Hybris_Orders_Header_Integretion] 
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
            @owner NVARCHAR(50)= 'Integretion_Orders_RFO_Hybris' ,
            @Key NVARCHAR(25)= 'OrderNumber' ,
            @ValidationType NVARCHAR(50)= 'Counts' 
        SET NOCOUNT ON 

        SET @message = CONCAT(' STEP: 1.RFOSource Table Started to Load.',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message


        SELECT  OrderNumber AS [RFOKey] , --	p_code
                AutoShipID , --	p_associatedOrders
                s.Name AS OrderStatusID , --	p_status
                t.Name AS OrderTypeID , --	p_type
                co.Alpha2Code AS CountryID , --	p_country
                cu.Code AS CurrencyID , --	p_currency
                ro.ConsultantID , --	p_ordersponsorid /*  This one Converted to AccountNumber*/
                ro.AccountID , --	p_userpk  /*  This one Converted to AccountNumber*/
                CompletionDate , --	createdTS
                CommissionDate , --	p_commissiondate
                ro.ModifiedDate , --	modifiedTS
                SubTotal , --	p_subtotal
                Total , --	p_totalprice
                TotalTax , --	p_totaltax
                TotalDiscount , --	p_totaldiscount
                CV , --	p_cv
                QV , --	p_qv
                TaxExempt , --	isTaxExempt
                donotship , --	p_donotship,
                ( os.ShippingCost + os.HandlingCost ) AS ShippingCost , --	p_deliverycost
                ( os.TaxOnShippingCost + os.TaxOnHandlingCost ) AS TaxOnShippingCost  --	p_taxonshippingcost       
      INTO    #RFO
        FROM    RFOperations.Hybris.Orders ro
                JOIN RFOperations.RFO_Reference.Countries co ON co.CountryID = ro.CountryID
                JOIN RFOperations.RFO_Reference.Currency cu ON cu.CurrencyID = ro.CurrencyID
                JOIN RFOperations.RFO_Accounts.AccountBase ab ON ab.AccountID = ro.AccountID
                JOIN RFOperations.RFO_Accounts.AccountBase sa ON sa.AccountID = ConsultantID
                JOIN RFOperations.RFO_Reference.OrderStatus s ON s.OrderStatusId = ro.OrderStatusID
                JOIN RFOperations.RFO_Reference.OrderType t ON t.OrderTypeID = ro.OrderTypeID
                LEFT JOIN ( SELECT  OrderID ,
                                    SUM(ShippingCost) ShippingCost ,
                                    SUM(HandlingCost) HandlingCost ,
                                    SUM(TaxOnHandlingCost) TaxOnHandlingCost ,
                                    SUM(TaxOnShippingCost) TaxOnShippingCost
                            FROM    RFOperations.Hybris.OrderShipment
                            GROUP BY OrderID
                          ) os ON os.OrderID = ro.OrderID
        WHERE   CAST(ro.CompletionDate AS DATE) BETWEEN '2017-03-15'
                                      AND     '2017-03-17'	   


        SET @message = CONCAT('STEP: 2.Target Table Started to Load', CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message
	

 /*
  





  SELECT CAST(CAST(o.p_code AS INT) AS NVARCHAR(225)) [HybrisKey] , --	OrderNumber
          o.p_orderreason ,
		o.p_ordertype,
        o.p_orderreasondescription ,
    CASE  WHEN act.Code IN ('consultant','preferred')  THEN CAST(CAST(o.p_code AS INT) AS NVARCHAR(225)) 
	ELSE NULL END  AS p_associatedOrders , --	AutoShipID Or P_parent ?????????????????
        s.Code AS p_status , --	OrderStatusID
        CASE WHEN o.p_ordertype IN ( 'ADHOC','ENROLLMENT','RENEWAL')
                  AND act.code = 'Consultant' THEN 'Consultant'
             WHEN o.p_ordertype IN ( 'ADHOC','ENROLLMENT','RENEWAL')
                  AND act.code = 'Preferred' THEN 'PC'
             WHEN o.p_ordertype = 'ADHOC'
                  AND act.code = 'Retail' THEN 'Retail'
             WHEN o.p_ordertype = 'PC AUTOSHIP'
             THEN 'PC Auto-ship'
             WHEN o.p_ordertype = 'CONSULTANT AUTOSHIP'
             THEN 'Consultant Auto-ship'
			 WHEN o.p_ordertype = 'PULSE TEMPLATE'
             THEN 'Pulse Auto-ship'
			 ELSE o.p_ordertype
        END AS p_type , --	OrderTypeID
        co.p_isocode AS p_country , --	CountryID
        cu.p_isocode AS p_currency , --	CurrencyID
        cons.p_customerid AS p_ordersponsorid , --	ConsultantID
        u.p_customerid AS p_userpk , --	AccountID
        o.createdTS , --	CompletionDate
        o.p_commissiondate , --	CommissionDate
        o.modifiedTS , --	ModifiedDate
        o.p_subtotal , --	SubTotal
        o.p_totalprice , --	Total
        o.p_totaltax , --	TotalTax
        o.p_totaldiscounts AS p_totaldiscount , --	TotalDiscount
        o.p_cv , --	CV
        o.p_totalsv , --	QV
        c.p_taxexempt AS isTaxExempt , --	TaxExempt
        o.p_donotship , --	donotship
        o.p_deliverycost , --	ShippingCost
        o.p_taxondeliverycost AS p_taxonshippingcost ,--	TaxOnShippingCost
        o.p_calculated ,--SET True        
        o.p_discountsincludedeliverycost ,-- SET 0.
        o.p_discountsincludepaymentcost ,-- SET 0.
        o.p_fraudulent , -- SET False.
        o.p_net ,-- SET 0.
        o.p_paymentcost , -- SET 0
        o.p_potentiallyfraudulent   -- SET 0				
 FROM   Hybris.dbo.orders o
        JOIN Hybris.dbo.users u ON u.pk = o.p_user --AND o.p_code='0006250895'		
         JOIN Hybris.dbo.users cons ON cons.pk = o.p_consultantdetails
        LEFT JOIN Hybris.dbo.enumerationvalues s ON s.pk = o.p_status
        LEFT JOIN Hybris.dbo.countries co ON co.pk = o.p_country
        LEFT JOIN Hybris.dbo.currencies cu ON cu.pk = o.p_currency
        LEFT JOIN Hybris.dbo.enumerationvalues t ON t.PK = o.p_deliverystatus
        LEFT JOIN Hybris.dbo.carts c ON c.p_user = o.p_user AND ISNUMERIC(c.p_code)=1 AND c.p_ordertype <>'order'
        LEFT JOIN Hybris.dbo.enumerationvalues act ON act.pk = u.p_type
 WHERE  o.p_ordertype IN ( 'PULSE TEMPLATE', 'ADHOC', 'PC AUTOSHIP',
                           'ENROLLMENT', 'Order', 
                           'CONSULTANT AUTOSHIP', 'OVERRIDE', 'RENEWAL' )
        AND CAST(o.createdTS AS DATE) BETWEEN '2017-03-15'
                                      AND     '2017-03-17'
*/

SELECT  *
INTO    #Hybris
FROM    DM_QA.dbo.HybrisOrders




--		DROP TABLE DM_QA.dbo.HybrisOrders


        SET @message = CONCAT('Step:3.Creating Indexes on Temps', CHAR(10),
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

        SET @message = CONCAT(' STEP: 5.initiating DUPLICATE Need to updaete Scripts ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SET @SourceCount = 0
        SET @TargetCount = 0
        SET @ValidationType = 'Duplicate'

        SELECT  @SourceCount = COUNT(t.Ct)
        FROM    ( SELECT    COUNT([RFOKey]) Ct
                  FROM      #RFO
                  GROUP BY  [RFOKey]
                  HAVING    COUNT([RFOKey]) > 1
                ) t



        IF ISNULL(@SourceCount, 0) > 0
            INSERT  INTO dbqa.SourceTargetLog
                    ( FlowTypes ,
                      ValidationTypes ,
                      [Owner] ,
                      SourceCount ,
                      Comments ,
                      ExecutionStatus
                    )
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
                      @owner , -- Owner - nvarchar(50)
                      @SourceCount , -- SourceCount - int         
                      CONCAT('RFO has Duplicate', @key) ,
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
                      CONCAT('RFO has NO Duplicate', @key) ,
                      'PASSED'
                    )

		



--++++++++++++++++++--+++++++++++++++++++++
--  HYBRIS  DUPLICATE VAIDATION.
--++++++++++++++++++--+++++++++++++++++++++

   

        SELECT  @TargetCount = COUNT(t.Ct)
        FROM    ( SELECT    COUNT([HybrisKey]) Ct
                  FROM      #Hybris
                  GROUP BY  [HybrisKey]
                  HAVING    COUNT([HybrisKey]) > 1
                ) t



        IF ISNULL(@TargetCount, 0) > 0
            INSERT  INTO dbqa.SourceTargetLog
                    ( FlowTypes ,
                      ValidationTypes ,
                      [Owner] ,
                      TargetCount ,
                      Comments ,
                      ExecutionStatus
                    )
            VALUES  ( @Flows , -- FlowTypes - nvarchar(50)
                      @ValidationType , -- ValidationTypes - nvarchar(50)
                      @owner , -- Owner - nvarchar(50)
                      @TargetCount , -- SourceCount - int         
                      CONCAT('Hybris has Duplicate', @key) ,
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
                      CONCAT('Hybris has No Duplicate', @key) ,
                      'PASSED'
                    )

		



--++++++++++++++++++++++++++++++++++++++++++
-- MISSING IN SOURCE AND MISSING IN TARGET 
--++++++++++++++++++++++++++++++++++++++++++
        SET @message = CONCAT(' STEP: 6.initiating MISSING Validation ',
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
      
			


--++++++++++++++++++++++++++++++++++++++++++++++++++
 --VALIDATION STARTING FOR END TO END 
--++++++++++++++++++++++++++++++++++++++++++++++++++
		
        SET @message = CONCAT(' STEP: 7.Removing Issues for END TO END Validaion  ',
                              CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

      	
        IF OBJECT_ID('Tempdb.dbo.#Temp') IS NOT NULL
            DROP TABLE #Temp
	


        DELETE  a
        FROM    #RFO a
                JOIN #missing m ON m.RFOkey = a.RFOKey


        DELETE  a
        FROM    #Hybris a
                JOIN #missing m ON m.HybrisKey = a.HybrisKey	



        DROP TABLE #missing
 
        SET @sourceCount = 0
        SELECT  @sourceCount = COUNT(RFOKey)
        FROM    #RFO a
                JOIN #Hybris b ON a.RFOKey = b.HybrisKey

        SET @message = CONCAT(' STEP: 8. Total Record Counts for End to End = ',
                              CAST(@SourceCount AS NVARCHAR(25)), CHAR(10),
                              '-----------------------------------------------')
        EXECUTE dbqa.uspPrintMessage @message

        SELECT  * ,
                ROW_NUMBER() OVER ( ORDER BY mapID ) AS [RowNumber]
        INTO    #Temp
        FROM    dbqa.Map_tab
        WHERE   [Owner] = 'Orders'
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
                        SELECT   @Flag = [flag] ,
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