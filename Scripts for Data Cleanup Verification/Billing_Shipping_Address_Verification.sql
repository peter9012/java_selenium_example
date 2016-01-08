DROP TABLE DATAMIGRATION.MIGRATION.SHIP_ADD_CLEANUP
				SELECT  * 
				INTO DATAMIGRATION.MIGRATION.SHIP_ADD_CLEANUP
				FROM
				(SELECT DISTINCT ACCOUNTID,CONCAT(Address1,' ',AddressLine2,' ',AddressLine3,' ',AddressLine4,' ',AddressLine5) AS AD FROM RFOPERATIONS.HYBRIS.ORDERSHIPPINGADDRESS OSA , RFOPERATIONS.HYBRIS.ORDERS O , RodanFieldsLive.dbo.Orders rfl WHERE O.OrderID = rfl.orderNumber AND rfl.orderTypeID NOT IN (4, 5, 9 ) AND O.ORDERID=OSA.ORDERID AND O.COUNTRYID=236 AND ACCOUNTID NOT IN (1,2) AND O.ORDERNUMBER IN (SELECT ORDERID FROM RFOPERATIONS.ETL.ORDERDATE WHERE STARTDATE > '06/01/2014')
				UNION
				SELECT DISTINCT O.ACCOUNTID,CONCAT(Address1,' ',AddressLine2,' ',AddressLine3,' ',AddressLine4,' ',AddressLine5) AS AD FROM RFOPERATIONS.HYBRIS.AUTOSHIPSHIPPINGADDRESS OSA , RFOPERATIONS.HYBRIS.AUTOSHIP O , RodanFieldsLive.dbo.AutoshipOrders ao WHERE O.AUTOSHIPNumber=OSA.AUTOSHIPID AND O.COUNTRYID=236 AND ao.TemplateOrderID = O.AutoshipID AND ao.AccountID = O.AccountID AND O.ACCOUNTID NOT IN (1,2))A
				EXCEPT
				SELECT DISTINCT A.ACCOUNTID, CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3,' ',AddressLine4,' ',AddressLine5)
				FROM
				RFOPERATIONS.RFO_ACCOUNTS.ACCOUNTBASE A,
				RFOPERATIONS.RFO_ACCOUNTS.ACCOUNTCONTACTS AC,
				RFOPERATIONS.RFO_ACCOUNTS.AccountContactAddresses ACA,
				RFOPERATIONS.RFO_ACCOUNTS.Addresses AD
				WHERE A.ACCOUNTID=AC.ACCOUNTID AND A.COUNTRYID=236 AND
				AC.ACCOUNTCONTACTID=ACA.ACCOUNTCONTACTID AND
				ACA.ADDRESSID=AD.ADDRESSID
				AND AD.ADDRESSTYPEID=2 AND A.ACCOUNTID NOT IN (1,2)

				
				DROP TABLE DATAMIGRATION.MIGRATION.BILL_ADD_CLEANUP

				--VERIFY BILLING ADDRESS
				SELECT  * 
				INTO DATAMIGRATION.MIGRATION.BILL_ADD_CLEANUP
				FROM
				(SELECT DISTINCT ACCOUNTID,CONCAT(Address1,' ',AddressLine2,' ',AddressLine3,' ',AddressLine4,' ',AddressLine5) AS AD FROM RFOPERATIONS.HYBRIS.ORDERBILLINGADDRESS OSA , RFOPERATIONS.HYBRIS.ORDERS O , RodanFieldsLive.dbo.Orders rfl WHERE O.OrderNumber = rfl.orderID AND rfl.orderTypeID NOT IN (4, 5, 9 ) AND O.ORDERID=OSA.ORDERID AND O.COUNTRYID=236 AND ACCOUNTID NOT IN (1,2) AND O.ORDERNUMBER IN (SELECT ORDERID FROM RFOPERATIONS.ETL.ORDERDATE WHERE STARTDATE > '06/01/2014')
				UNION
				SELECT DISTINCT O.ACCOUNTID,CONCAT(Address1,' ',AddressLine2,' ',AddressLine3,' ',AddressLine4,' ',AddressLine5) AS AD FROM RFOPERATIONS.HYBRIS.AUTOSHIPPAYMENTADDRESS OSA , RFOPERATIONS.HYBRIS.AUTOSHIP O , RodanFieldsLive.dbo.AutoshipOrders ao WHERE O.AUTOSHIPNumber=OSA.AUTOSHIPID AND O.COUNTRYID=236 AND ao.TemplateOrderID = O.AutoshipID AND ao.AccountID = O.AccountID AND O.ACCOUNTID NOT IN (1,2))A
				EXCEPT
				SELECT DISTINCT A.ACCOUNTID, CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3,' ',AddressLine4,' ',AddressLine5)
				FROM
				RFOPERATIONS.RFO_ACCOUNTS.ACCOUNTBASE A,
				RFOPERATIONS.RFO_ACCOUNTS.ACCOUNTCONTACTS AC,
				RFOPERATIONS.RFO_ACCOUNTS.AccountContactAddresses ACA,
				RFOPERATIONS.RFO_ACCOUNTS.Addresses AD
				WHERE A.ACCOUNTID=AC.ACCOUNTID AND A.COUNTRYID=236 AND
				AC.ACCOUNTCONTACTID=ACA.ACCOUNTCONTACTID AND
				ACA.ADDRESSID=AD.ADDRESSID
				AND AD.ADDRESSTYPEID=3 AND A.ACCOUNTID NOT IN (1,2)

