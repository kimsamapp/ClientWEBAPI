USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[AGAApplicationsProcedure]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AGAApplicationsProcedure]

@_AGAApplication_Id int,
@_actionType int,
@_name varchar(max),
@_createdby varchar(max),
@_applicationType int,
@_isActive int,
@_searchKeyword varchar(max),
@_url varchar(max),
@_description varchar(max)

AS

BEGIN
	--INSERT ALL
	If @_actionType = 0
		Begin
			Insert into MBGSPMainDB.dbo.AGAApplications 
			(
				Name,
				CreatedBy,
				CreatedDate,
				ApplicationType,
				IsActive,
				URL,
				Description
			)
			values
			(
				@_name,
				@_createdby,
				(select getdate()),
				@_applicationType,
				1,
				@_url,
				@_description
			)
		End
	--UPDATE
	If @_actionType = 2
		BEGIN
			Update MBGSPMainDB.dbo.AGAApplications
			set Name = @_name, ApplicationType = @_applicationType, URL = @_url, Description = @_description
			where AGAApplication_Id = @_AGAApplication_Id
		END
	--VIEW
	If @_actionType = 3
		BEGIN
			Select a.AGAApplication_Id, a.AGAApplicationId, a.ApplicationType, a.CreatedBy, a.CreatedDate, a.Description, a.IsActive as ApplicationActive, a.Name as ApplicationName, a.URL,
			 b.AGAApplicationType_Id, b.AGAApplicationTypeId, b.Name as ApplicationTypeName, b.IsActive as ApplicationTypeActive, b.UpdatedBy, b.UpdatedDate
			  from MBGSPMainDB.dbo.AGAApplications a inner join MBGSPMainDB.dbo.AGAApplicationType b on a.ApplicationType = b.AGAApplicationType_Id
			ORDER BY AGAApplication_Id desc
		END
	--SEARCH
	If @_actionType = 4
		BEGIN
			Select * from MBGSPMainDB.dbo.AGAApplications
			where Name LIKE '%' + @_searchKeyword + '%' OR URL LIKE '%' + @_searchKeyword + '%' 
		END
	If @_actionType = 5
		BEGIN
			Select * from MBGSPMainDB.dbo.AGAApplications
			where AGAApplication_Id = @_AGAApplication_Id
		END
	If @_actionType = 6
		BEGIN
			Update MBGSPMainDB.dbo.AGAApplications
			set IsActive = @_isActive
			where AGAApplication_Id = @_AGAApplication_Id
		END
	If @_actionType = 7
		BEGIN
			Select a.AGAApplication_Id, a.AGAApplicationId, a.ApplicationType, a.CreatedBy, a.CreatedDate, a.Description, a.IsActive as ApplicationActive, a.Name as ApplicationName, a.URL,
			 b.AGAApplicationType_Id, b.AGAApplicationTypeId, b.Name as ApplicationTypeName, b.IsActive as ApplicationTypeActive, b.UpdatedBy, b.UpdatedDate
			  from MBGSPMainDB.dbo.AGAApplications a inner join MBGSPMainDB.dbo.AGAApplicationType b on a.ApplicationType = b.AGAApplicationType_Id
			where a.IsActive = @_isActive
			ORDER BY AGAApplication_Id desc
		END
END


GO
/****** Object:  StoredProcedure [dbo].[AGAApplicationTypeProcedure]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AGAApplicationTypeProcedure]

@_AGAApplicationType_Id int,
@_actionType int,
@_name varchar(max),
@_UpdatedBy varchar(max),
@_isActive int,
@_searchKeyword varchar(max)

AS

BEGIN
	--INSERT ALL
	If @_actionType = 0
		Begin
			Insert into MBGSPMainDB.dbo.AGAApplicationType
			(
				Name,
				UpdatedBy,
				UpdatedDate,
				IsActive
			)
			values
			(
				@_name,
				@_UpdatedBy,
				(select getdate()),
				1
			)
		End
	--UPDATE
	If @_actionType = 2
		BEGIN
			Update MBGSPMainDB.dbo.AGAApplicationType
			set Name = @_name
			where AGAApplicationType_Id = @_AGAApplicationType_Id
		END
	--VIEW
	If @_actionType = 3
		BEGIN
			Select * from MBGSPMainDB.dbo.AGAApplicationType
			ORDER BY AGAApplicationType_Id desc
		END
	--SEARCH
	If @_actionType = 4
		BEGIN
			Select * from MBGSPMainDB.dbo.AGAApplicationType
			where Name LIKE '%' + @_searchKeyword + '%' 
		END
	If @_actionType = 5
		BEGIN
			Select * from MBGSPMainDB.dbo.AGAApplicationType
			where AGAApplicationType_Id = @_AGAApplicationType_Id
		END
	If @_actionType = 6
		BEGIN
			Update MBGSPMainDB.dbo.AGAApplicationType
			set IsActive = @_isActive
			where AGAApplicationType_Id = @_AGAApplicationType_Id
		END
	If @_actionType = 7
		BEGIN
			Select * from MBGSPMainDB.dbo.AGAApplicationType
			where IsActive = @_isActive
		END
END
GO
/****** Object:  StoredProcedure [dbo].[AGAUsersProcedure]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AGAUsersProcedure]

--AGAUser_Id int IDENTITY(1,1) NOT NULL,
--	AGAUserId AS (concat('AGAUser-',AGAUser_Id)) PERSISTED NOT NULL,
--	AGAApplication_Id int,
--	UpdatedBy varchar(max),
--	UpdatedDate datetime
-- EmployeeId

@_AGAUser_Id int,
@_actionType int,
@_AGAApplication_Id int,
@_UpdatedBy varchar(max),
@_EmployeeId varchar(max)

AS

BEGIN
	--INSERT ALL
	If @_actionType = 0
		Begin
			Insert into MBGSPMainDB.dbo.AGAUsers 
			(
				EmployeeId,
				UpdatedBy,
				UpdatedDate,
				AGAApplication_Id
			)
			values
			(
				@_EmployeeId,
				@_UpdatedBy,
				(select getdate()),
				@_AGAApplication_Id
			)
		End
	--VIEW
	If @_actionType = 1
		BEGIN
			Select a.AGAApplication_Id, a.AGAApplicationId, a.ApplicationType, a.CreatedBy, a.CreatedDate, a.Description, a.IsActive as ApplicationActive, a.Name as ApplicationName, a.URL,
			 b.AGAApplicationType_Id, b.AGAApplicationTypeId, b.Name as ApplicationTypeName, b.IsActive as ApplicationTypeActive, b.UpdatedBy, b.UpdatedDate, c.AGAApplication_Id, c.AGAUser_Id, c.AGAUserId, c.EmployeeId, c.UpdatedBy, c.UpdatedDate
			  from MBGSPMainDB.dbo.AGAApplications a inner join MBGSPMainDB.dbo.AGAApplicationType b on a.ApplicationType = b.AGAApplicationType_Id inner join MBGSPMainDB.dbo.AGAUsers c on a.AGAApplication_Id = c.AGAApplication_Id
			  WHERE EmployeeId = @_EmployeeId
		END
	--DELETE
	If @_actionType = 2
		BEGIN
			DELETE MBGSPMainDB.dbo.AGAUsers
			WHERE AGAUser_Id = @_AGAUser_Id
		END
	If @_actionType = 3
		BEGIN
			select
                    dbo.CommonEmployeesActive.Employee_ID,
                    dbo.CommonEmployeesActive.FirstName,
                    dbo.CommonEmployeesActive.LastName,
                    dbo.CommonEmployeesActive.MiddleName,
                    dbo.CommonEmployeesActive.Department,
                    dbo.CommonEmployeesActive.UserID, 
                    dbo.CommonUserRoles.Roles,
                    dbo.CommonUserRoles.User_id,
                    dbo.SRRoles.rolename,
					STUFF((SELECT ', ' + CONCAT('APP-', CAST(b.AGAApplication_Id AS varchar)) from [MBGSPMainDB].[dbo].[AGAApplications] a left join 
					[MBGSPMainDB].[dbo].[AGAUsers] b on a.AGAApplication_Id = b.AGAApplication_Id
					where b.EmployeeId = dbo.CommonEmployeesActive.Employee_ID
					FOR XML PATH('')), 1, 1, '') [AppAccessGrants]

                from
	            dbo.CommonEmployeesActive left join dbo.CommonUserRoles 
	            on 
	            dbo.CommonEmployeesActive.UserId = dbo.CommonUserRoles.Username
	            left join dbo.CommonPreference
	            on
	            dbo.CommonEmployeesActive.UserID = dbo.CommonPreference.username
                left join dbo.SRRoles
                on 
                dbo.CommonUserRoles.Roles = dbo.SRRoles.seatrrolesid
		END
	If @_actionType = 4
		BEGIN
			select
                    dbo.CommonEmployeesActive.Employee_ID,
                    dbo.CommonEmployeesActive.FirstName,
                    dbo.CommonEmployeesActive.LastName,
                    dbo.CommonEmployeesActive.MiddleName,
                    dbo.CommonEmployeesActive.Department,
                    dbo.CommonEmployeesActive.UserID, 
                    dbo.CommonUserRoles.Roles,
                    dbo.CommonUserRoles.User_id,
                    dbo.SRRoles.rolename,
					STUFF((SELECT ', ' + CONCAT('APP-', CAST(b.AGAApplication_Id AS varchar)) from [MBGSPMainDB].[dbo].[AGAApplications] a left join 
					[MBGSPMainDB].[dbo].[AGAUsers] b on a.AGAApplication_Id = b.AGAApplication_Id
					where b.EmployeeId = dbo.CommonEmployeesActive.Employee_ID
					FOR XML PATH('')), 1, 1, '') [AppAccessGrants]

                from
	            dbo.CommonEmployeesActive left join dbo.CommonUserRoles 
	            on 
	            dbo.CommonEmployeesActive.UserId = dbo.CommonUserRoles.Username
	            left join dbo.CommonPreference
	            on
	            dbo.CommonEmployeesActive.UserID = dbo.CommonPreference.username
                left join dbo.SRRoles
                on 
                dbo.CommonUserRoles.Roles = dbo.SRRoles.seatrrolesid
				where dbo.CommonEmployeesActive.Employee_ID = @_EmployeeId
		END

		If @_actionType = 5
		BEGIN
			select
                    dbo.CommonEmployeesActive.Employee_ID,
                    dbo.CommonEmployeesActive.FirstName,
                    dbo.CommonEmployeesActive.LastName,
                    dbo.CommonEmployeesActive.MiddleName,
                    dbo.CommonEmployeesActive.Department,
                    dbo.CommonEmployeesActive.UserID, 
                    dbo.CommonUserRoles.Roles,
                    dbo.CommonUserRoles.User_id,
                    dbo.SRRoles.rolename,
					STUFF((SELECT ', ' + CONCAT('APP-', CAST(b.AGAApplication_Id AS varchar)) from [MBGSPMainDB].[dbo].[AGAApplications] a left join 
					[MBGSPMainDB].[dbo].[AGAUsers] b on a.AGAApplication_Id = b.AGAApplication_Id
					where b.EmployeeId = dbo.CommonEmployeesActive.Employee_ID
					FOR XML PATH('')), 1, 1, '') [AppAccessGrants]

                from
	            dbo.CommonEmployeesActive left join dbo.CommonUserRoles 
	            on 
	            dbo.CommonEmployeesActive.UserId = dbo.CommonUserRoles.Username
	            left join dbo.CommonPreference
	            on
	            dbo.CommonEmployeesActive.UserID = dbo.CommonPreference.username
                left join dbo.SRRoles
                on 
                dbo.CommonUserRoles.Roles = dbo.SRRoles.seatrrolesid
				where dbo.CommonEmployeesActive.Employee_ID like '%' + @_UpdatedBy + '%' OR  
				dbo.CommonEmployeesActive.FirstName like '%' + @_UpdatedBy + '%' OR  
				dbo.CommonEmployeesActive.LastName like '%' + @_UpdatedBy + '%' OR  
				dbo.SRRoles.rolename like '%' + @_UpdatedBy + '%'
		END

END
GO
/****** Object:  StoredProcedure [dbo].[CommonNotificationGetByEmployeeId]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CommonNotificationGetByEmployeeId]  

@EmployeeId varchar(max)

AS
BEGIN

	SELECT TOP 100 [CommonNotification_Id]
      ,[CommonNotificationId]
      ,[Name]
      ,[AppType]
      ,[AppTypeId]
      ,[SystemModification]
      ,[IsActive]
      ,[EmployeeId]
		FROM [MBGSPMainDB].[dbo].[CommonNotification]
		

  where EmployeeId = @EmployeeId
  ORDER BY([SystemModification]) DESC, [IsActive]

END

GO
/****** Object:  StoredProcedure [dbo].[CommonNotificationUpdateStatus]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CommonNotificationUpdateStatus]  

@CommonNotification_Id int,
@IsActive int

AS
BEGIN
	
	UPDATE [MBGSPMainDB].[dbo].[CommonNotification]
	set IsActive = @IsActive
	where CommonNotification_Id = @CommonNotification_Id

END

GO
/****** Object:  StoredProcedure [dbo].[SPPACreatePolicy]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreatePolicy]  

@PolicyName [varchar](200) NULL,
@PolicyDescription [varchar](MAX) NULL,
@Questionnaire_Id [int] NULL,
@VersionControl varchar(100),
@CreatedBy [varchar](100) NULL

AS

BEGIN

	Insert into MBGSPMainDB.dbo.PAPolicy 
		(
			PolicyName,
			PolicyDescription,
			Questionnaire_Id,
			VersionControl,
			CreatedDate,
			CreatedBy,
			SysModificationDate, 
			IsActive
		)
	values
		(
			@PolicyName,
			@PolicyDescription,
			@Questionnaire_Id,
			@VersionControl,
			(select getdate()),
			@CreatedBy,
			(select getdate()),
			1
		)

	SELECT TOP 1 Policy_Id from MBGSPMainDB.dbo.PAPolicy 
	ORDER BY (Policy_Id) DESC

END

GO
/****** Object:  StoredProcedure [dbo].[SPPACreatePolicyByUser]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreatePolicyByUser]  

@EmployeeId varchar(max),
@Policy_Id int,
@Due_Date datetime

AS
BEGIN

	INSERT INTO dbo.PAPolicyByUser(Policy_Id,Employee_Id,Due_Date,IsStatus,SysModificationDate)
	values(@Policy_Id,@EmployeeId,@Due_Date, 1, (SELECT GETDATE()))
END

GO
/****** Object:  StoredProcedure [dbo].[SPPACreateQuestionnaire]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreateQuestionnaire]  

@Questionnaire_Id int,
@Module_Type int,
@UpdatedBy varchar(100)

AS

BEGIN
		Insert into MBGSPMainDB.dbo.QMQuestionnaire 
		(
			Module_Type,
			CreatedBy,
			CreatedDate
		)
		values
		(
			@Module_Type,
			@UpdatedBy,
			(select getdate())
		)

	SELECT TOP 1 Questionnaire_Id from MBGSPMainDB.dbo.QMQuestionnaire 
    ORDER BY (Questionnaire_Id) DESC
END

--exec SPPAUpdateQuestionnnaire 
--@Questionnaire_Id = 1,
--@Module_Type = 2,
--@UpdatedBy = 'llumapa'
--select * from QMQuestionnaire
--select GETDATE()

--exec SPPACreateQuestionnaire 
--@Module_Type = 1,
--@CreatedBy = 'llumapa'

--select * from QMQuestionnaire
--select GETDATE()

GO
/****** Object:  StoredProcedure [dbo].[SPPACreateRemoveAttachments]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreateRemoveAttachments]  

@PolicyId int,
@PAPolicyType int,
@PAAttachmentName varchar(500) NULL,
@PAAttachmentURL varchar(max) NULL,
@ActionType varchar(20) NULL


AS

BEGIN

    If @ActionType = 'Insert'
        Begin
            Insert into MBGSPMainDB.dbo.PAAttachments 
            (
                Policy_Id,
                PAPolicyType,
				PAAttachmentName,
                PAAttachmentURL,
                CreatedDate
            )
            values
            (
                @PolicyId,
                @PAPolicyType,
				@PAAttachmentName,
                @PAAttachmentURL,
                (select getdate())
            )
        End
    If @ActionType = 'Delete'
        Begin
            Delete from MBGSPMainDB.dbo.PAAttachments
                where Policy_Id = @PolicyId
        End

END

GO
/****** Object:  StoredProcedure [dbo].[SPPACreateRemoveJobLevel]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreateRemoveJobLevel]  

@PolicyId int,
@JobLevelId varchar(5) NULL,
@ActionType varchar(20) NULL

AS

BEGIN
	
	If @ActionType = 'Insert'
		Begin
			Insert into MBGSPMainDB.dbo.PAPolicyByJobLevel 
			(
				Policy_Id,
				JobLevelId,
				SysModificationDate
			)
			values
			(
				@PolicyId,
				@JobLevelId,
				(select getdate())
			)
		End
	If @ActionType = 'Delete'
		Begin
			Delete from MBGSPMainDB.dbo.PAPolicyByJobLevel
				where Policy_Id = @PolicyId
		End

END

--TEST
--Select * from PAPolicyByJobLevel


GO
/****** Object:  StoredProcedure [dbo].[SPPACreateUpdateAttachments]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreateUpdateAttachments]  

@PAAttachments_Id int,
@PolicyId int,
@PAPolicyType int,
@PAAttachmentURL [varchar](500) NULL,
@ActionType varchar(20) NULL

AS

BEGIN
	
	If @ActionType = 'Insert'
		Begin
			Insert into MBGSPMainDB.dbo.PAAttachments 
			(
				Policy_Id,
				PAPolicyType,
				PAAttachmentURL,
				CreatedDate
			)
			values
			(
				@PolicyId,
				@PAPolicyType,
				@PAAttachmentURL,
				(select getdate())
			)
		End
	If @ActionType = 'Update'
		Begin
			Update MBGSPMainDB.dbo.PAAttachments
				set PAPolicyType	= @PAPolicyType
			   ,PAAttachmentURL		= @PAAttachmentURL
			   ,Policy_Id			= @PolicyId
				where PAAttachments_Id = @PAAttachments_Id
		End

END

--TEST
--Select * from PAAttachments


GO
/****** Object:  StoredProcedure [dbo].[SPPACreateUpdateJobLevel]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPACreateUpdateJobLevel]  

@PAPolicyByJobLevel_Id int,
@PolicyId int,
@JobLevelId int,
@ActionType varchar(20) NULL

AS

BEGIN
	
	If @ActionType = 'Insert'
		Begin
			Insert into MBGSPMainDB.dbo.PAPolicyByJobLevel 
			(
				Policy_Id,
				JobLevelId,
				SysModificationDate
			)
			values
			(
				@PolicyId,
				@JobLevelId,
				(select getdate())
			)
		End
	If @ActionType = 'Update'
		Begin
			Update MBGSPMainDB.dbo.PAPolicyByJobLevel
				set Policy_Id		= @PolicyId
			   ,JobLevelId			= @JobLevelId
			   ,SysModificationDate	= @PolicyId
				where PAPolicyByJobLevel_Id = @PAPolicyByJobLevel_Id
		End

END

--TEST
--Select * from PAPolicyByJobLevel


GO
/****** Object:  StoredProcedure [dbo].[SPPAGetAttachmentsByPolicyId]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetAttachmentsByPolicyId]

@PolicyId int

AS

BEGIN
		Select * from PAAttachments
		where Policy_Id = @PolicyId
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetCountOfQuestionCorrectAnswer]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetCountOfQuestionCorrectAnswer]

@Question_Id int

AS

BEGIN
        Select COUNT (*) as [Count] from QMQuestionCorrectAnswer 
        where QMQuestionCorrectAnswer.Question_Id = @Question_Id
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetJobLevelByPolicyId]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetJobLevelByPolicyId]

@PolicyId int

AS

BEGIN
		Select * from PAPolicyByJobLevel
		where Policy_Id = @PolicyId
END


GO
/****** Object:  StoredProcedure [dbo].[SPPAGetJobLevelPositions]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetJobLevelPositions]  

AS

BEGIN

SELECT [PositionId]
      ,[PositionCode]
      ,[PositionName]
      ,[Description]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[DeleteFlag]
  FROM [MBGSPMainDB].[dbo].[CommonPosition]
	where DeleteFlag <> 1 and PositionId <> 1
END

exec SPPAGetJobLevelPositions
--select getdate()

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPoliciesAcknowledgement]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPoliciesAcknowledgement]  

@EmployeeId varchar(max),
@PolicyId int,
@PAPolicyByUser_Id int

AS
BEGIN
		IF (@EmployeeId != 0) AND (@PolicyId = 0) AND (@PAPolicyByUser_Id = 0)
		BEGIN
			SELECT 
			   a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,b.[PolicyName]
			  ,a.[IsStatus] as IsStatusUser
			  ,b.[VersionControl]
			  ,CONCAT(c.LastName,', ',c.FirstName) as FullName
			  ,a.[AcknowledgeForm]
	
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Employee_Id = @EmployeeId
		END

		IF (@EmployeeId = 0) AND (@PolicyId = 0) AND (@PAPolicyByUser_Id = 0)
		BEGIN
				SELECT 
			   a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,b.[PolicyName]
			  ,a.[IsStatus] as IsStatusUser
			  ,b.[VersionControl]
			  ,CONCAT(c.LastName,', ',c.FirstName) as FullName
			  ,a.[AcknowledgeForm]

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
		END

		IF (@EmployeeId != 0 AND @PolicyId != 0) AND (@PAPolicyByUser_Id = 0)
		BEGIN
				SELECT 
			   a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,b.[PolicyName]
			  ,a.[IsStatus] as IsStatusUser
			  ,b.[VersionControl]
			  ,CONCAT(c.LastName,', ',c.FirstName) as FullName
			  ,a.[AcknowledgeForm]

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Employee_Id = @EmployeeId and a.Policy_Id = @PolicyId
		END

		IF (@EmployeeId = 0 AND @PolicyId != 0) AND (@PAPolicyByUser_Id = 0)
		BEGIN
			SELECT 
			   a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,b.[PolicyName]
			  ,a.[IsStatus] as IsStatusUser
			  ,b.[VersionControl]
			  ,CONCAT(c.LastName,', ',c.FirstName) as FullName
			  ,a.[AcknowledgeForm]
					
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Policy_Id = @PolicyId
		END

		IF (@EmployeeId = 0 AND @PolicyId = 0) AND (@PAPolicyByUser_Id != 0)
		BEGIN
			SELECT 
			   a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,b.[PolicyName]
			  ,a.[IsStatus] as IsStatusUser
			  ,b.[VersionControl]
			  ,CONCAT(c.LastName,', ',c.FirstName) as FullName
			  ,a.[AcknowledgeForm]
					
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.PAPolicyByUser_Id = @PAPolicyByUser_Id
		END
	
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPoliciesByUser]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPoliciesByUser]  

@EmployeeId varchar(max),
@PageNumber int,
@RowsOfPage int
AS
BEGIN

		SELECT a.[PAPolicyByUser_Id]
			  ,a.[PAPolicyByUserId]
			  ,a.[Policy_Id]
			  ,a.[Employee_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,a.[DateCompleted]
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[PolicyDescription]
			  ,b.[VersionControl]
			  ,b.[Questionnaire_Id]
			  ,b.[CreatedDate]
			  ,b.[CreatedBy]
			  ,b.[UpdatedBy]
			  ,b.[PublishedBy]
			  ,b.[PublishedDate]
			  ,b.[SysModificationDate] as SysModificationDateByPolicy
			  ,b.[IsActive] as IsActivePolicy
			  ,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
			  [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
			  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = b.Policy_Id
			  FOR XML PATH('')), 1, 1, '') [JobLevel]
			  ,(SELECT COUNT (*) from [MBGSPMainDB].[dbo].[PAPolicyByUser] where [MBGSPMainDB].[dbo].[PAPolicyByUser].Employee_Id = @EmployeeId and ([MBGSPMainDB].[dbo].[PAPolicyByUser].IsStatus = 1 OR [MBGSPMainDB].[dbo].[PAPolicyByUser].IsStatus = 2 OR [MBGSPMainDB].[dbo].[PAPolicyByUser].IsStatus = 4)) as TotalCountPolicyByUser

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  where a.Employee_Id = @EmployeeId and (a.IsStatus = 0 OR a.IsStatus = 1 OR a.IsStatus = 2)
			  ORDER BY a.IsStatus, a.[PAPolicyByUser_Id] ASC
			  OFFSET (@PageNumber-1)*@RowsOfPage ROWS
			  FETCH NEXT @RowsOfPage ROWS ONLY

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPoliciesByUserById]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPoliciesByUserById]  

@EmployeeId varchar(max),
@PAPolicyByUser_Id int

AS
BEGIN

		SELECT a.[PAPolicyByUser_Id]
			  ,a.[PAPolicyByUserId]
			  ,a.[Policy_Id]
			  ,a.[Employee_Id]
			  ,a.[Due_Date]
			  ,a.[AcknowledgeForm]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,a.[DateCompleted]
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[PolicyDescription]
			  ,b.[VersionControl]
			  ,b.[Questionnaire_Id]
			  ,b.[CreatedDate]
			  ,b.[CreatedBy]
			  ,b.[UpdatedBy]
			  ,b.[PublishedBy]
			  ,b.[PublishedDate]
			  ,b.[SysModificationDate] as SysModificationDateByPolicy
			  ,b.[IsActive] as IsActivePolicy
			  ,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
			  [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
			  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = b.Policy_Id
			  FOR XML PATH('')), 1, 1, '') [JobLevel]
			  ,(SELECT COUNT (*) from [MBGSPMainDB].[dbo].[PAPolicyByUser] where [MBGSPMainDB].[dbo].[PAPolicyByUser].Employee_Id = @EmployeeId) as TotalCountPolicyByUser

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  where a.Employee_Id = @EmployeeId and a.PAPolicyByUser_Id = @PAPolicyByUser_Id 

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPoliciesByUserSearch]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPoliciesByUserSearch]  
@Keyword varchar(max),
@IsStatus int,
@EmployeeId varchar(max),
@PageNumber int,
@RowsOfPage int
AS
BEGIN
		IF @Keyword != '0' AND @IsStatus = 100
		BEGIN
		SELECT a.[PAPolicyByUser_Id]
			  ,a.[PAPolicyByUserId]
			  ,a.[Policy_Id]
			  ,a.[Employee_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,a.[DateCompleted]
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[PolicyDescription]
			  ,b.[VersionControl]
			  ,b.[Questionnaire_Id]
			  ,b.[CreatedDate]
			  ,b.[CreatedBy]
			  ,b.[UpdatedBy]
			  ,b.[PublishedBy]
			  ,b.[PublishedDate]
			  ,b.[SysModificationDate] as SysModificationDateByPolicy
			  ,b.[IsActive] as IsActivePolicy
			  ,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
			  [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
			  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = b.Policy_Id
			  FOR XML PATH('')), 1, 1, '') [JobLevel]
			  ,(SELECT COUNT (*) from [MBGSPMainDB].[dbo].[PAPolicyByUser] a inner join [MBGSPMainDB].[dbo].PAPolicy b on a.Policy_Id = b.Policy_Id  where a.Employee_Id = @EmployeeId and 
			  (b.[PolicyName] LIKE '%' + @Keyword + '%' OR b.PolicyDescription LIKE '%' + @Keyword + '%' OR b.VersionControl LIKE '%' + @Keyword + '%')) as TotalCountPolicyByUser

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  where a.Employee_Id = @EmployeeId and 
			  (b.[PolicyName] LIKE '%' + @Keyword + '%' OR b.PolicyDescription LIKE '%' + @Keyword + '%' OR b.VersionControl LIKE '%' + @Keyword + '%')
			  ORDER BY a.[PAPolicyByUser_Id]
			  OFFSET (@PageNumber-1)*@RowsOfPage ROWS
			  FETCH NEXT @RowsOfPage ROWS ONLY
		END

		IF @Keyword = '0' AND @IsStatus != 100
		BEGIN
		SELECT a.[PAPolicyByUser_Id]
			  ,a.[PAPolicyByUserId]
			  ,a.[Policy_Id]
			  ,a.[Employee_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,a.[DateCompleted]
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[PolicyDescription]
			  ,b.[VersionControl]
			  ,b.[Questionnaire_Id]
			  ,b.[CreatedDate]
			  ,b.[CreatedBy]
			  ,b.[UpdatedBy]
			  ,b.[PublishedBy]
			  ,b.[PublishedDate]
			  ,b.[SysModificationDate] as SysModificationDateByPolicy
			  ,b.[IsActive] as IsActivePolicy
			  ,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
			  [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
			  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = b.Policy_Id
			  FOR XML PATH('')), 1, 1, '') [JobLevel]
			  ,(SELECT COUNT (*) from [MBGSPMainDB].[dbo].[PAPolicyByUser] a inner join [MBGSPMainDB].[dbo].PAPolicy b on a.Policy_Id = b.Policy_Id  where a.Employee_Id = @EmployeeId and a.IsStatus = @IsStatus) as TotalCountPolicyByUser

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  where a.Employee_Id = @EmployeeId and a.IsStatus = @IsStatus
			  ORDER BY a.[PAPolicyByUser_Id]
			  OFFSET (@PageNumber-1)*@RowsOfPage ROWS
			  FETCH NEXT @RowsOfPage ROWS ONLY
		END

		IF @Keyword != '0' AND @IsStatus != 100
		BEGIN
		SELECT a.[PAPolicyByUser_Id]
			  ,a.[PAPolicyByUserId]
			  ,a.[Policy_Id]
			  ,a.[Employee_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,a.[DateCompleted]
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[PolicyDescription]
			  ,b.[VersionControl]
			  ,b.[Questionnaire_Id]
			  ,b.[CreatedDate]
			  ,b.[CreatedBy]
			  ,b.[UpdatedBy]
			  ,b.[PublishedBy]
			  ,b.[PublishedDate]
			  ,b.[SysModificationDate] as SysModificationDateByPolicy
			  ,b.[IsActive] as IsActivePolicy
			  ,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
			  [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
			  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = b.Policy_Id
			  FOR XML PATH('')), 1, 1, '') [JobLevel]
			  ,(SELECT COUNT (*) from [MBGSPMainDB].[dbo].[PAPolicyByUser] a inner join [MBGSPMainDB].[dbo].PAPolicy b on a.Policy_Id = b.Policy_Id  where a.Employee_Id = @EmployeeId and a.IsStatus = @IsStatus and
			  (b.[PolicyName] LIKE '%' + @Keyword + '%' OR b.PolicyDescription LIKE '%' + @Keyword + '%' OR b.VersionControl LIKE '%' + @Keyword + '%')) as TotalCountPolicyByUser

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  where a.Employee_Id = @EmployeeId and a.IsStatus = @IsStatus and
			  (b.[PolicyName] LIKE '%' + @Keyword + '%' OR b.PolicyDescription LIKE '%' + @Keyword + '%' OR b.VersionControl LIKE '%' + @Keyword + '%') 
			  ORDER BY a.[PAPolicyByUser_Id]
			  OFFSET (@PageNumber-1)*@RowsOfPage ROWS
			  FETCH NEXT @RowsOfPage ROWS ONLY
		END

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPolicy]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPolicy]  

AS

BEGIN

SELECT  [Policy_Id]
      ,[PolicyId]
      ,[PolicyName]
      ,[PolicyDescription]
      ,[VersionControl]
      ,[Questionnaire_Id]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[UpdatedBy]
	  ,[PublishedBy]
	  ,[PublishedDate]
      ,[SysModificationDate]
      ,[IsActive]
		,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
          [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
		  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = [MBGSPMainDB].[dbo].[PAPolicy].Policy_Id
          FOR XML PATH('')), 1, 1, '') [JobLevel]
  FROM [MBGSPMainDB].[dbo].[PAPolicy] 
  ORDER BY [IsActive] ASC
END


GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPolicyByPolicyId]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPolicyByPolicyId]

@PolicyId int

AS

BEGIN
		Select * from PAPolicy
		where Policy_Id = @PolicyId
END
--


GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPolicyNewHireNewPromoted]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SPPAGetPolicyNewHireNewPromoted]

@Username varchar(max)

as

Begin

	declare @TempPolicy table(Id int identity (1,1),
						      Policy_Id int)
	declare @TempPromotionPolicy table(Id int identity (1,1),
									   Policy_Id int)
	declare @JobLevel varchar(5)
	declare @EmployeeID varchar(max)
	declare @count int
	declare @num int
	declare @TotalRecords int
	
	set @EmployeeID = (Select Employee_ID from CommonEmployeesActive where UserID = @Username)
	set @JobLevel = (Select Job_Level from CommonEmployeesActive where UserID = @Username)

	--Update for Newly Promoted Employee
	If @EmployeeID in
	(Select Employee_Id from dbo.PAPolicyByUser)
		Begin
			Insert into @TempPromotionPolicy (Policy_Id)
			Select b.Policy_Id from (Select a.Policy_Id from dbo.PAPolicy a full join dbo.PAPolicyByJobLevel b on a.Policy_Id = b.Policy_Id 
				Full Join dbo.PAPolicyByUser c on c.Policy_Id = a.Policy_Id
				Full Join dbo.CommonEmployeesActive d on c.Employee_Id = d.Employee_ID
				where b.JobLevelId = @JobLevel and c.Employee_Id = @EmployeeID) a 
				Right Join  
			(Select a.Policy_Id from PAPolicy a full join dbo.PAPolicyByJobLevel b on a.Policy_Id = b.Policy_Id
			where b.JobLevelId = @JobLevel) b on a.Policy_Id = b.Policy_Id where a.Policy_Id IS NULL

			set @TotalRecords = (SELECT COUNT(*) FROM @TempPromotionPolicy)
			set @num = (Select top 1 Id from @TempPromotionPolicy order by Id asc)
			set @count = (Select top 1 Id from @TempPromotionPolicy order by Id desc)

			while (@num <= @count)
			Begin
				INSERT INTO dbo.PAPolicyByUser(Policy_Id,Employee_Id, Due_Date, IsStatus,SysModificationDate, Bit_Email, BitEmailDate)
				Select a.Policy_Id, @EmployeeID, (SELECT DATEADD(DAY, 15, (SELECT GETDATE()))), 1, (SELECT GETDATE()), 1, 
				(Select Convert (Date,(select convert(varchar, getdate(), 23))))
				from @TempPromotionPolicy a
				where a.Id = @num

				INSERT INTO dbo.CommonNotification(EmployeeId, Name,AppType, AppTypeId, SystemModification, IsActive)
				select @EmployeeID, CONCAT('You have pending policy in your policy list. Please click this notification to access your policy list or visit the MBGSP portal directly. Policy-', a.Policy_Id), 
				1, a.Policy_Id,(SELECT GETDATE()), 1 from @TempPromotionPolicy a
				where a.Id = @num

				set @num = @num+1
			end

			if @TotalRecords > 0
			Begin 
				select distinct b.Policy_Id, a.Employee_ID, a.Email_Address, c.PolicyName, c.VersionControl, CONCAT(a.FirstName, ' ', a.LastName) as FullName,
				(select convert(varchar, d.Due_Date, 107)) as Due_Date
				from dbo.CommonEmployeesActive a inner join dbo.PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId inner join dbo.PAPolicy c on b.Policy_Id = c.Policy_Id
				inner join dbo.PAPolicyByUser d on c.Policy_Id = d.Policy_Id
				where a.UserID = @Username and a.DeleteFlag <> 1 and b.Policy_Id in (Select Policy_Id from @TempPromotionPolicy)

				--select distinct b.Policy_Id, a.Employee_ID, a.Email_Address, c.PolicyName, c.VersionControl, CONCAT(a.FirstName, ' ', a.LastName) as FullName,
				--(select convert(varchar, d.Due_Date, 107)) as Due_Date
				--from dbo.CommonEmployeesActive a inner join dbo.PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId inner join dbo.PAPolicy c on b.Policy_Id = c.Policy_Id
				--inner join dbo.PAPolicyByUser d on c.Policy_Id = d.Policy_Id
				--where a.UserID = 'llumapa' and a.DeleteFlag <> 1 and b.Policy_Id = 1
			End
		End

	--Update for New Hire Employee
	If @Username in
	(Select a.UserID from dbo.CommonEmployeesActive a full join dbo.PAPolicyByUser b on a.Employee_ID = b.Employee_Id
	where b.Employee_Id IS NULL and a.Deleteflag = 0)
		Begin
			Insert into @TempPolicy (Policy_Id)
			Select a.Policy_Id from dbo.PAPolicy a full join dbo.PAPolicyByJobLevel b on a.Policy_Id = b.Policy_Id 
			where b.JobLevelId = @JobLevel

			set @num = (Select top 1 Id from @TempPolicy order by Id asc)
			set @count = (Select top 1 Id from @TempPolicy order by Id desc)

			while (@num <= @count)
			Begin
				INSERT INTO dbo.PAPolicyByUser(Policy_Id,Employee_Id, Due_Date, IsStatus,SysModificationDate, Bit_Email, BitEmailDate)
				Select a.Policy_Id, @EmployeeID, (SELECT DATEADD(DAY, 15, (SELECT GETDATE()))), 1, (SELECT GETDATE()), 1, 
				(Select Convert (Date,(select convert(varchar, getdate(), 23)))) from @TempPolicy a
				where a.Id = @num

				INSERT INTO dbo.CommonNotification(EmployeeId, Name,AppType, AppTypeId, SystemModification, IsActive)
				select @EmployeeID, CONCAT('You have pending policy in your policy list. Please click this notification to access your policy list or visit the MBGSP portal directly. Policy-', a.Policy_Id), 
				1, a.Policy_Id,(SELECT GETDATE()), 1 from @TempPolicy a
				where a.Id = @num

				set @num = @num+1

			end

			select distinct b.Policy_Id, a.Employee_ID, a.Email_Address, c.PolicyName, c.VersionControl, CONCAT(a.FirstName, ' ', a.LastName) as FullName,
			(select convert(varchar, d.Due_Date, 107)) as Due_Date 
			from dbo.CommonEmployeesActive a inner join dbo.PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId inner join PAPolicy c on b.Policy_Id = c.Policy_Id
			inner join dbo.PAPolicyByUser d on c.Policy_Id = d.Policy_Id
			where a.UserID = @Username and a.DeleteFlag <> 1 and b.Policy_Id in (Select Policy_Id from @TempPolicy)
		End
End


GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPolicyPublished]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetPolicyPublished]  

AS

BEGIN

SELECT  [Policy_Id]
      ,[PolicyId]
      ,[PolicyName]
      ,[PolicyDescription]
      ,[VersionControl]
      ,[Questionnaire_Id]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[UpdatedBy]
	  ,[PublishedBy]
	  ,[PublishedDate]
      ,[SysModificationDate]
      ,[IsActive]
		,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
          [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
		  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = [MBGSPMainDB].[dbo].[PAPolicy].Policy_Id
          FOR XML PATH('')), 1, 1, '') [JobLevel]
  FROM [MBGSPMainDB].[dbo].[PAPolicy] 
	where [MBGSPMainDB].[dbo].[PAPolicy].IsActive = 2 OR [MBGSPMainDB].[dbo].[PAPolicy].IsActive = 4 
END


GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPolicyReminder]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SPPAGetPolicyReminder]

@Username varchar(max)

as

Begin

	declare @TempPAPolicyByUser table(Id int identity (1,1),
									Policy_id int, 
									Employee_id varchar(max),
									Due_Date datetime,
									Bit_Email varchar(max),
									BitEmailDate varchar(max),
									CreationDate varchar(max)
									)
	declare @TempFinalPAPolicyByUser table(Id int identity (1,1),
									Policy_id int, 
									Employee_id varchar(max),
									Due_Date datetime,
									Bit_Email varchar(max),
									BitEmailDate varchar(max),
									CreationDate varchar(max)
									)

	declare @JobLevel varchar(5)
	declare @EmployeeID varchar(max)
	declare @count int
	declare @num int
	declare @TotalRecords int
	declare @5thDay_DueDate varchar(max)
	declare @8thDay_DueDate varchar(max)
	declare @11thDay_DueDate varchar(max)
	declare @Due_Date varchar(max)
	declare @TodaysDate varchar(max)
	declare @Bit_Email varchar(5)
	declare @BitEmailDate varchar(max)
	
	set @EmployeeID = (Select Employee_ID from CommonEmployeesActive where UserID = @Username)
	set @JobLevel = (Select Job_Level from CommonEmployeesActive where UserID = @Username)

	If @EmployeeID in
	(Select Employee_Id from dbo.PAPolicyByUser)
		Begin
			Insert into @TempPAPolicyByUser (Policy_id, Employee_id, Due_Date, Bit_Email, BitEmailDate, CreationDate)
			Select Policy_Id, Employee_Id, (select convert(varchar, Due_Date, 23)) as [Due_Date], Bit_Email, 
			(Select Convert (Date,(select convert(varchar, BitEmailDate, 23))) as [BitEmailDate]), 
			(Select Convert (Date,(select convert(varchar, SysModificationDate, 23))) as [SysModificationDate])
			 from PAPolicyByUser 
			where DateCompleted IS NULL and Employee_Id = @EmployeeID 

			set @num = (Select top 1 Id from @TempPAPolicyByUser order by Id asc)
			set @count = (Select top 1 Id from @TempPAPolicyByUser order by Id desc)

			while (@num <= @count)
			Begin
				set @5thDay_DueDate = (Select Convert (Date,(SELECT DATEADD(DAY,5, ((select convert(varchar, CreationDate, 23)))))) as [CreationDate]
										from @TempPAPolicyByUser where Id = @num)
				set @8thDay_DueDate = (Select Convert (Date,(SELECT DATEADD(DAY,8, ((select convert(varchar, CreationDate, 23)))))) as [CreationDate]
										from @TempPAPolicyByUser where Id = @num)
				set @11thDay_DueDate = (Select Convert (Date,(SELECT DATEADD(DAY,11, ((select convert(varchar, CreationDate, 23)))))) as [CreationDate]
										from @TempPAPolicyByUser where Id = @num)
				set @Due_Date = (Select Convert (Date,(select convert(varchar, Due_Date, 23))) as [DueDate]
										from @TempPAPolicyByUser where Id = @num)
				set @TodaysDate =(Select Convert (Date,(select convert(varchar, getdate(), 23))) as [TodaysDate])
				set @Bit_Email = (Select Bit_Email from @TempPAPolicyByUser where Id = @num)
				set @BitEmailDate = (Select Convert (Date,(select convert(varchar, BitEmailDate, 23))) as [BitEmailDate]
										from @TempPAPolicyByUser where Id = @num)
				
				if @TodaysDate = @5thDay_DueDate or @TodaysDate = @8thDay_DueDate or @TodaysDate = @11thDay_DueDate or @TodaysDate = @Due_Date
				   or @TodaysDate > @Due_Date
				Begin
					If @TodaysDate > @Due_Date
					Begin
						Update a
						set a.IsStatus = 0
						from PAPolicyByUser a
						Full Join @TempPAPolicyByUser b on a.Policy_Id = b.Policy_id
						where b.Id = @num and a.Employee_Id = @EmployeeID
					End

					If @Bit_Email = 1 and @BitEmailDate < @TodaysDate
					Begin
						Update a
						set a.Bit_Email = 1, a.BitEmailDate = @TodaysDate
						from PAPolicyByUser a
						Full Join @TempPAPolicyByUser b on a.Policy_Id = b.Policy_id
						where b.Id = @num and a.Employee_Id = @EmployeeID

						INSERT INTO dbo.CommonNotification(EmployeeId, Name,AppType, AppTypeId, SystemModification, IsActive)
						select @EmployeeID, CONCAT('You have pending policy in your policy list. Please click this notification to access your policy list or visit the MBGSP portal directly. Policy-', a.Policy_Id), 
						1, a.Policy_Id,(SELECT GETDATE()), 1 from @TempPAPolicyByUser a
						where a.Id = @num

						Insert into @TempFinalPAPolicyByUser (Policy_id, Employee_id, Due_Date, Bit_Email, BitEmailDate, CreationDate)
						Select a.Policy_id, a.Employee_id, a.Due_Date, b.Bit_Email, 
						(Select Convert (Date,(select convert(varchar, b.BitEmailDate, 23)))), a.CreationDate
						from @TempPAPolicyByUser a
						Full Join PAPolicyByUser b on a.Policy_Id = b.Policy_Id
						where Id = @num and b.Employee_Id = @EmployeeID
					End
				End
				set @num = @num+1
			End
				select b.Policy_Id, a.Employee_ID, a.Email_Address, c.PolicyName, c.VersionControl, CONCAT(a.FirstName, ' ', a.LastName) as FullName, 
				(select convert(varchar, d.Due_Date, 107)) as Due_Date
				from dbo.CommonEmployeesActive a inner join dbo.PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId inner join PAPolicy c on b.Policy_Id = c.Policy_Id
				inner join @TempPAPolicyByUser d on b.Policy_Id = d.Policy_id
				where a.UserID = @Username and a.DeleteFlag <> 1 and b.Policy_Id in (Select Policy_Id from @TempFinalPAPolicyByUser)
		End
End
GO
/****** Object:  StoredProcedure [dbo].[SPPAGetQuestionnaireTotalScore]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetQuestionnaireTotalScore]  

@Questionnaire_Id int

AS
BEGIN
	Select SUM(Score) as TotalScore from QMQuestion
        where Questionnaire_Id = @Questionnaire_Id

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetQuestionsOfPolicyByQuestionnaireId]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetQuestionsOfPolicyByQuestionnaireId]  

@Questionnaire_Id int

AS
BEGIN

		SELECT TOP 5 [Question_Id]
      ,[QuestionId]
      ,[Question_Title]
      ,[Question_Text]
      ,[QuestionType_Id]
      ,[Questionnaire_Id]
      ,[Score]
      ,[ChoiceA]
      ,[ChoiceB]
      ,[ChoiceC]
      ,[ChoiceD]
      ,[ChoiceE]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[UpdatedBy]
      ,[SysModificationDate]
      ,[IsActive]
  FROM [MBGSPMainDB].[dbo].[QMQuestion]
  where Questionnaire_Id = @Questionnaire_Id

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetReports]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetReports]  

@EmployeeId varchar(max),
@PolicyId int

AS
BEGIN
		IF (@EmployeeId != 0) AND (@PolicyId = 0)
		BEGIN
			SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname
	
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Employee_Id = @EmployeeId
		END

			IF (@EmployeeId = 0) AND (@PolicyId = 0)
		BEGIN
				SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
		END

		IF (@EmployeeId != 0 AND @PolicyId != 0)
		BEGIN
				SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Employee_Id = @EmployeeId and a.Policy_Id = @PolicyId
		END

			IF (@EmployeeId = 0 AND @PolicyId != 0)
		BEGIN
			SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[PAPolicyByUser_Id]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname

					
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Policy_Id = @PolicyId
		END
	
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetReportsByTeam]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetReportsByTeam]  

@EmployeeId varchar(max),
@PolicyId int,
@ManagerUserId varchar(max)

AS
BEGIN
		IF (@EmployeeId != 0) AND (@PolicyId = 0)
		BEGIN
			SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname
	
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Employee_Id = @EmployeeId and (d.FirstApproverUsername = @ManagerUserId OR d.SecondApproverUsername = @ManagerUserId OR c.Direct_SuperiorID = @ManagerUserId) 
		END

			IF (@EmployeeId = 0) AND (@PolicyId = 0)
		BEGIN
				SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where d.FirstApproverUsername = @ManagerUserId OR d.SecondApproverUsername = @ManagerUserId OR c.Direct_SuperiorID = @ManagerUserId 

		END

		IF (@EmployeeId != 0 AND @PolicyId != 0)
		BEGIN
				SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname

			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Employee_Id = @EmployeeId and a.Policy_Id = @PolicyId and (d.FirstApproverUsername = @ManagerUserId OR d.SecondApproverUsername = @ManagerUserId OR c.Direct_SuperiorID = @ManagerUserId) 
		END

			IF (@EmployeeId = 0 AND @PolicyId != 0)
		BEGIN
			SELECT 
			   b.[PolicyId]
			  ,a.[Employee_Id]
			  ,a.[DateCompleted]
			  ,a.[Due_Date]
			  ,a.[IsStatus] as IsStatusUser
			  ,a.[SysModificationDate] as SysModificationDateUser
			  ,b.[PolicyId]
			  ,b.[PolicyName]
			  ,b.[VersionControl]
			  ,CONCAT(c.FirstName,' ',c.LastName) as FullName
			  ,c.Department
			  ,d.FirstApproverFullname

					
			  FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
			  on a.Policy_Id = b.Policy_Id
			  left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
			  on a.Employee_Id = c.Employee_ID
			  left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
			  on c.AreaID = d.AreaID
			  where a.Policy_Id = @PolicyId and (d.FirstApproverUsername = @ManagerUserId OR d.SecondApproverUsername = @ManagerUserId OR c.Direct_SuperiorID = @ManagerUserId) 
		END
	
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetReportsTop]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetReportsTop]  
@PolicyId int

AS
BEGIN
		
		SELECT TOP 10
		b.[PolicyId]
		,a.[Employee_Id]
		,a.[DateCompleted]
		,a.[PAPolicyByUser_Id]
		,a.[Due_Date]
		,a.[IsStatus] as IsStatusUser
		,a.[SysModificationDate] as SysModificationDateUser
		,b.[PolicyId]
		,b.[PolicyName]
		,b.[VersionControl]
		,CONCAT(c.FirstName,' ',c.LastName) as FullName
		,c.Department
		,d.FirstApproverFullname

		FROM [MBGSPMainDB].[dbo].[PAPolicyByUser] a left join [MBGSPMainDB].[dbo].PAPolicy b 
		on a.Policy_Id = b.Policy_Id
		left join [MBGSPMainDB].[dbo].CommonEmployeesActive c
		on a.Employee_Id = c.Employee_ID
		left join [MBGSPMainDB].[dbo].CommonAreaApprovers d
		on c.AreaID = d.AreaID
		where b.Policy_Id = @PolicyId and (a.IsStatus = 3 OR a.IsStatus = 4)
		ORDER BY a.[DateCompleted] ASC
	
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAGetScoreOfQuestion]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAGetScoreOfQuestion]

@Question_Id int,
@QuestionCorrectAnswer varchar(max)

AS

BEGIN
        Select Score from QMQuestion a
		left join QMQuestionCorrectAnswer b
		on a.Question_Id = b.Question_Id
        where  a.Question_Id = @Question_Id and b.QuestionCorrectAnswer = @QuestionCorrectAnswer
END
--
--exec [dbo].[SPPAGetScoreOfQuestion]
--@Question_Id = 24,
--@QuestionCorrectAnswer = 'Rest'


GO
/****** Object:  StoredProcedure [dbo].[SPPAPolicyStatusAcknowledgeOfUser]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAPolicyStatusAcknowledgeOfUser]

@PAPolicyByUser_Id int,
@Policy_Id int,
@AcknowledgeForm varchar(max)

AS

BEGIN
		declare @dueDate datetime = (SELECT TOP 1 [MBGSPMainDB].dbo.PAPolicyByUser.Due_Date from [MBGSPMainDB].dbo.PAPolicyByUser where PAPolicyByUser_Id = @PAPolicyByUser_Id)

		IF @dueDate < (SELECT GETDATE())
			begin
				UPDATE dbo.PAPolicyByUser
				set  IsStatus = 3, DateCompleted = (SELECT GETDATE()), AcknowledgeForm = @AcknowledgeForm
				where PAPolicyByUser_Id = @PAPolicyByUser_Id

				select COUNT(IsStatus) as TopFinisher from dbo.PAPolicyByUser
				where Policy_Id = @Policy_Id and (IsStatus= 3 or IsStatus= 4)
			end
		IF @dueDate > (SELECT GETDATE())
			begin
				UPDATE dbo.PAPolicyByUser
				set  IsStatus = 4, DateCompleted = (SELECT GETDATE()), AcknowledgeForm = @AcknowledgeForm
				where PAPolicyByUser_Id = @PAPolicyByUser_Id

				select COUNT(IsStatus) as TopFinisher from dbo.PAPolicyByUser
				where Policy_Id = @Policy_Id and (IsStatus= 3 or IsStatus= 4)
			end
END

GO
/****** Object:  StoredProcedure [dbo].[SPPAPolicyStatusUpdateOfUser]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAPolicyStatusUpdateOfUser]

@PAPolicyByUser_Id int,
@IsStatus int

AS

BEGIN
		UPDATE dbo.PAPolicyByUser
		set  IsStatus = @IsStatus
		where PAPolicyByUser_Id = @PAPolicyByUser_Id

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAPublishPolicy]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAPublishPolicy]  

@PolicyId int,
@UpdatedBy varchar(100)

AS
BEGIN

		Update MBGSPMainDB.dbo.PAPolicy
		set IsActive = 2, UpdatedBy = @UpdatedBy, SysModificationDate = (SELECT GETDATE()), PublishedBy = @UpdatedBy, PublishedDate = (SELECT GETDATE())
		where Policy_Id = @PolicyId

		INSERT INTO dbo.PAPolicyByUser(Policy_Id,Employee_Id, Due_Date, IsStatus,SysModificationDate, Bit_Email, BitEmailDate)
		select b.Policy_Id, a.Employee_ID, (SELECT DATEADD(DAY, 15, (SELECT GETDATE()))), 1, (SELECT GETDATE()), 1, 
		(Select Convert (Date,(select convert(varchar, getdate(), 23))))
		from CommonEmployeesActive a inner join PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId
		where b.Policy_Id = @PolicyId 

		INSERT INTO dbo.CommonNotification(EmployeeId, Name,AppType, AppTypeId, SystemModification, IsActive)
		select a.Employee_ID, CONCAT('You have pending policy in your policy list. Please click this notification to access your policy list or visit the MBGSP portal directly. Policy-', b.Policy_Id), 1, b.Policy_Id,(SELECT GETDATE()), 1 from CommonEmployeesActive a inner join PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId
		where b.Policy_Id = @PolicyId 

		select distinct b.Policy_Id, a.Employee_ID, a.Email_Address, c.PolicyName, c.VersionControl, CONCAT(a.FirstName, ' ', a.LastName) as FullName,
		(select convert(varchar, d.Due_Date, 107)) as Due_Date
		 from CommonEmployeesActive a inner join PAPolicyByJobLevel b on a.Job_Level = b.JobLevelId inner join PAPolicy c on b.Policy_Id = c.Policy_Id
		 inner join dbo.PAPolicyByUser d on c.Policy_Id = d.Policy_Id
		where b.Policy_Id = @PolicyId
END

GO
/****** Object:  StoredProcedure [dbo].[SPPARemovePolicy]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPARemovePolicy]  

@PolicyId int

AS

BEGIN
	declare @previousIsActiveStatus int = (SELECT TOP 1 [MBGSPMainDB].dbo.PAPolicy.IsActive from [MBGSPMainDB].dbo.PAPolicy where Policy_Id = @PolicyId)

	IF @previousIsActiveStatus  = 1
		begin
			Update MBGSPMainDB.dbo.PAPolicy
			set IsActive	= 3
			where Policy_Id = @PolicyId
		end
	IF @previousIsActiveStatus = 2
		begin
			Update MBGSPMainDB.dbo.PAPolicy
			set IsActive	= 4
			where Policy_Id = @PolicyId
		end

END

--TEST
--exec SPPARemovePolicy
--@PolicyId = 1


GO
/****** Object:  StoredProcedure [dbo].[SPPASearchPolicy]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPASearchPolicy]  

@SearchKeyword varchar(max)

AS

BEGIN
	SELECT  [Policy_Id]
      ,[PolicyId]
      ,[PolicyName]
      ,[PolicyDescription]
      ,[VersionControl]
      ,[Questionnaire_Id]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[UpdatedBy]
	  ,[PublishedBy]
	  ,[PublishedDate]
      ,[SysModificationDate]
      ,[IsActive]
		,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].JobLevelId from
          [MBGSPMainDB].[dbo].[PAPolicyByJobLevel]
		  where [MBGSPMainDB].[dbo].[PAPolicyByJobLevel].Policy_Id = [MBGSPMainDB].[dbo].[PAPolicy].Policy_Id
          FOR XML PATH('')), 1, 1, '') [JobLevel]
  FROM [MBGSPMainDB].[dbo].[PAPolicy] 
	where ( PolicyName like '%' + @SearchKeyword + '%'
				or PolicyDescription like '%' + @SearchKeyword + '%'
				or VersionControl like '%' + @SearchKeyword + '%' )
	ORDER BY [IsActive] ASC

END

GO
/****** Object:  StoredProcedure [dbo].[SPPAUpdatePolicy]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAUpdatePolicy]  

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
		   ,Questionnaire_Id	= @Questionnaire_Id
		   ,VersionControl		= @VersionControl
		   ,UpdatedBy			= @UpdatedBy
		   ,SysModificationDate	= (select getdate())
		where Policy_Id = @PolicyId

END


GO
/****** Object:  StoredProcedure [dbo].[SPPAUpdateQuestionnnaire]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPAUpdateQuestionnnaire]  

@Questionnaire_Id int,
@Module_Type int,
@UpdatedBy varchar(100)

AS

BEGIN

	Update MBGSPMainDB.dbo.QMQuestionnaire
		set Module_Type			= @Module_Type
		   ,UpdatedBy			= @UpdatedBy
		   ,SysModificationDate	= (select getdate())
		where Questionnaire_Id = @Questionnaire_Id

END


GO
/****** Object:  StoredProcedure [dbo].[SPPQMCreateUpdateQuestionCorrectAnswer]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPPQMCreateUpdateQuestionCorrectAnswer]

@Question_Id int NULL,
@QuestionCorrectAnswer varchar(100),
@UpdatedBy varchar(100) NULL,
@ActionType varchar(20) NULL

AS

BEGIN
	
	If @ActionType = 'Insert'
		Begin
			Insert into MBGSPMainDB.dbo.QMQuestionCorrectAnswer 
			(
				Question_Id,
				QuestionCorrectAnswer,
				CreatedBy,
				CreatedDate,
				IsActive
			)
			values
			(
				@Question_Id,
				@QuestionCorrectAnswer,
				@UpdatedBy,
				(select getdate()),
				1
			)
		End
END



GO
/****** Object:  StoredProcedure [dbo].[SPQMCreateQuestionnaire]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMCreateQuestionnaire]  

@Module_Type int,
@UpdatedBy varchar(100)

AS

BEGIN
        Insert into MBGSPMainDB.dbo.QMQuestionnaire 
        (
            Module_Type,
            CreatedBy,
            CreatedDate
        )
        values
        (
            @Module_Type,
            @UpdatedBy,
            (select getdate())
        )

 

    SELECT TOP 1 Questionnaire_Id from MBGSPMainDB.dbo.QMQuestionnaire 
    ORDER BY (Questionnaire_Id) DESC
END

GO
/****** Object:  StoredProcedure [dbo].[SPQMCreateUpdateQuestion]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMCreateUpdateQuestion]

@Question_Id int,
@Question_Title varchar(100),
@Question_Text varchar(1000),
@QuestionType_Id int,
@Questionnaire_Id int NULL,
@Score int,
@ChoiceA varchar(max),
@ChoiceB varchar(max),
@ChoiceC varchar(max),
@ChoiceD varchar(max),
@ChoiceE varchar(max),
@UpdatedBy varchar(100) NULL,
@ActionType varchar(20) NULL
AS

BEGIN

	If @ActionType = 'Insert'
		Begin
			Insert into MBGSPMainDB.dbo.QMQuestion 
			(
				Question_Text,
				Question_Title,
				QuestionType_Id,
				Questionnaire_Id,
				Score,
				ChoiceA,
				ChoiceB,
				ChoiceC,
				ChoiceD,
				ChoiceE,
				CreatedBy,
				CreatedDate,
				IsActive
			)
			values
			(
				@Question_Text,
				@Question_Title,
				@QuestionType_Id,
				@Questionnaire_Id,
				@Score,
				@ChoiceA,
				@ChoiceB,
				@ChoiceC,
				@ChoiceD,
				@ChoiceE,
				@UpdatedBy,
				(select getdate()),
				1
			)
				declare @question_id_generated int
				set  @question_id_generated = SCOPE_IDENTITY()
				

				SELECT @question_id_generated as QID
		End
	If @ActionType = 'Update'
		Begin
			Update MBGSPMainDB.dbo.QMQuestion
				set Question_Text	= @Question_Text
				,Question_Title	= @Question_Title
			   ,Score				= @Score
			   ,UpdatedBy			= @UpdatedBy
			   ,SysModificationDate	= (select getdate())
			   ,IsActive			= 1
				where Question_Id = @Question_Id
		End

END



GO
/****** Object:  StoredProcedure [dbo].[SPQMGetQuestionById]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMGetQuestionById]

@Question_Id int

AS

BEGIN

		SELECT  a.[Question_Id]
			  ,a.[QuestionId]
			  ,a.[Question_Title]
			  ,a.[Question_Text]
			  ,a.[QuestionType_Id]
			  ,a.[Questionnaire_Id]
			  ,a.[Score]
			  ,a.[ChoiceA]
			  ,a.[ChoiceB]
			  ,a.[ChoiceC]
			  ,a.[ChoiceD]
			  ,a.[ChoiceE]
			  ,a.[CreatedDate]
			  ,a.[CreatedBy]
			  ,a.[UpdatedBy]
			  ,a.[SysModificationDate]
			  ,a.[IsActive]
			  ,STUFF((SELECT ', ' + [MBGSPMainDB].[dbo].[QMQuestionCorrectAnswer].QuestionCorrectAnswer from
			  [MBGSPMainDB].[dbo].[QMQuestionCorrectAnswer]
			  where [MBGSPMainDB].[dbo].[QMQuestionCorrectAnswer].Question_Id = a.Question_Id
			  FOR XML PATH('')), 1, 1, '') [QuestionCorrectAnswer]
			FROM [MBGSPMainDB].[dbo].[QMQuestion] a 
			where  a.IsActive = 1 and a.Question_Id = @Question_Id
END
--




GO
/****** Object:  StoredProcedure [dbo].[SPQMGetQuestionCorrectAnswerById]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMGetQuestionCorrectAnswerById]

@QuestionId int

AS

BEGIN
		Select * from QMQuestionCorrectAnswer
		where Question_Id = @QuestionId
END
--




GO
/****** Object:  StoredProcedure [dbo].[SPQMGetQuestionnaire]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMGetQuestionnaire]  

AS

BEGIN

SELECT [Questionnaire_Id]
      ,[QuestionnaireId]
      ,[Module_Type]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[UpdatedBy]
      ,[SysModificationDate]
      ,[IsActive]
  FROM [MBGSPMainDB].[dbo].[QMQuestionnaire]
	where IsActive <> 0
	
END


GO
/****** Object:  StoredProcedure [dbo].[SPQMGetQuestionsById]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMGetQuestionsById]

@Questionnaire_Id int

 
AS

BEGIN
        Select * from QMQuestion a
        where a.Questionnaire_Id = @Questionnaire_Id
END
--

GO
/****** Object:  StoredProcedure [dbo].[SPQMRemoveQuestion]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMRemoveQuestion]  

@Question_Id int

AS


BEGIN

	Update MBGSPMainDB.dbo.QMQuestion
		set IsActive	= 0
		where Question_Id = @Question_Id

END




GO
/****** Object:  StoredProcedure [dbo].[SPQMRemoveQuestionCorrectAnswer]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMRemoveQuestionCorrectAnswer]  

@QuestionCorrectAnswer_Id int

AS


BEGIN

	Update MBGSPMainDB.dbo.QMQuestionCorrectAnswer
		set IsActive	= 0
		where QuestionCorrectAnswer_Id = @QuestionCorrectAnswer_Id

END




GO
/****** Object:  StoredProcedure [dbo].[SPQMSearchQuestion]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMSearchQuestion] 

@SearchKeyword varchar(max)

AS

BEGIN
		Select * from QMQuestion
		where ( Question_Text like @SearchKeyword 
				or Question_Title like @SearchKeyword 
				or Score like @SearchKeyword )

END




GO
/****** Object:  StoredProcedure [dbo].[SPQMSearchQuestionCorrectAnswer]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMSearchQuestionCorrectAnswer] 

@SearchKeyword varchar(max)

AS

BEGIN
		Select * from QMQuestionCorrectAnswer
		where ( Question_Id like @SearchKeyword 
				or QuestionCorrectAnswer like @SearchKeyword)

END




GO
/****** Object:  StoredProcedure [dbo].[SPQMSearchQuestionnaire]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMSearchQuestionnaire]  

@SearchKeyword varchar(max)

AS

BEGIN
		Select * from QMQuestionnaire
		where ( Module_Type like @SearchKeyword)

END

--exec SPQMSearchQuestionnaire 
--@SearchKeyword =2
--Select * from QMQuestionnaire



GO
/****** Object:  StoredProcedure [dbo].[SPQMUpdateQuestionnnaire]    Script Date: 23/08/2023 3:57:20 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPQMUpdateQuestionnnaire]  

@Questionnaire_Id int,
@Module_Type int,
@UpdatedBy varchar(100)

AS

BEGIN

	Update MBGSPMainDB.dbo.QMQuestionnaire
		set Module_Type			= @Module_Type
		   ,UpdatedBy			= @UpdatedBy
		   ,SysModificationDate	= (select getdate())
		where Questionnaire_Id = @Questionnaire_Id

END

GO
