USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPSRSearchReservationAvailable]    Script Date: 09/11/2023 4:06:40 pm ******/
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