USE [MBGSPMainDB]
GO
/****** Object:  Table [dbo].[CommonExternalType]    Script Date: 16/11/2023 9:08:08 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CommonExternalType](
	[CExternalTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CExternalTypeIDF]  AS (concat('ETYPE-',[CExternalTypeID])) PERSISTED NOT NULL,
	[Name] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[IsActive] [int] NULL,
	[CreatedBy] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CExternalTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CommonExternalUsers]    Script Date: 16/11/2023 9:08:08 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CommonExternalUsers](
	[CExternalUID] [int] IDENTITY(1,1) NOT NULL,
	[CExternalUIDF]  AS (concat('EID-',[CExternalUID])) PERSISTED NOT NULL,
	[Employee_ID] [varchar](100) NULL,
	[UserID] [varchar](100) NULL,
	[FirstName] [varchar](250) NULL,
	[LastName] [varchar](250) NULL,
	[MiddleName] [varchar](250) NULL,
	[Phone_number] [varchar](100) NULL,
	[Site_Location] [varchar](100) NULL,
	[UserType] [int] NULL,
	[IsActive] [int] NULL,
	[CreatedBy] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CExternalUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SPCEEmployeeSiteProcedures]    Script Date: 16/11/2023 9:08:08 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPCEExternalTypeProcedures]    Script Date: 16/11/2023 9:08:08 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPCEExternalUsersProcedures]    Script Date: 16/11/2023 9:08:08 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPSRSearchReservationAvailable]    Script Date: 16/11/2023 9:08:08 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SPSRSearchReservationAvailable]

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
