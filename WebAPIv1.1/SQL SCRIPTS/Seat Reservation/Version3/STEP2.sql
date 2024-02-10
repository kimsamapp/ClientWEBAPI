USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresBuildingMasterfile]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresDashboard]    Script Date: 09/11/2023 3:32:16 pm ******/
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
			where convert(date, Date_Start_CutOff_Period) <= convert(date, getdate()) AND convert(date, Date_End_CutOff_Period) >= convert(date, getdate())
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresFloorMasterfile]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresGS]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresLocationMasterfile]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresReservationPage]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresReservationsPage]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresSeatMasterfile]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresSetup]    Script Date: 09/11/2023 3:32:16 pm ******/
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
@Keyword varchar(max)

AS
BEGIN
	--get
	If @ActionType = 1
		Begin
			SELECT a.[SpecialDayOffId]
      ,a.[SpecialIDF]
      ,a.[IsActive]
      ,a.[Date]
      ,a.[Username]
      ,a.[Datestamp],
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
END	
GO
/****** Object:  StoredProcedure [dbo].[SPSRProceduresTK]    Script Date: 09/11/2023 3:32:16 pm ******/
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
			values(@NO_EMPLOYEE_ID, (SELECT CONVERT(date, @TIME_IN_LOG_DATE)), (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),@NO_SITE, @NO_AREA, 0, 0, 1, 'tksradmin', (SELECT GETDATE()), 2)

				UPDATE dbo.SRReservation set 
					seat_reservation_status = 2
					,seat_reservation_check_in = (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE))
					where seatreservationid = @RsvId
		End
		
		-- WITO 
		If @ActionType = 2
		Begin
			INSERT INTO [MBGSPMainDB].[dbo].[TKTimelogs](NO_EMPLOYEE_ID,TIME_IN_LOG_DATE,TIME_IN, NO_SITE,NO_AREA, BIT_DELETED, BIT_UPDATE, BIT_REMARKS, USER_MOD, DATE_MOD, BIT_TK_TYPE)
			values(@NO_EMPLOYEE_ID, (SELECT CONVERT(date, @TIME_IN_LOG_DATE)), (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),@NO_SITE, @NO_AREA, 0, 0, 1, 'tksradmin', (SELECT GETDATE()), 1)

			UPDATE dbo.SRReservation set 
                    seat_reservation_status = 2
                    ,seat_reservation_check_in = (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE))
                    where seatreservationid = @RsvId
		End

		--Travel/External Training
		if @ActionType = 3
		Begin
			INSERT INTO [MBGSPMainDB].[dbo].[TKTimelogs](NO_EMPLOYEE_ID,TIME_IN_LOG_DATE,TIME_IN, NO_SITE,NO_AREA, BIT_DELETED, BIT_UPDATE, BIT_REMARKS, USER_MOD, DATE_MOD, BIT_TK_TYPE)
			values(@NO_EMPLOYEE_ID, (SELECT CONVERT(date, @TIME_IN_LOG_DATE)), (SELECT CONVERT(datetime, @TIME_IN_LOG_DATE)),@NO_SITE, @NO_AREA, 0, 0, 1, 'tksradmin', (SELECT GETDATE()), 3)
		
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresUsersPage]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRProceduresZoneMasterfile]    Script Date: 09/11/2023 3:32:16 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRSearchReservationAvailable]    Script Date: 09/11/2023 3:32:16 pm ******/
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
		AND (SRFloor.priorityid = 1 OR SRFloor.priorityid = 2)

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
		AND 
		(SRFloor.priorityid = 1 OR SRFloor.priorityid = 2)
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
GO
/****** Object:  StoredProcedure [dbo].[SPUserPreferenceProcedures]    Script Date: 09/11/2023 3:32:16 pm ******/
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
