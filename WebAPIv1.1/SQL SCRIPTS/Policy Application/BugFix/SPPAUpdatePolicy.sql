USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPPAUpdatePolicy]    Script Date: 25/08/2023 6:53:35 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SPPAUpdatePolicy]  

@PolicyId int,
@PolicyName [varchar](200) NULL,
@PolicyDescription [varchar](max) NULL,
@Questionnaire_Id [int] NULL,
@VersionControl varchar(100),
@UpdatedBy [varchar](100) NULL

AS

BEGIN

	Update MBGSPMainDB.dbo.PAPolicy
		set PolicyName			= @PolicyName
		   ,PolicyDescription	= @PolicyDescription
		   ,VersionControl		= @VersionControl
		   ,UpdatedBy			= @UpdatedBy
		   ,SysModificationDate	= (select getdate())
		where Policy_Id = @PolicyId

END

