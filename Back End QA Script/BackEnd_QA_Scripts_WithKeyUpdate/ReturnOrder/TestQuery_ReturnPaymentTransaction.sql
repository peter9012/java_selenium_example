



--SELECT * FROM datamigration..dm_log
--WHERE test_area='853-ReturnPaymentTransaction'
USE rfoperations
set statistics time on
go

set transaction isolation level read uncommitted

declare @HYB_key varchar(100) = 'P_order'
declare @RFO_key varchar(100) = 'returnorderId'
declare @sql_gen_1 nvarchar(max)
declare @sql_gen_2 nvarchar(max)
declare @cnt int
declare @lt_1 int
declare @lt_2 int
declare @temp table(test_area varchar(max), test_type varchar(max), rfo_column varchar(max), hybris_column varchar(max), hyb_key varchar(max), hyb_value varchar(max), rfo_key varchar(max), rfo_value varchar(max))

		--Validation of AUTOSHIP Counts, Dups & Columns without transformations

		--Duplicate check on Hybris side for US
		select case when count(1)>0 then 'Duplicates Found' else 'No duplicates - Validation Passed' end as [Step-1 Validation]
		from (select count(*) cnt, e.p_order, e.p_info --, a.ownerpkstring  
		from hybris.dbo.paymentinfos (nolock) a,
		hybris.dbo.users b,
		hybris.dbo.countries c,
		hybris.dbo.orders (nolock) d,
		hybris.dbo.paymenttransactions e
		where a.userpk=b.pk
		and b.p_country=c.pk
		and d.pk=a.ownerpkstring
		AND a.pk=e.p_info
		and c.isocode = 'US'
		and b.p_sourcename = 'Hybris-DM'
		and d.p_template is null AND d.TypePkString=8796127723602 AND a.duplicate = 1 --R profile
		group by e.p_order, e.p_info
		having count(*) > 1)t1


				----Counts check on Hybris side for US
				SELECT  hybris_cnt ,
						RFO_CNT ,
						CASE WHEN hybris_cnt > rfo_cnt THEN 'Hybris count more than RFO count'
							 WHEN rfo_cnt > hybris_cnt THEN 'RFO count more than Hybris count'
							 ELSE 'Count matches - validation passed'
						END Results
				FROM    ( SELECT    COUNT(hpt.PK) hybris_cnt
						  FROM      Hybris.dbo.orders ho
									JOIN Hybris..users u ON ho.userpk = u.PK
															AND u.p_sourcename = 'Hybris-DM'
															AND ho.TypePkString = 8796127723602
															AND ho.p_template IS NULL
									JOIN Hybris..countries c ON c.PK = u.p_country
																AND c.isocode = 'US'
									JOIN Hybris..paymentinfos pai ON pai.OwnerPkString = ho.PK
									JOIN Hybris..paymenttransactions hpt ON hpt.p_info = pai.originalpk
																	AND hpt.p_order=ho.pk
																			AND pai.duplicate = 1
						) t1 , --105789
						( SELECT    COUNT(rpt.ReturnPaymentTransactionId) rfo_cnt
						  FROM      RFOperations.Hybris.ReturnOrder ro
									JOIN RodanFieldsLive.dbo.Orders rfl ON ro.ReturnOrderNumber = rfl.orderID
                                                             AND rfl.orderTypeID = 9
									JOIN Hybris.dbo.users u ON u.p_rfaccountid = ro.AccountID
									JOIN RFOperations.Hybris.ReturnPayment rp ON rp.ReturnOrderID = ro.ReturnOrderID
									JOIN Hybris..orders ho ON ho.PK = ro.OrderID
									JOIN Hybris.ReturnPaymentTransaction rpt ON rpt.ReturnPaymentId = rp.ReturnPaymentId
						  WHERE     CountryID = 236
									AND p_sourcename = 'Hybris-DM'
						) t2 --149286


    SELECT  t1.PK ,
            t2.ReturnOrderID ,
            CASE WHEN t1.PK IS NULL THEN 'Missing In Hybris'
                 WHEN t2.ReturnOrderID IS NULL THEN 'Missing In RFO'
            END AS Results
    FROM    ( SELECT  DISTINCT
                        ho.PK
              FROM      Hybris..orders ho
                        JOIN Hybris..users u ON ho.userpk = u.PK
                                                AND u.p_sourcename = 'Hybris-DM'
                                                AND ho.TypePkString = 8796127723602
                                                AND ISNULL(ho.p_template, 0) = 0
                        JOIN Hybris..countries c ON c.PK = u.p_country
                                                    AND c.isocode = 'US'
                        JOIN Hybris..paymentinfos pai ON pai.OwnerPkString = ho.PK
                        JOIN Hybris..paymenttransactions hpt ON hpt.p_info = pai.originalpk
														--ON hpt.p_order=ho.pk
                                                              AND pai.duplicate = 1
            ) t1
            FULL OUTER JOIN ( SELECT    ro.ReturnOrderID
                              FROM      RFOperations.Hybris.ReturnOrder ro
										JOIN RodanFieldsLive.dbo.Orders rfl ON ro.ReturnOrderNumber = rfl.orderID
                                                             AND rfl.orderTypeID = 9
                                        JOIN Hybris.dbo.users u ON u.p_rfaccountid = ro.AccountID AND ro.ReturnOrderID=9024957481005
                                        JOIN RFOperations.Hybris.ReturnPayment rp ON rp.ReturnOrderID = ro.ReturnOrderID
                                        JOIN Hybris..orders ho ON ho.PK = ro.OrderID
                                        JOIN Hybris.ReturnPaymentTransaction rpt ON rpt.ReturnPaymentId = rp.ReturnPaymentId
                              WHERE     CountryID = 236
                                        AND p_sourcename = 'Hybris-DM'
                            ) t2 ON t1.PK = t2.ReturnOrderID
    WHERE   t1.PK IS NULL
            OR t2.ReturnOrderID IS NULL; 
	


--Column2Column Validation that doesn't have transformation - Autoship

delete from datamigration.dbo.dm_log where test_area = '853-ReturnPaymentTransaction'
IF OBJECT_ID('tempdb..#tempact') IS NOT NULL
drop table #tempact

select a.returnorderid, a.orderid, returnordernumber, a.accountid, b.pk, c.returnpaymentid, c.Vendorid, c.AmountToBeAuthorized, c.ProcessOnDate into #tempact 
from rfoperations.hybris.ReturnOrder a  JOIN RodanFieldsLive.dbo.Orders rfl ON A.ReturnOrderNumber = rfl.orderID
                                                             AND rfl.orderTypeID = 9,
hybris.dbo.users b,
rfoperations.hybris.ReturnPayment c,
hybris.dbo.paymentinfos d
where a.accountid=b.p_rfaccountid
and a.ReturnOrderID=c.ReturnOrderID
and c.returnpaymentid=d.pk 
and countryid = 236 and b.p_sourcename = 'Hybris-DM'
AND a.ReturnOrderID IN (SELECT returnorderid FROM hybris.returnitem)
group by a.returnorderid, a.orderid, returnordernumber, a.accountid, b.pk, c.returnpaymentid, c.Vendorid, d.code,c.AmountToBeAuthorized , c.ProcessOnDate

create clustered index as_cls1 on #tempact (returnorderid)

select 'Validation of column to column with no transformation in progress' as [Step-2 Validation], getdate() as StartTime
set @cnt = 1
select @lt_1 = count(*) from datamigration.dbo.map_tab where flag = 'c2c' and rfo_column <> @RFO_key
AND [Hybris_Column ]<>@HYB_key and [owner] = '853-ReturnPaymentTransaction'

while @cnt<=@lt_1
begin

select @sql_gen_1 = 'SELECT DISTINCT  '''+[owner]+''', '''+flag+''', '''+[RFO_Reference Table]+''' as rfo_column, '''+Hybris_Column+''' as hybris_column, A.'+@HYB_key+' as hyb_key, A.'+Hybris_Column+' as hyb_value, B.'+@RFO_key+' as rfo_key, B.RFO_Col as rfo_value

FROM (SELECT a.'+@HYB_key+', '+Hybris_Column+' FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+'
except
SELECT a.'+@RFO_key+', a.'+RFO_Column+' as RFO_Col FROM rfoperations.'+[Schema]+'.'+RFO_Table+' a, #tempact b where a.'+@RFO_key+'=b.'+@RFO_key+') A  

LEFT JOIN

(SELECT a.'+@RFO_key+', a.'+RFO_Column+' as RFO_Col FROM rfoperations.'+[Schema]+'.'+RFO_Table+' a, #tempact b where a.'+@RFO_key+'=b.'+@RFO_key+'
except
SELECT a.'+@HYB_key+', '+Hybris_Column+' FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+') B
ON A.'+@HYB_key+'=B.'+@RFO_key+'
UNION
SELECT DISTINCT '''+[owner]+''', '''+flag+''', '''+[RFO_Reference Table]+''', '''+Hybris_Column+''', A.'+@HYB_key+', A.'+Hybris_Column+', B.'+@RFO_key+',B.RFO_Col

FROM (SELECT a.'+@HYB_key+', '+Hybris_Column+' FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+'
except
SELECT a.'+@RFO_key+', a.'+RFO_Column+' as RFO_Col FROM rfoperations.'+[Schema]+'.'+RFO_Table+' a, #tempact b where a.'+@RFO_key+'=b.'+@RFO_key+') A  

RIGHT JOIN

(SELECT a.'+@RFO_key+', a.'+RFO_Column+' as RFO_Col FROM rfoperations.'+[Schema]+'.'+RFO_Table+' a, #tempact b where a.'+@RFO_key+'=b.'+@RFO_key+'
except
SELECT a.'+@HYB_key+', '+Hybris_Column+' FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+') B
ON A.'+@HYB_key+'=B.'+@RFO_key+''
from (select *, row_number() over (order by [owner]) rn
from datamigration.dbo.map_tab
where flag = 'c2c' 
AND [RFO_Column ]<>@RFO_key
and Hybris_column <> @HYB_key
and [owner] = '853-ReturnPaymentTransaction')temp where rn = @cnt 

print @sql_gen_1
insert into @temp (test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value)
EXEC sp_executesql @sql_gen_1

if(select count(*) from @temp) >1
begin
	declare @err_cnt int
	select @err_cnt = case when hyb_cnt = 0 then rfo_cnt else hyb_cnt end from (select count(distinct hyb_key) hyb_cnt, count(distinct rfo_key) rfo_cnt from @temp)t1

	update a
	set [prev_run_err] = @err_cnt
	from datamigration.dbo.map_tab a,
	@temp b
	where a.hybris_column=b.hybris_column
	and [owner] = '853-ReturnPaymentTransaction' 
end	

insert into datamigration.dbo.dm_log
select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
from @temp
where ((coalesce(hyb_key, '~') = coalesce(rfo_key,'~'))
and (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))
union 
select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
from @temp
where ((coalesce(hyb_key, '~') <> coalesce(rfo_key,'~'))
or (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))

delete from @temp

set @cnt=@cnt+1

end

update datamigration.dbo.map_tab
set [prev_run_err] = 0
where [owner] = '853-ReturnPaymentTransaction' and flag = 'c2c'
and hybris_column not in (select distinct hybris_column from datamigration..dm_log where test_area = '853-ReturnPaymentTransaction' and test_type = 'c2c')


select 'Step-2 Completed, Validation of default columns in progress' as [Step-3 Validation],
getdate() as StartTime

----Defaults Check
set @cnt = 1
select @lt_1 = count(*) from datamigration.dbo.map_tab   where flag = 'defaults' and [owner] = '853-ReturnPaymentTransaction' and [rfo_reference table]= 'NULL'
select @lt_2 = count(*) from datamigration.dbo.map_tab  where flag = 'defaults' and [owner] = '853-ReturnPaymentTransaction' and [rfo_reference table]<> 'NULL'

while (@cnt<=@lt_1 and @cnt<=@lt_2)
begin
	if (select count(*) from datamigration.dbo.map_tab   where flag = 'defaults' and [owner] = '853-ReturnPaymentTransaction' and [rfo_reference table] = 'NULL') >1
	begin
		select @sql_gen_1 = 'use rfoperations
		select distinct '''+[owner]+''' as test_area, '''+flag+''' as test_type, null as rfo_column, '''+Hybris_Column+''' as hybris_column, a.'+@HYB_key+', '+hybris_column+', null as rfo_key, null as rfo_value
		from hybris.dbo.'+hybris_table+' a, #tempact b 
		where a.'+@HYB_key+'=b.'+@RFO_key+'
		and '+hybris_column+' is not null' 
		from (select *, row_number() over (order by [owner]) rn
		from datamigration.dbo.map_tab 
		where flag = 'defaults' 
		and [rfo_reference table] = 'NULL'
		and [owner] = '853-ReturnPaymentTransaction')temp where rn = @cnt
	end

	print @sql_gen_1
	insert into @temp (test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value)
	EXEC sp_executesql @sql_gen_1

	if(select count(*) from @temp) >1
	begin
		--declare @err_cnt int
		select @err_cnt = case when hyb_cnt = 0 then rfo_cnt else hyb_cnt end from (select count(distinct hyb_key) hyb_cnt, count(distinct rfo_key) rfo_cnt from @temp)t1

		update a
		set [prev_run_err] = @err_cnt
		from datamigration.dbo.map_tab a,
		@temp b
		where a.hybris_column=b.hybris_column
		and [owner] = '853-ReturnPaymentTransaction' 
	end	

	insert into datamigration.dbo.dm_log
	select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
	from @temp
	where ((coalesce(hyb_key, '~') = coalesce(rfo_key,'~'))
	and (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))
	union 
	select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
	from @temp
	where ((coalesce(hyb_key, '~') <> coalesce(rfo_key,'~'))
	or (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))

	--select * from datamigration.dbo.dm_log where test_type = 'defaults'

	if (select count(*) from datamigration.dbo.map_tab  where flag = 'defaults' and [owner] = '853-ReturnPaymentTransaction' and [rfo_reference table] <> 'NULL') >1
	begin
		select @sql_gen_2 = 'use rfoperations
		select distinct '''+[owner]+''' as test_area, '''+flag+''' as test_type, null as rfo_column, '''+Hybris_Column+''' as hybris_column, a.'+@HYB_key+', '+hybris_column+', null as rfo_key, null as rfo_value
		from hybris.dbo.'+hybris_table+' a, #tempact b 
		where a.'+@HYB_key+'=b.'+@RFO_key+'
		and '+hybris_column+' <> '''+[rfo_reference table]+'''' 
		from (select *, row_number() over (order by [owner]) rn
		from datamigration.dbo.map_tab 
		where flag = 'defaults' 
		and [rfo_reference table] <> 'NULL'
		and [owner] = '853-ReturnPaymentTransaction')temp where rn = @cnt
	end

	print @sql_gen_2
    insert into @temp (test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value)
	EXEC sp_executesql @sql_gen_2

	if(select count(*) from @temp) >1
	begin
		--declare @err_cnt int
		select @err_cnt = case when hyb_cnt = 0 then rfo_cnt else hyb_cnt end from (select count(distinct hyb_key) hyb_cnt, count(distinct rfo_key) rfo_cnt from @temp )t1

		update a
		set [prev_run_err] = @err_cnt
		from datamigration.dbo.map_tab a,
		@temp b
		where a.hybris_column=b.hybris_column
		and [owner] = '853-ReturnPaymentTransaction' 
	end	

	insert into datamigration.dbo.dm_log
	select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
	from @temp
	where ((coalesce(hyb_key, '~') = coalesce(rfo_key,'~'))
	and (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))
	union 
	select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
	from @temp
	where ((coalesce(hyb_key, '~') <> coalesce(rfo_key,'~'))
	or (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))

delete from @temp

set @cnt=@cnt+1

end

update datamigration.dbo.map_tab
set [prev_run_err] = 0
where [owner] = '853-ReturnPaymentTransaction' and flag = 'defaults'
and hybris_column not in (select distinct hybris_column from datamigration..dm_log where test_area = '853-ReturnPaymentTransaction' and test_type = 'defaults')



select 'Step-3 completed, Validation of transformed columns in progress' as [Step-4 Validation], getdate() as StartTime

--Transformed Columns Validation --10:16 mins
set @cnt = 1
select @lt_1 = count(*) from datamigration.dbo.map_tab  where flag = 'manual' and rfo_column <> @RFO_key and [owner] = '853-ReturnPaymentTransaction'

while @cnt<=@lt_1
begin

select  @sql_gen_1 = 'SELECT DISTINCT  '''+[owner]+''' as test_area, '''+flag+''' as test_type, '''+[RFO_Reference Table]+''' as rfo_column, '''+Hybris_Column+''' as hybris_column, A.'+@HYB_key+' as hyb_key, A.Hyb_Trans_col as hyb_value, B.'+@RFO_key+' as rfo_key, B.RFO_Trans_Col as rfo_value

FROM (SELECT a.'+@HYB_key+', '+Hybris_Column+' as Hyb_Trans_col FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+'
except
SELECT a.'+@RFO_key+', '+RFO_Column+' as RFO_Trans_Col FROM '+RFO_Table+') A  

LEFT JOIN

(SELECT a.'+@RFO_key+', '+RFO_Column+' as RFO_Trans_Col FROM '+RFO_Table+'
except
SELECT a.'+@HYB_key+', '+Hybris_Column+' as Hyb_Trans_col FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+') B
ON A.'+@HYB_key+'=B.'+@RFO_key+'
UNION
SELECT DISTINCT  '''+[owner]+''', '''+flag+''', '''+[RFO_Reference Table]+''', '''+Hybris_Column+''', A.'+@HYB_key+', A.Hyb_Trans_col, B.'+@RFO_key+', B.RFO_Trans_Col

FROM (SELECT a.'+@HYB_key+', '+Hybris_Column+' as Hyb_Trans_col FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+'
except
SELECT a.'+@RFO_key+', '+RFO_Column+' as RFO_Trans_Col FROM '+RFO_Table+') A  

RIGHT JOIN

(SELECT a.'+@RFO_key+', '+RFO_Column+' as RFO_Trans_Col FROM '+RFO_Table+'
except
SELECT a.'+@HYB_key+', '+Hybris_Column+' as Hyb_Trans_col FROM hybris.dbo.'+Hybris_Table+' a, #tempact b where a.'+@HYB_key+'=b.'+@RFO_key+') B
ON A.'+@HYB_key+'=B.'+@RFO_key+''
from (select *, row_number() over (order by [owner]) rn
from datamigration.dbo.map_tab
where flag = 'manual'
and Hybris_column <> @HYB_key
AND id <> 327 --orders related
and [owner] = '853-ReturnPaymentTransaction')temp where rn = @cnt

print @sql_gen_1
insert into @temp (test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value)
EXEC sp_executesql @sql_gen_1


if(select count(*) from @temp) >1
begin
	--declare @err_cnt int
	select @err_cnt = case when hyb_cnt = 0 then rfo_cnt else hyb_cnt end from (select count(distinct hyb_key) hyb_cnt, count(distinct rfo_key) rfo_cnt from @temp)t1

	update a
	set [prev_run_err] = @err_cnt
	from datamigration.dbo.map_tab a,
	@temp b
	where a.hybris_column=b.hybris_column
	and [owner] = '853-ReturnPaymentTransaction' 
end	

insert into datamigration..dm_log
select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value
from @temp
where ((coalesce(hyb_key, '~') = coalesce(rfo_key,'~'))
and (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))
union 
select top 5 test_area, test_type, rfo_column, hybris_column, hyb_key, hyb_value, rfo_key, rfo_value 
from @temp
where ((coalesce(hyb_key, '~') <> coalesce(rfo_key,'~'))
or (coalesce(hyb_value,'~') <> coalesce(rfo_value,'~')))


update datamigration.dbo.map_tab
set [prev_run_err] = 0
where [owner] = '853-ReturnPaymentTransaction' and flag = 'manual'
and hybris_column not in (select distinct hybris_column from datamigration..dm_log where test_area = '853-ReturnPaymentTransaction' and test_type = 'manual')

delete from @temp

set @cnt=@cnt+1

end

select 'VALIDATION COMPLETED' [Status], [total no of columns], [columns passed],[total no of columns]-[columns passed] as [Required Analysis],
getdate() as EndTime
from 
	(select count(cnt) as [columns passed] from (select distinct hybris_column as cnt from datamigration.dbo.map_tab where [owner] = '853-ReturnPaymentTransaction' and flag in ('c2c', 'manual', 'defaults')
	except
	select distinct hybris_column from DataMigration..dm_log where test_area = '853-ReturnPaymentTransaction')a) tab1,

	(select count(id) as [total no of columns] from  datamigration.dbo.map_tab where [owner] = '853-ReturnPaymentTransaction' and flag in ('c2c', 'manual','defaults'))tab2

set statistics time off
go


