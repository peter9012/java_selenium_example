USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbo].[usp_RFO_Hybris_Commission_Report]    Script Date: 3/13/2017 3:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_RFO_Hybris_Commission_Report] 
    (
      @Country CHAR(2) = NULL ,
      @AccountType NVARCHAR(3) = NULL ,
      @Email NVARCHAR(225) = NULL ,
      @AccountID NVARCHAR(225) = NULL
    )
AS
    BEGIN

        DECLARE @Catalog BIGINT ,
            @catalogVersion BIGINT ,
            @SKU NVARCHAR(25) = NULL ,
            @ctype NVARCHAR(10) ,
            @Count INT= 0 ,
            @message NVARCHAR(225)
	
        IF ( @Country NOT  IN ( 'US', 'CA', 'AU' )
             OR @AccountType NOT IN ( 'RC', 'PC', 'CON' )
           )
            AND ( ISNULL(@Email, '') = '' )
            AND ( ISNULL(@AccountID, '') = '' )
            BEGIN 
                PRINT 'Please Pass Either Country(''US'',''CA'',''AU'') AND CustomerType(''RC'',''PC'',''CON'') OR AccountID(CID  Like ''00123459'') OR UserEmail(UserName Like ''test@test.com'')'
            END 
        ELSE
            BEGIN

                IF ( ( ISNULL(@AccountID, '') = '' )
                     AND ( ISNULL(@Email, '') = '' )
                   )
                    BEGIN
                        SELECT  @ctype = CASE @AccountType
                                           WHEN 'RC' THEN 'Retail'
                                           WHEN 'PC' THEN 'Preferred'
                                           WHEN 'CON' THEN 'Consultant'
                                         END 

                        --SET @EmailPattern = CASE @AccountType
                        --                      WHEN 'RC'
                        --                      THEN   CONCAT('autorc', REPLACE(CONVERT(NVARCHAR(10),GETDATE(),121),'-',''))
                        --                      WHEN 'PC'
                        --                        THEN   CONCAT('autopcwpwsspon', REPLACE(CONVERT(NVARCHAR(10),GETDATE(),121),'-',''))
                        --                      WHEN 'CON'
                        --                        THEN   CONCAT('autoconswpwcrp', REPLACE(CONVERT(NVARCHAR(10),GETDATE(),121),'-',''))
                        --                    END
              
                        IF ( @ctype = 'Retail' )
                            SELECT TOP 1
                                    @AccountID = p_customerid ,
                                    @Email = u.p_uid
                            FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues v ON v.pk = u.p_type
                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.countries co ON co.pk = u.p_country
                            WHERE   co.p_isocode = @Country
							AND cast(u.modifiedTS AS DATE)>=CAST(GETDATE()-1 AS DATE)
                                    AND u.p_uid LIKE 'autorc%'
                            ORDER BY co.modifiedTS DESC ,
                                    NEWID()
                        IF ( @ctype = 'Preferred' )
                            SELECT TOP 1
                                    @AccountID = p_customerid ,
                                    @Email = u.p_uid
                            FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues v ON v.pk = u.p_type
                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.countries co ON co.pk = u.p_country
                            WHERE   co.p_isocode = @Country
							AND cast(u.modifiedTS AS DATE)>=CAST(GETDATE()-1 AS DATE)
                                    AND u.p_uid LIKE 'autopcwpwsspon%'
                            ORDER BY co.modifiedTS DESC ,
                                    NEWID()

                        IF ( @ctype = 'Consultant' )
                            SELECT TOP 1
                                    @AccountID = p_customerid ,
                                    @Email = u.p_uid
                            FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues v ON v.pk = u.p_type
                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.countries co ON co.pk = u.p_country
                            WHERE   co.p_isocode = @Country
							AND cast(u.modifiedTS AS DATE)>=CAST(GETDATE()-1 AS DATE)
                                    AND u.p_uid LIKE 'autoconswpwcrp%'
                            ORDER BY co.modifiedTS DESC ,
                                    NEWID()

                        SELECT  @AccountType ,
                                @ctype ,
                                @Email ,
                                @AccountID


                    END


                ELSE
                    BEGIN 
					
	
                        IF ( ISNULL(@Email, '') <> '' )
                            BEGIN

                                SELECT  @AccountID = p_customerid ,
                                        @Email = u.p_uid,
										@Country=co.p_isocode
                                FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues v ON v.pk = u.p_type
                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.countries co ON co.pk = u.p_country									
                                WHERE   u.p_uid = @Email

								

                            END 
                        IF ( ISNULL(@AccountID, '') <> '' )
                            BEGIN

                                SELECT  @AccountID = p_customerid ,
                                        @Email = u.p_uid,
										@Country=co.p_isocode

										--SELECT p_uid,p_customerid
                                FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues v ON v.pk = u.p_type
                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.countries co ON co.pk = u.p_country
                                WHERE   u.p_customerid =   @AccountID

                            END 
                    END 
					
	SET @count=0
                SELECT  @Count = COUNT(pk)
                FROM    [SJC-V2-QA01-W07].Hybris.dbo.users
                WHERE   p_uid = @Email

                IF ( ISNULL(@Count, 0) = 0 )
                    BEGIN
                        PRINT CONCAT('Your Input ', @Email, @AccountID,
                                     SPACE(2), 'is Invalid')
                    END 
                ELSE
                    BEGIN 



                        SET @Catalog = ( SELECT DISTINCT
                                                pk
                                         FROM   [SJC-V2-QA01-W07].Hybris.dbo.catalogs
                                         WHERE  p_id = CASE @Country
                                                         WHEN 'US'
                                                         THEN 'rodanandfieldsProductCatalog'
                                                         WHEN 'CA'
                                                         THEN 'rodanandfieldsCANProductCatalog'
                                                         WHEN 'AU'
                                                         THEN 'rodanandfieldsAUSProductCatalog'
                                                       END
                                       )

                        SET @catalogVersion = ( SELECT DISTINCT
                                                        v.pk
                                                FROM    [SJC-V2-QA01-W07].Hybris.dbo.products p
                                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.catalogversions v ON v.pk = p.p_catalogversion
                                                WHERE   v.p_version = 'Online'
                                                        AND p.p_catalog = @Catalog
                                              )

              


               
                        SELECT  'Hybris_Product' [Source] ,
                                p_code [Product SKU] ,
                                lp.p_name [Products] ,
                                cpr.p_price [Consultant Price] ,
                                ppr.p_price [PC_Price] ,
                                Rpr.p_price [RC_Price] ,
                                Cpr.p_sv [CV] ,
                                Cpr.p_qv [QV]
                        FROM    [SJC-V2-QA01-W07].Hybris.dbo.products P
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.productslp lp ON ITEMPK = p.pk
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.languages la ON la.pk = lp.LANGPK
                                LEFT JOIN ( SELECT  pr.p_product ,
                                                    pr.p_price ,
                                                    pr.p_sv ,
                                                    pr.p_qv
                                            FROM    [SJC-V2-QA01-W07].Hybris.dbo.pricerows pr
                                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues pg ON pg.pk = pr.p_ug
                                                              AND pg.Code = '01'
                                          ) Cpr ON Cpr.p_product = p.pk
                                LEFT JOIN ( SELECT  pr.p_product ,
                                                    pr.p_price
                                            FROM    [SJC-V2-QA01-W07].Hybris.dbo.pricerows pr
                                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues pg ON pg.pk = pr.p_ug
                                                              AND pg.Code = '02'
                                          ) Ppr ON Ppr.p_product = p.pk
                                LEFT JOIN ( SELECT  pr.p_product ,
                                                    pr.p_price
                                            FROM    [SJC-V2-QA01-W07].Hybris.dbo.pricerows pr
                                                    JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues pg ON pg.pk = pr.p_ug
                                                              AND pg.Code = '03'
                                          ) Rpr ON Rpr.p_product = p.pk
                        WHERE   p.p_catalog = @Catalog
                                AND p.p_catalogversion = @catalogVersion
                                AND la.p_isocode = 'en'
                                AND ( EXISTS ( SELECT   1
                                               FROM     [SJC-V2-QA01-W07].Hybris.dbo.carts c
                                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.cartentries ce ON ce.p_order = c.PK
                                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.users u ON u.pk = c.p_user
                                               WHERE    ce.p_product = p.pk
                                                        AND u.p_uid = @Email )
                                      OR EXISTS ( SELECT    1
                                                  FROM      [SJC-V2-QA01-W07].Hybris.dbo.orders o
                                                            JOIN [SJC-V2-QA01-W07].Hybris.dbo.orderentries oe ON oe.p_order = o.PK
                                                            JOIN [SJC-V2-QA01-W07].Hybris.dbo.users u ON u.pk = o.p_user
                                                  WHERE     oe.p_product = p.pk
                                                            AND u.p_uid = @Email )
                                    )
		
		


                        SELECT  'Hybris_Users' [SourceFrom] ,
                                u.p_name [Customer] ,
                                u.p_customerid [AccountID] ,
                                u.p_accountnumber [AccountNumber] ,
                                t.Code [AccountType] ,
                                s.Code [AccountStatus] ,
                                co.p_isocode [Country] ,
                                p_uid [UserName_Email] ,
                                u.createdTS [CreatedDate] ,
                                u.modifiedTS [Modified] ,
                                u.p_enrollmentdate [EnrolledDate] ,
                                p_softterminateddate [SoftTermDate] ,
                                p_hardterminateddate [HardTermDate] ,
                                CONCAT('NameOnCard =', p.p_ccowner, SPACE(2),
                                       'CreditCardType= ', ct.Code, SPACE(2),
                                       'ExpirationDate= ', p.p_validtomonth,
                                       '-', p.p_validtoyear) [Order Payment] ,
                                CONCAT(ba.p_streetname, ba.p_streetnumber,
                                       SPACE(1), ba.p_town, SPACE(1),
                                       bg.p_isocode) PaymentProfile_Billing_D ,
                                CONCAT(db.p_streetname, db.p_streetnumber,
                                       SPACE(1), db.p_town, SPACE(1),
                                       dbr.p_isocode) AccountDefault_Billing_D ,
                                CONCAT(sa.p_streetname, sa.p_streetnumber,
                                       SPACE(1), sa.p_town, SPACE(1),
                                       sg.p_isocode) AccountDefault_Shipping_D
                        FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues t ON t.pk = u.p_type
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues s ON s.pk = u.p_accountstatus
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.countries co ON co.pk = u.p_country
                               LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymentinfos p ON p.pk = u.p_defaultpaymentinfo
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues ct ON ct.pk = p.p_type
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses ba ON ba.pk = p.p_billingaddress
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions bg ON bg.pk = ba.p_region
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses db ON db.pk = u.p_defaultpaymentaddress
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions dbr ON dbr.pk = db.p_region
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses sa ON sa.pk = u.p_defaultshipmentaddress
                                LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions sg ON sg.pk = sa.p_region
                        WHERE   u.p_uid = @Email

 

                        SET @count = 0

                        SET @Count = ( SELECT   COUNT(ab.AccountID)
                                       FROM     RFOperations.RFO_Accounts.AccountBase ab
                                                JOIN RFOperations.RFO_Accounts.AccountRF rf ON rf.AccountID = ab.AccountID
                                                JOIN RFOperations.RFO_Accounts.accountcontacts ac ON ac.AccountId = ab.AccountID
                                       WHERE    ab.AccountID = @AccountID
                                     )
                        IF ( @Count > 0 )
                            BEGIN


                                SELECT  'RFO_Accounts_Level' [SourceFrom] ,
                                        CONCAT(ac.FirstName, SPACE(1),
                                               MiddleNAme, SPACE(1),
                                               ac.LastName) [Name] ,
                                        ab.AccountID ,
                                        ab.AccountNumber ,
                                        t.Name [AccountType] ,
                                        s.Name [AccountStatus] ,
                                        co.Alpha2Code [Country] ,
                                        acs.Username ,
                                        rf.EnrollmentDate ,
                                        rf.ServerModifiedDate ,
                                        rf.SoftTerminationDate ,
                                        rf.HardTerminationDate ,
                                        IIF(ISNULL(cp.PaymentProfileID, 0) = 0, NULL, CONCAT('NameOnCard=',
                                                              cp.NameOnCard,
                                                              SPACE(1),
                                                              'CreditCardType=',
                                                              v.Name, SPACE(2),
                                                              'ExpirationDate= ',
                                                              cp.ExpMonth, '-',
                                                              cp.ExpYear,
                                                              'IsRFO Default=',
                                                              p.IsDefault)) [PaymentProfile] ,
                                        IIF(ISNULL(ba.AddressID, 0) = 0, NULL, CONCAT(ba.AddressLine1,
                                                              SPACE(1),
                                                              ba.AddressLine2,
                                                              SPACE(1),
                                                              ba.Locale,
                                                              SPACE(2),
                                                              ba.Region,
                                                              'IsAddressDefault=',
                                                              ba.IsDefault)) [CreditCardBillingAddress_Ref_D] ,
                                        IIF(ISNULL(pa.AddressID, 0) = 0, NULL, CONCAT(pa.AddressLine1,
                                                              SPACE(1),
                                                              pa.AddressLine2,
                                                              SPACE(1),
                                                              pa.Locale,
                                                              SPACE(2),
                                                              pa.Region,
                                                              'IsAddressDefault=',
                                                              pa.IsDefault)) [Account_BillingAddress_Ref_D] ,
                                        IIF(ISNULL(sa.AddressID, 0) = 0, NULL, CONCAT(sa.AddressLine1,
                                                              SPACE(1),
                                                              sa.AddressLine2,
                                                              SPACE(1),
                                                              sa.Locale,
                                                              SPACE(2),
                                                              sa.Region,
                                                              'IsAddressDefault=',
                                                              sa.IsDefault)) [Account_Shipping_Address_Ref_D] ,
                                        IIF(ISNULL(ca.AddressID, 0) = 0, NULL, CONCAT(ca.AddressLine1,
                                                              SPACE(1),
                                                              ca.AddressLine2,
                                                              SPACE(1),
                                                              ca.Locale,
                                                              SPACE(2),
                                                              ca.Region,
                                                              'IsAddressDefault=',
                                                              ca.IsDefault)) [Account_Contact_Address_Ref_D]
                                FROM    RFOperations.RFO_Accounts.AccountBase ab
                                        JOIN RFOperations.RFO_Accounts.AccountRF rf ON rf.AccountID = ab.AccountID
                                        JOIN RFOperations.RFO_Accounts.accountcontacts ac ON ac.AccountId = ab.AccountID
                                        LEFT JOIN RFOperations.RFO_Reference.AccountType t ON t.AccountTypeID = ab.AccountTypeID
                                        LEFT JOIN RFOperations.RFO_Reference.AccountStatus s ON s.AccountStatusID = ab.AccountStatusID
                                        LEFT JOIN RFOperations.RFO_Reference.Countries co ON co.CountryID = ab.CountryID
                                        LEFT JOIN RFOperations.Security.AccountSecurity acs ON acs.AccountID = ab.AccountID
                                        LEFT JOIN RFOperations.RFO_Accounts.PaymentProfiles p ON p.AccountID = ab.AccountID
                                        LEFT JOIN RFOperations.RFO_Accounts.CreditCardProfiles cp ON cp.PaymentProfileID = p.PaymentProfileID
                                        LEFT JOIN RFOperations.RFO_Reference.CreditCardVendors v ON v.VendorID = cp.VendorID
                                        LEFT JOIN RFOperations.RFO_Accounts.Addresses ba ON ba.AddressID = cp.BillingAddressID
                                        LEFT JOIN RFOperations.RFO_Accounts.AccountContactAddresses aca ON aca.AccountContactId = ac.AccountContactId
                                        LEFT JOIN RFOperations.RFO_Accounts.Addresses pa ON pa.AddressID = aca.AddressID
                                                              AND pa.AddressTypeID = 2
                                        LEFT JOIN RFOperations.RFO_Accounts.addresses sa ON sa.AddressID = aca.AddressID
                                                              AND sa.AddressTypeID = 3
                                        LEFT JOIN RFOperations.RFO_Accounts.addresses ca ON ca.AddressID = aca.AddressID
                                                              AND ca.AddressTypeID = 1
                                WHERE   ab.AccountID = @AccountID
                                        AND ac.AccountContactTypeId = 1

             
                                SET @count = 0

                                SET @Count = ( SELECT   COUNT(a.AccountID)
                                               FROM     [SJC-V2-QA01-W03].commissions.dropoff.Accounts a
                                                        LEFT JOIN RFOperations.RFO_Reference.AccountStatus s ON s.AccountStatusID = a.AccountStatusID
                                                        LEFT JOIN RFOperations.RFO_Reference.AccountType t ON t.AccounttypeId = a.AccountTypeID
                                               WHERE    AccountID = @AccountID
                                             )
                                IF ( @Count > 0 )
                                    BEGIN

                                        SELECT  'Commission_Accounts' [SourceFrom] ,
                                                s.name [AccountStatus] ,
                                                t.name [AccountType] ,
                                                a.*
                                        FROM    [SJC-V2-QA01-W03].commissions.dropoff.Accounts a
                                                LEFT JOIN RFOperations.RFO_Reference.AccountStatus s ON s.AccountStatusID = a.AccountStatusID
                                                LEFT JOIN RFOperations.RFO_Reference.AccountType t ON t.AccounttypeId = a.AccountTypeID
                                        WHERE   AccountID = @AccountID

                
                               

---Hybris Autoship

                                        SET @count = 0

                                        SET @Count = ( SELECT COUNT(c.pk)
                                                       FROM   [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                              JOIN [SJC-V2-QA01-W07].Hybris.dbo.carts c ON c.p_user = u.PK
                                                       WHERE  ISNUMERIC(c.p_code) = 1
                                                              AND u.p_uid = @Email
                                                     )
                                        IF ( @Count > 0 )
                                            BEGIN

                                                SELECT  'Hybris_Template' [Source From ] ,
                                                        u.p_customerid [AccountID] ,
                                                        c.p_code [AutoshipNumber] ,
                                                        c.p_ordertype [TemplateType] ,
                                                        s.Code [TemplateStatus] ,
                                                        c.createdTS [TemplateCreated] ,
                                                        c.modifiedTS [TemplateModified] ,
                                                        c.p_deliverycost [TemplateDeliveryCost] ,
                                                        c.p_totalprice [TemplateTotal] ,
                                                        c.p_subtotal [TemplateSubTotal] ,
                                                        c.p_totaldiscounts [TemplateDistountPrice] ,
                                                        c.p_totaltax [TemplateTotalTax] ,
                                                        c.p_totalsv [Tempalte_QV] ,
                                                        c.p_cv [Template_CV] ,
                                                        c.p_scheduleddate [TempalteScheduleDate] ,
                                                        CONCAT('NameOnCard =',
                                                              p.p_ccowner,
                                                              SPACE(2),
                                                              'CreditCardType= ',
                                                              ct.Code,
                                                              SPACE(2),
                                                              'ExpirationDate= ',
                                                              p.p_validtomonth,
                                                              '-',
                                                              p.p_validtoyear) [Order Payment] ,
                                                        CONCAT(ba.p_streetname,
                                                              ba.p_streetnumber,
                                                              SPACE(1),
                                                              ba.p_town,
                                                              SPACE(1),
                                                              bg.p_isocode) Template_BillingAddress_D ,
                                                        CONCAT(db.p_streetname,
                                                              db.p_streetnumber,
                                                              SPACE(1),
                                                              db.p_town,
                                                              SPACE(1),
                                                              dbr.p_isocode) Template_ShippingingAddress_D ,
                                                        CONCAT('TemplateProduct= ',
                                                              ce.p_info,
                                                              SPACE(2),
                                                              'LineItem= ',
                                                              ce.p_entrynumber,
                                                              SPACE(2),
                                                              'BasePrice= ',
                                                              ce.p_baseprice,
                                                              SPACE(2),
                                                              'TotalPrice= ',
                                                              ce.p_totalprice,
                                                              SPACE(2),
                                                              'Quantity= ',
                                                              ce.p_quantity) [Template_Items_Details_D]
                                                FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                        LEFT  JOIN [SJC-V2-QA01-W07].Hybris.dbo.carts c ON c.p_user = u.PK
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues s ON s.pk = c.p_cartcronjobstatus
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymentinfos p ON p.pk = c.p_paymentinfo
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues ct ON ct.pk = p.p_type
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses ba ON ba.pk = c.p_paymentaddress
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions bg ON bg.pk = ba.p_region
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses db ON db.pk = c.p_deliveryaddress
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions dbr ON dbr.pk = db.p_region
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.cartentries ce ON ce.p_order = c.PK
                                                WHERE   ISNUMERIC(c.p_code) = 1
                                                        AND u.p_uid = @Email

						
                                                SELECT  'Hybris_Subscription' [Source From ] ,
                                                        u.p_customerid [AccountId] ,
                                                        sb.p_id [PulseTeplateNumber] ,
                                                        sb.p_name [CustomerName] ,
                                                        sb.p_nextbillingdate [NextBillingDate] ,
                                                        sb.p_productcode [SKU] ,
                                                        sb.p_startdate [TemplateStartDate] ,
                                                        sb.p_enddate [TempEndDate] ,
                                                        sb.p_subscriptionstatus [Active] ,
                                                        s.Code [OriginalOrderStatus] ,
                                                        o.p_ordertype [ReturnOrderType] ,
                                                        o.p_deliverycost [DeliveryCost] ,
                                                        o.p_subtotal [SubTotal] ,
                                                        o.p_totalprice [TotalPrice] ,
                                                        o.p_totaldiscounts [DiscountTotal] ,
                                                        o.p_totaltax [TotalTax] ,
                                                        o.p_totalsv [QV] ,
                                                        o.p_cv [CV] ,
                                                        o.p_taxexempt [TaxExempt] ,
                                                        p_donotship [DonotShip] ,
                                                        CONCAT('NameOnCard =',
                                                              pa.p_ccowner,
                                                              SPACE(2),
                                                              'CreditCardType= ',
                                                              ct.Code,
                                                              SPACE(2),
                                                              'ExpirationDate= ',
                                                              pa.p_validtomonth,
                                                              '-',
                                                              pa.p_validtoyear) [Pulse_Order Payment] ,
                                                        CONCAT(ba.p_streetname,
                                                              ba.p_streetnumber,
                                                              SPACE(1),
                                                              ba.p_town,
                                                              SPACE(1),
                                                              bg.p_isocode) Pulse_Orders_BillingAddress_D ,
                                                        CONCAT(db.p_streetname,
                                                              db.p_streetnumber,
                                                              SPACE(1),
                                                              db.p_town,
                                                              SPACE(1),
                                                              dbr.p_isocode) Pulse_Order_ShippingingAddress_D ,
                                                        CONCAT('TemplateProduct= ',
                                                              ce.p_info,
                                                              SPACE(2),
                                                              'LineItem= ',
                                                              ce.p_entrynumber,
                                                              SPACE(2),
                                                              'BasePrice= ',
                                                              ce.p_baseprice,
                                                              SPACE(2),
                                                              'TotalPrice= ',
                                                              ce.p_totalprice,
                                                              SPACE(2),
                                                              'Quantity= ',
                                                              ce.p_quantity) [Orders_Items_Details_D]
                                                FROM    [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                        JOIN [SJC-V2-QA01-W07].Hybris.dbo.subscriptions sb ON u.p_customerid = sb.p_customerid
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.orders o ON o.pk = sb.p_order
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues s ON s.pk = o.p_status
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymentinfos pa ON pa.OwnerPkString = o.pk
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues ct ON ct.pk = pa.p_type
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses ba ON ba.pk = o.p_paymentaddress
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions bg ON bg.pk = ba.p_region
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses db ON db.pk = o.p_deliveryaddress
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions dbr ON dbr.pk = db.p_region
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.orderentries ce ON ce.p_order = o.PK
                                                        LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.products pd ON pd.pk = ce.p_product
                                                              AND pd.p_code = sb.p_productcode
                                                WHERE   u.p_uid = @Email
				 

        
      


                                       
                                                SET @count = 0

                                                SET @Count = ( SELECT
                                                              COUNT(ab.accountID)
                                                              FROM
                                                              RFOperations.RFO_Accounts.AccountBase ab
                                                              JOIN RFOperations.Hybris.Autoship a ON a.AccountID = ab.AccountID
                                                              WHERE
                                                              ab.AccountID = @AccountId
                                                             )
                                                IF ( @Count > 0 )
                                                    BEGIN

                                                        SELECT
                                                              'RFO_Autoship' [Source From] ,
                                                              ab.AccountID ,
                                                              a.AutoshipNumber ,
                                                              t.Name [Autoshiptype] ,
                                                              s.Name [AutoshipStatus] ,
                                                              a.StartDate ,
                                                              a.DateModified ,
                                                              asp.ShippingCost [RFODeliveryCsot] ,
                                                              a.Total ,
                                                              a.SubTotal ,
                                                              a.TotalDiscount ,
                                                              a.TotalTax ,
                                                              a.Qv ,
                                                              a.CV ,
                                                              a.NextRunDate ,
                                                              IIF(ISNULL(ap.AutoshipPaymentID,
                                                              '') = '', 'No Payment Profile_D', CONCAT('NameOnCard=',
                                                              apa.FirstName,
                                                              SPACE(1),
                                                              apa.MiddleName,
                                                              SPACE(1),
                                                              apa.LastName,
                                                              SPACE(1),
                                                              'CreditCardType=',
                                                              v.Name, SPACE(2),
                                                              'ExpirationDate=',
                                                              SPACE(1),
                                                              ap.Expmonth, '-',
                                                              ap.ExpYear)) [Autoship_PaymentProfile] ,
                                                              CONCAT(apa.Address1,
                                                              SPACE(1),
                                                              apa.AddressLine2,
                                                              SPACE(1),
                                                              apa.Locale,
                                                              SPACE(2),
                                                              apa.Region) [Account_BillingAddress_Ref_D] ,
                                                              CONCAT(sa.Address1,
                                                              SPACE(1),
                                                              sa.AddressLine2,
                                                              SPACE(1),
                                                              sa.Locale,
                                                              SPACE(2),
                                                              sa.Region) [Account_Shipping_Address_Ref_D]
                                                        FROM  RFOperations.RFO_Accounts.AccountBase ab
                                                              LEFT JOIN RFOperations.Hybris.Autoship a ON a.AccountID = ab.AccountID
                                                              LEFT JOIN RFOperations.RFO_Reference.AutoShipType t ON t.AutoShipTypeID = a.AutoshipTypeID
                                                              LEFT JOIN RFOperations.RFO_Reference.AutoshipStatus s ON s.AutoshipStatusId = a.AutoshipStatusID
                                                              LEFT JOIN RFOperations.Hybris.AutoshipItem ai ON ai.AutoshipId = a.AutoshipID
                                                              LEFT JOIN RFOperations.Hybris.AutoshipPayment ap ON ap.AutoshipID = a.AutoshipID
                                                              LEFT JOIN RFOperations.Hybris.AutoshipPaymentAddress apa ON apa.AutoShipID = a.AutoshipID
                                                              LEFT JOIN RFOperations.RFO_Reference.CreditCardVendors v ON v.VendorID = ap.VendorID
                                                              LEFT JOIN RFOperations.Hybris.AutoshipShipment asp ON asp.AutoshipID = a.AutoshipID
                                                              LEFT JOIN RFOperations.Hybris.AutoshipShippingAddress sa ON sa.AutoShipID = a.AutoshipID
                                                        WHERE ab.AccountID = @AccountId


                                                    END 
                                                ELSE
                                                    BEGIN
                                                        SELECT
                                                              'RFO No Template'
                                                    END 
                            
                                        
                                                SET @count = 0

                                                SET @Count = ( SELECT
                                                              COUNT(o.pk)
                                                              FROM
                                                              [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                              JOIN [SJC-V2-QA01-W07].Hybris.dbo.orders o ON o.p_user = u.PK
                                                              WHERE
                                                              u.p_uid = @Email
                                                              AND o.p_ordertype NOT IN (
                                                              'CREDITMEMO',
                                                              'RETURN' )
                                                             )
                                                IF ( ISNULL(@Count, 0) > 0 )
                                                    BEGIN

                                                        SELECT
                                                              'Hybris_Orders_Level' [Source From ] ,
                                                              u.p_customerid [AccountID] ,
                                                              o.p_code [OrderNumber] ,
                                                              s.Code [OrderStatus] ,
                                                              o.p_ordertype [OrderType] ,
                                                              o.createdTS [CreatedDate] ,
                                                              o.p_commissiondate [OrderCommissionDate] ,
                                                              su.p_customerid [OrderConsultantID] ,
                                                              o.p_deliverycost [DeliveryCost] ,
                                                              o.p_subtotal [SubTotal] ,
                                                              o.p_totalprice [TotalPrice] ,
                                                              o.p_totaldiscounts [DiscountTotal] ,
                                                              o.p_totaltax [TotalTax] ,
                                                              o.p_totalsv [QV] ,
                                                              o.p_cv [CV] ,
                                                              o.p_taxexempt [TaxExempt] ,
                                                              p_donotship [DonotShip] ,
                                                              CONCAT('NameOnCard =',
                                                              pa.p_ccowner,
                                                              SPACE(2),
                                                              'CreditCardType= ',
                                                              ct.Code,
                                                              SPACE(2),
                                                              'ExpirationDate= ',
                                                              pa.p_validtomonth,
                                                              '-',
                                                              pa.p_validtoyear) [Order Payment] ,
                                                              CONCAT(ba.p_streetname,
                                                              ba.p_streetnumber,
                                                              SPACE(1),
                                                              ba.p_town,
                                                              SPACE(1),
                                                              bg.p_isocode) Orders_BillingAddress_D ,
                                                              CONCAT(db.p_streetname,
                                                              db.p_streetnumber,
                                                              SPACE(1),
                                                              db.p_town,
                                                              SPACE(1),
                                                              dbr.p_isocode) Order_ShippingingAddress_D ,
                                                              CONCAT('TemplateProduct= ',
                                                              ce.p_info,
                                                              SPACE(2),
                                                              'LineItem= ',
                                                              ce.p_entrynumber,
                                                              SPACE(2),
                                                              'BasePrice= ',
                                                              ce.p_baseprice,
                                                              SPACE(2),
                                                              'TotalPrice= ',
                                                              ce.p_totalprice,
                                                              SPACE(2),
                                                              'Quantity= ',
                                                              ce.p_quantity) [Orders_Items_Details_D] ,
                                                              CONCAT('PlannedAmount=',
                                                              pt.p_plannedamount,
                                                              SPACE(2),
                                                              'PayEntryAmount=',
                                                              pe.p_amount,
                                                              SPACE(2),
                                                              'TransStatus=',
                                                              pe.p_transactionstatus,
                                                              SPACE(2),
                                                              'TransStatusDetails',
                                                              pe.p_transactionstatusdetails) [OrderPaymentTransactionDetails]
                                                        FROM  [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                              JOIN [SJC-V2-QA01-W07].Hybris.dbo.orders o ON o.p_user = u.PK
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues s ON s.pk = o.p_status
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymentinfos pa ON pa.OwnerPkString = o.pk
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues ct ON ct.pk = pa.p_type
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses ba ON ba.pk = o.p_paymentaddress
                                                              AND ba.p_billingaddress = 1
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions bg ON bg.pk = ba.p_region
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses db ON db.pk = o.p_deliveryaddress
                                                              AND db.p_shippingaddress = 1
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions dbr ON dbr.pk = db.p_region
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.orderentries ce ON ce.p_order = o.PK
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.users su ON su.pk = o.p_consultantdetails
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymenttransactions pt ON pt.p_order = o.pk
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymnttrnsctentries pe ON pe.p_paymenttransaction = pt.PK
                                                        WHERE u.p_uid = @Email
                                                              AND o.p_ordertype NOT IN (
                                                              'CREDITMEMO',
                                                              'RETURN' )

                                                
                                                        SET @count = 0

                                                        SET @Count = ( SELECT
                                                              COUNT(ro.OrderID)
                                                              FROM
                                                              RFOperations.Hybris.orders ro
                                                              WHERE
                                                              ro.AccountID = @AccountID
                                                              )
                             
                                                        IF ( ISNULL(@Count, 0) > 0 )
                                                            BEGIN


                                                              SELECT
                                                              'RFO_Orders_Level' [Source From] ,
                                                              ro.AccountID ,
                                                              ro.OrderNumber ,
                                                              s.Name [OrderStatus] ,
                                                              t.Name [OrderType] ,
                                                              ro.CompletionDate ,
                                                              ro.CommissionDate ,
                                                              ro.ConsultantID ,
                                                              os.ShippingCost ,
                                                              os.TaxOnShippingCost ,
                                                              ro.Total ,
                                                              ro.SubTotal ,
                                                              ro.TotalDiscount ,
                                                              ro.TotalTax [OrdersTable_TotalTax] ,
                                                              ot.TaxAmount [OrderTaxTable_TotalTax] ,
                                                              ro.QV ,
                                                              ro.CV ,
                                                              ro.TaxExempt ,
                                                              ro.donotship ,
                                                              IIF(ISNULL(op.OrderPaymentID,
                                                              '') = '', 'No Payment Profile_D', CONCAT('NameOnCard=',
                                                              ba.FirstName,
                                                              SPACE(1),
                                                              ba.MiddleName,
                                                              SPACE(1),
                                                              ba.LastName,
                                                              SPACE(1),
                                                              'CreditCardType=',
                                                              v.Name, SPACE(2),
                                                              'ExpirationDate=',
                                                              SPACE(1),
                                                              op.Expmonth, '-',
                                                              op.ExpYear)) [Orders_PaymentProfile] ,
                                                              CONCAT(ba.Address1,
                                                              SPACE(1),
                                                              ba.AddressLine2,
                                                              SPACE(1),
                                                              ba.Locale,
                                                              SPACE(2),
                                                              ba.Region) [Orders_BillingAddress_Ref_D] ,
                                                              CONCAT(sa.Address1,
                                                              SPACE(1),
                                                              sa.AddressLine2,
                                                              SPACE(1),
                                                              sa.Locale,
                                                              SPACE(2),
                                                              sa.Region) [Orders_Shipping_Address_Ref_D] ,
                                                              IIF(ISNULL(oi.OrderId,
                                                              '') = '', 'NO Order Items_Records_D', CONCAT('Orders_Product= ',
                                                              p.SKU, SPACE(2),
                                                              'LineItem= ',
                                                              oi.LineItemNo,
                                                              SPACE(2),
                                                              'BasePrice= ',
                                                              oi.BasePrice,
                                                              SPACE(2),
                                                              'TotalPrice= ',
                                                              oi.TotalPrice,
                                                              SPACE(2),
                                                              'Quantity= ',
                                                              oi.Quantity,
                                                              SPACE(2),
                                                              'ItemTable_Tax=',
                                                              oi.TotalTax,
                                                              'ItemTaxTable_TTax=',
                                                              oit.TaxAmount,
                                                              SPACE(2), 'CV=',
                                                              oi.CV, SPACE(2),
                                                              'QV=', oi.QV)) [Orders_Items_Details_D] ,
                                                              CONCAT('AuthorizedAmount=',
                                                              opt.AmountAuthorized,
                                                              SPACE(2),
                                                              'ApprovalCode=',
                                                              opt.ApprovalCode,
                                                              SPACE(2),
                                                              'ErrorMessage=',
                                                              ISNULL(opt.ErrorMessage,
                                                              'No Error_D'),
                                                              'ResponceCode=',
                                                              opt.ResponseCode) [Orders PaymentDetails]
                                                              FROM
                                                              RFOperations.Hybris.orders ro
                                                              LEFT JOIN RFOperations.RFO_Reference.OrderStatus s ON s.OrderStatusId = ro.OrderStatusID
                                                              LEFT JOIN RFOperations.RFO_Reference.OrderType t ON t.OrderTypeID = ro.OrderTypeID
                                                              LEFT JOIN RFOperations.Hybris.OrderItem oi ON oi.OrderId = ro.OrderID
                                                              LEFT JOIN RFOperations.Hybris.ProductBase p ON p.productID = oi.ProductID
                                                              LEFT JOIN RFOperations.Hybris.OrderPayment op ON op.OrderID = ro.OrderID
                                                              LEFT JOIN RFOperations.RFO_Reference.CreditCardVendors v ON v.VendorID = op.VendorID
                                                              LEFT JOIN RFOperations.Hybris.OrderPaymentTransaction opt ON opt.OrderPaymentID = op.OrderPaymentID
                                                              LEFT JOIN RFOperations.Hybris.OrderBillingAddress ba ON ba.OrderID = ro.OrderID
                                                              LEFT JOIN RFOperations.Hybris.OrderShipment os ON os.OrderID = ro.OrderID
                                                              LEFT JOIN RFOperations.Hybris.OrderShippingAddress sa ON sa.OrderID = ro.OrderID
                                                              LEFT JOIN ( SELECT
                                                              orderId ,
                                                              SUM(TaxAmount) TaxAmount
                                                              FROM
                                                              RFOperations.Hybris.OrdersTax
                                                              GROUP BY orderId
                                                              ) ot ON ot.OrderID = ro.OrderID
                                                              LEFT JOIN ( SELECT
                                                              OrderItemID ,
                                                              SUM(TaxAmount) TaxAmount
                                                              FROM
                                                              RFOperations.Hybris.OrderItemTax
                                                              GROUP BY OrderItemID
                                                              ) oit ON oit.OrderItemID = oi.OrderItemID
                                                              LEFT JOIN RFOperations.Hybris.OrderShipmentPackageItem sop ON sop.OrderID = ro.OrderID
                                                              AND sop.OrderID = oi.OrderItemID
                                                              LEFT JOIN RFOperations.Hybris.OrderNotes n ON n.OrderID = ro.OrderID
                                                              WHERE
                                                              ro.AccountID = @AccountID



                                                            END
                                                        ELSE
                                                            BEGIN
                                                              SELECT
                                                              'RFO No orders'
                                                            END 
                                               
                                                        SET @count = 0

                                                        SET @Count = ( SELECT
                                                              COUNT(o.OrderNumber)
                                                              FROM
                                                              [SJC-V2-QA01-W03].commissions.dropoff.orders o
                                                              WHERE
                                                              AccountID = @AccountID
                                                              )
                             
                                                        IF ( ISNULL(@Count, 0) > 0 )
                                                            BEGIN


  
                                                              SELECT
                                                              'Commission_Orders' [Table] ,
                                                              o.OrderNumber ,
                                                              o.AccountID ,
                                                              s.name [OrderStatus] ,
                                                              t.name [OrderTypes] ,
                                                              o.* ,
                                                              CONCAT('LineItemNo=',
                                                              oi.lineitemNO,
                                                              SPACE(2), 'SKU=',
                                                              oi.SKU, SPACE(2),
                                                              'Item_CV=',
                                                              oi.CV, SPACE(2),
                                                              'Item_QV=',
                                                              oi.QV,
                                                              'Item_basePrice=',
                                                              oi.baseprice,
                                                              SPACE(2),
                                                              'Item_Wholesaleprice',
                                                              oi.Wholesaleprice) [OrderItem_Details_D]
                                                              FROM
                                                              [SJC-V2-QA01-W03].commissions.dropoff.orders o
                                                              LEFT JOIN RFOperations.RFO_Reference.OrderType t ON t.ordertypeid = o.OrderTypeID
                                                              LEFT JOIN RFOperations.RFO_Reference.OrderStatus s ON s.orderstatusid = o.OrderStatusID
                                                              LEFT JOIN [SJC-V2-QA01-W03].commissions.dropoff.OrderItems oi ON oi.OrderNumber = o.OrderNumber
                                                              WHERE
                                                              AccountID = @AccountID



                                                            END 
                                                        ELSE
                                                            BEGIN
                                                              SELECT
                                                              ' No Orders in Commission Yet'
                                                            END
                                               
                                                        SET @count = 0

                                                        SET @Count = ( SELECT
                                                              COUNT(o.pk)
                                                              FROM
                                                              [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                              JOIN [SJC-V2-QA01-W07].Hybris.dbo.orders o ON o.p_user = u.PK
                                                              WHERE
                                                              u.p_uid = @Email
                                                              AND o.p_ordertype IN (
                                                              'CREDITMEMO',
                                                              'RETURN' )
                                                              )
                                                        IF ( ISNULL(@Count, 0) > 0 )
                                                            BEGIN

  


--Hybris ReturnOrders

                                                              SELECT
                                                              'Hybris_ReturnOrders_Level' [Source From] ,
                                                              u.p_customerid [AccountID] ,
                                                              o.p_code [ReturnOrderNumber] ,
                                                              s.Code [ReturnStatus] ,
                                                              o.p_ordertype [ReturnOrderType] ,
                                                              o.p_deliverycost [DeliveryCost] ,
                                                              o.p_subtotal [SubTotal] ,
                                                              o.p_totalprice [TotalPrice] ,
                                                              o.p_totaldiscounts [DiscountTotal] ,
                                                              o.p_totaltax [TotalTax] ,
                                                              o.p_totalsv [QV] ,
                                                              o.p_cv [CV] ,
                                                              o.p_taxexempt [TaxExempt] ,
                                                              p_donotship [DonotShip] ,
                                                              CONCAT('NameOnCard =',
                                                              pa.p_ccowner,
                                                              SPACE(2),
                                                              'CreditCardType= ',
                                                              ct.Code,
                                                              SPACE(2),
                                                              'ExpirationDate= ',
                                                              pa.p_validtomonth,
                                                              '-',
                                                              pa.p_validtoyear) [ReturnOrder Payment] ,
                                                              CONCAT(ba.p_streetname,
                                                              ba.p_streetnumber,
                                                              SPACE(1),
                                                              ba.p_town,
                                                              SPACE(1),
                                                              bg.p_isocode) Orders_BillingAddress_D ,
                                                              CONCAT(db.p_streetname,
                                                              db.p_streetnumber,
                                                              SPACE(1),
                                                              db.p_town,
                                                              SPACE(1),
                                                              dbr.p_isocode) Order_ShippingingAddress_D ,
                                                              CONCAT('TemplateProduct= ',
                                                              ce.p_info,
                                                              SPACE(2),
                                                              'LineItem= ',
                                                              ce.p_entrynumber,
                                                              SPACE(2),
                                                              'BasePrice= ',
                                                              ce.p_baseprice,
                                                              SPACE(2),
                                                              'TotalPrice= ',
                                                              ce.p_totalprice,
                                                              SPACE(2),
                                                              'Quantity= ',
                                                              ce.p_quantity) [Orders_Items_Details_D]
                                                              FROM
                                                              [SJC-V2-QA01-W07].Hybris.dbo.users u
                                                              JOIN [SJC-V2-QA01-W07].Hybris.dbo.orders o ON o.p_user = u.PK
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues s ON s.pk = o.p_status
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.paymentinfos pa ON pa.OwnerPkString = o.pk
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.enumerationvalues ct ON ct.pk = pa.p_type
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses ba ON ba.pk = o.p_paymentaddress
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions bg ON bg.pk = ba.p_region
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.addresses db ON db.pk = o.p_deliveryaddress
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.regions dbr ON dbr.pk = db.p_region
                                                              LEFT JOIN [SJC-V2-QA01-W07].Hybris.dbo.orderentries ce ON ce.p_order = o.PK
                                                              WHERE
                                                              u.p_uid = @Email
                                                              AND o.p_ordertype IN (
                                                              'CREDITMEMO',
                                                              'RETURN' )
						 

                                                        
                                                              SET @count = 0

                                                              SET @Count = ( SELECT
                                                              COUNT(ro.AccountId)
                                                              FROM
                                                              RFOperations.Hybris.ReturnOrder ro
                                                              WHERE
                                                              ro.AccountID = @AccountID
                                                              )
                                                              IF ( ISNULL(@Count,
                                                              0) > 0 )
                                                              BEGIN


                                                              SELECT
                                                              'RFO_ReturnOrder_Level' [Source From] ,
                                                              ro.AccountID ,
                                                              ro.ConsultantID ,
                                                              ro.ReturnOrderNumber ,
                                                              s.Name [ReturnStatus] ,
                                                              t.Name [RetunrType] ,
                                                              ro.CompletionDate ,
                                                              ro.CommissionDate ,
                                                              ro.Total ,
                                                              ro.SubTotal ,
                                                              ro.RefundedShippingCost ,
                                                              ro.RefundTaxOnly ,
                                                              ro.RefundedTax ,
                                                              ro.ProductDiscount ,
                                                              ro.TotalDiscount ,
                                                              ro.CV ,
                                                              ro.QV ,
                                                              ro.OrderID [OriginalOrders] ,
                                                              ro.DoNotShip ,
                                                              ro.TaxExempt ,
                                                              IIF(ISNULL(rp.returnpaymentid,
                                                              '') = '', 'No Payment Profile_D', CONCAT('NameOnCard=',
                                                              ba.FirstName,
                                                              SPACE(1),
                                                              ba.MiddleName,
                                                              SPACE(1),
                                                              ba.LastName,
                                                              SPACE(1),
                                                              'CreditCardType=',
                                                              v.Name, SPACE(2),
                                                              'ExpirationDate=',
                                                              SPACE(1),
                                                              rp.Expmonth, '-',
                                                              rp.ExpYear)) [ReturnOrders_PaymentProfile] ,
                                                              CONCAT(ba.addressline1,
                                                              SPACE(1),
                                                              ba.AddressLine2,
                                                              SPACE(1),
                                                              ba.Locale,
                                                              SPACE(2),
                                                              ba.Region) [ReturnOrderOrders_BillingAddress_Ref_D] ,
                                                              IIF(ISNULL(ri.ReturnOrderID,
                                                              '') = '', 'NO Order Items_Records_D', CONCAT('Orders_Product= ',
                                                              p.SKU, SPACE(2),
                                                              'Expencted Qnt.= ',
                                                              ri.ExpectedQuantity,
                                                              SPACE(2),
                                                              'Received Qnt.= ',
                                                              ri.ReceivedQuantity,
                                                              SPACE(2),
                                                              'BasePrice= ',
                                                              ri.BasePrice,
                                                              SPACE(2),
                                                              'TotalPrice= ',
                                                              ri.TotalPrice,
                                                              SPACE(2),
                                                              'ReFundedDate= ',
                                                              ri.RefundedDate,
                                                              SPACE(2),
                                                              'RestokingFee=',
                                                              ri.ReStockingFeeTax,
                                                              'ItemTaxTable_TTax=',
                                                              rit.TaxAmount,
                                                              SPACE(2), 'CV=',
                                                              ri.CV, SPACE(2),
                                                              'QV=', ri.QV)) [Orders_Items_Details_D] ,
                                                              CONCAT('AuthorizedAmount=',
                                                              rpt.AmountAuthorized,
                                                              SPACE(2),
                                                              'ApprovalCode=',
                                                              rpt.ApprovalCode,
                                                              SPACE(2),
                                                              'ErrorMessage=',
                                                              ISNULL(rpt.ErrorMessage,
                                                              'No Error_D'),
                                                              'ResponceCode=',
                                                              rpt.ResponseCode) [Returns PaymentDetails]
                                                              FROM
                                                              RFOperations.Hybris.ReturnOrder ro
                                                              LEFT JOIN RFOperations.RFO_Reference.ReturnStatus s ON s.ReturnStatusId = ro.ReturnStatusID
                                                              LEFT JOIN RFOperations.Hybris.ReturnItem ri ON ri.ReturnOrderID = ro.ReturnOrderID
                                                              LEFT JOIN RFOperations.Hybris.ProductBase p ON p.productID = ri.ProductID
                                                              LEFT JOIN RFOperations.RFO_Reference.ReturnType t ON t.ReturnTypeID = ri.ReturnTypeID
                                                              LEFT JOIN RFOperations.RFO_Reference.ReturnReason rr ON rr.ReturnReasonID = ri.ReturnReasonID
                                                              LEFT JOIN RFOperations.Hybris.ReturnPayment rp ON rp.ReturnOrderID = ro.ReturnOrderID
                                                              LEFT JOIN RFOperations.RFO_Reference.CreditCardVendors v ON v.VendorID = rp.VendorID
                                                              LEFT JOIN RFOperations.Hybris.ReturnPaymentTransaction rpt ON rpt.ReturnPaymentId = rp.ReturnPaymentId
                                                              LEFT JOIN RFOperations.Hybris.ReturnBillingAddress ba ON ba.ReturnOrderID = ro.ReturnOrderID
                                                              LEFT JOIN RFOperations.Hybris.ReturnOrderTax rt ON rt.ReturnOrderID = ro.ReturnOrderID
                                                              LEFT JOIN RFOperations.Hybris.ReturnItemTax rit ON rit.ReturnItemID = ri.ReturnItemID
                                                              LEFT JOIN RFOperations.Hybris.ReturnNotes n ON n.ReturnOrderID = ro.ReturnOrderID
                                                              WHERE
                                                              ro.AccountID = @AccountID

                                                              END 
				

                                                              ELSE
                                                              BEGIN
                                                              SELECT
                                                              ' No ReturnOrders in RFO Yet '
                                                              END 
                                                        
                                                              SET @count = 0

                                                              SET @Count = ( SELECT
                                                              COUNT(AC.AccountId)
                                                              FROM
                                                              [SJC-V2-QA01-W03].commissions.dropoff.Accounts ac
                                                              JOIN [SJC-V2-QA01-W03].commissions.dropoff.Orders ro ON ro.AccountID = ac.AccountID
                                                              JOIN [SJC-V2-QA01-W03].commissions.dropoff.OrderReturns re ON re.OrderNumber = ro.OrderNumber
                                                              WHERE
                                                              ac.AccountID = @AccountID
                                                              )
                                                              IF ( ISNULL(@Count,
                                                              0) > 0 )
                                                              BEGIN


                                                             
                                                              SELECT
                                                              'Commission_ReturnOrderItems' [Table] ,
                                                              re.* ,
                                                              IIF(ISNULL(ri.ReturnOrderID,
                                                              0) = 0, NULL, CONCAT('SKU=',
                                                              ri.SKU, SPACE(2),
                                                              'ReceiveQnt=',
                                                              ri.ReceivedQuantity)) ReturnItem_Details_D
                                                              FROM
                                                              [SJC-V2-QA01-W03].commissions.dropoff.Accounts ac
                                                              JOIN [SJC-V2-QA01-W03].commissions.dropoff.Orders ro ON ro.AccountID = ac.AccountID
                                                              LEFT JOIN [SJC-V2-QA01-W03].commissions.dropoff.OrderReturns re ON re.OrderNumber = ro.OrderNumber
                                                              LEFT JOIN [SJC-V2-QA01-W03].commissions.[dropoff].[OrderReturnItems] ri ON ri.ReturnOrderID = re.ReturnOrderID
                                                              WHERE
                                                              ac.AccountID = @AccountID


                                                              END 
				

                                                              ELSE
                                                              BEGIN
                                                              SELECT
                                                              'No Return in Commission  Yet'
                                                              END 
                                                            END 

                                                        ELSE
                                                            BEGIN 
                                                              SELECT
                                                              'Hybris has No return'
                                               
                                                            END 


                                                    END 
                                                ELSE
                                                    BEGIN
                                                        SELECT
                                                              'Hybris has no Orders Yet '
                                      
                                                    END 
                                            END
                                        ELSE
                                            BEGIN
                                                SELECT  'Hybris has No Templates'

                                            END 

								
                                    END

                                ELSE
                                    BEGIN
                                        SELECT  'No  Account in Commission Yet'

                                    END 


                            END

                        ELSE
                            BEGIN

                                SELECT  'No  Account in RFO Yet'

                            END 
			

                    END 

            END 

    END 