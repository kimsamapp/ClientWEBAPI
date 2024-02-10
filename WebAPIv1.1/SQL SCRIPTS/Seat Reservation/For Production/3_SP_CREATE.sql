USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPAnnouncementProcedures]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPAnnouncementProcedures]

@title varchar(max),
@description varchar(max),
@username varchar(max),
@IsActive int,
@id int,
@ActionType int,
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			select announcement_id, announcementid, title, 
                description, username, 
                datestamp, is_Active
                from dbo.CommonAnnouncement where is_Active=1 order by announcement_id desc
		End
	--Post
	If @ActionType = 2
		Begin
		 insert into dbo.CommonAnnouncement 
                    (title,description, username,dateStamp,is_Active)
                    values 
                    (
                    @title
                    ,@description
                    ,@username
                    ,(SELECT GETDATE())
                    ,@IsActive
                    )
		End
	--Update
	If @ActionType = 3
		Begin
		 update dbo.CommonAnnouncement set 
                    title = @title
                    ,description = @description
                    where announcement_id = @id
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			update dbo.CommonAnnouncement set 
                    is_Active = @IsActive
                    where announcement_id = @id
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPCEEmployeeSiteProcedures]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SPCEEmployeeSiteProcedures]
@ID int,
@ActionType int,
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			  SELECT [Site_ID]
			  ,[Site_Name]
			  ,[BIT_DELETED]
		  FROM [MBGSPMainDB].[dbo].[CommonEmployeeSite]
		  where [BIT_DELETED] = 0
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPCEExternalTypeProcedures]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPCEExternalTypeProcedures]

@Name varchar(max),
@Description varchar(max),
@ID int,
@IsActive int,
@ActionType int,
@CreatedBy varchar(max),
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			  select 
                a.CExternalTypeID, 
                a.CExternalTypeIDF,
                CONCAT(b.FirstName, b.LastName) as CreatedBy,
                a.CreatedDate,
                a.Description,
				a.IsActive,
				a.Name
                from 
                dbo.CommonExternalType a left join dbo.CommonEmployeesActive b on a.CreatedBy = b.UserID
				where a.IsActive = 1
		End
	--Post
	If @ActionType = 2
		Begin
		insert into dbo.CommonExternalType 
                    (Name,Description, IsActive, CreatedBy, CreatedDate)
                    values 
                    (
                    @Name,
					@Description,
					@IsActive,
					@CreatedBy,
					(SELECT GETDATE())
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.CommonExternalType set 
                    Name = @Name, Description = @Description
                    where CExternalTypeID  = @ID
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			 update dbo.CommonExternalType set 
                    IsActive = @IsActive
                    where CExternalTypeID = @ID
		End
	--Search
	If @ActionType = 5
		Begin
			select 
                a.CExternalTypeID, 
                a.CExternalTypeIDF,
                CONCAT(b.FirstName, b.LastName) as CreatedBy,
                a.CreatedDate,
                a.Description,
				a.IsActive,
				a.Name
                from 
                dbo.CommonExternalType a left join dbo.CommonEmployeesActive b on a.CreatedBy = b.UserID
				where a.IsActive = 1
				and
				(a.CExternalTypeIDF LIKE '%' + @Keyword + '%' OR b.FirstName LIKE '%' + @Keyword + '%' OR b.LastName LIKE '%' + @Keyword + '%' OR a.Name LIKE '%' + @Keyword + '%' OR a.Description LIKE '%' + @Keyword + '%')
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPCEExternalUsersProcedures]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SPCEExternalUsersProcedures]

@Employee_ID varchar(100),
@UserID varchar(100),
@FirstName varchar(100),
@LastName varchar(100),
@MiddleName varchar(100),
@Phone_number varchar(100),
@Site_Location varchar(100),
@UserType int,
@ID int,
@IsActive int,
@ActionType int,
@CreatedBy varchar(max),
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			  select 
                a.[CExternalUID]
				  ,a.[CExternalUIDF]
				  ,a.[Employee_ID]
				  ,a.[UserID]
				  ,a.[FirstName]
				  ,a.[LastName]
				  ,a.[MiddleName]
				  ,a.[Phone_number]
				  ,d.Site_Name
				  ,a.Site_Location
				  ,a.[UserType]
				  ,a.[IsActive]
				   ,CONCAT(c.FirstName, ' ', c.LastName) as CreatedBy
				  ,a.[CreatedDate]
				  ,b.[Name] as UserTypeName
			  FROM [MBGSPMainDB].[dbo].[CommonExternalUsers] a left join [MBGSPMainDB].[dbo].[CommonExternalType] b on a.UserType = b.CExternalTypeID
			  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c on a.CreatedBy = c.UserID 
			  left join [MBGSPMainDB].[dbo].[CommonEmployeeSite] d on a.Site_Location = d.Site_ID
			  where a.IsActive = 1 and b.IsActive = 1
		End
	--Post
	If @ActionType = 2
		Begin
		insert into dbo.CommonExternalUsers 
                    (Employee_ID,UserID,FirstName,LastName, MiddleName,Phone_number, Site_Location,UserType, IsActive, CreatedBy, CreatedDate)
                    values 
                    (
                    @Employee_ID,
					@UserID,
					@FirstName,
					@LastName,
					@MiddleName,
					@Phone_number,
					@Site_Location,
					@UserType,
					@IsActive,
					@CreatedBy,
					(SELECT GETDATE())
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.CommonExternalUsers set 
                    Employee_ID = @Employee_ID,
					UserID = @UserID,
					FirstName = @FirstName,
					MiddleName= @MiddleName,
					LastName = @LastName,
					Phone_number = @Phone_number,
					Site_Location =@Site_Location,
					UserType = @UserType
                    where CExternalUID  = @ID
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			 update dbo.CommonExternalUsers set 
                    IsActive = @IsActive
                    where CExternalUID = @ID
		End
	--Search
	If @ActionType = 5
		Begin
			 select a.[CExternalUID]
				  ,a.[CExternalUIDF]
				  ,a.[Employee_ID]
				  ,a.[UserID]
				  ,a.[FirstName]
				  ,a.[LastName]
				  ,a.[MiddleName]
				  ,a.[Phone_number]
				  ,d.Site_Name
				  ,a.Site_Location
				  ,a.[UserType]
				  ,a.[IsActive]
				   ,CONCAT(c.FirstName,' ', c.LastName) as CreatedBy
				  ,a.[CreatedDate]
				  ,b.[Name] as UserTypeName
			  FROM [MBGSPMainDB].[dbo].[CommonExternalUsers] a left join [MBGSPMainDB].[dbo].[CommonExternalType] b on a.UserType = b.CExternalTypeID
			  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c on a.CreatedBy = c.UserID 
			  left join [MBGSPMainDB].[dbo].[CommonEmployeeSite] d on a.Site_Location = d.Site_ID
			  where a.IsActive = 1 and b.IsActive = 1
				and
				(a.CExternalUIDF LIKE '%' + @Keyword + '%' 
				OR c.FirstName LIKE '%' + @Keyword + '%' 
				OR c.LastName LIKE '%' + @Keyword + '%' 
				OR a.Employee_ID LIKE '%' + @Keyword + '%' 
				OR a.MiddleName LIKE '%' + @Keyword + '%'
				OR a.UserID LIKE '%' + @Keyword + '%'
				OR a.Phone_number LIKE '%' + @Keyword + '%'
				OR a.Site_Location LIKE '%' + @Keyword + '%'
				OR b.Name LIKE '%' + @Keyword + '%'
				OR d.Site_Name LIKE '%' + @Keyword + '%'
				)
		End
		--GetUser
	If @ActionType = 6
	Begin
		select 
                a.[CExternalUID]
				  ,a.[CExternalUIDF]
				  ,a.[Employee_ID]
				  ,a.[UserID]
				  ,a.[FirstName]
				  ,a.[LastName]
				  ,a.[MiddleName]
				  ,a.[Phone_number]
				  ,d.Site_Name as Site_Location
				  ,a.[UserType]
				  ,a.[IsActive]
				  ,b.[Name] as UserTypeName
				  ,e.user_telecommuting
				  ,e.buildingid
				  ,e.zoneid
				  ,e.floorid
				  ,e.sr_preference_id
				  ,e.theme
				  ,e.fixedseat
				  ,e.specialdayoff
			  FROM [MBGSPMainDB].[dbo].[CommonExternalUsers] a left join [MBGSPMainDB].[dbo].[CommonExternalType] b on a.UserType = b.CExternalTypeID
			  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c on a.CreatedBy = c.UserID 
			  left join [MBGSPMainDB].[dbo].[CommonEmployeeSite] d on a.Site_Location = d.Site_ID
			  left join dbo.CommonPreference e on a.UserID = e.username
			  where a.IsActive = 1 and a.UserID = @UserID
	End
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresBuildingMasterfile]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresBuildingMasterfile]

@BuildingName varchar(max),
@LocationId int,
@BuildingId int,
@IsActive int,
@ActionType int,
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			 select SRBuilding.building_id, SRBuilding.buildingid, SRBuilding.building_name, 
                SRBuilding.is_Active, SRBuilding.location_id, 
                SRLocation.location_name
                from dbo.SRBuilding inner join dbo.SRLocation on SRBuilding.location_id = SRLocation.location_id where SRBuilding.is_Active !=0 
		End
	--Post
	If @ActionType = 2
		Begin
		 insert into dbo.SRBuilding 
                    (Building_Name,is_Active, location_id)
                    values 
                    (
                    @BuildingName
                    ,@ActionType
                    ,@LocationId
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.SRBuilding set 
                    building_name = @BuildingName
                    ,location_id = @LocationId
                    where building_id = @BuildingId
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			 update dbo.SRBuilding set 
                    is_Active = @IsActive
                    where building_id = @BuildingId
		End
	--Search
	If @ActionType = 5
		Begin
			select SRBuilding.building_id, 
                SRBuilding.buildingid, 
                SRBuilding.building_name, 
                SRBuilding.is_Active, 
                SRBuilding.location_id, 
                SRLocation.location_name
                from dbo.SRBuilding
                inner join dbo.SRLocation 
                    on SRBuilding.location_id = SRLocation.location_id 
                        where SRBuilding.is_Active != 0 and (SRBuilding.building_name LIKE '%' + @Keyword + '%' OR SRLocation.location_name LIKE '%' + @Keyword + '%')
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresDashboard]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresDashboard]

@dFrom datetime,
@dTo datetime,
@EmployeeId varchar(max),
@ActionType int,
@Username varchar(max),
@RID int,
@dF varchar(max),
@dT varchar(max)

AS

BEGIN
	If @ActionType = 1
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
            SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
            SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
            SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
            SRReservation.datestamp, SRReservation.teleCtr
            from dbo.SRSeat 
            left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
            left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
            left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
            left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
            left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
			where 
			(
			CONVERT(datetime,SRReservation.seat_reservation_datetime_from) 
			>= DATEADD(MONTH, -1, CONVERT(datetime, @dFrom)) AND CONVERT(datetime,SRReservation.seat_reservation_datetime_from) <= DATEADD(MONTH, 2, CONVERT(datetime, @dFrom))
			)
			and
			SRReservation.username = @Username 
			and 
			SRReservation.seat_reservation_status != 4 
			and 
			SRReservation.seat_reservation_status != 5 
			and 
			SRReservation.seat_reservation_status != 7 
			order by SRReservation.seat_reservation_datetime_from asc
		End
	If @ActionType = 2
		Begin
			SELECT DISTINCT Name, [Date], HolidayId
		  FROM [MBGSPMainDB].[dbo].[CommonHoliday]
		  where DeleteFlag = 0 
		  and
		  (LocationId = 4 OR LocationId = @dF)
		  and
		  (
			[Date]
			BETWEEN DATEADD(MONTH, -1, CONVERT(datetime, @dFrom)) AND DATEADD(MONTH, 2, CONVERT(DATETIME, @dFrom))
			)
		  order by [Date] asc
		End
	if @ActionType = 3
		Begin
			select [CutOffPeriodName] as 'title', [Date_Start_CutOff_Period] as 'start', [Date_End_CutOff_Period] as 'end', (SELECT '#3788d8') as 'backgroundColor', (SELECT CAST(1 as bit)) as 'allDay'
			from [MBGSPMainDB].[dbo].[CommonPayrollCutOffPeriods] 
			where convert(date, Date_Start_CutOff_Period) <= convert(date, getdate()) AND convert(date, Date_End_CutOff_Period) >= convert(date, getdate()) AND DeleteFlag = 0
		End
	if @ActionType = 4
		begin
			declare @TempMonthlyReportTbl table(NO_EMPLOYEE_ID varchar(max),fullname varchar(max),DATE_FILED varchar(max),Department_id varchar(max),LEAVE_TYPE_NAME varchar(max),Date_Covered varchar(max),TRACKER_STATUS varchar(max),noOfdays varchar(max),NO_LEAVE_REQUEST varchar(max), startD varchar(max), endD varchar(max))
			insert into @TempMonthlyReportTbl
			  select l.NO_EMPLOYEE_ID, concat(a.LAST_NAME,', ', a.FIRST_NAME) as fullname,DATE_FILED, b.[AREA_CODE_GROUP],LEAVE_TYPE_NAME,concat(DATE_FROM, ' - ' ,DATE_TO) as Date_Covered, TRACKER_STATUS, datediff(day, DATE_FROM, DATE_TO) + 1 as noOfdays,NO_LEAVE_REQUEST,DATE_FROM, DATE_TO
			   FROM [LeaveManagementSystem].[dbo].[MonthlyReportLeaves] l
			  inner join [DatabaseMBGSP2.0].[dbo].TblEmployee a on a.NO_EMPLOYEE_ID = l.NO_EMPLOYEE_ID
			  inner join [DatabaseMBGSP2.0].[dbo].TblAreaCodeGroup b on b.[NO_AREA_CODE_GROUP] = a.NO_AREA_CODE_GROUP
			  inner join [LeaveManagementSystem].[dbo].[TblLeaveType] lt on lt.NO_LEAVE_TYPE = l.NO_LEAVE_TYPE 
			  WHERE
			  (
				DATE_FROM
				BETWEEN DATEADD(MONTH, -1, CONVERT(datetime, @dFrom)) AND DATEADD(MONTH, 2, CONVERT(DATETIME, @dFrom))
				)

			  select * from @TempMonthlyReportTbl where NO_EMPLOYEE_ID = @EmployeeId
		end
END
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresFloorMasterfile]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresFloorMasterfile]

@FloorName varchar(max),
@BuildingId int,
@FloorId int,
@IsActive int,
@ActionType int,
@Keyword varchar(max),
@PriorityId int

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			  select 
                SRFloor.floor_id, 
                SRFloor.floorid, 
                SRFloor.floor_name, 
                SRFloor.is_Active, 
                SRFloor.building_id, 
                SRBuilding.building_name,
				SRFloor.priorityid
                from 
                dbo.SRFloor inner join dbo.SRBuilding 
                    on SRFloor.building_id = SRBuilding.building_id 
                        where SRFloor.is_Active = 1
		End
	--Post
	If @ActionType = 2
		Begin
		insert into dbo.SRFloor 
                    (floor_name,is_Active, building_id, priorityid)
                    values 
                    (
                    @FloorName,
					@IsActive,
					@BuildingId,
					@PriorityId
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.SRFloor set 
                    floor_name = @FloorName
                    ,building_id = @BuildingId
					,priorityid = @PriorityId
                    where floor_id = @FloorId
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			 update dbo.SRFloor set 
                    is_Active = @IsActive
                    where floor_id = @FloorId
		End
	--Search
	If @ActionType = 5
		Begin
			   select 
                SRFloor.floor_id, 
                SRFloor.floorid,
                SRFloor.floor_name, 
                SRFloor.is_Active, 
                SRFloor.building_id, 
				SRFloor.priorityid,
                SRBuilding.building_name
                from dbo.SRFloor inner join dbo.SRBuilding 
                    on SRFloor.building_id = SRBuilding.building_id 
                        where SRFloor.is_Active = 1 and (SRFloor.floor_name LIKE '%' + @Keyword + '%' OR SRBuilding.building_name LIKE '%' + @Keyword + '%')
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresGS]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresGS]

@dFrom datetime,
@dTo datetime,
@EmployeeId varchar(max),
@ActionType int,
@Username varchar(max),
@RID int

AS

BEGIN
	If @ActionType = 1
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
					SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
					SRReservation.seat_reservation_id, SRReservation.seatreservationid, SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
					SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
					SRReservation.datestamp
					from dbo.SRSeat 
					left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
					left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
					left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
					left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
					left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
					where SRReservation.username = @Username and (SRReservation.seat_reservation_isActive = 1)
		End
	If @ActionType = 2
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                    SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                    SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
                    SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
                    SRReservation.datestamp
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                    left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                    left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                    left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                    where SRReservation.username = @Username and SRReservation.seatreservationid = @RID
		End
	If @ActionType = 3
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                    SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                    SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
                    SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
                    SRReservation.datestamp
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                    left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                    left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                    left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                    where SRReservation.username = @Username
                    AND ((SELECT CONVERT(DATE,SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(DATE, @dFrom))) and (SRReservation.seat_reservation_isActive = 1) order by SRReservation.seat_reservation_datetime_from asc
		End
	If @ActionType = 4
		Begin
			SELECT [NO_TIME_LOG]
			  ,[NO_EMPLOYEE_ID]
			  ,[TIME_IN_LOG_DATE]
			  ,[TIME_IN]
			  ,[TIME_IN_MANUAL]
			  ,[TIME_OUT_LOG_DATE]
			  ,[TIME_OUT]
			  ,[TIME_OUT_MANUAL]
			  ,[NO_SITE]
			  ,[NO_AREA]
			  ,[NO_DEPARTMENT]
			  ,[BIT_DELETED]
			  ,[BIT_UPDATE]
			  ,[BIT_SHIFT]
			  ,[BIT_REMARKS]
			  ,[REMARKS_TIME_LOG]
			  ,[USER_MOD]
			  ,[DATE_MOD]
				FROM [MBGSPMainDB].[dbo].[TKTimelogs]
				WHERE NO_EMPLOYEE_ID = @EmployeeId
		End
	If @ActionType = 5
		Begin
			SELECT [NO_TIME_LOG]
			  ,[NO_EMPLOYEE_ID]
			  ,[TIME_IN_LOG_DATE]
			  ,[TIME_IN]
			  ,[TIME_IN_MANUAL]
			  ,[TIME_OUT_LOG_DATE]
			  ,[TIME_OUT]
			  ,[TIME_OUT_MANUAL]
			  ,[NO_SITE]
			  ,[NO_AREA]
			  ,[NO_DEPARTMENT]
			  ,[BIT_DELETED]
			  ,[BIT_UPDATE]
			  ,[BIT_SHIFT]
			  ,[BIT_REMARKS]
			  ,[REMARKS_TIME_LOG]
			  ,[USER_MOD]
			  ,[DATE_MOD]
				FROM [MBGSPMainDB].[dbo].[TKTimelogs]
				WHERE NO_EMPLOYEE_ID = @EmployeeId and TIME_IN_LOG_DATE = (SELECT CONVERT(DATE, @dFrom))
		End
	If @ActionType = 6
		Begin
			SELECT TOP 1000 [HolidayId]
			  ,[Name]
			  ,[Date]
			  ,[LocationId]
			  ,[IsRegular]
			  ,[Description]
			  ,[CreatedBy]
			  ,[CreatedDate]
			  ,[ModifiedBy]
			  ,[ModifiedDate]
			  ,[DeleteFlag]
		  FROM [MBGSPMainDB].[dbo].[CommonHoliday]
		  where DeleteFlag = 0
		End
	if @ActionType = 7
		begin
			select count(SRReservation.seatreservationid) from SRReservation left join SRSeat on SRReservation.seatid = SRSeat.seat_id where SRSeat.is_Special = 1 AND (cast (datediff (day, 0, SRReservation.seat_reservation_datetime_from) as datetime) BETWEEN (SELECT CONVERT(DATE, @dFrom)) AND (SELECT CONVERT(DATE, @dTo)))
		end

END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresLocationMasterfile]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresLocationMasterfile]

@LocationName varchar(max),
@LocationId int,
@IsActive int,
@ActionType int,
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			 select 
                location_id, 
                locationid, 
                location_name, 
                is_Active 
                    from dbo.SRLocation 
                        where is_Active!= 0
		End
	--Post
	If @ActionType = 2
		Begin
		insert into dbo.SRLocation 
                    (Location_Name,is_Active)
                    values 
                    (
                    @LocationName
                    , @IsActive
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.SRLocation set 
                location_name = @LocationName
                where location_id = @LocationId
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			  update dbo.SRLocation set 
                is_Active = @IsActive
                where location_id = @LocationId
		End
	--Search
	If @ActionType = 5
		Begin
		select 
            location_id, 
            locationid, 
            location_name, 
            is_Active 
                from dbo.SRLocation 
                    where is_Active!= 0 and location_name LIKE '%' + @Keyword + '%'
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresReservationPage]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresReservationPage]

@dFrom datetime,
@dTo datetime,
@LocationId int,
@BuildingId int,
@ZoneId int,
@EmployeeId varchar(max),
@ActionType int,
@Username varchar(max),
@RID int,
@Keyword varchar(max)

AS

BEGIN
	--CheckActiveReservation
	If @ActionType = 1
		Begin
			SELECT SRReservation.seatreservationid FROM SRReservation
            where SRReservation.username = @Username
            AND ((SELECT CONVERT(DATE, SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(DATE, @dFrom)))
            AND SRReservation.seat_reservation_isActive = 1
		End
	--CheckTotalReservationForADay
	If @ActionType = 2
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
            SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
            SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
            SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
            SRReservation.datestamp
            from dbo.SRSeat 
            left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
            left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
            left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
            left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
            left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
            where SRReservation.username = @Username
            AND (SELECT CONVERT(DATE, SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(DATE, @dFrom))
            AND (SRReservation.seat_reservation_status = 3 OR SRReservation.seat_reservation_status = 1 OR SRReservation.seat_reservation_status = 2 OR SRReservation.seat_reservation_status = 5)
		End
	--CheckReservationAvailability
	If @ActionType = 3
		Begin
		SELECT TOP 1 SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                SRReservation.seat_reservation_id, SRReservation.seatreservationid
                from dbo.SRSeat 
                left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                where 
				SRSeat.seat_id = @RID 
                AND 
				( 
				(SELECT CONVERT(DATETIME, @dFrom)) 
					BETWEEN 
					(SELECT CONVERT(datetime, SRReservation.seat_reservation_datetime_from)) 
						AND 
					(SELECT CONVERT(datetime,SRReservation.seat_reservation_datetime_to)) 
				OR 
				(SELECT CONVERT(DATETIME, @dTo)) 
					BETWEEN (SELECT CONVERT(DATETIME,SRReservation.seat_reservation_datetime_from)) 
						AND 
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to))
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_from)) 
					BETWEEN
					(SELECT CONVERT(datetime, @dFrom)) 
						AND 
					(SELECT CONVERT(datetime, @dTo)) 
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to)) 
					BETWEEN
					(SELECT CONVERT(datetime, @dFrom)) 
						AND 
					(SELECT CONVERT(datetime, @dTo)) 
				)
                AND SRReservation.seat_reservation_isActive = 1
                AND SRSeat.is_Special = 0
		End
	--Reserve
	If @ActionType = 4
	Begin
		 insert into dbo.SRReservation 
                    (seat_reservation_datetime_from,seat_reservation_datetime_to,seat_reservation_status,seat_reservation_isActive,seatid,username,datestamp)
                    values 
                    (
                    @dFrom
                    ,@dTo
                    ,1
                    ,1
                    ,@RID
                    ,@Username
                    ,(SELECT GETDATE())
                    )
	End
END
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresReservationsPage]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresReservationsPage]

@dFrom datetime,
@dTo datetime,
@EmployeeId varchar(max),
@ActionType int,
@Username varchar(max),
@RID int,
@Keyword varchar(max)

AS

BEGIN
	--getreservationbysearch
	If @ActionType = 1
		Begin
            select SRSeat.seat_id, SRSeat.seat_number, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
            SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
            SRReservation.seat_reservation_id, SRReservation.seatreservationid, SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
            SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username, CommonEmployeesActive.LastName, CommonEmployeesActive.FirstName, CommonEmployeesActive.Email_Address,
            SRReservation.datestamp
            from dbo.SRSeat 
            left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
            left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
            left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
            left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
            left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
            left join dbo.CommonEmployeesActive on CommonEmployeesActive.UserID = SRReservation.username
            where (SRReservation.seat_reservation_status = 1 and SRSeat.is_Special = 0) AND (((SELECT CONVERT(DATE, SRReservation.seat_reservation_datetime_from)) BETWEEN (SELECT CONVERT(DATE, @dFrom)) AND (SELECT CONVERT(DATE, @dTo))) 
			OR (SRSeat.seat_number LIKE '%' + @Keyword + '%' OR SRLocation.location_name LIKE '%' + @Keyword + '%' OR SRBuilding.building_name LIKE '%' + @Keyword + '%' OR
			SRReservation.username LIKE '%' + @Keyword + '%' OR SRZone.zone_name LIKE '%' + @Keyword + '%' OR SRLocation.location_name LIKE '%' + @Keyword + '%' OR floor_name LIKE '%' + @Keyword + '%'
			OR SRReservation.seatreservationid LIKE '%' + @Keyword + '%' OR SRReservation.seat_reservation_id LIKE '%' + @Keyword + '%' OR CommonEmployeesActive.LastName LIKE '%' + @Keyword + '%'
			OR CommonEmployeesActive.FirstName LIKE '%' + @Keyword + '%' ))
		End
		--simple get
	If @ActionType = 2
		Begin
			 select SRSeat.seat_id, SRSeat.seat_number, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
            SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
            SRReservation.seat_reservation_id, SRReservation.seatreservationid, SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
            SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username, CommonEmployeesActive.LastName, CommonEmployeesActive.FirstName, CommonEmployeesActive.Email_Address,
            SRReservation.datestamp
            from dbo.SRSeat 
            left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
            left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
            left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
            left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
            left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
            left join dbo.CommonEmployeesActive on CommonEmployeesActive.UserID = SRReservation.username
            where (SRReservation.seat_reservation_status = 1 and SRSeat.is_Special = 0)
		End
	--removeReservation
	IF @ActionType = 3
		BEGIN
		SELECT * FROM SRReservation
			UPDATE SRReservation
			SET seat_reservation_isActive = 7, seat_reservation_status = 0
			WHERE SRReservation.seatreservationid = @RID
		END
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresSeatMasterfile]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresSeatMasterfile]

@SeatNumber varchar(max),
@Inclusion varchar(max),
@LocationId int,
@BuildingId int,
@FloorId int,
@ZoneId int,
@IsActive int,
@IsSpecial int,
@SeatId int,
@ActionType int,
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name
                from dbo.SRSeat 
                left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
				where SRSeat.is_Active != 0
		End
	--Post
	If @ActionType = 2
		Begin
		insert into dbo.SRSeat 
                    (seat_number,inclusion,location_id,building_id,floor_id,zone_id,is_Active,is_Special)
                    values 
                    (@SeatNumber,
					 @Inclusion,
					 @LocationId,
					 @BuildingId,
					 @FloorId,
					 @ZoneId,
					 @IsActive,
					 @IsSpecial
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.SRSeat set 
                    seat_number = @SeatNumber
                    ,inclusion = @Inclusion
                    ,location_id = @LocationId
                    ,building_id = @BuildingId
                    ,floor_id = @FloorId
                    ,zone_id = @ZoneId
                    ,is_Active = @IsActive
                    where seat_id = @SeatId
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			 update dbo.SRSeat set 
                    is_Active = @IsActive
                    where seat_id = @SeatId
		End
	--GETSEAT
	If @ActionType = 5
		Begin
			 select * from 
                dbo.SRSeat 
                where 
                SRSeat.is_Active=1 
                and 
                SRSeat.seat_number = @SeatNumber
                and 
                SRSeat.location_id = @LocationId
                and 
                SRSeat.building_id = @BuildingId
                and 
                SRSeat.floor_id = @FloorId
                and 
                SRSeat.zone_id = @ZoneId
		End
	--Search
	If @ActionType = 6
		Begin
			select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name
                from dbo.SRSeat 
                left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                where 
				SRSeat.is_Active != 0 AND
				(SRSeat.seat_number LIKE '%' + @Keyword + '%' 
				OR SRLocation.location_name LIKE '%' + @Keyword + '%' 
				OR SRBuilding.building_name LIKE '%' + @Keyword + '%' 
				OR SRFloor.floor_name LIKE '%' + @Keyword + '%'
				OR SRZone.zone_name LIKE '%' + @Keyword + '%') 
		End
		--FixedSeatDropdown
	If @ActionType = 7
		select SRSeat.seat_id, SRSeat.seat_number, SRSeat.location_id,
                    SRLocation.location_name, CommonPreference.username
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join CommonPreference
                      on SRSeat.seat_id = CommonPreference.fixedseat
                        where SRSeat.is_Active = 3 and username is null
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresSetup]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresSetup]

@dFrom datetime,
@dTo datetime,
@ActionType int,
@Username varchar(max),
@ID int,
@IsActive int,
@PerformedBy varchar(max),
@Keyword varchar(max),
@D1 varchar(100),
@D2 varchar(100)

AS
BEGIN
	--get
	If @ActionType = 1
		Begin
			SELECT a.[SpecialDayOffId]
      ,a.[SpecialIDF]
      ,a.[IsActive]
      ,a.[Date]
	  ,a.Day1
	  ,a.Day2
      ,a.[Username]
      ,a.[Datestamp],
	  a.PerformedBy,
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialDayOffs] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	  where a.IsActive = 1
	End
	--insert
	If @ActionType = 2
	Begin
		INSERT INTO [MBGSPMainDB].[dbo].[SRSpecialDayOffs] (IsActive,[Date],Username,PerformedBy, Datestamp)
		VALUES(@IsActive, (SELECT CONVERT(date,@dFrom)), @Username,@PerformedBy, (SELECT GETDATE()))
	End
	--remove
	If @ActionType = 3
	Begin
		UPDATE [MBGSPMainDB].[dbo].[SRSpecialDayOffs] 
		SET IsActive = @IsActive
		WHERE SpecialDayOffId = @ID
	End
	--search
	If @ActionType = 4
	Begin
		SELECT a.[SpecialDayOffId]
      ,a.[SpecialIDF]
      ,a.[IsActive]
      ,a.[Date]
	  ,a.Day1
	  ,a.Day2
      ,a.[Username]
      ,a.[Datestamp],
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialDayOffs] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	  where 
	  (a.SpecialIDF LIKE '%' + @Keyword + '%' 
	  OR 
	  a.Date LIKE '%' + @Keyword + '%' 
	  OR 
	  b.LastName LIKE '%' + @Keyword + '%'
	   OR 
	  a.Day1 LIKE '%' + @Keyword + '%'
	   OR 
	  a.Day2 LIKE '%' + @Keyword + '%'
	  OR
	  b.FirstName LIKE '%' + @Keyword + '%')
	  AND a.IsActive = 1
	End
	If @ActionType = 5
		Begin
			SELECT a.[SRSpecialTelecomDatesId]
      ,a.[SpecialTeleIDF]
      ,a.[IsActive]
      ,a.[FDate]
	  ,a.[TDate]
      ,a.[Username]
      ,a.[Datestamp],
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialTelecomDates] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	  where a.IsActive = 1
	End
	If @ActionType = 6
		Begin
			SELECT a.[SRSpecialTelecomDatesId]
      ,a.[SpecialTeleIDF]
      ,a.[IsActive]
      ,a.[FDate]
	  ,a.[TDate]
      ,a.[Username]
      ,a.[Datestamp],
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialTelecomDates] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	   where 
	  (a.SpecialTeleIDF LIKE '%' + @Keyword + '%' 
	  OR 
	  a.[FDate] LIKE '%' + @Keyword + '%' 
	  OR 
	  a.[TDate] LIKE '%' + @Keyword + '%' 
	  OR 
	  b.LastName LIKE '%' + @Keyword + '%'
	  OR
	  b.FirstName LIKE '%' + @Keyword + '%'
	  OR
	  a.[PerformedBy] LIKE '%' + @Keyword + '%')
	  AND
	  a.IsActive = 1
	End
	If @ActionType = 7
	Begin
		INSERT INTO [MBGSPMainDB].[dbo].[SRSpecialTelecomDates] (IsActive,FDate,TDate, Username, PerformedBy, Datestamp)
		VALUES(@IsActive, @dFrom, @dTo, @Username,@PerformedBy, (SELECT GETDATE()))
	End
	If @ActionType = 8
	Begin
		UPDATE [MBGSPMainDB].[dbo].[SRSpecialTelecomDates]
		SET IsActive = @IsActive
		where SRSpecialTelecomDatesId = @ID
	End
	If @ActionType = 9
	Begin
		UPDATE [MBGSPMainDB].[dbo].[SRSpecialTelecomDates]
		SET FDate = @dFrom, TDate = @dTo, Username=@Username
		where SRSpecialTelecomDatesId = @ID
	End
	If @ActionType = 10
		Begin
			SELECT a.[SpecialDayOffId]
      ,a.[SpecialIDF]
      ,a.[IsActive]
      ,a.[Date]
	  ,a.Day1
	  ,a.Day2
      ,a.[Username]
      ,a.[Datestamp],
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialDayOffs] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	  where a.IsActive = 1 and a.Username = @Username and (SELECT CONVERT(date, a.Date)) = (SELECT CONVERT(date, @dFrom))
	End
	If @ActionType = 11
		Begin
			SELECT a.[SpecialDayOffId]
      ,a.[SpecialIDF]
      ,a.[IsActive]
      ,a.[Date]
	  ,a.Day1
	  ,a.Day2
      ,a.[Username]
      ,a.[Datestamp],
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialDayOffs] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	  where a.IsActive = 1 and a.Username = @Username and 
	  (
			a.[Date]
			BETWEEN DATEADD(MONTH, -1, CONVERT(datetime, @dFrom)) AND DATEADD(MONTH, 2, CONVERT(DATETIME, @dFrom))
		)
	End
	If @ActionType = 12
		Begin
			SELECT a.[SpecialDayOffId]
      ,a.[SpecialIDF]
      ,a.[IsActive]
      ,a.[Date]
      ,a.[Username]
	  ,a.Day1
	  ,a.Day2
      ,a.[Datestamp],
	  CONCAT(b.LastName,' ' ,b.FirstName) as Name
      ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialDayOffs] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	  on a.[Username] = b.UserID
	  where a.IsActive = 1 and a.[SpecialDayOffId] = @ID
	End

	If @ActionType = 13
		Begin
			SELECT a.[SRSpecialTelecomDatesId]
			  ,a.[SpecialTeleIDF]
			  ,a.[IsActive]
			  ,a.[FDate]
			  ,a.[TDate]
			  ,a.[Username]
			  ,a.[Datestamp],
			  CONCAT(b.LastName,' ' ,b.FirstName) as Name
			  ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialTelecomDates] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
			  on a.[Username] = b.UserID
			  where a.IsActive = 1 and a.Username = @Username and
			  (
				(SELECT CONVERT(date, @dFrom)) BETWEEN (SELECT CONVERT(date, a.FDate)) AND (SELECT CONVERT(date, a.TDate))
			  )
		End
	if @ActionType = 14
		begin
			INSERT INTO [MBGSPMainDB].[dbo].[SRSpecialDayOffs] (IsActive, Day1, Day2, Username, PerformedBy, Datestamp)
			VALUES(@IsActive, @D1, @D2, @Username,@PerformedBy, (SELECT GETDATE()))
		end
	if @ActionType = 15
		begin
			select
            dbo.CommonEmployeesActive.Employee_ID,
            dbo.CommonEmployeesActive.FirstName,
            dbo.CommonEmployeesActive.LastName,
            dbo.CommonEmployeesActive.MiddleName,
            dbo.CommonEmployeesActive.FullName,
            dbo.CommonEmployeesActive.Phone_number,
            dbo.CommonEmployeesActive.BusinessP_number,
            dbo.CommonEmployeesActive.Email_Address,
            dbo.CommonEmployeesActive.Home_Address1,
            dbo.CommonEmployeesActive.City,
            dbo.CommonEmployeesActive.Country,
            dbo.CommonEmployeesActive.Postal_ID,
            dbo.CommonEmployeesActive.Employee_Status,
            dbo.CommonEmployeesActive.Department,
            dbo.CommonEmployeesActive.Direct_SuperiorID,
            dbo.CommonEmployeesActive.Site_Location,
            dbo.CommonEmployeesActive.Site_LocationCode,
            dbo.CommonEmployeesActive.isFulltime,
            dbo.CommonEmployeesActive.NewAddress,
            dbo.CommonEmployeesActive.NewPhoneNumber,
            dbo.CommonEmployeesActive.UserID, 
            dbo.CommonEmployeesActive.AreaID,
            dbo.CommonEmployeesActive.Shifts,
            dbo.CommonEmployeesActive.PromotionDate,
            dbo.CommonUserRoles.Roles,
            dbo.CommonUserRoles.[User_id],
            dbo.SRRoles.rolename,
            dbo.CommonPreference.buildingid,
            dbo.CommonPreference.floorid,
            dbo.CommonPreference.sr_preference_id,
            dbo.CommonPreference.theme,
            dbo.CommonPreference.fixedseat,
            dbo.SRSeat.seat_number,
            dbo.CommonPreference.user_telecommuting,
            dbo.CommonArea.[Description],
            dbo.CommonPreference.zoneid,
            dbo.SRZone.zone_name,
            dbo.CommonShift.ShiftName, 
            dbo.CommonEmployeeSite.Site_Name,
            dbo.CommonArea.FirstApproverFullname,
            dbo.CommonArea.SecondApproverFullname,
			dbo.CommonPreference.specialdayoff
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
        left join dbo.SRSeat
        on
        dbo.CommonPreference.fixedseat = dbo.SRSeat.seat_id
        left join dbo.CommonArea
        on 
        dbo.CommonEmployeesActive.AreaID = dbo.CommonArea.AreaId
        left join dbo.SRZone
        on
        dbo.CommonPreference.zoneid = dbo.SRZone.zone_id
        left join dbo.CommonShift
        on 
        dbo.CommonEmployeesActive.Shifts = dbo.CommonShift.ShiftId
        left join dbo.CommonEmployeeSite
        on 
        dbo.CommonEmployeesActive.Site_LocationCode = dbo.CommonEmployeeSite.Site_ID
        where dbo.CommonEmployeesActive.DeleteFlag = 0 and dbo.CommonPreference.specialdayoff = 2
		end

		if @ActionType = 16
		begin
			declare @now datetime = (SELECT DATEADD(DAY, 1, (SELECT GETDATE())))
			update SRReservation 
			set seat_reservation_isActive = 0, seat_reservation_status = 7
			where (SELECT CONVERT(DATE, seat_reservation_datetime_from)) >= (SELECT CONVERT(DATE, @now)) AND username = @Username
		end	
		IF @ActionType = 17
		BEGIN
			SELECT top 1 a.[SpecialDayOffId]
			  ,a.[SpecialIDF]
			  ,a.[IsActive]
			  ,a.[Date]
			  ,a.Day1
			  ,a.Day2
			  ,a.[Username]
			  ,a.[Datestamp],
			  CONCAT(b.LastName,' ' ,b.FirstName) as Name
			  ,a.[PerformedBy] from [MBGSPMainDB].[dbo].[SRSpecialDayOffs] a left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
			  on a.[Username] = b.UserID
			where a.IsActive = 1 and a.Username = @Username
			ORDER BY a.SpecialDayOffId desc
	  	END
END	
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresTK]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresTK]
@NO_TIME_LOG int,
@TIME_IN_LOG_DATE datetime,
@TIME_OUT_LOG_DATE datetime,
@NO_SITE int,
@NO_AREA int,
@BIT_TK_TYPE int,
@NO_EMPLOYEE_ID varchar(max),
@ActionType int,
@Username varchar(max),
@RsvId int,
@SeatId int

AS

BEGIN
    --Telecommuting Scenario
		If @ActionType = 1
		
		Begin

			INSERT INTO [MBGSPMainDB].[dbo].[TKTimelogs](NO_EMPLOYEE_ID,TIME_IN_LOG_DATE,TIME_IN, NO_SITE,NO_AREA, BIT_DELETED, BIT_UPDATE, BIT_REMARKS, USER_MOD, DATE_MOD, BIT_TK_TYPE)
			values(@NO_EMPLOYEE_ID, (SELECT CONVERT(date, @TIME_IN_LOG_DATE)), (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),@NO_SITE, @NO_AREA, 0, 0, 1, 'tksradmin', (SELECT GETDATE()), @BIT_TK_TYPE)

				UPDATE dbo.SRReservation set 
					seat_reservation_status = 2
					,seat_reservation_check_in = (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE))
					where seatreservationid = @RsvId
		End
		
		-- WITO 
		If @ActionType = 2
		Begin
			INSERT INTO [MBGSPMainDB].[dbo].[TKTimelogs](NO_EMPLOYEE_ID,TIME_IN_LOG_DATE,TIME_IN, NO_SITE,NO_AREA, BIT_DELETED, BIT_UPDATE, BIT_REMARKS, USER_MOD, DATE_MOD, BIT_TK_TYPE)
			values(@NO_EMPLOYEE_ID, (SELECT CONVERT(date, @TIME_IN_LOG_DATE)), (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),@NO_SITE, @NO_AREA, 0, 0, 1, 'tksradmin', (SELECT GETDATE()), @BIT_TK_TYPE)

			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 2
                    ,seat_reservation_check_in = (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE))
                    where seatreservationid = @RsvId
		End

		--Travel/External Training
		if @ActionType = 3
		Begin
			INSERT INTO [MBGSPMainDB].[dbo].[TKTimelogs](NO_EMPLOYEE_ID,TIME_IN_LOG_DATE,TIME_IN, NO_SITE,NO_AREA, BIT_DELETED, BIT_UPDATE, BIT_REMARKS, USER_MOD, DATE_MOD, BIT_TK_TYPE)
			values(@NO_EMPLOYEE_ID, (SELECT CONVERT(date, @TIME_IN_LOG_DATE)), (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),@NO_SITE, @NO_AREA, 0, 0, 1, 'tksradmin', (SELECT GETDATE()), @BIT_TK_TYPE)
		
			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 2
                    ,seat_reservation_check_in = (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE))
                    where seatreservationid = @RsvId
		End

		--Check In Reservation
		if @ActionType = 4
		Begin
			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 2
                    ,seat_reservation_check_in = (SELECT GETDATE())
                    where seatreservationid = @RsvId
		End

		--Check Out Reservation
		if @ActionType = 5
		Begin
			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 3
                    ,seat_reservation_check_out = (SELECT GETDATE())
					,seat_reservation_isActive = 0
                    where seatreservationid = @RsvId
		End

		--Update BIT_TK_TYPE
		if @ActionType = 6
		begin
			UPDATE dbo.TKTimelogs
			set BIT_TK_TYPE = @BIT_TK_TYPE, BIT_UPDATE = 1, USER_MOD = 'tksradmin', DATE_MOD = (SELECT GETDATE())
			where NO_TIME_LOG = @NO_TIME_LOG
		end

		--TIME OUT SR/TK
		if @ActionType = 7
		begin
			UPDATE dbo.TKTimelogs
			set BIT_UPDATE = 1, USER_MOD = 'tksradmin', DATE_MOD = (SELECT GETDATE()), BIT_REMARKS = 2, TIME_OUT_LOG_DATE = (SELECT CONVERT(date, (SELECT GETDATE()))), TIME_OUT = (SELECT CONVERT(datetime, (SELECT GETDATE())))
			where NO_TIME_LOG = @NO_TIME_LOG

			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 3
                    ,seat_reservation_check_out = (SELECT GETDATE())
					,seat_reservation_isActive = 0
                    where seatreservationid = @RsvId
		end

		--Cancel Reservation
		if @ActionType = 8
		begin

			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 4
					,seat_reservation_isActive = 0
                    where seatreservationid = @RsvId
		end

		--Extend Reservation
		if @ActionType = 9
		begin
			update dbo.SRReservation set 
                    seat_reservation_datetime_to = @TIME_OUT_LOG_DATE
                    where seatreservationid = @RsvId
		end

		--reserve telecommuting/business travel/wito
		IF @ActionType = 10
		BEGIN

			declare @TotalRecords int
			declare @IsHoliday int
			declare @IsDayOff varchar(max)

			set @IsDayOff = (SELECT CATEGORY =
				CASE (DATENAME(DW,(SELECT CONVERT(date, @TIME_IN_LOG_DATE))))
				WHEN 'SATURDAY' THEN 'WEEKEND'
				WHEN 'SUNDAY' THEN 'WEEKEND'
				ELSE 'WEEKDAY'
			END
			)

			set @IsHoliday = (SELECT COUNT(*) FROM dbo.CommonHoliday
			WHERE (SELECT CONVERT(date, CommonHoliday.Date)) = (SELECT CONVERT(date, @TIME_IN_LOG_DATE)) AND CommonHoliday.DeleteFlag = 0 AND (CommonHoliday.LocationId = 4)
			)

			set @TotalRecords = (SELECT COUNT(*) FROM SRReservation 
				where 
				SRReservation.username = @Username AND
				(SELECT CONVERT(date,SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(date, @TIME_IN_LOG_DATE)) 
				AND (SRReservation.seat_reservation_status = 1 OR SRReservation.seat_reservation_status = 2 OR SRReservation.seat_reservation_status = 3 OR SRReservation.seat_reservation_status = 6))
			
			if @TotalRecords = 0 AND @SeatId = 3 AND @IsHoliday = 0 AND @IsDayOff ='WEEKDAY'
				Begin
					insert into dbo.SRReservation 
                    (seat_reservation_datetime_from,seat_reservation_datetime_to,seat_reservation_status,seat_reservation_isActive,seatid,username,datestamp,teleCtr)
                    values 
                    (
                    (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),
					(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)),
					1,
                    1,
					@SeatId,                   
                    @Username,
                    (SELECT GETDATE()),
					1
                    )
				End
			 else
				Begin
					insert into dbo.SRReservation 
                    (seat_reservation_datetime_from,seat_reservation_datetime_to,seat_reservation_status,seat_reservation_isActive,seatid,username,datestamp)
                    values 
                    (
                    (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),
					(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)),
					1,
                    1,
					@SeatId,                   
                    @Username,
                    (SELECT GETDATE())
                    )
				End
		END
		--ReservationCountTC
		IF @ActionType = 11
			begin
				SELECT COUNT(*) as RCount
				FROM SRReservation 
				left join SRSeat on 
				SRReservation.seatid = SRSeat.seat_id
				WHERE 
				SRReservation.username = @Username AND
				((SELECT CONVERT(date,SRReservation.seat_reservation_datetime_from)) BETWEEN (SELECT CONVERT(date, @TIME_IN_LOG_DATE)) AND (SELECT CONVERT(date, @TIME_OUT_LOG_DATE))) AND SRReservation.teleCtr = 1 AND (SRReservation.seat_reservation_status = 1 OR SRReservation.seat_reservation_status = 2 OR SRReservation.seat_reservation_status = 3 OR SRReservation.seat_reservation_status = 6)
			end
		--CheckReservationAvailabilityW/User
		IF @ActionType = 12
			BEGIN
				select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                SRReservation.seat_reservation_id, SRReservation.seatreservationid
                from dbo.SRSeat 
                left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                where SRSeat.seat_id = @SeatId
                AND (((SELECT CONVERT(DATETIME, @TIME_IN_LOG_DATE)) BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to) OR ((SELECT CONVERT(DATETIME, @TIME_OUT_LOG_DATE)) BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to))
                AND SRReservation.seat_reservation_isActive !=0
                AND SRSeat.is_Special = 0
                AND SRReservation.username != @Username
			END
		--CheckReservationAvailabilityWout/User
		IF @ActionType = 13
			BEGIN
				select TOP 1 SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                SRReservation.seat_reservation_id, SRReservation.seatreservationid
                from dbo.SRSeat 
                left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                where SRSeat.seat_id = @SeatId
                AND (((SELECT CONVERT(DATETIME, @TIME_IN_LOG_DATE)) BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to) OR ((SELECT CONVERT(DATETIME, @TIME_OUT_LOG_DATE)) BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to))
                AND SRReservation.seat_reservation_isActive = 1
                AND SRSeat.is_Special = 0
			END
			--ReservationByUser1
		IF @ActionType = 14
			BEGIN
				select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                    SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                    SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
                    SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
                    SRReservation.datestamp
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                    left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                    left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                    left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                    where SRReservation.username = @Username
                    AND (SELECT CONVERT(DATE, SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(DATE, @Username))
                    AND SRReservation.seat_reservation_isActive != 0
			END
			--ReservationByUser2
		IF @ActionType = 15
			BEGIN
				select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                    SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                    SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
                    SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
                    SRReservation.datestamp
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                    left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                    left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                    left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                    where SRReservation.username = @Username 
                    AND (SELECT CONVERT(DATE, SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(DATE, @TIME_IN_LOG_DATE))
                    AND SRReservation.seat_reservation_isActive != 0
			END
			--ReservationByUser3
		IF @ActionType = 16
			BEGIN
				select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                    SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                    SRReservation.seat_reservation_id,SRReservation.seatreservationid,SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
                    SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
                    SRReservation.datestamp
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                    left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                    left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                    left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                    where SRReservation.username = @Username
                    AND (SELECT CONVERT(DATE, SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(DATE, @TIME_IN_LOG_DATE))
			END
			--ReservationByUser4
		IF @ActionType = 17
			BEGIN
				 select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                    SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                    SRReservation.seat_reservation_id, SRReservation.seatreservationid, SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
                    SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username,
                    SRReservation.datestamp
                    from dbo.SRSeat 
                    left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                    left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                    left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                    left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                    left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                    where SRReservation.username = @Username
			END
			--Reservations
		IF @ActionType = 18
			BEGIN
				select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
				SRSeat.zone_id,SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
				SRReservation.seat_reservation_id, SRReservation.seatreservationid, SRReservation.seat_reservation_datetime_from, SRReservation.seat_reservation_datetime_to,
				SRReservation.seat_reservation_check_in, SRReservation.seat_reservation_check_out, SRReservation.seat_reservation_status, SRReservation.username, CommonEmployeesActive.LastName, CommonEmployeesActive.FirstName, CommonEmployeesActive.Email_Address,
				SRReservation.datestamp
				from dbo.SRSeat 
				left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
				left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
				left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
				left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
				left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
				left join dbo.CommonEmployeesActive on CommonEmployeesActive.UserID = SRReservation.username
				where SRReservation.seat_reservation_status = 1 and SRSeat.is_Special = 0
			END
		--CheckAvailability
		IF @ActionType = 19
			BEGIN
			   select SRSeat.seat_id, SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
                SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name,
                SRReservation.seat_reservation_id, SRReservation.seatreservationid
                from dbo.SRSeat 
                left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
                left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
                left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
                left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
                left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
                where SRSeat.seat_id = @SeatId 
				 AND 
				( 
				(SELECT CONVERT(DATETIME, @TIME_IN_LOG_DATE)) 
					BETWEEN 
					(SELECT CONVERT(datetime, SRReservation.seat_reservation_datetime_from)) 
						AND 
					(SELECT CONVERT(datetime,SRReservation.seat_reservation_datetime_to)) 
				OR 
				(SELECT CONVERT(DATETIME, @TIME_OUT_LOG_DATE)) 
					BETWEEN (SELECT CONVERT(DATETIME,SRReservation.seat_reservation_datetime_from)) 
						AND 
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to))
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_from)) 
					BETWEEN
					(SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)) 
						AND 
					(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)) 
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to)) 
					BETWEEN
					(SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)) 
						AND 
					(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)) 
				)
                AND SRReservation.seat_reservation_isActive = 1
                AND SRSeat.is_Special = 0
                AND SRReservation.username != @Username
			END
		IF @ActionType = 20
		Begin
			insert into dbo.SRReservation 
            (seat_reservation_datetime_from,seat_reservation_datetime_to,seat_reservation_status,seat_reservation_isActive,seatid,username,datestamp)
            values 
            (
            (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),
			(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)),
			1,
            1,
			@SeatId,                   
            @Username,
            (SELECT GETDATE())
            )
		End	
		IF @ActionType = 21
		Begin
			declare @TotalRecordsRsvrd int
			set @TotalRecordsRsvrd = (SELECT COUNT(*) FROM SRReservation 
				where 
				SRReservation.username = @Username AND
				(SELECT CONVERT(date,SRReservation.seat_reservation_datetime_from)) = (SELECT CONVERT(date, @TIME_IN_LOG_DATE)) 
				AND (SRReservation.seat_reservation_status = 1 OR SRReservation.seat_reservation_status = 2 OR SRReservation.seat_reservation_status = 3 OR SRReservation.seat_reservation_status = 6))
			
			IF @TotalRecordsRsvrd = 0 AND @SeatId = 3 
			BEGIN
					insert into dbo.SRReservation 
					(seat_reservation_datetime_from,seat_reservation_datetime_to,seat_reservation_status,seat_reservation_isActive,seatid,username,datestamp,teleCtr)
					values 
					(
					(SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),
					(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)),
					1,
					1,
					@SeatId,                   
					@Username,
					(SELECT GETDATE()),
					1
					)
			END
			ELSE
				BEGIN
					insert into dbo.SRReservation 
					(seat_reservation_datetime_from,seat_reservation_datetime_to,seat_reservation_status,seat_reservation_isActive,seatid,username,datestamp)
					values 
					(
					(SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),
					(SELECT CONVERT(datetime, @TIME_OUT_LOG_DATE)),
					1,
					1,
					@SeatId,                   
					@Username,
					(SELECT GETDATE())
					)
				END
		
		End			
END

	
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresUsersPage]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresUsersPage]
@FloorId int,
@BuildingId int,
@ZoneId int,
@EmployeeId varchar(max),
@ActionType int,
@Username varchar(max),
@PID int,
@Keyword varchar(max),
@UserTelecommuting int,
@FixedSeat int,
@specialdayoff int

AS

BEGIN
	--SaveTelecommuting
	If @ActionType = 1
		Begin
			insert into dbo.CommonPreference(user_telecommuting, fixedseat, username, zoneid, specialdayoff)
                values 
                    (
                    @UserTelecommuting,
					@FixedSeat,
					@Username,
					@ZoneId,
					@specialdayoff
                    )
		End
	If @ActionType = 2
	--UpdateTelecommuting
		Begin
			update dbo.CommonPreference
                set user_telecommuting = @UserTelecommuting,
                fixedseat = @FixedSeat,
                zoneid = @ZoneId,
				specialdayoff = @specialdayoff
                where username = @Username
		End
	--
END
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresZoneMasterfile]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRProceduresZoneMasterfile]

@ZoneName varchar(max),
@ZoneId int,
@IsActive int,
@ActionType int,
@Keyword varchar(max)

AS

BEGIN
	--Get
	If @ActionType = 1
		Begin
			select 
                    SRZone.zone_id, 
                    SRZone.zoneid, 
                    SRZone.zone_name, 
                    SRZone.is_Active
                        from dbo.SRZone
                        where SRZone.is_Active!=0
		End
	--Post
	If @ActionType = 2
		Begin
		 insert into dbo.SRZone 
                    (Zone_Name,is_Active)
                    values 
                    (
                    @ZoneName
                    ,@IsActive
                    )
		End
	--Update
	If @ActionType = 3
		Begin
			update dbo.SRZone set 
                zone_name = @ZoneName
                where zone_id = @ZoneId
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			 update dbo.SRZone set 
                is_Active = @IsActive
                where zone_id = @ZoneId
		End
	--Search
	If @ActionType = 5
		Begin
			 select 
                SRZone.zone_id, SRZone.zoneid, SRZone.zone_name, SRZone.is_Active
                from dbo.SRZone 
                where SRZone.is_Active != 0 and SRZone.zone_name LIKE '%' + @Keyword + '%'
		End
	--GetZonesForPref
	If @ActionType = 6
		Begin
			select distinct 
                SRZone.zone_id, SRZone.zoneid, SRZone.zone_name, SRZone.is_Active
                from dbo.SRZone
                where SRZone.is_Active = 1
		End
END


GO
/****** Object:  StoredProcedure [dbo].[SPSRSearchReservationAvailable]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPSRSearchReservationAvailable]

@dFrom datetime,
@dTo datetime,
@LocId int,
@BldId int,
@Keyword varchar(max)
AS

BEGIN
		declare @temptableNum table (tempnum int)
		declare @temptablePriorities table (pid int)
		insert into @temptablePriorities select TOP 2 SRFloor.priorityid from SRFloor where SRFloor.building_id = 1 ORDER BY SRFloor.priorityid ASC
		declare @ctrStart int = 2
		declare @ctrEnd int = 2
		declare @sum int = 0
	 IF @Keyword = 0
		 BEGIN
		

			while(@ctrStart <= @ctrEnd)
			Begin
				insert into @temptableNum select distinct (SRSeat.seat_id)
				from dbo.SRSeat 
				left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
				left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
				where 
				( 
				(SELECT CONVERT(DATETIME, @dFrom)) 
					BETWEEN 
					(SELECT CONVERT(datetime, SRReservation.seat_reservation_datetime_from)) 
						AND 
					(SELECT CONVERT(datetime,SRReservation.seat_reservation_datetime_to)) 
				OR 
				(SELECT CONVERT(DATETIME, @dTo)) 
					BETWEEN (SELECT CONVERT(DATETIME,SRReservation.seat_reservation_datetime_from)) 
						AND 
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to))
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_from)) 
					BETWEEN
					(SELECT CONVERT(datetime, @dFrom)) 
						AND 
					(SELECT CONVERT(datetime, @dTo)) 
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to)) 
					BETWEEN
					(SELECT CONVERT(datetime, @dFrom)) 
						AND 
					(SELECT CONVERT(datetime, @dTo)) 
				)
				AND SRSeat.is_Special = 0
				AND SRReservation.seat_reservation_isActive = 1
				AND SRSeat.location_id = @LocId
				AND SRSeat.building_id = @BldId
				AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
				AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0)

				set @sum = (SELECT COUNT(distinct SRSeat.seat_id)
				from dbo.SRSeat 
				left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
				left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
				left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
				left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
				left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
				where 
				(
				SRSeat.location_id = @LocId
				AND 
				SRSeat.Building_id = @BldId
				AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
				AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0)
				AND
				SRSeat.is_Active = 1
				AND
					(
						SRReservation.seatreservationid is null 
						OR
						(
							(@dFrom
							NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							AND 
							(@dTo
							NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
						)
						OR
						(
							(@dFrom
							BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							AND 
							(@dTo
							BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							AND SRReservation.seat_reservation_isActive = 0
						)
					)
			)
			AND SRSeat.seat_id not in (select * from @temptableNum)
			AND
			SRSeat.is_Special = 0)

			IF @sum <= 10
				BEGIN
					DELETE @temptableNum
					DELETE @temptablePriorities
					set @ctrStart = @ctrStart + 1
					set @ctrEnd = @ctrEnd + 1
					set @sum = 0
					insert into @temptablePriorities select TOP (@ctrStart) SRFloor.priorityid from SRFloor where SRFloor.building_id = 1 ORDER BY SRFloor.priorityid ASC
				END
			ELSE
				BEGIN
					break
				END
			End

			DELETE @temptableNum
					insert into @temptableNum select distinct (SRSeat.seat_id)
					from dbo.SRSeat 
					left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
					left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
					where 
					( 
					(SELECT CONVERT(DATETIME, @dFrom)) 
						BETWEEN 
						(SELECT CONVERT(datetime, SRReservation.seat_reservation_datetime_from)) 
							AND 
						(SELECT CONVERT(datetime,SRReservation.seat_reservation_datetime_to)) 
					OR 
					(SELECT CONVERT(DATETIME, @dTo)) 
						BETWEEN (SELECT CONVERT(DATETIME,SRReservation.seat_reservation_datetime_from)) 
							AND 
					(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to))
					OR
					(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_from)) 
						BETWEEN
						(SELECT CONVERT(datetime, @dFrom)) 
							AND 
						(SELECT CONVERT(datetime, @dTo)) 
					OR
					(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to)) 
						BETWEEN
						(SELECT CONVERT(datetime, @dFrom)) 
							AND 
						(SELECT CONVERT(datetime, @dTo)) 
					)
					AND SRSeat.is_Special = 0
					AND SRReservation.seat_reservation_isActive = 1
					AND SRSeat.location_id = @LocId
					AND SRSeat.building_id = @BldId
					AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
					AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0)

					select distinct(SRSeat.seat_id), SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
						SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name
					from dbo.SRSeat 
					left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
					left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
					left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
					left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
					left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
					where 
					(
					SRSeat.location_id = @LocId
					AND 
					SRSeat.Building_id = @BldId
					AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
					AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0)
					AND
					SRSeat.is_Active = 1
					AND
						(
							SRReservation.seatreservationid is null 
							OR
							(
								(@dFrom
								NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
								AND 
								(@dTo
								NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							)
							OR
							(
								(@dFrom
								BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
								AND 
								(@dTo
								BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
								AND SRReservation.seat_reservation_isActive = 0
							)
						)
				)
				AND SRSeat.seat_id not in (select * from @temptableNum)
				AND
				SRSeat.is_Special = 0
	 END

	 ELSE
		BEGIN
		while(@ctrStart <= @ctrEnd)
		Begin
			insert into @temptableNum select distinct (SRSeat.seat_id)
			from dbo.SRSeat 
			left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
			left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
			where 
			( 
			(SELECT CONVERT(DATETIME, @dFrom)) 
				BETWEEN 
				(SELECT CONVERT(datetime, SRReservation.seat_reservation_datetime_from)) 
					AND 
				(SELECT CONVERT(datetime,SRReservation.seat_reservation_datetime_to)) 
			OR 
			(SELECT CONVERT(DATETIME, @dTo)) 
				BETWEEN (SELECT CONVERT(DATETIME,SRReservation.seat_reservation_datetime_from)) 
					AND 
			(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to))
			OR
			(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_from)) 
				BETWEEN
				(SELECT CONVERT(datetime, @dFrom)) 
					AND 
				(SELECT CONVERT(datetime, @dTo)) 
			OR
			(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to)) 
				BETWEEN
				(SELECT CONVERT(datetime, @dFrom)) 
					AND 
				(SELECT CONVERT(datetime, @dTo)) 
			)
			AND SRSeat.is_Special = 0
			AND SRReservation.seat_reservation_isActive = 1
			AND SRSeat.location_id = @LocId
			AND SRSeat.building_id = @BldId
			AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0 OR SRSeat.zone_id = @Keyword)
			AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))

			set @sum = (SELECT COUNT(distinct SRSeat.seat_id)
			from dbo.SRSeat 
			left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
			left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
			left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
			left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
			left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
			where 
			(
			SRSeat.location_id = @LocId
			AND 
			SRSeat.Building_id = @BldId
			AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
			AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0 OR SRSeat.zone_id = @Keyword)
			AND
			SRSeat.is_Active = 1
			AND
				(
					SRReservation.seatreservationid is null 
					OR
					(
						(@dFrom
						NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
						AND 
						(@dTo
						NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
					)
					OR
					(
						(@dFrom
						BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
						AND 
						(@dTo
						BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
						AND SRReservation.seat_reservation_isActive = 0
					)
				)
		)
		AND SRSeat.seat_id not in (select * from @temptableNum)
		AND
		SRSeat.is_Special = 0)

		IF @sum <= 10
			BEGIN
				DELETE @temptableNum
				DELETE @temptablePriorities
				set @ctrStart = @ctrStart + 1
				set @ctrEnd = @ctrEnd + 1
				set @sum = 0
				insert into @temptablePriorities select TOP (@ctrStart) SRFloor.priorityid from SRFloor where SRFloor.building_id = 1 ORDER BY SRFloor.priorityid ASC
			END
		ELSE
			BEGIN
				break
			END
		End

		DELETE @temptableNum
				insert into @temptableNum select distinct (SRSeat.seat_id)
				from dbo.SRSeat 
				left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
				left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
				where 
				( 
				(SELECT CONVERT(DATETIME, @dFrom)) 
					BETWEEN 
					(SELECT CONVERT(datetime, SRReservation.seat_reservation_datetime_from)) 
						AND 
					(SELECT CONVERT(datetime,SRReservation.seat_reservation_datetime_to)) 
				OR 
				(SELECT CONVERT(DATETIME, @dTo)) 
					BETWEEN (SELECT CONVERT(DATETIME,SRReservation.seat_reservation_datetime_from)) 
						AND 
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to))
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_from)) 
					BETWEEN
					(SELECT CONVERT(datetime, @dFrom)) 
						AND 
					(SELECT CONVERT(datetime, @dTo)) 
				OR
				(SELECT CONVERT(DATETIME, SRReservation.seat_reservation_datetime_to)) 
					BETWEEN
					(SELECT CONVERT(datetime, @dFrom)) 
						AND 
					(SELECT CONVERT(datetime, @dTo)) 
				)
				AND SRSeat.is_Special = 0
				AND SRReservation.seat_reservation_isActive = 1
				AND SRSeat.location_id = @LocId
				AND SRSeat.building_id = @BldId
				AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
				AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0 OR SRSeat.zone_id = @Keyword)

				select distinct(SRSeat.seat_id), SRSeat.seat_number, SRSeat.inclusion, SRSeat.seat_image, SRSeat.location_id, SRSeat.building_id, SRSeat.floor_id,
					SRSeat.zone_id, SRSeat.is_Active, SRSeat.is_Special, SRLocation.location_name, SRBuilding.building_name, SRFloor.floor_name, SRZone.zone_name
				from dbo.SRSeat 
				left join dbo.SRReservation on SRSeat.seat_id = SRReservation.seatid
				left join dbo.SRLocation on SRSeat.location_id = SRLocation.location_id 
				left join dbo.SRBuilding on SRSeat.building_id = SRBuilding.building_id
				left join dbo.SRFloor on SRSeat.floor_id = SRFloor.floor_id
				left join dbo.SRZone on SRSeat.zone_id = SRZone.zone_id
				where 
				(
				SRSeat.location_id = @LocId
				AND 
				SRSeat.Building_id = @BldId
				AND (SRFloor.priorityid in (SELECT * from @temptablePriorities))
				AND (SRSeat.zone_id IS NULL OR SRSeat.zone_id = 0 OR SRSeat.zone_id = @Keyword)
				AND
				SRSeat.is_Active = 1
				AND
					(
						SRReservation.seatreservationid is null 
						OR
						(
							(@dFrom
							NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							AND 
							(@dTo
							NOT BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
						)
						OR
						(
							(@dFrom
							BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							AND 
							(@dTo
							BETWEEN SRReservation.seat_reservation_datetime_from AND SRReservation.seat_reservation_datetime_to)
							AND SRReservation.seat_reservation_isActive = 0
						)
					)
			)
			AND SRSeat.seat_id not in (select * from @temptableNum)
			AND
			SRSeat.is_Special = 0
	 END
	 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTKGetAllEmployeeHRTKReportsV2]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:������� <Author,,Name>
-- Create date: <Create Date,,>
-- Description:��� <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPTKGetAllEmployeeHRTKReportsV2]
@datefrom as datetime,
@dateto as datetime
AS
BEGIN
	begin try
	declare @tempreportstable table(
									time_log_no int null,
									employeee_id_no varchar(30) null,
									employee_fullname varchar(MAX) null,
									site_location varchar(10) null,
									area_id varchar(20) null,
									time_in_log_date date null,
									time_in datetime null,
									time_out_log_date date null,
									time_out datetime null,
									working_hours varchar(50) null,
									nsd varchar(30) null,
									work_arrangement varchar(10) null,
									remarks varchar(MAX) null,
									leave_request_num int null
								)

	insert into @tempreportstable
	select NO_TIME_LOG,
		   NO_EMPLOYEE_ID, 
           concat(b.LastName, ', ', b.FirstName) as Employee_fullname, 
		   Site_Location,
		   AreaID, --to update to areaname
		   TIME_IN_LOG_DATE,
		   convert(varchar, TIME_IN, 22) as TIME_IN,
		   TIME_OUT_LOG_DATE,
		   convert(varchar, TIME_OUT, 22) as TIME_OUT,
		   (cast((datediff(minute,TIME_IN,TIME_OUT))/60 AS varchar(5))+ ' hours' + ' '+ cast( (datediff(minute,TIME_IN,TIME_OUT))%60 AS varchar(2))+' minutes') as Working_hours,
		   (case when TIME_OUT is not null 
					then 
						(case when cast(TIME_IN as date) = cast(TIME_OUT as date)
							then
								(case when DATEPART(hour, TIME_IN) > DATEPART(hour, TIME_OUT)
									then
										(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
									else
										(case when DATEPART(hour, TIME_OUT) >= '22'
											then
												(case when DATEPART(hour, TIME_IN) >= '22'
													then
														(case when cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, TIME_IN)),DATEADD(HOUR,convert(int,DATEPART(hour, TIME_IN)),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as integer) >=1 
															then
																(cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, TIME_IN)),DATEADD(HOUR,convert(int,DATEPART(hour, TIME_IN)),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as varchar) + ' Hours')
															else
																(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
															end
														)
													else
														(case when cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, '22:00')),DATEADD(HOUR,convert(int,DATEPART(hour, '22:00')),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as integer) >=1 
															then
																(cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, '22:00')),DATEADD(HOUR,convert(int,DATEPART(hour, '22:00')),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as varchar) + ' Hours')
															else
																(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
															end
														)
													end
												)
											else
												(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
										end)
								end)
							else
								(case when DATEPART(hour, TIME_OUT) < '6'
									then
										(case when DATEPART(hour, TIME_IN) >= '22'
											then
												(case when cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, TIME_IN)),DATEADD(HOUR,convert(int,DATEPART(hour, TIME_IN)),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as integer) >=1 
													then
														(cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, TIME_IN)),DATEADD(HOUR,convert(int,DATEPART(hour, TIME_IN)),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as varchar) + ' Hours')
													else
														(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
													end
												)
											else
												(case when cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, '22:00')),DATEADD(HOUR,convert(int,DATEPART(hour, '22:00')),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as integer) >=1 
													then
														(cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, '22:00')),DATEADD(HOUR,convert(int,DATEPART(hour, '22:00')),cast(cast(TIME_IN as date) as datetime))),TIME_OUT)) as varchar), 0) / 100 as decimal(18,2)) as varchar) + ' Hours')
													else
														(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
													end
												)
											end
										)
									else
										(case when DATEPART(hour, TIME_IN) >= '22'
											then
												(case when cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, TIME_IN)),DATEADD(HOUR,convert(int,DATEPART(hour, TIME_IN)),cast(cast(TIME_IN as date) as datetime))),DATEADD(MINUTE,convert(int,DATEPART(mi, '06:00')),DATEADD(HOUR,convert(int,DATEPART(hour, '06:00')),cast(cast(TIME_OUT as date) as datetime))))) as varchar), 0) / 100 as decimal(18,2)) as integer) >=1 
													then
														(cast(cast(ROUND(cast((cast((1.666666666666667) as float) * DATEDIFF(mi,DATEADD(MINUTE,convert(int,DATEPART(mi, TIME_IN)),DATEADD(HOUR,convert(int,DATEPART(hour, TIME_IN)),cast(cast(TIME_IN as date) as datetime))),DATEADD(MINUTE,convert(int,DATEPART(mi, '06:00')),DATEADD(HOUR,convert(int,DATEPART(hour, '06:00')),cast(cast(TIME_OUT as date) as datetime))))) as varchar), 0) / 100 as decimal(18,2)) as varchar) + ' Hours')
													else
														(cast(FORMAT(0, 'N2') as varchar) + ' Hours')
													end
												)
											else
												(cast(FORMAT(8, 'N2') as varchar) + ' Hours')
											end
										)
								end)
						end)
					else
						cast(TIME_OUT as varchar)
				end) as NSD,
				BIT_TK_TYPE as  work_arrangement,
				null as remarks,
				null as leaverequestnum
				
    from [MBGSPMainDB].[dbo].[TKTimelogs] a
	--from [DatabaseMBGSP2.0].[dbo].[TblTimeLog] a
	inner join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
	on a.NO_EMPLOYEE_ID = b.Employee_ID
	where convert(date, @datefrom) <= convert(date, TIME_IN_LOG_DATE) AND convert(date, @dateto) >= convert(date, TIME_IN_LOG_DATE)

	--select * from @tempreportstable
	
	declare @MonthsFrom int
	declare @MonthsTo int
	declare @noOfDaysMonthFrom int 
	declare @noOfDaysMonthTo int
	declare @noOfDaysMonthTemp int
	declare @dayOfMonthFromTemp int
	declare @dayOfMonthToTemp int
	declare @yearfrom int
	declare @yearto int
	
	declare @approvedleaves table(
		[NO_EMPLOYEE_ID] [varchar](max) NULL,
		[NO_LEAVE_REQUEST] int,
		[NO_PROCESS_REQUEST] int,
		[NO_LEAVE_TYPE] int,
		[NO_LEAVE_DATES] int,
		[DATE_FROM] [date] NULL,
		[DATE_TO] [date] NULL,
		[TRACKER_STATUS] [varchar](max) NULL,
		[Date_Filed] [date] NULL
	)

	insert into @approvedleaves
	select NO_EMPLOYEE_ID,
	       convert(int, NO_LEAVE_REQUEST),
		   convert(int, NO_PROCESS_REQUEST),
		   convert(int, NO_LEAVE_TYPE),
		   convert(int, NO_LEAVE_DATES),
		   DATE_FROM,
		   DATE_TO,
		   TRACKER_STATUS,
		   Date_Filed from [LeaveManagementSystem].[dbo].[MonthlyReportLeaves] 
		   --where DATE_FROM <= DATEADD(month, 2, @datefrom) AND DATE_FROM >= DATEADD(month, -2, @datefrom)--put limit +-2months from current --modify if needed

	declare @tempTblTimeLogs table([NO_TIME_LOG] [int] NOT NULL,
									[NO_EMPLOYEE_ID] [varchar](max) NOT NULL,
									[TIME_IN_LOG_DATE] [varchar](max) NULL,
									[TIME_IN] [datetime] NULL,
									[TIME_IN_MANUAL] [varchar](max) NULL,
									[TIME_OUT_LOG_DATE] [varchar](max) NULL,
									[TIME_OUT] [datetime] NULL,
									[TIME_OUT_MANUAL] [varchar](max) NULL,
									[NO_SITE] [int] NOT NULL,
									[NO_AREA] [int] NOT NULL,
									[NO_DEPARTMENT] [int] NULL,
									[BIT_DELETED] [bit] NOT NULL,
									[BIT_UPDATE] [bit] NOT NULL,
									[BIT_SHIFT] [int] NULL,
									[BIT_REMARKS] [bit] NOT NULL,
									[REMARKS_TIME_LOG] [varchar](max) NULL,
									[USER_MOD] [varchar](max) NULL,
									[DATE_MOD] [datetime] NULL
									)

	declare @tempTblTimeLogsCalendar table(
									empId varchar(MAX),
									calMonth int,
									calDay int,
									[NO_TIME_LOG] [int] NULL,
									lilorequestno int null,
									otrequestno int null,
									datetimelog datetime
									)
	declare @tempTblEmpId table(
									empId int
									)

	INSERT @tempTblTimeLogs
	SELECT	[NO_TIME_LOG],[NO_EMPLOYEE_ID],[TIME_IN_LOG_DATE],[TIME_IN],[TIME_IN_MANUAL],[TIME_OUT_LOG_DATE],[TIME_OUT],[TIME_OUT_MANUAL],[NO_SITE],[NO_AREA],
		    [NO_DEPARTMENT],[BIT_DELETED],[BIT_UPDATE],[BIT_SHIFT],[BIT_REMARKS],[REMARKS_TIME_LOG],[USER_MOD],[DATE_MOD]
    --FROM [DatabaseMBGSP2.0].[dbo].[TblTimeLog]
	from [MBGSPMainDB].[dbo].[TKTimelogs]
    WHERE (convert(date, TIME_IN_LOG_DATE) >= convert(date, @datefrom) AND convert(date, TIME_IN_LOG_DATE) <= convert(date, @dateto))
    ORDER BY NO_TIME_LOG DESC

	INSERT INTO @tempTblEmpId
	SELECT [Employee_ID] --set top N for debugging
	FROM [MBGSPMainDB].[dbo].[CommonEmployeesActive]
	WHERE DeleteFlag = 0 AND Employee_ID NOT LIKE '%OJT%' AND CONVERT(INT,
													CASE
													WHEN IsNumeric(CONVERT(VARCHAR(12), Employee_ID)) = 1 THEN CONVERT(VARCHAR(12), Employee_ID)
													ELSE 0 END) >= 20000000 --and Employee_ID = '20169690'
	group by Employee_ID 
	order by Employee_ID asc
	
	declare @TableID int

	while exists (select * from @tempTblEmpId)
	begin

		select @TableID = (select top 1 empId
						   from @tempTblEmpId
						   order by empId asc)

		set @noOfDaysMonthFrom = DAY(EOMONTH(@datefrom)) 
		set @noOfDaysMonthTo = DAY(EOMONTH(@dateto))
		set @MonthsFrom = month(@datefrom)
		set @MonthsTo = month(@dateto)
		set @dayOfMonthFromTemp = day(@datefrom)
		set @dayOfMonthToTemp = day(@dateto)
		set @yearfrom = year(@datefrom)
		set @yearto = year(@dateto)
		declare @monthctr int
		declare @dayctr int
		declare @daylimitctr int

		if(@yearfrom = @yearto)
		begin
			if(month(@datefrom) = month(@dateto))
			begin
				declare @ctr int
				declare @endctr int
				declare @currentrowdate date

				set @ctr = @dayOfMonthFromTemp
				set @endctr = @dayOfMonthToTemp

				while(@ctr <= @endctr)
				begin
					set @currentrowdate = datefromparts(year(@datefrom), @MonthsFrom, @ctr)
					INSERT INTO @tempTblTimeLogsCalendar (empId,calMonth,calDay,[NO_TIME_LOG],lilorequestno,otrequestno,datetimelog)
					VALUES (@TableID,@MonthsFrom,@ctr,
							(SELECT top 1 NO_TIME_LOG FROM @tempTblTimeLogs WHERE day(TIME_IN_LOG_DATE) = @ctr AND month(TIME_IN_LOG_DATE) = @MonthsFrom AND NO_EMPLOYEE_ID = @TableID),
							(SELECT aa.user_requests_id
							 from [MBGSPMainDB].dbo.CommonRequests aa
							 inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] bb
							 on aa.module_id = bb.user_lilo_id and aa.request_type = 1
							 WHERE aa.employee_id = @TableID AND (convert(date,bb.manual_log_in) = convert(date,@currentrowdate)) AND aa.is_status = 2 AND aa.is_delete <> 1),
							 (SELECT top 1 aa.user_requests_id  --top 1 due to user request having the same date_login
							 from [MBGSPMainDB].dbo.CommonRequests aa
							 inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] bb
							 on aa.module_id = bb.user_overtime_id and aa.request_type = 2
							 WHERE aa.employee_id = @TableID AND (convert(date,bb.date_login) = convert(date,@currentrowdate)) AND aa.is_status = 2 AND aa.is_delete <> 1),
							 @currentrowdate
						   )
				
					--select @currentrowdate --fordebugging
				
					set @ctr = @ctr + 1
				end
			end
			else
			begin
				
				set @monthctr = @MonthsFrom
			
				while(@monthctr <= @MonthsTo)
				begin
					
					if(@monthctr = @MonthsTo)
					begin
						set @dayctr = 1
						set @daylimitctr = @dayOfMonthToTemp
					end
					else
					begin
						set @dayctr = @dayOfMonthFromTemp
						set @daylimitctr = @noOfDaysMonthFrom
					end
					while(@dayctr <= @daylimitctr)
					begin
						set @currentrowdate = datefromparts(year(@datefrom), @monthctr, @dayctr)
						INSERT INTO @tempTblTimeLogsCalendar (empId,calMonth,calDay,[NO_TIME_LOG],lilorequestno,otrequestno,datetimelog)
						VALUES (@TableID,@monthctr,@dayctr,
								(SELECT top 1 NO_TIME_LOG FROM @tempTblTimeLogs WHERE day(TIME_IN_LOG_DATE) = @dayctr AND month(TIME_IN_LOG_DATE) = @monthctr AND NO_EMPLOYEE_ID = @TableID),
								(SELECT aa.user_requests_id
								 from [MBGSPMainDB].dbo.CommonRequests aa
								 inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] bb
								 on aa.module_id = bb.user_lilo_id and aa.request_type = 1
								 WHERE aa.employee_id = @TableID AND (convert(date,bb.manual_log_in) = convert(date,@currentrowdate)) AND aa.is_status = 2 AND aa.is_delete <> 1
								),
								(SELECT top 1 aa.user_requests_id --top 1 due to user request having the same date_login
								 from [MBGSPMainDB].dbo.CommonRequests aa
								 inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] bb
								 on aa.module_id = bb.user_overtime_id and aa.request_type = 2
								 WHERE aa.employee_id = @TableID AND (convert(date,bb.date_login) = convert(date,@currentrowdate)) AND aa.is_status = 2 AND aa.is_delete <> 1
								),
								@currentrowdate
							   )
						set @dayctr = @dayctr + 1

						--select @currentrowdate --fordebugging
					end
					set @monthctr = @monthctr + 1
				end
			end
		end
		else
		begin
				declare @yearctr int
				set @yearctr = @yearfrom

				while(@yearctr <= @yearto)
				begin
					--declare @monthctr int
					set @monthctr = @MonthsFrom
					
					while(@monthctr <> 2) --there is a reset down at the bottom which resets the month to 1 if 12 is chosen so we just need to check if month is january already. only applicable for different year on dec - january
					begin
						--declare @dayctr int
						--declare @daylimitctr int
						if(@monthctr = @MonthsTo)
						begin
							set @dayctr = 1
							set @daylimitctr = @dayOfMonthToTemp
						end
						else
						begin
							set @dayctr = @dayOfMonthFromTemp
							set @daylimitctr = @noOfDaysMonthFrom
						end
						while(@dayctr <= @daylimitctr)
						begin
							set @currentrowdate = datefromparts(@yearctr, @monthctr, @dayctr)
							INSERT INTO @tempTblTimeLogsCalendar (empId,calMonth,calDay,[NO_TIME_LOG],lilorequestno,otrequestno,datetimelog)
							VALUES (@TableID,@monthctr,@dayctr,
									(SELECT top 1 NO_TIME_LOG FROM @tempTblTimeLogs WHERE day(TIME_IN_LOG_DATE) = @dayctr AND month(TIME_IN_LOG_DATE) = @monthctr AND NO_EMPLOYEE_ID = @TableID),
									(SELECT aa.user_requests_id
									 from [MBGSPMainDB].dbo.CommonRequests aa
									 inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] bb
									 on aa.module_id = bb.user_lilo_id and aa.request_type = 1
									 WHERE aa.employee_id = @TableID AND (convert(date,bb.manual_log_in) = convert(date,@currentrowdate)) AND aa.is_status = 2 AND aa.is_delete <> 1
									),
									(SELECT top 1 aa.user_requests_id --top 1 due to user request having the same date_login
									 from [MBGSPMainDB].dbo.CommonRequests aa
									 inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] bb
									 on aa.module_id = bb.user_overtime_id and aa.request_type = 2
									 WHERE aa.employee_id = @TableID AND (convert(date,bb.date_login) = convert(date,@currentrowdate)) AND aa.is_status = 2 AND aa.is_delete <> 1
									),
									@currentrowdate
								   )
							set @dayctr = @dayctr + 1

							--select @currentrowdate --fordebugging
						end
						set @monthctr = @monthctr + 1
						if(@monthctr > 12) --last month is december
						begin
							set @monthctr = 1
						end
						set @yearctr = @yearctr + 1
					end
				end
		end

		

		delete @tempTblEmpId where empId = @TableID
	end

	declare @tempTblApprovedLILO table(
									[user_lilo_id] [int] NULL,
									[userliloid] [varchar](20) NULL,
									[no_time_log] [int] NULL,
									[manual_log_in] [datetime] NULL,
									[manual_log_out] [datetime] NULL,
									[reason] [varchar](300) NULL,
									[BIT_TK_TYPE] [int] NULL,
									liloreqnum int null,
									liloreqnumformat varchar(50) null
									)

	declare @tempTblApprovedOT table(
									[user_overtime_id] [int] NULL,
									[userovertimeid]  [varchar](20) NULL,
									[date_overtime_from] [datetime] NULL,
									[date_overtime_to] [datetime] NULL,
									[no_of_hours] [decimal](10, 2) NULL,
									[approved_no_of_hours] [decimal](10, 2) NULL,
									[reason] [varchar](max) NULL,
									otreqnum int null,
									otreqnumformat varchar(50) null
									)

	insert into @tempTblApprovedLILO
	SELECT b.[user_lilo_id]
		  ,b.[userliloid]
		  ,b.[no_time_log]
		  ,b.[manual_log_in]
		  ,b.[manual_log_out]
		  ,b.[reason]
		  ,BIT_TK_TYPE
		  ,a.user_requests_id
		  ,concat('REQ', a.user_requests_id) as userrequestsid
	from dbo.CommonRequests a
	inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] b
	on a.module_id = b.user_lilo_id and a.request_type = 1 AND a.is_status = 2 AND a.is_delete <> 1

	insert into @tempTblApprovedOT
	select [user_overtime_id]
		  ,[userovertimeid]
		  ,[date_overtime_from]
		  ,[date_overtime_to]
		  ,[no_of_hours]
		  ,[approved_no_of_hours]
		  ,[reason]
		  ,a.user_requests_id
		  ,concat('REQ', a.user_requests_id) as userrequestsid
	from dbo.CommonRequests a
	inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] b
	on a.module_id = b.user_overtime_id and a.request_type = 2 AND a.is_status = 2 AND a.is_delete <> 1

	select 
	a.empId as temp_employeeid,
	--a.NO_TIME_LOG as temp_notimelog,
	--b.employeee_id_no,
	--b.employee_fullname,
	concat(e.LastName, ', ', e.FirstName) as employee_fullname,
	e.site_location,
	(select top 1 AreaCode from [MBGSPMainDB].[dbo].[CommonArea] where AreaId = e.AreaID) as area_id,
	datename(dw, a.datetimelog) as dayoftheweek,
	case when(d.user_lilo_id IS NOT NULL)
		 then convert(varchar, convert(date, d.manual_log_in), 23)
		 else convert(varchar, a.datetimelog, 23)
		 end as time_in_log_date,
	case when(d.user_lilo_id IS NOT NULL)
		 then convert(varchar, d.manual_log_in, 22)
		 else convert(varchar, b.time_in, 22)
		 end as time_in,
	case when(d.user_lilo_id IS NOT NULL)
		 then convert(varchar, convert(date, d.manual_log_out), 23)
		 else convert(varchar, b.time_out_log_date, 23)
		 end as time_out_log_date,
	case when(d.user_lilo_id IS NOT NULL)
		 then convert(varchar, d.manual_log_out, 22)
		 else convert(varchar, b.time_out, 22)
		 end as time_out,
	case when(d.user_lilo_id IS NOT NULL)
		 then (cast((datediff(minute,d.manual_log_in,d.manual_log_out))/60 AS varchar(5))+ ' hours' + ' '+ cast( (datediff(minute,d.manual_log_in,d.manual_log_out))%60 AS varchar(2))+' minutes')
		 else b.working_hours
		 end as Working_hours,
	--b.work_arrangement,
	case when(d.user_lilo_id IS NOT NULL)
		 then d.[BIT_TK_TYPE]
		 else b.work_arrangement
		 end as work_arrangement,
	b.nsd,
	d.liloreqnumformat as templiloreqnum,
	c.otreqnumformat as tempotreqnum,
	c.no_of_hours,
	c.approved_no_of_hours,
	case when(b.time_in IS NULL OR d.user_lilo_id IS NULL)
		 then (select top 1 concat(case when(NO_LEAVE_TYPE = 1) then 'VL'
										 when(NO_LEAVE_TYPE = 2) then 'CL'
										 when(NO_LEAVE_TYPE = 3) then 'SL'
										 when(NO_LEAVE_TYPE = 4) then 'EL'
										 when(NO_LEAVE_TYPE = 5) then 'BL'
										 when(NO_LEAVE_TYPE = 6) then 'MRL'
										 when(NO_LEAVE_TYPE = 7) then 'MNCL'
										 when(NO_LEAVE_TYPE = 8) then 'METPL'
										 when(NO_LEAVE_TYPE = 9) then 'PL'
										 when(NO_LEAVE_TYPE = 10) then 'MNCWL'
										 when(NO_LEAVE_TYPE = 11) then 'SPL'
									end,
									' Request No:',
									NO_PROCESS_REQUEST 
									)
				from @approvedleaves where NO_EMPLOYEE_ID = a.empId AND (convert(date, a.datetimelog) >= convert(date, DATE_FROM) AND convert(date, a.datetimelog) <= convert(date, DATE_TO) ))--use a.datetimelog
		 end as leave_request
	--b.remarks
	from @tempTblTimeLogsCalendar a
	left join @tempreportstable b on a.empId=b.employeee_id_no AND datefromparts(year(getdate()), a.calMonth, a.calDay) = convert(date, b.time_in)
	left join @tempTblApprovedOT c on a.otrequestno = c.otreqnum
	left join @tempTblApprovedLILO d on a.lilorequestno = d.liloreqnum
	left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] e on a.empId = e.Employee_ID
	end try
	begin catch
	EXECUTE SPCommonGetErrorInfo
	end catch
	
	
	--select * from @approvedleaves
	--commented for raw reports data development
	/*select * from @tempTblTimeLogsCalendar a
	left join @tempreportstable b on a.empId=b.employeee_id_no AND datefromparts(year(getdate()), a.calMonth, a.calDay) = convert(date, b.time_in)
	left join [MBGSPMainDB].[dbo].[TKRequestsOvertime] c on a.otrequestno = c.user_overtime_id
	left join [MBGSPMainDB].[dbo].[TKRequestsLILO] d on a.lilorequestno = d.user_lilo_id*/
END

/*
exec [dbo].[SPTKGetAllEmployeeHRTKReportsV2]
@datefrom = '2023-05-09 13:51:47',
@dateto = '2023-05-30 13:51:47'

exec [dbo].[SPTKGetAllEmployeeHRTKReports]
@datefrom = '2023-04-16',
@dateto = '2023-04-30'

exec [dbo].[SPTKGetAllEmployeeHRTKReports]
@datefrom = '2023-02-01',
@dateto = '2023-02-07'

exec [dbo].[SPTKGetAllEmployeeHRTKReports]
@datefrom = '2023-02-24',
@dateto = '2023-03-09'
{
�� dateFrom : "2023-02-01",
�� dateTo : "2023-02-28"
}
*/



/*
to be used

SELECT a.userrequestsid
	   from dbo.TKRequests a
	   inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] b
	   on a.module_id = b.user_lilo_id and a.request_type = 1
	   WHERE a.employee_id = NO_EMPLOYEE_ID AND (convert(date,b.manual_log_in) >= @datefrom AND convert(date,b.manual_log_in) <= @dateto)



SELECT a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, concat(c.FirstName, ' ', c.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
		       b.date_overtime_from, b.date_overtime_to, 
			   b.no_of_hours, --no of hours on request 
			   (select convert(decimal(10,2), convert(decimal(10,2), datediff(MINUTE, TIME_IN, TIME_OUT))/60) - 9 from [DatabaseMBGSP2.0].[dbo].[TblTimeLog] where convert(date, b.date_overtime_from) = convert(date, TIME_IN) AND NO_EMPLOYEE_ID = a.employee_id) as no_of_hours_from_logs,
			   b.reason
		from dbo.TKRequests a
		inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] b
		on a.module_id = b.user_overtime_id and a.request_type = 2
		left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c 
		on a.employee_id = c.Employee_ID
		WHERE a.employee_id = @EmployeeId AND (convert(date,b.date_overtime_from) >= @datefrom AND convert(date,b.date_overtime_from) <= @dateto)



************ LMT

(
				   SELECT TOP 1 --a.[NO_PROCESS_TRACKER]
				   aa.[NO_PROCESS_REQUEST]
				   --,a.[TRACKER_DATE]
				   --,a.[NO_PROCESS_ROUTING]
				   --,a.[TRACKER_STATUS]
				   --,b.[NO_EMPLOYEE_ID]
				   --,vldates.DATE_FROM as vldatesfrom
				   --,vldates.DATE_TO as vldatesto
				   --,cldates.DATE_FROM as cldatesfrom
				   --,cldates.DATE_TO as cldatesto
				   --,sldates.DATE_FROM as sldatesfrom
				   --,sldates.DATE_TO as sldatesto
				  FROM [LeaveManagementSystem].[dbo].[TblProcessTracker] aa
				  LEFT JOIN [LeaveManagementSystem].[dbo].[TblProcessRequestDetail] bb
				  ON aa.NO_PROCESS_REQUEST = bb.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestVL] vl
				  on aa.NO_PROCESS_REQUEST = vl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestVLDates] vldates
				  on vl.NO_LEAVE_REQUEST = vldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestCL] cl
				  on aa.NO_PROCESS_REQUEST = cl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestCLDates] cldates
				  on cl.NO_LEAVE_REQUEST = cldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSL] sl
				  on aa.NO_PROCESS_REQUEST = sl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSLDates] sldates
				  on sl.NO_LEAVE_REQUEST = sldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestEL] el
				  on aa.NO_PROCESS_REQUEST = el.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestELDates] eldates
				  on el.NO_LEAVE_REQUEST = eldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestBL] bl
				  on aa.NO_PROCESS_REQUEST = bl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestBLDates] bldates
				  on bl.NO_LEAVE_REQUEST = bldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMRL] mrl
				  on aa.NO_PROCESS_REQUEST = mrl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMRLDates] mrldates
				  on mrl.NO_LEAVE_REQUEST = mrldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCL] mncl
				  on aa.NO_PROCESS_REQUEST = mncl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCLDates] mncldates
				  on mncl.NO_LEAVE_REQUEST = mncldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMETPL] metpl
				  on aa.NO_PROCESS_REQUEST = metpl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMETPLDates] metpldates
				  on metpl.NO_LEAVE_REQUEST = metpldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestPL] pl
				  on aa.NO_PROCESS_REQUEST = pl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestPLDates] pldates
				  on pl.NO_LEAVE_REQUEST = pldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCWL] mncwl
				  on aa.NO_PROCESS_REQUEST = mncwl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCWLDates] mncwldates
				  on mncwl.NO_LEAVE_REQUEST = mncwldates.NO_LEAVE_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSPL] spl
				  on aa.NO_PROCESS_REQUEST = spl.NO_PROCESS_REQUEST
				  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSPLDates] spldates
				  on spl.NO_LEAVE_REQUEST = spldates.NO_LEAVE_REQUEST
				  WHERE aa.TRACKER_STATUS = 'Approved' AND bb.NO_EMPLOYEE_ID = a.NO_EMPLOYEE_ID AND
				  (
					convert(date, vldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, vldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, cldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, cldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, sldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, sldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, eldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, eldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, bldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, bldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, mrldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, mrldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, mncldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, mncldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, metpldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, metpldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, pldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, pldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, mncwldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, mncwldates.DATE_TO) <= TIME_IN_LOG_DATE OR
					convert(date, spldates.DATE_FROM) >= TIME_IN_LOG_DATE AND convert(date, spldates.DATE_TO) <= TIME_IN_LOG_DATE
				  )
				  ORDER BY NO_PROCESS_TRACKER DESC
				) as leaverequestid

				

				  SELECT TOP 1 --a.[NO_PROCESS_TRACKER]
		   a.[NO_PROCESS_REQUEST]
		   --,a.[TRACKER_DATE]
		   --,a.[NO_PROCESS_ROUTING]
		   --,a.[TRACKER_STATUS]
		   --,b.[NO_EMPLOYEE_ID]
		   --,vldates.DATE_FROM as vldatesfrom
		   --,vldates.DATE_TO as vldatesto
		   --,cldates.DATE_FROM as cldatesfrom
		   --,cldates.DATE_TO as cldatesto
		   --,sldates.DATE_FROM as sldatesfrom
		   --,sldates.DATE_TO as sldatesto
  FROM [LeaveManagementSystem].[dbo].[TblProcessTracker] a
  LEFT JOIN [LeaveManagementSystem].[dbo].[TblProcessRequestDetail] b
  ON a.NO_PROCESS_REQUEST = b.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestVL] vl
  on a.NO_PROCESS_REQUEST = vl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestVLDates] vldates
  on vl.NO_LEAVE_REQUEST = vldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestCL] cl
  on a.NO_PROCESS_REQUEST = cl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestCLDates] cldates
  on cl.NO_LEAVE_REQUEST = cldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSL] sl
  on a.NO_PROCESS_REQUEST = sl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSLDates] sldates
  on sl.NO_LEAVE_REQUEST = sldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestEL] el
  on a.NO_PROCESS_REQUEST = el.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestELDates] eldates
  on el.NO_LEAVE_REQUEST = eldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestBL] bl
  on a.NO_PROCESS_REQUEST = bl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestBLDates] bldates
  on bl.NO_LEAVE_REQUEST = bldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMRL] mrl
  on a.NO_PROCESS_REQUEST = mrl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMRLDates] mrldates
  on mrl.NO_LEAVE_REQUEST = mrldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCL] mncl
  on a.NO_PROCESS_REQUEST = mncl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCLDates] mncldates
  on mncl.NO_LEAVE_REQUEST = mncldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMETPL] metpl
  on a.NO_PROCESS_REQUEST = metpl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMETPLDates] metpldates
  on metpl.NO_LEAVE_REQUEST = metpldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestPL] pl
  on a.NO_PROCESS_REQUEST = pl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestPLDates] pldates
  on pl.NO_LEAVE_REQUEST = pldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCWL] mncwl
  on a.NO_PROCESS_REQUEST = mncwl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestMNCWLDates] mncwldates
  on mncwl.NO_LEAVE_REQUEST = mncwldates.NO_LEAVE_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSPL] spl
  on a.NO_PROCESS_REQUEST = spl.NO_PROCESS_REQUEST
  left join [LeaveManagementSystem].[dbo].[TblLeaveRequestSPLDates] spldates
  on spl.NO_LEAVE_REQUEST = spldates.NO_LEAVE_REQUEST
  WHERE a.TRACKER_STATUS = 'Approved' AND
  (
	convert(date, vldates.DATE_FROM) >= '2022-11-01' AND convert(date, vldates.DATE_TO) <= '2022-11-15' OR
	convert(date, cldates.DATE_FROM) >= '2022-11-01' AND convert(date, cldates.DATE_TO) <= '2022-11-15' OR
	convert(date, sldates.DATE_FROM) >= '2022-11-01' AND convert(date, sldates.DATE_TO) <= '2022-11-15' OR
	convert(date, eldates.DATE_FROM) >= '2022-11-01' AND convert(date, eldates.DATE_TO) <= '2022-11-15' OR
	convert(date, bldates.DATE_FROM) >= '2022-11-01' AND convert(date, bldates.DATE_TO) <= '2022-11-15' OR
	convert(date, mrldates.DATE_FROM) >= '2022-11-01' AND convert(date, mrldates.DATE_TO) <= '2022-11-15' OR
	convert(date, mncldates.DATE_FROM) >= '2022-11-01' AND convert(date, mncldates.DATE_TO) <= '2022-11-15' OR
	convert(date, metpldates.DATE_FROM) >= '2022-11-01' AND convert(date, metpldates.DATE_TO) <= '2022-11-15' OR
	convert(date, pldates.DATE_FROM) >= '2022-11-01' AND convert(date, pldates.DATE_TO) <= '2022-11-15' OR
	convert(date, mncwldates.DATE_FROM) >= '2022-11-01' AND convert(date, mncwldates.DATE_TO) <= '2022-11-15' OR
	convert(date, spldates.DATE_FROM) >= '2022-11-01' AND convert(date, spldates.DATE_TO) <= '2022-11-15'
  )
  ORDER BY NO_PROCESS_TRACKER DESC



  -------------------------lmt side------------------------------
  declare @approvedleaves table(
		[NO_EMPLOYEE_ID] [varchar](max) NULL,
		[NO_LEAVE_REQUEST] int,
		[NO_PROCESS_REQUEST] int,
		[NO_LEAVE_TYPE] int,
		[NO_LEAVE_DATES] int,
		[DATE_FROM] [date] NULL,
		[DATE_TO] [date] NULL,
		[TRACKER_STATUS] [varchar](max) NULL,
		[Date_Filed] [date] NULL
	)

	insert into @approvedleaves
	select NO_EMPLOYEE_ID,
	       convert(int, NO_LEAVE_REQUEST),
		   convert(int, NO_PROCESS_REQUEST),
		   convert(int, NO_LEAVE_TYPE),
		   convert(int, NO_LEAVE_DATES),
		   DATE_FROM,
		   DATE_TO,
		   TRACKER_STATUS,
		   Date_Filed from [LeaveManagementSystem].[dbo].[MonthlyReportLeaves] 

select * from @approvedleaves where NO_EMPLOYEE_ID = '20169690'

--'2023-01-02'
--select NO_EMPLOYEE_ID ,NO_LEAVE_TYPE, NO_PROCESS_REQUEST from @approvedleaves where NO_EMPLOYEE_ID = '20169690' AND (DATE_FROM >= '2023-04-17' AND DATE_TO <= '2023-04-17')

select top 1 concat(
			case when(NO_LEAVE_TYPE = 1) then 'VL'
				 when(NO_LEAVE_TYPE = 2) then 'CL'
				 when(NO_LEAVE_TYPE = 3) then 'SL'
				 when(NO_LEAVE_TYPE = 4) then 'EL'
				 when(NO_LEAVE_TYPE = 5) then 'BL'
				 when(NO_LEAVE_TYPE = 6) then 'MRL'
				 when(NO_LEAVE_TYPE = 7) then 'MNCL'
				 when(NO_LEAVE_TYPE = 8) then 'METPL'
				 when(NO_LEAVE_TYPE = 9) then 'PL'
				 when(NO_LEAVE_TYPE = 10) then 'MNCWL'
				 when(NO_LEAVE_TYPE = 11) then 'SPL'
			end,
			' Request No:',
			NO_PROCESS_REQUEST 
			)
from @approvedleaves where NO_EMPLOYEE_ID = '20169690' AND (DATE_FROM >= '2023-04-17' AND DATE_TO <= '2023-04-17')
*/

GO
/****** Object:  StoredProcedure [dbo].[SPUserPreferenceProcedures]    Script Date: 01/12/2023 9:01:49 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPUserPreferenceProcedures]

@theme int,
@buildingid int,
@floorid int,
@zoneid int,
@user_telecommuting int,
@fixedseat int,
@username varchar(max),
@IsActive int,
@id int,
@ActionType int,
@Keyword varchar(max),
@specialdayoff int

AS

BEGIN
	--GET USER PREFERENCES
	If @ActionType = 1
		Begin
			select sr_preference_id, theme, user_telecommuting, buildingid, floorid, zoneid, specialdayoff from 
                dbo.CommonPreference
                where Username = @username
		End
	--SAVE USER PREFERENCES
	If @ActionType = 2
		Begin
		 insert into dbo.CommonPreference(theme, buildingid, floorid, username)
                values 
                    (
                    @theme
                    ,@buildingid
                    ,@floorid
                    ,@username
                    )
		End
	--UpdateUserPreference
	If @ActionType = 3
		Begin
		  update dbo.CommonPreference set 
                    theme = @theme
                    ,buildingid = @buildingid
                    ,floorid = @floorid
                    where sr_preference_id = @id
		End
	--StatusUpdate/Delete
	If @ActionType = 4
		Begin
			update dbo.CommonAnnouncement set 
                    is_Active = @IsActive
                    where announcement_id = @id
		End
	--SaveTelecommutingOfUser
	If @ActionType = 4
		Begin
			insert into dbo.CommonPreference(user_telecommuting, fixedseat, username, zoneid)
                values 
                    (
                    @user_telecommuting
                    ,@fixedseat
                    ,@username
                    ,@zoneid
                    )
		End
	--UpdateTelecommutingOfUser
	If @ActionType = 5
		Begin
		 update dbo.CommonPreference
                set user_telecommuting = @user_telecommuting,
                fixedseat = @fixedseat,
                zoneid = @zoneid
                where sr_preference_id = @id
		End
	--GetUser
	If @ActionType = 6
	Begin
		declare @isApprover int

				if exists (select a.AreaId from [MBGSPMainDB].[dbo].[CommonAreaApprovers] a where FirstApproverUsername = @username OR SecondApproverUsername = @username)
				begin
					set @isApprover = 1
				end
				else
				begin
					set @isApprover = 0
				end

                select
                    dbo.CommonEmployeesActive.Employee_ID,
                    ticketSupportAccess = (select count(is_active) active  from RequestTypeGroup where employee_id = CommonEmployeesActive.Employee_ID and is_active = 1),
                    ticketSupportAccessAdmin = (select count(is_active) active  from RequestTypeGroup where employee_id = CommonEmployeesActive.Employee_ID and is_active = 1 and RequestTypeGroup.member_type = 1),
                    dbo.CommonEmployeesActive.FirstName,
                    dbo.CommonEmployeesActive.LastName,
                    dbo.CommonEmployeesActive.MiddleName,
                    dbo.CommonEmployeesActive.FullName,
                    dbo.CommonEmployeesActive.Phone_number,
                    dbo.CommonEmployeesActive.BusinessP_number,
                    dbo.CommonEmployeesActive.Email_Address,
                    dbo.CommonEmployeesActive.Home_Address1,
                    dbo.CommonEmployeesActive.City,
                    dbo.CommonEmployeesActive.Country,
                    dbo.CommonEmployeesActive.Postal_ID,
                    dbo.CommonEmployeesActive.Employee_Status,
                    dbo.CommonEmployeesActive.Department,
                    dbo.CommonEmployeesActive.Direct_SuperiorID,
                    dbo.CommonEmployeesActive.Site_Location,
                    dbo.CommonEmployeesActive.isFulltime,
                    dbo.CommonEmployeesActive.NewAddress,
                    dbo.CommonEmployeesActive.NewPhoneNumber,
                    dbo.CommonEmployeesActive.UserID, 
                    dbo.CommonEmployeesActive.AreaID,
                    dbo.CommonEmployeesActive.Job_Level,
                    dbo.CommonEmployeesActive.Department_CostCenterID,
                    dbo.CommonUserRoles.Roles,
                    dbo.CommonUserRoles.User_id,
                    dbo.CommonPreference.buildingid,
                    dbo.CommonPreference.floorid,
                    dbo.CommonPreference.sr_preference_id,
                    dbo.CommonPreference.theme,
                    dbo.CommonPreference.fixedseat,
                    dbo.SRSeat.seat_number,
                    dbo.CommonPreference.user_telecommuting,
                    dbo.CommonPreference.zoneid,
                    dbo.CommonEmployeeAdditionalDetails.ProvincialAdd_LotBlockHouseNoStreet,
                    dbo.CommonEmployeeAdditionalDetails.ProvincialAdd_SubdivisionVillageZone,
                    dbo.CommonEmployeeAdditionalDetails.ProvincialAdd_Barangay,
                    dbo.CommonEmployeeAdditionalDetails.ProvincialAdd_Municipality,
                    dbo.CommonEmployeeAdditionalDetails.ProvincialAdd_Province,
                    dbo.CommonEmployeeAdditionalDetails.ProvincialAdd_ZipCode,
                    dbo.CommonEmployeeAdditionalDetails.Undergraduate_School,
                    dbo.CommonEmployeeAdditionalDetails.Course,
                    dbo.CommonEmployeeAdditionalDetails.Postgraduate_School,
                    dbo.CommonEmployeeAdditionalDetails.Masteral_Degree,
                    dbo.CommonEmployeeTravelDataVisa.Visa_Number,
                    dbo.CommonEmployeeTravelDataVisa.Visa_Country,
                    dbo.CommonEmployeeTravelDataVisa.Visa_Category,
                    dbo.CommonEmployeeTravelDataVisa.Visa_Validity,
                    dbo.CommonEmployeeTravelDataVisa.Visa_NoOfEntries,
                    dbo.CommonEmployeeTravelDataVisa.Visa_File,
                    dbo.CommonEmployeeAdditionalDetails.Passport_Number,
                    dbo.CommonEmployeeAdditionalDetails.Passport_Validity,
                    dbo.CommonEmployeeAdditionalDetails.Passport_File,
                    dbo.CommonEmployeeAdditionalDetails.EmergencyFirstName,
                    dbo.CommonEmployeeAdditionalDetails.EmergencyLastName,
                    dbo.CommonEmployeeAdditionalDetails.EmergencyMobilePhone,
                    dbo.CommonEmployeeAdditionalDetails.EmergencyRelation,
                    dbo.CommonEmployeeAdditionalDetails.EmergencyPermanentAddress,
                    dbo.CommonEmployeeAdditionalDetails.Additional_Language,
                    dbo.CommonEmployeeAdditionalDetails.Additional_Skills,
                    dbo.CommonEmployeeAdditionalDetails.Language_Level,
                    dbo.CommonArea.Description,
                    dbo.CommonAreaApprovers.FirstApproverFullname,
                    dbo.CommonAreaApprovers.SecondApproverFullname,
                    dbo.CommonShift.ShiftName,
                    dbo.CommonEmployeePhoto.Path,
					@isApprover as isApprover
                    from
	                dbo.CommonEmployeesActive left join dbo.CommonUserRoles 
	                on 
	                dbo.CommonEmployeesActive.UserId = dbo.CommonUserRoles.Username
	                left join dbo.CommonPreference
	                on
	                dbo.CommonEmployeesActive.UserID = dbo.CommonPreference.username
                    left join dbo.SRSeat
                    on
                    dbo.CommonPreference.fixedseat = dbo.SRSeat.seat_id
                    left join dbo.CommonEmployeePhoto
	                on
	                dbo.CommonEmployeesActive.Employee_ID = dbo.CommonEmployeePhoto.EmployeeID
                    left join dbo.CommonEmployeeAdditionalDetails
                    on dbo.CommonEmployeesActive.Employee_ID = dbo.CommonEmployeeAdditionalDetails.EmployeeID
                    left join dbo.CommonEmployeeTravelDataVisa
                    on dbo.CommonEmployeesActive.Employee_ID = dbo.CommonEmployeeTravelDataVisa.EmployeeID
                    left join dbo.CommonArea
                    on dbo.CommonEmployeesActive.AreaID = dbo.CommonArea.AreaId
                    left join dbo.CommonAreaApprovers
                    on dbo.CommonAreaApprovers.AreaID = dbo.CommonArea.AreaId
                    left join dbo.CommonShift
                    on dbo.CommonEmployeesActive.Shifts = dbo.CommonShift.ShiftId
                    left join dbo.CommonEmployeeSite
                    on 
                    dbo.CommonEmployeesActive.Site_LocationCode = dbo.CommonEmployeeSite.Site_ID
                        where dbo.CommonEmployeesActive.UserID  = @username
	End
END


GO
