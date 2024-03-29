USE RFOperations;
SET STATISTICS TIME ON;
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @HYB_key VARCHAR(100) = 'pk';
DECLARE @RFO_key VARCHAR(100) = 'ReturnOrderId';
DECLARE @sql_gen_1 NVARCHAR(MAX);
DECLARE @sql_gen_2 NVARCHAR(MAX);
DECLARE @cnt INT;
DECLARE @lt_1 INT;
DECLARE @lt_2 INT;
DECLARE @temp TABLE
    (
      test_area VARCHAR(MAX) ,
      test_type VARCHAR(MAX) ,
      rfo_column VARCHAR(MAX) ,
      hybris_column VARCHAR(MAX) ,
      hyb_key VARCHAR(MAX) ,
      hyb_value VARCHAR(MAX) ,
      rfo_key VARCHAR(MAX) ,
      rfo_value VARCHAR(MAX)
    );

	
		
DECLARE @StartedTime TIME;
DECLARE @EndTime TIME; 

SELECT  'Return Entries Loading TempTable ' AS EntityName ,
        GETDATE() AS StartedTime;
SELECT  @StartedTime = CAST(GETDATE() AS TIME);
		
		
		--DECLARE @modifiedDate DATE='2016-01-04'

	
IF OBJECT_ID('tempdb..#tempact') IS NOT NULL
    DROP TABLE #tempact;


SELECT DISTINCT
        ri.ReturnItemID ,
        ro.ReturnOrderID ,
        ri.OrderItemID ,
        ri.Action ,
        ri.ReturnStatusID ,
        ri.ReturnReasonID ,
        oi.LineItemNo - 1 AS LineItemNo ,
        p.PK ,
        oi.RetailProfit ,
        oi.WholesalePrice ,
        oi.TaxablePrice ,
        ro.TotalTax
INTO    #tempact
FROM    Hybris.ReturnOrder ro
        JOIN RodanFieldsLive.dbo.Orders rfl ON ro.ReturnOrderNumber = rfl.OrderID
                                               AND rfl.OrderTypeID = 9
        JOIN Hybris.dbo.orders ho ON ho.PK = ro.ReturnOrderID
                                     AND ho.TypePkString = 8796127723602
        JOIN Hybris.dbo.users u ON u.PK = ho.userpk
        JOIN Hybris.ReturnItem ri ON ri.ReturnOrderID = ro.ReturnOrderID
        JOIN Hybris.OrderItem oi ON oi.OrderItemID = ri.OrderItemID
        JOIN Hybris.dbo.products p ON p.p_rflegacyproductid = oi.ProductID
                                      AND p_catalognumber IS NOT NULL
                                      AND p_catalog = '8796093088344'
                                      AND p_catalogversion = '8796093153881'
WHERE   ro.ReturnOrderID NOT IN (
        SELECT  a.ReturnOrderNumber
        FROM    Hybris.ReturnOrder a
                JOIN Hybris.Orders b ON a.ReturnOrderNumber = b.OrderNumber
                                        AND a.CountryID = 236 )
		--AND CAST(ho.modifiedTS AS DATE)=@modifiedDate
GROUP BY ri.ReturnItemID ,
        ro.ReturnOrderID ,
        ri.OrderItemID ,
        ri.Action ,
        ri.ReturnStatusID ,
        ri.ReturnReasonID ,
        oi.LineItemNo - 1 ,
        p.PK ,
        oi.RetailProfit ,
        oi.WholesalePrice ,
        oi.TaxablePrice ,
        ro.TotalTax;

CREATE CLUSTERED INDEX as_cls1 ON #tempact (ReturnOrderID);


			
SELECT  'Return Entries Templtable load is Completed' AS EntityName ,
        GETDATE() AS CompletionTime;

SELECT  @EndTime = CAST(GETDATE() AS TIME);
SELECT  @StartedTime AS StartedTime ,
        @EndTime AS CompletionTime ,
        DATEDIFF(MINUTE, @StartedTime, @EndTime) AS [Total Time (MM)] ,
        'Return Entries Temp Table Loading ' AS Entity; 
		


			

SELECT  'Return Entries to OrderEntries Transformed Column Validation Started ' AS EntityName ,
        GETDATE() AS StartedTime;
SELECT  @StartedTime = CAST(GETDATE() AS TIME);

DELETE 	 DataMigration..dm_log
        WHERE   test_area = '853-Returnitems'
                AND test_type IN  ('manual'  )

		

SET @cnt = 1;
SELECT  @lt_1 = COUNT(*)
FROM    DataMigration.dbo.map_tab
WHERE   flag = 'manual'
        AND rfo_column <> @RFO_key
        AND [owner] = '853-Returnitems'
        AND Hybris_Table = 'OrderEntries';

WHILE @cnt <= @lt_1
    BEGIN

        SELECT  @sql_gen_1 = 'SELECT DISTINCT  ''' + [owner]
                + ''' as test_area, ''' + flag + ''' as test_type, '''
                + [RFO_Reference Table] + ''' as rfo_column, '''
                + Hybris_Column + ''' as hybris_column, A.' + @HYB_key
                + ' as hyb_key, A.Hyb_Trans_col as hyb_value, B.' + @RFO_key
                + ' as rfo_key, B.RFO_Trans_Col as rfo_value

			FROM (SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key + '
			except
			SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + ') A  

			LEFT JOIN

			(SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + '
			except
			SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key
                + ') B
			ON A.' + @HYB_key + '=B.' + @RFO_key + '
			UNION
			SELECT DISTINCT  ''' + [owner] + ''', ''' + flag + ''', '''
                + [RFO_Reference Table] + ''', ''' + Hybris_Column + ''', A.'
                + @HYB_key + ', A.Hyb_Trans_col, B.' + @RFO_key
                + ', B.RFO_Trans_Col

			FROM (SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key + '
			except
			SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + ') A  

			RIGHT JOIN

			(SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + '
			except
			SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key
                + ') B
			ON A.' + @HYB_key + '=B.' + @RFO_key + ''
        FROM    ( SELECT    * ,
                            ROW_NUMBER() OVER ( ORDER BY [owner] ) rn
                  FROM      DataMigration.dbo.map_tab
                  WHERE     flag = 'manual'
                            AND rfo_column <> @RFO_key 
--and id not in (3,4,64,65) --order not migrated yet
                            AND [owner] = '853-Returnitems'
                            AND Hybris_Table = 'OrderEntries'
                ) temp
        WHERE   rn = @cnt;

        PRINT @sql_gen_1;
        INSERT  INTO @temp
                ( test_area ,
                  test_type ,
                  rfo_column ,
                  hybris_column ,
                  hyb_key ,
                  hyb_value ,
                  rfo_key ,
                  rfo_value
                )
                EXEC sp_executesql @sql_gen_1;


        IF ( SELECT COUNT(*)
             FROM   @temp
           ) > 1
            BEGIN
                DECLARE @err_cnt INT;
                SELECT  @err_cnt = CASE WHEN hyb_cnt = 0 THEN rfo_cnt
                                        ELSE hyb_cnt
                                   END
                FROM    ( SELECT    COUNT(DISTINCT hyb_key) hyb_cnt ,
                                    COUNT(DISTINCT rfo_key) rfo_cnt
                          FROM      @temp
                        ) t1;

                UPDATE  a
                SET     [prev_run_err] = @err_cnt
                FROM    DataMigration.dbo.map_tab a ,
                        @temp b
                WHERE   a.hybris_column = b.hybris_column
                        AND [owner] = '853-Returnitems'
                        AND Hybris_Table = 'OrderEntries'; 
            END;  

        INSERT  INTO DataMigration..dm_log
                SELECT TOP 5
                        test_area ,
                        test_type ,
                        rfo_column ,
                        hybris_column ,
                        hyb_key ,
                        hyb_value ,
                        rfo_key ,
                        rfo_value
                FROM    @temp
                WHERE   ( ( COALESCE(hyb_key, '~') = COALESCE(rfo_key, '~') )
                          AND ( COALESCE(hyb_value, '~') <> COALESCE(rfo_value,
                                                              '~') )
                        )
                UNION
                SELECT TOP 5
                        test_area ,
                        test_type ,
                        rfo_column ,
                        hybris_column ,
                        hyb_key ,
                        hyb_value ,
                        rfo_key ,
                        rfo_value
                FROM    @temp
                WHERE   ( ( COALESCE(hyb_key, '~') <> COALESCE(rfo_key, '~') )
                          OR ( COALESCE(hyb_value, '~') <> COALESCE(rfo_value,
                                                              '~') )
                        );


        DELETE  FROM @temp;

        SET @cnt = @cnt + 1;

    END;

UPDATE  DataMigration.dbo.map_tab
SET     [prev_run_err] = 0
WHERE   [owner] = '853-Returnitems'
        AND flag = 'manual'
        AND hybris_column NOT IN ( SELECT DISTINCT
                                            hybris_column
                                   FROM     DataMigration..dm_log
                                   WHERE    test_area = '853-Returnitems'
                                            AND test_type = 'manual'
                                            AND Hybris_Table = 'OrderEntries' );






		
						
SELECT  'Return Items to OrderEntries Transformed  Column Validation' AS EntityName ,
        GETDATE() AS CompletionTime;

SELECT  @EndTime = CAST(GETDATE() AS TIME);
SELECT  @StartedTime AS StartedTime ,
        @EndTime AS CompletionTime ,
        DATEDIFF(MINUTE, @StartedTime, @EndTime) AS [Total Time (MM)] ,
        'Return Items to OrderEntries Transformed  Column Validation' AS Entity; 
		
		

INSERT  INTO DataMigration.dbo.ExecResult
        SELECT  'ReturnEntries WithKey' AS Entity ,
                'Manual' AS Types ,
                @StartedTime AS StartedTime ,
                @EndTime AS CompletionTime ,
                DATEDIFF(MINUTE, @StartedTime, @EndTime) AS [Total Time (MM)] ,
                USER_NAME() AS UserName ,
                CAST(GETDATE() AS DATE) AS RunDate;





SELECT  'Return Items  to ReturnEntry Transformed Columns Validation Started ' AS EntityName ,
        GETDATE() AS StartedTime;
SELECT  @StartedTime = CAST(GETDATE() AS TIME);

	

SET @cnt = 1;
SELECT  @lt_1 = COUNT(*)
FROM    DataMigration.dbo.map_tab
WHERE   flag = 'manual'
        AND rfo_column <> @RFO_key
        AND [owner] = '853-Returnitems'
        AND Hybris_Table = 'ReturnEntry';

WHILE @cnt <= @lt_1
    BEGIN

        SELECT  @sql_gen_1 = 'SELECT DISTINCT  ''' + [owner]
                + ''' as test_area, ''' + flag + ''' as test_type, '''
                + [RFO_Reference Table] + ''' as rfo_column, '''
                + Hybris_Column + ''' as hybris_column, A.' + @HYB_key
                + ' as hyb_key, A.Hyb_Trans_col as hyb_value, B.' + @RFO_key
                + ' as rfo_key, B.RFO_Trans_Col as rfo_value

			FROM (SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key + '
			except
			SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + ') A  

			LEFT JOIN

			(SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + '
			except
			SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key
                + ') B
			ON A.' + @HYB_key + '=B.' + @RFO_key + '
			UNION
			SELECT DISTINCT  ''' + [owner] + ''', ''' + flag + ''', '''
                + [RFO_Reference Table] + ''', ''' + Hybris_Column + ''', A.'
                + @HYB_key + ', A.Hyb_Trans_col, B.' + @RFO_key
                + ', B.RFO_Trans_Col

			FROM (SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key + '
			except
			SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + ') A  

			RIGHT JOIN

			(SELECT a.' + @RFO_key + ', ' + RFO_Column
                + ' as RFO_Trans_Col FROM ' + RFO_Table + '
			except
			SELECT a.' + @HYB_key + ', ' + Hybris_Column
                + ' as Hyb_Trans_col FROM hybris.dbo.' + Hybris_Table
                + ' a, #tempact b where a.' + @HYB_key + '=b.' + @RFO_key
                + ') B
			ON A.' + @HYB_key + '=B.' + @RFO_key + ''
        FROM    ( SELECT    * ,
                            ROW_NUMBER() OVER ( ORDER BY [owner] ) rn
                  FROM      DataMigration.dbo.map_tab
                  WHERE     flag = 'manual'
                            AND Hybris_Table = 'ReturnEntry'
                            AND rfo_column <> @RFO_key 
--and id not in (3,4,64,65) --order not migrated yet
                            AND [owner] = '853-Returnitems'
                ) temp
        WHERE   rn = @cnt;

        PRINT @sql_gen_1;
        INSERT  INTO @temp
                ( test_area ,
                  test_type ,
                  rfo_column ,
                  hybris_column ,
                  hyb_key ,
                  hyb_value ,
                  rfo_key ,
                  rfo_value
                )
                EXEC sp_executesql @sql_gen_1;


        IF ( SELECT COUNT(*)
             FROM   @temp
           ) > 1
            BEGIN
      --declare @err_cnt int
                SELECT  @err_cnt = CASE WHEN hyb_cnt = 0 THEN rfo_cnt
                                        ELSE hyb_cnt
                                   END
                FROM    ( SELECT    COUNT(DISTINCT hyb_key) hyb_cnt ,
                                    COUNT(DISTINCT rfo_key) rfo_cnt
                          FROM      @temp
                        ) t1;

                UPDATE  a
                SET     [prev_run_err] = @err_cnt
                FROM    DataMigration.dbo.map_tab a ,
                        @temp b
                WHERE   a.hybris_column = b.hybris_column
                        AND [owner] = '853-Returnitems'
                        AND Hybris_Table = 'ReturnEntry'; 
            END;  

        INSERT  INTO DataMigration..dm_log
                SELECT TOP 5
                        test_area ,
                        test_type ,
                        rfo_column ,
                        hybris_column ,
                        hyb_key ,
                        hyb_value ,
                        rfo_key ,
                        rfo_value
                FROM    @temp
                WHERE   ( ( COALESCE(hyb_key, '~') = COALESCE(rfo_key, '~') )
                          AND ( COALESCE(hyb_value, '~') <> COALESCE(rfo_value,
                                                              '~') )
                        )
                UNION
                SELECT TOP 5
                        test_area ,
                        test_type ,
                        rfo_column ,
                        hybris_column ,
                        hyb_key ,
                        hyb_value ,
                        rfo_key ,
                        rfo_value
                FROM    @temp
                WHERE   ( ( COALESCE(hyb_key, '~') <> COALESCE(rfo_key, '~') )
                          OR ( COALESCE(hyb_value, '~') <> COALESCE(rfo_value,
                                                              '~') )
                        );


        DELETE  FROM @temp;

        SET @cnt = @cnt + 1;

    END;

UPDATE  DataMigration.dbo.map_tab
SET     [prev_run_err] = 0
WHERE   [owner] = '853-Returnitems'
        AND flag = 'manual'
        AND Hybris_Table = 'ReturnEntry'
        AND hybris_column NOT IN ( SELECT DISTINCT
                                            hybris_column
                                   FROM     DataMigration..dm_log
                                   WHERE    test_area = '853-Returnitems'
                                            AND Hybris_Table = 'ReturnEntry'
                                            AND test_type = 'manual' );

				
						
SELECT  'Return Items to ReturnEntry Transformed  Column Validation' AS EntityName ,
        GETDATE() AS CompletionTime;

SELECT  @EndTime = CAST(GETDATE() AS TIME);
SELECT  @StartedTime AS StartedTime ,
        @EndTime AS CompletionTime ,
        DATEDIFF(MINUTE, @StartedTime, @EndTime) AS [Total Time (MM)] ,
        'Return Items to ReturnEntry Transformed  Column Validation' AS Entity; 
		
		

INSERT  INTO DataMigration.dbo.ExecResult
        SELECT  'ReturnEntry WithKey' AS Entity ,
                'Manual' AS Types ,
                @StartedTime AS StartedTime ,
                @EndTime AS CompletionTime ,
                DATEDIFF(MINUTE, @StartedTime, @EndTime) AS [Total Time (MM)] ,
                USER_NAME() AS UserName ,
                CAST(GETDATE() AS DATE) AS RunDate;
