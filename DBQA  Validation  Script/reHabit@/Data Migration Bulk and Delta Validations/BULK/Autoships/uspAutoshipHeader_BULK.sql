USE [DM_QA]
GO
/****** Object:  StoredProcedure [dbqa].[uspAutoshipHeader_BULK]    Script Date: 3/6/2017 5:33:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbqa].[uspAutoshipHeader_BULK] ( @LoadDate DATE )
AS
    BEGIN

EXECUTE	[dbqa].[uspAutoshipHeader_CRP_PC_BULK] @LoadDate

EXECUTE  [dbqa].[uspAutoship_PULSE_BULK]

END 