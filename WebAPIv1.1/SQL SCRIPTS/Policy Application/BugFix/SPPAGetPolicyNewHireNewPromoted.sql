
USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPPAGetPolicyNewHireNewPromoted]    Script Date: 8/24/2023 11:57:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPPAGetPolicyNewHireNewPromoted]

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
				where b.JobLevelId = @JobLevel and c.Employee_Id = @EmployeeID and a.IsActive = 2) a 
				Right Join  
			(Select a.Policy_Id from PAPolicy a full join dbo.PAPolicyByJobLevel b on a.Policy_Id = b.Policy_Id
			where b.JobLevelId = @JobLevel and a.IsActive = 2) b on a.Policy_Id = b.Policy_Id where a.Policy_Id IS NULL 

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
			where b.JobLevelId = @JobLevel and a.IsActive = 2

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