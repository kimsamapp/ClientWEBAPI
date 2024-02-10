USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPGetUsers]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

ALTER PROCEDURE [dbo].[SPGetUsers]  

 

AS

 

BEGIN
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
        where dbo.CommonEmployeesActive.DeleteFlag = 0
END
GO
/****** Object:  StoredProcedure [dbo].[SPGetUsersBySearchKeyword]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

ALTER PROCEDURE [dbo].[SPGetUsersBySearchKeyword]

 

@SearchKeyword varchar(max)

 

AS

 

BEGIN
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
        dbo.CommonEmployeesActive.isFulltime,
        dbo.CommonEmployeesActive.NewAddress,
        dbo.CommonEmployeesActive.NewPhoneNumber,
        dbo.CommonEmployeesActive.UserID, 
        dbo.CommonEmployeesActive.AreaID,
        dbo.CommonEmployeesActive.Shifts,
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
        dbo.CommonPreference.zoneid,
        dbo.SRZone.zone_name,
        dbo.CommonArea.[Description],
        dbo.CommonShift.ShiftName,
        dbo.CommonEmployeeSite.Site_Name,
        dbo.CommonEmployeesActive.Site_LocationCode,
        dbo.CommonEmployeesActive.PromotionDate,
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
			left join dbo.SRZone
			on
			dbo.CommonPreference.zoneid = dbo.SRZone.zone_id
			left join dbo.CommonArea
			on
			dbo.CommonEmployeesActive.AreaID = dbo.CommonArea.AreaId
			left join dbo.CommonShift
			on
				dbo.CommonEmployeesActive.Shifts = dbo.CommonShift.ShiftId
			left join dbo.CommonEmployeeSite
			on 
			dbo.CommonEmployeesActive.Site_LocationCode = dbo.CommonEmployeeSite.Site_ID
			where 
			dbo.CommonEmployeesActive.DeleteFlag = 0 and (
				dbo.CommonEmployeesActive.LastName LIKE '%' + @SearchKeyword + '%' 
				OR dbo.SRRoles.rolename LIKE '%' + @SearchKeyword + '%'  
				OR dbo.CommonEmployeesActive.Employee_ID LIKE '%' + @SearchKeyword + '%' 
				OR dbo.CommonEmployeesActive.FirstName LIKE '%' + @SearchKeyword + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[SPTKGetAllEmployeeHRTKReports]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:������� <Author,,Name>
-- Create date: <Create Date,,>
-- Description:��� <Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPTKGetAllEmployeeHRTKReports]
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
				case when exists(SELECT tas.NO_ACTION FROM [DatabaseMBGSP2.0].[dbo].[TblTimeLogActionStep] tas where tas.NO_TIME_LOG = a.NO_TIME_LOG AND (tas.NO_ACTION = 1 OR tas.NO_ACTION = 2)) 
					 then 'WITO'
				when exists(SELECT tas.NO_ACTION FROM [DatabaseMBGSP2.0].[dbo].[TblTimeLogActionStep] tas where tas.NO_TIME_LOG = a.NO_TIME_LOG AND (tas.NO_ACTION = 3 OR tas.NO_ACTION = 4 OR tas.NO_ACTION = 5)) 
						 then 'WFH'
				else '-'
						 end as work_arrangement,
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
	b.work_arrangement,
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
exec [dbo].[SPTKGetAllEmployeeHRTKReports]
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
/****** Object:  StoredProcedure [dbo].[SPTKGetEmployeeTimelogs]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SPTKGetEmployeeTimelogs] 
@EmployeeId as varchar(30),
@datefrom as datetime, 
@dateto as datetime
AS
BEGIN
	declare @tempTblApprovedLILO table(
									[user_lilo_id] [int] NULL,
									[userliloid] [varchar](20) NULL,
									[no_time_log] [int] NULL,
									[manual_log_in] [datetime] NULL,
									[manual_log_out] [datetime] NULL,
									[reason] [varchar](300) NULL,
									liloreqnum int null,
									liloreqnumformat varchar(50) null,
									empid varchar(50) null,
									BIT_TK_TYPE int null
									)

	declare @tempTblLogs table(
								[NO_TIME_LOG] [int]  NULL,
								[NO_EMPLOYEE_ID] [varchar](max)  NULL,
								[TIME_IN_LOG_DATE] [varchar](max) NULL,
								[TIME_IN] [datetime] NULL,
								[TIME_IN_MANUAL] [varchar](max) NULL,
								[TIME_OUT_LOG_DATE] [varchar](max) NULL,
								[TIME_OUT] [datetime] NULL,
								[TIME_OUT_MANUAL] [varchar](max) NULL,
								[NO_SITE] [int] NULL,
								[NO_AREA] [int] NULL,
								[NO_DEPARTMENT] [int] NULL,
								[BIT_DELETED] [bit] NULL,
								[BIT_UPDATE] [bit] NULL,
								[BIT_SHIFT] [int] NULL,
								[BIT_REMARKS] [bit] NULL,
								[REMARKS_TIME_LOG] [varchar](max) NULL,
								[USER_MOD] [varchar](max) NULL,
								[DATE_MOD] [datetime] NULL,
								[manual_log_in] [datetime] NULL,
								[manual_log_out] [datetime] NULL,
								[user_lilo_id] [int] NULL,
								[userliloid] [varchar](20) NULL,
								liloreqnum int null,
								liloreqnumformat varchar(50) null,
								BIT_TK_TYPE int null
								)

	insert into @tempTblApprovedLILO
	SELECT b.[user_lilo_id]
		  ,b.[userliloid]
		  ,b.[no_time_log]
		  ,b.[manual_log_in]
		  ,b.[manual_log_out]
		  ,b.[reason]
		  ,a.user_requests_id
		  ,a.userrequestsid
		  ,a.employee_id
		  ,b.BIT_TK_TYPE
	from [MBGSPMainDB].dbo.CommonRequests a
	inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] b
	on a.module_id = b.user_lilo_id and a.request_type = 1 AND a.is_status = 2 AND a.is_delete <> 1 and (convert(date, @datefrom) <= convert(date, b.manual_log_in) AND convert(date, @dateto) >= convert(date, b.manual_log_in)) and a.employee_id = @EmployeeId

	insert into @tempTblLogs
	SELECT	a.[NO_TIME_LOG],[NO_EMPLOYEE_ID],[TIME_IN_LOG_DATE],[TIME_IN],[TIME_IN_MANUAL],[TIME_OUT_LOG_DATE],[TIME_OUT],[TIME_OUT_MANUAL],[NO_SITE],[NO_AREA],
		    [NO_DEPARTMENT],[BIT_DELETED],[BIT_UPDATE],[BIT_SHIFT],[BIT_REMARKS],[REMARKS_TIME_LOG],[USER_MOD],[DATE_MOD],
			b.manual_log_in as lilo_time_in, b.manual_log_out as lilo_time_out, b.user_lilo_id, b.userliloid, b.liloreqnum as user_requests_id, b.liloreqnumformat as userrequestsid, a.BIT_TK_TYPE
    FROM [MBGSPMainDB].[dbo].[TKTimelogs] a
	left join @tempTblApprovedLILO b
	on convert(date, a.TIME_IN) = convert(date, b.manual_log_in)
    WHERE NO_EMPLOYEE_ID = @employeeID AND (convert(date, TIME_IN_LOG_DATE) >= convert(date, @datefrom) AND convert(date, TIME_IN_LOG_DATE) <= convert(date, @dateto))

	declare @TableID int

	while exists (select * from @tempTblApprovedLILO)
	begin

		select @TableID = (select top 1 user_lilo_id
						   from @tempTblApprovedLILO
						   order by user_lilo_id asc)
		
		if not exists(select TIME_IN_LOG_DATE from @tempTblLogs where TIME_IN_LOG_DATE = convert(date, (select manual_log_in from @tempTblApprovedLILO where user_lilo_id = @TableID)))
		begin
			insert into @tempTblLogs (TIME_IN_LOG_DATE,[manual_log_in],[manual_log_out],[user_lilo_id],[userliloid],liloreqnum,liloreqnumformat, BIT_TK_TYPE)
			SELECT convert(date, b.manual_log_in), b.manual_log_in as lilo_time_in, b.manual_log_out as lilo_time_out, b.user_lilo_id, b.userliloid, b.liloreqnum as user_requests_id, b.liloreqnumformat as userrequestsid, b.BIT_TK_TYPE
			FROM @tempTblApprovedLILO b
			WHERE b.empid = @employeeID AND (convert(date, b.manual_log_in) >= convert(date, @datefrom) AND convert(date, b.manual_log_in) <= convert(date, @dateto)) AND b.user_lilo_id = @TableID
		end

		delete @tempTblApprovedLILO where user_lilo_id = @TableID
	end


	select * from @tempTblLogs
	order by TIME_IN_LOG_DATE desc
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[SPTKGetOTLILORequest]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPTKGetOTLILORequest] 
@requestType as int,
--@requestID as int,
@EmployeeId as varchar(30),
@datefrom as date,
@dateto as date
AS
BEGIN
	if(@requestType = 1) --lilo
	begin
		SELECT a.user_requests_id, concat('REQ', a.user_requests_id) as userrequestsid, a.date_created, a.employee_id, concat(d.FirstName, ' ', d.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
		       b.no_time_log, b.manual_log_in, b.manual_log_out, b.reason, b.BIT_TK_TYPE,
			   null as attachment_path, c.attachment_type, 
			   e.FirstApproverEmployeeID,e.FirstApproverFullname, e.FirstApproverUsername, 
			   e.SecondApproverEmployeeID, e.SecondApproverFullname, e.SecondApproverUsername,
			   f.[TIME_IN_LOG_DATE], f.[TIME_IN], f.[TIME_OUT_LOG_DATE], f.[TIME_OUT]
		from dbo.CommonRequests a
		inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] b
		on a.module_id = b.user_lilo_id and a.request_type = 1
		inner join [MBGSPMainDB].[dbo].[CommonRequestAttachments] c
		on a.user_userattachment_id = c.user_userattachment_id
		left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] d 
		on a.employee_id = d.Employee_ID
		left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] e 
		on d.AreaID = e.AreaID
		left join [MBGSPMainDB].[dbo].[TKTimelogs] f
		on b.no_time_log = f.NO_TIME_LOG
		WHERE a.employee_id = @EmployeeId AND (convert(date,a.date_created) >= @datefrom AND convert(date,a.date_created) <= @dateto) 
		ORDER BY a.user_requests_id desc
	end
	else if(@requestType = 2) --ot
	begin
		SELECT a.user_requests_id, concat('REQ', a.user_requests_id) as userrequestsid, a.date_created, a.employee_id ,  
		       concat(c.FirstName, ' ', c.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
		       b.date_login, b.date_overtime_from, b.date_overtime_to, 
			   b.no_of_hours, --no of hours on request ,
			   b.approved_no_of_hours,
			   (select convert(decimal(10,2), convert(decimal(10,2), datediff(MINUTE, TIME_IN, TIME_OUT))/60) - 9 from [DatabaseMBGSP2.0].[dbo].[TblTimeLog] where convert(date, b.date_overtime_from) = convert(date, TIME_IN) AND NO_EMPLOYEE_ID = a.employee_id) as no_of_hours_from_logs,
			   b.reason, 
			   d.FirstApproverEmployeeID, d.FirstApproverFullname, d.FirstApproverUsername, d.SecondApproverEmployeeID, d.SecondApproverFullname, d.SecondApproverUsername
		from dbo.CommonRequests a
		inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] b
		on a.module_id = b.user_overtime_id and a.request_type = 2
		left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c 
		on a.employee_id = c.Employee_ID
		left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] d 
		on c.AreaID = d.AreaID
		WHERE a.employee_id = @EmployeeId AND (convert(date,a.date_created) >= @datefrom AND convert(date,a.date_created) <= @dateto) 
		ORDER BY a.user_requests_id desc
	end 
END
 
/*
exec [dbo].[SPTKGetOTLILORequest] 
@requestType = 1,
@EmployeeId = '20169690',
@datefrom = '2023-04-16',
@dateto = '2023-06-15'
*/
GO
/****** Object:  StoredProcedure [dbo].[SPTKGetOTLILORequestPerID]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPTKGetOTLILORequestPerID]
@requestID as int,
@EmployeeId as varchar(30)
 
AS
BEGIN
	  declare @empApproverNo int
				if EXISTS ( select a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, 
						  a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, b.AreaID, c.FirstApproverEmployeeID, c.SecondApproverEmployeeID 
						  from [MBGSPMainDB].[dbo].[CommonRequests] a
						  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
						  left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID where c.FirstApproverEmployeeID = @EmployeeId)
					begin
						set @empApproverNo = 1
						--check if approver still exists on second approver
						if EXISTS ( select a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, 
									a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, b.AreaID, c.FirstApproverEmployeeID, c.SecondApproverEmployeeID 
									from [MBGSPMainDB].[dbo].[CommonRequests] a
									left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
									left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID where c.SecondApproverEmployeeID = @EmployeeId)
						 begin
							set @empApproverNo = 3 --3 for single approver. the same first and second approver
 
						 end
 
						if ((select top 1 c.SecondApproverEmployeeID 
								from [MBGSPMainDB].[dbo].[CommonRequests] a
								left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
								left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID where c.FirstApproverEmployeeID = @EmployeeId ) = '20125338')--2nd approver jochen is not included
						begin
							set @empApproverNo = 3
						end
					end
				else
					begin
						if EXISTS ( select a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, 
									a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, b.AreaID, c.FirstApproverEmployeeID, c.SecondApproverEmployeeID 
									from [MBGSPMainDB].[dbo].[CommonRequests] a
									left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
									left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID where c.SecondApproverEmployeeID = @EmployeeId)
						 begin
							set @empApproverNo = 2 --3 for single approver. the same first and second approver
						 end
						else
						 begin
						    set @empApproverNo = 0 --not an approver
						 end
					end
                /*if(@empApproverNo = 0)
				begin
					RAISERROR ('User is not an Approver.', -- Message text.
				    16, -- Severity.
				    1 -- State.
				    );
				end*/
				--select @empApproverNo
 
	  if(@empApproverNo = 1)
	  begin
		  select a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, b.UserID as requestor_id, concat(b.FirstName, ' ', b.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, remarks,
		  a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, b.AreaID, c.FirstApproverEmployeeID, c.FirstApproverUsername, c.FirstApproverFullname, c.SecondApproverEmployeeID, c.SecondApproverFullname, c.SecondApproverUsername,
		  d.user_lilo_id as lilo_id, d.manual_log_in as lilo_manual_log_in, d.BIT_TK_TYPE, d.manual_log_out as lilo_manual_log_out, d.reason as lilo_reason,
		  e.user_userattachment_id as lilo_attachment_id, e.attachment_path as lilo_attachment_path, e.attachment_type as lilo_attachment_type,
		  f.user_overtime_id as ot_overtime_id, f.date_login, f.date_overtime_from as ot_date_overtime_from, f.date_overtime_to as ot_date_overtime_to, f.no_of_hours as ot_no_of_hours, f.approved_no_of_hours as approved_no_of_hours, f.reason as ot_reason
		  from [MBGSPMainDB].[dbo].[CommonRequests] a
		  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
		  left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID
		  left join [MBGSPMainDB].[dbo].[TKRequestsLILO] d on d.user_lilo_id = case when(a.request_type = 1)
																							 then a.module_id
																							 else 0
																						end
		  left join [MBGSPMainDB].[dbo].[CommonRequestAttachments] e on e.user_userattachment_id = case when(a.request_type = 1)
																							 then a.module_id
																							 else 0
																						end
		  left join [MBGSPMainDB].[dbo].[TKRequestsOvertime] f on f.user_overtime_id = case when(a.request_type = 2)
																							 then a.module_id
																							 else 0
																						end
		  where c.FirstApproverEmployeeID = @EmployeeId AND a.user_requests_id = @requestID --AND a.a1_approvedDate IS NULL 

	  end
	  else if(@empApproverNo = 2)
	  begin
		  select a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, b.UserID as requestor_id, concat(b.FirstName, ' ', b.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, remarks,
		  a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, b.AreaID, c.FirstApproverEmployeeID, c.FirstApproverUsername, c.FirstApproverFullname, c.SecondApproverEmployeeID, c.SecondApproverFullname, c.SecondApproverUsername,
		  d.user_lilo_id as lilo_id, d.manual_log_in as lilo_manual_log_in, d.BIT_TK_TYPE, d.manual_log_out as lilo_manual_log_out, d.reason as lilo_reason,
		  e.user_userattachment_id as lilo_attachment_id, e.attachment_path as lilo_attachment_path, e.attachment_type as lilo_attachment_type,
		  f.user_overtime_id as ot_overtime_id, f.date_login, f.date_overtime_from as ot_date_overtime_from, f.date_overtime_to as ot_date_overtime_to, f.no_of_hours as ot_no_of_hours, f.approved_no_of_hours as approved_no_of_hours, f.reason as ot_reason
		  from [MBGSPMainDB].[dbo].[CommonRequests] a
		  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
		  left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID
		  left join [MBGSPMainDB].[dbo].[TKRequestsLILO] d on d.user_lilo_id = case when(a.request_type = 1)
																							 then a.module_id
																							 else 0
																						end
		  left join [MBGSPMainDB].[dbo].[CommonRequestAttachments] e on e.user_userattachment_id = case when(a.request_type = 1)
																							 then a.module_id
																							 else 0
																						end
		  left join [MBGSPMainDB].[dbo].[TKRequestsOvertime] f on f.user_overtime_id = case when(a.request_type = 2)
																							 then a.module_id
																							 else 0
																						end
		  where c.SecondApproverEmployeeID = @EmployeeId AND a.user_requests_id = @requestID --AND a.a2_approvedDate IS NULL AND a.a1_approvedDate IS NOT NULL 
	  end
	  else if(@empApproverNo = 3)
	  begin
		  select a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, b.UserID as requestor_id, concat(b.FirstName, ' ', b.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, remarks,
		  a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, b.AreaID, c.FirstApproverEmployeeID, c.FirstApproverUsername, c.FirstApproverFullname, c.SecondApproverEmployeeID, c.SecondApproverFullname, c.SecondApproverUsername,
		  d.user_lilo_id as lilo_id, d.manual_log_in as lilo_manual_log_in, d.BIT_TK_TYPE, d.manual_log_out as lilo_manual_log_out, d.reason as lilo_reason,
		  e.user_userattachment_id as lilo_attachment_id, e.attachment_path as lilo_attachment_path, e.attachment_type as lilo_attachment_type,
		  f.user_overtime_id as ot_overtime_id, f.date_login, f.date_overtime_from as ot_date_overtime_from, f.date_overtime_to as ot_date_overtime_to, f.no_of_hours as ot_no_of_hours, f.approved_no_of_hours as approved_no_of_hours, f.reason as ot_reason
		  from [MBGSPMainDB].[dbo].[CommonRequests] a
		  left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b on a.employee_id = b.Employee_ID
		  left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c on b.AreaID = c.AreaID
		  left join [MBGSPMainDB].[dbo].[TKRequestsLILO] d on d.user_lilo_id = case when(a.request_type = 1)
																							 then a.module_id
																							 else 0
																						end
		  left join [MBGSPMainDB].[dbo].[CommonRequestAttachments] e on e.user_userattachment_id = case when(a.request_type = 1)
																							 then a.module_id
																							 else 0
																						end
		  left join [MBGSPMainDB].[dbo].[TKRequestsOvertime] f on f.user_overtime_id = case when(a.request_type = 2)
																							 then a.module_id
																							 else 0
																						end
		  where c.FirstApproverEmployeeID = @EmployeeId AND a.user_requests_id = @requestID --AND a.a1_approvedDate IS NULL AND
	  end
 
END
GO
/****** Object:  StoredProcedure [dbo].[SPTKGetOTLILOSingleRequest]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPTKGetOTLILOSingleRequest] 
@requestID as int,
@requestType as int,
@EmployeeId as varchar(30)
AS
BEGIN
	if(@requestType = 1) --lilo
	begin
		SELECT a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, concat(d.FirstName, ' ', d.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
		       b.no_time_log, b.manual_log_in, b.manual_log_out, b.reason, b.BIT_TK_TYPE,
			   c.attachment_path, c.attachment_type,
			   e.FirstApproverEmployeeID,e.FirstApproverFullname, e.FirstApproverUsername, 
			   e.SecondApproverEmployeeID, e.SecondApproverFullname, e.SecondApproverUsername,
			   f.[TIME_IN_LOG_DATE], f.[TIME_IN], f.[TIME_OUT_LOG_DATE], f.[TIME_OUT]
		from dbo.CommonRequests a
		inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] b
		on a.module_id = b.user_lilo_id and a.request_type = 1
		inner join [MBGSPMainDB].[dbo].[CommonRequestAttachments] c
		on a.user_userattachment_id = c.user_userattachment_id
		left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] d 
		on a.employee_id = d.Employee_ID
		left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] e 
		on d.AreaID = e.AreaID
		left join [MBGSPMainDB].[dbo].[TKTimelogs] f
		on b.no_time_log = f.NO_TIME_LOG
		WHERE a.employee_id = @EmployeeId AND a.user_requests_id = @requestID
	end
	else if(@requestType = 2) --ot
	begin
		SELECT a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id ,  
		       concat(c.FirstName, ' ', c.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
		       b.date_login, b.date_overtime_from, b.date_overtime_to, 
			   b.no_of_hours, --no of hours on request ,
			   b.approved_no_of_hours,
			   (select convert(decimal(10,2), convert(decimal(10,2), datediff(MINUTE, TIME_IN, TIME_OUT))/60) - 9 from [DatabaseMBGSP2.0].[dbo].[TblTimeLog] where convert(date, b.date_overtime_from) = convert(date, TIME_IN) AND NO_EMPLOYEE_ID = a.employee_id) as no_of_hours_from_logs,
			   b.reason, 
			   d.FirstApproverEmployeeID, d.FirstApproverFullname, d.FirstApproverUsername, d.SecondApproverEmployeeID, d.SecondApproverFullname, d.SecondApproverUsername
		from dbo.CommonRequests a
		inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] b
		on a.module_id = b.user_overtime_id and a.request_type = 2
		left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c 
		on a.employee_id = c.Employee_ID
		left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] d 
		on c.AreaID = d.AreaID
		WHERE a.employee_id = @EmployeeId AND a.user_requests_id = @requestID
	end
END
GO
/****** Object:  StoredProcedure [dbo].[SPTKInsertLILORequest]    Script Date: 01/12/2023 9:05:57 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPTKInsertLILORequest] 
@RequestType as int,
@LogID as int,
@TKRequestsAttachmentType as varchar(MAX),
@TKRequestsAttachmentPath as varchar(MAX),
@DateFrom as datetime,
@DateTo as datetime,
@Reason as varchar(MAX),
@EmployeeID as varchar(20),
@BIT_TK_TYPE int
 
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			declare @requestID as int
			declare @liloid as int
			declare @attachmentid as int
			IF NOT EXISTS (
			        SELECT b.user_lilo_id
			        FROM [MBGSPMainDB].[dbo].[CommonRequests] a
			        INNER JOIN [MBGSPMainDB].[dbo].[TKRequestsLILO] b ON a.module_id = b.user_lilo_id AND a.request_type = 1
			        WHERE a.employee_id = @EmployeeID AND (DATEDIFF(day, b.manual_log_in, @DateFrom) = 0) AND a.is_status <> 0 AND a.is_delete = 0
			       )
			        begin
                    INSERT INTO dbo.CommonRequestAttachments(attachment_type,attachment_path, request_type)
                    values
                    (@TKRequestsAttachmentType
                    ,@TKRequestsAttachmentPath
                    ,@RequestType
                    )
					set @attachmentid = @@IDENTITY
 
                    INSERT INTO dbo.TKRequestsLILO(no_time_log, manual_log_in, manual_log_out, reason, BIT_TK_TYPE)
                    values
                    (@LogID
                    ,@DateFrom
                    ,@DateTo
                    ,@Reason
					,@BIT_TK_TYPE
                    )
					set @liloid = @@IDENTITY
 
                    INSERT INTO dbo.CommonRequests(date_created, employee_id, request_type, module_id, user_userattachment_id, is_delete, is_status)
                    values
                    (GETDATE()
                    ,@EmployeeID
                    ,@RequestType
                    , @liloid
                    , @attachmentid
                    , 0
                    , 1
                    )
					set @requestID = @@IDENTITY
                end
		COMMIT TRANSACTION
					SELECT user_requests_id, userrequestsid, concat(b.FirstName, ' ', b.LastName) as requestor_fullname, a.employee_id, b.Email_Address as requestor_email, is_status, a1_approvedDate, a2_approvedDate, is_delete, remarks, request_type, d.reason as lilo_reason,
			        c.FirstApproverEmployeeID, c.FirstApproverFullname, c.FirstApproverUsername,
			        (select Email_Address from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = c.FirstApproverEmployeeID) as firstApproverEmail,
			        c.SecondApproverEmployeeID, c.SecondApproverFullname, c.SecondApproverUsername,
			        (select Email_Address from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = c.SecondApproverEmployeeID) as secondApproverEmail
		            from dbo.CommonRequests a
		            left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] b
		            on a.employee_id = b.Employee_ID
		            left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] c
		            on b.AreaID = c.AreaID
                    left join [MBGSPMainDB].[dbo].[TKRequestsLILO] d
                    on a.module_id = d.user_lilo_id
                    where user_requests_id = @requestID AND a.request_type = 1
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		EXECUTE SPCommonGetErrorInfo
	END CATCH
END
 
GO
