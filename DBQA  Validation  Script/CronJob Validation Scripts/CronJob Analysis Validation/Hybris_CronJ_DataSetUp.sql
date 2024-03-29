USE [RFOperations]
GO
/****** Object:  StoredProcedure [dbo].[CJ_DataSetup]    Script Date: 11/7/2015 9:24:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	GET the counts
			1. Templates inactive IN hybris but schdate IN 11/11
			2. Templates inactive IN hybris but schdate IN 10/11
			3. Templates NOT IN hybris but part OF legacy run
			4. Templates WITH fail COUNT FROM 0,1,2 3 & above
			5. Templates WITH sch date around 10/11
			6. NO OF templates WITH swap products
			7. Templates < 10/11 but NOT part OF legacy run   
			
	For CRP, EXEC [dbo].[CJ_DataSetup] 'crp', '2015-10-11' 
	For PCPerk, EXEC [dbo].[CJ_DataSetup] 'pcperk', '2015-10-11' 
	For Pulse, EXEC [dbo].[CJ_DataSetup] 'pulse', '2015-10-11'    */

CREATE  PROCEDURE [dbo].[CJ_DataSetup]
    (
      @Template NVARCHAR(10) ,
      @RunDate NVARCHAR(10)
    )
AS
    BEGIN

        BEGIN TRY
            DECLARE @type BIGINT;
            DECLARE @datetocheck DATE;
            DECLARE @monthstomove INT;


            SELECT  @type = CASE WHEN @Template = 'crp' THEN 8796124676178
                                 WHEN @Template IN ( 'pcperks', 'pcperk' )
                                 THEN 8796124708946
                                 WHEN @Template = 'pulse' THEN 8796124741714
                            END;

            SELECT  @datetocheck = CASE WHEN @Template IN ( 'crp', 'pulse' )
                                        THEN DATEADD(MONTH, 1, @RunDate)
                                        WHEN @Template IN ( 'pcperks',
                                                            'pcperk' )
                                        THEN DATEADD(MONTH, 2, @RunDate)
                                   END;
            SELECT  @monthstomove = CASE WHEN @Template IN ( 'crp', 'pulse' )
                                         THEN -1
                                         WHEN @Template IN ( 'pcperks',
                                                             'pcperk' )
                                         THEN -2
                                    END;

            IF OBJECT_ID('tempdb..#staging') IS NOT NULL
                DROP TABLE #staging;
 
            SELECT  * ,
                    GETDATE() loadtime ,
                    USER loadedbyuser ,
                    @RunDate AS rundate
            INTO    #staging
            FROM    Hybris..orders
            WHERE   p_template = 1
                    AND code IN (
                    SELECT  TemplateOrderID
                    FROM    RodanFieldsLive.dbo.AutoshipLog
                    WHERE   CAST(ISNULL(DateAutoshipRan, '1900-01-01') AS DATE) = @RunDate );

		
            IF OBJECT_ID('Hybris..SelectedTemplates') IS NULL
                BEGIN
                    SELECT  *
                    INTO    Hybris..SelectedTemplates
                    FROM    #staging
                    WHERE   1 = 2;
                END; 
            
            BEGIN
                IF ( SELECT COUNT(*)
                     FROM   Hybris..SelectedTemplates
                     WHERE  rundate = @RunDate
                            AND typepkstring = @type
                   ) = 0
                    INSERT  INTO Hybris..SelectedTemplates
                            SELECT  *
                            FROM    #staging;
            END;
                
		               		 
            BEGIN TRAN;

            IF ( SELECT COUNT(DISTINCT b.code)
                 FROM   Hybris..selectedtemplates a
                        JOIN Hybris..orders b ON a.PK = b.PK
                 WHERE  a.TypePkString = @type AND b.p_template = 1 AND b.p_active = 1
               ) > 1
                BEGIN 
                    SELECT  'Data set up already in place for the given parameters' AS [Alert];
                END;
             
            ELSE
                BEGIN 
                    UPDATE  a
                    SET     a.p_lastprocessingdate = DATEADD(MONTH, -1,
                                                             a.p_lastprocessingdate) ,
                            a.p_ccfailurecount = a.p_ccfailurecount - 1
                    FROM    Hybris..orders a
                            LEFT JOIN Hybris..orders a1 ON a.PK = a1.p_associatedtemplate
                                                           AND ( a1.p_template = 0
                                                              OR a1.p_template IS NOT NULL
                                                              )
                                                           AND a1.TypePkString <> 8796127723602
                                                           AND CAST(a1.createdTS AS DATE) = CAST(a.p_lastprocessingdate AS DATE)
                                                           AND a1.statuspk = 8796134998107 --failed order
                    WHERE   a.p_template = 1
                            AND CONVERT(VARCHAR(6), a.p_schedulingdate, 112) <> CONVERT(VARCHAR(6), CAST(@datetocheck AS DATE), 112)
                            AND a.p_active = 1
							AND a.p_ccfailurecount>0
                            AND a.TypePkString = @type
                            AND a.code IN (
                            SELECT  TemplateOrderID
                            FROM    RodanFieldsLive.dbo.AutoshipLog
                            WHERE   CAST(ISNULL(DateAutoshipRan, '1900-01-01') AS DATE) = @RunDate )
                            AND a1.PK IS NOT NULL
                            AND a.PK IN ( SELECT    PK
                                          FROM      #staging );

                    UPDATE  a
                    SET     a.p_lastprocessingdate = DATEADD(MONTH, -1,
                                                             a.p_lastprocessingdate)
                    FROM    Hybris..orders a
                            LEFT JOIN Hybris..orders a1 ON a.PK = a1.p_associatedtemplate
                                                           AND ( a1.p_template = 0
                                                              OR a1.p_template IS NOT NULL
                                                              )
                                                           AND a1.TypePkString <> 8796127723602
                                                           AND CAST(a1.createdTS AS DATE) = CAST(a.p_lastprocessingdate AS DATE)
                                                           AND a1.statuspk = 8796134998107 --failed order
                    WHERE   a.p_template = 1
                            AND CONVERT(VARCHAR(6), a.p_schedulingdate, 112) <> CONVERT(VARCHAR(6), CAST(@datetocheck AS DATE), 112)
                            AND a.p_active = 1
							AND a.p_ccfailurecount>0
                            AND a.TypePkString = @type
                            AND a.code IN (
                            SELECT  TemplateOrderID
                            FROM    RodanFieldsLive.dbo.AutoshipLog
                            WHERE   CAST(ISNULL(DateAutoshipRan, '1900-01-01') AS DATE) = @RunDate )
                            AND a1.PK IS NULL
                            AND a.PK IN ( SELECT    PK
                                          FROM      #staging );
		

                    UPDATE  Hybris..orders
                    SET     p_schedulingdate = DATEADD(MONTH, @monthstomove,
                                                       p_schedulingdate) ,
                            p_lastprocessingdate = DATEADD(MONTH, -1,
                                                           p_lastprocessingdate)
                    WHERE   p_template = 1
                            AND CONVERT(VARCHAR(6), p_schedulingdate, 112) = CONVERT(VARCHAR(6), CAST(@datetocheck AS DATE), 112)
                            AND p_active = 1
                            AND TypePkString = @type
                            AND PK IN ( SELECT  PK
                                        FROM    #staging );


                    UPDATE  Hybris..orders
                    SET     p_schedulingdate = DATEADD(MONTH, @monthstomove,
                                                       p_schedulingdate) ,
                            p_lastprocessingdate = DATEADD(MONTH, -1,
                                                           p_lastprocessingdate)
                    WHERE   p_template = 1
                            AND CONVERT(VARCHAR(6), p_schedulingdate, 112) = CONVERT(VARCHAR(6), CAST(@datetocheck AS DATE), 112)
                            AND p_active = 0
                            AND TypePkString = @type
                            AND PK IN ( SELECT  PK
                                        FROM    #staging );

                    UPDATE  Hybris..orders
                    SET     p_schedulingdate =  DATEADD(yy, 1,
                                                       CAST(GETDATE() AS DATE))
                    WHERE   p_template = 1
                            AND p_active = 1
                            AND TypePkString = @type
                            AND CAST(p_schedulingdate AS DATE) > @RunDate
                            AND CAST(p_schedulingdate AS DATE) <= GETDATE()
                            AND PK NOT IN ( SELECT  PK
                                            FROM    #staging );
											 
                    SELECT  '' + CAST(@@ROWCOUNT AS VARCHAR)
                            + ' templates that were not part of legacy run is moved to future date' AS [Message-1];

                    SELECT  '' + CAST(COUNT(DISTINCT code) AS VARCHAR)
                            + ' templates were left as is which was not part of legacy run and sch date < '
                            + CAST(@RunDate AS VARCHAR) + '' AS [Message-2]
                    FROM    Hybris..orders
                    WHERE   TypePkString = @type
                            AND p_template = 1
                            AND p_active = 1
                            AND p_schedulingdate < @RunDate
                            AND PK NOT IN ( SELECT  PK
                                            FROM    #staging );

                END;
            BEGIN 
                IF @@ERROR > 0
                    BEGIN 
                        ROLLBACK; 
                    END; 
                ELSE
                    BEGIN 
                        COMMIT; 
                    END;
            END;
        END TRY
        BEGIN CATCH
            RAISERROR('Data Set Up Has Failed',16,1);
            SELECT  ERROR_PROCEDURE() AS [SP];
            SELECT  ERROR_MESSAGE() AS [ERROR MESSAGE]; 
            SELECT  ERROR_LINE() AS [ERROR LINE];
        END CATCH;
    END;



