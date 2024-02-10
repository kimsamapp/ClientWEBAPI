USE [MBGSPMainDB]
GO
/****** Object:  StoredProcedure [dbo].[SPApprovalsGetRequest]    Script Date: 30/11/2023 4:07:15 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SPApprovalsGetRequest] 
@requestID as int,
@requestType as int,
@EmployeeId as varchar(30)
AS
BEGIN
    if(@requestType = 1) --lilo
    begin
        SELECT a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id, concat(d.FirstName, ' ', d.LastName) as requestor_fullname, a.request_type, a.module_id, a.user_userattachment_id, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
               b.no_time_log, b.manual_log_in, b.manual_log_out, b.reason,
               --c.attachment_path, c.attachment_type,
               e.FirstApproverEmployeeID,e.FirstApproverFullname, e.FirstApproverUsername, 
               e.SecondApproverEmployeeID, e.SecondApproverFullname, e.SecondApproverUsername,
			   b.BIT_TK_TYPE,
               f.[TIME_IN_LOG_DATE], f.[TIME_IN], f.[TIME_OUT_LOG_DATE], f.[TIME_OUT],
               rejecter_id,
               rejecter_name = (select concat(FirstName, ' ', LastName) from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = rejecter_id)
        from [MBGSPMainDB].[dbo].CommonRequests a
        inner join [MBGSPMainDB].[dbo].[TKRequestsLILO] b
        on a.module_id = b.user_lilo_id and a.request_type = 1
        --inner join [MBGSPMainDB].[dbo].[TKRequestsAttachment] c
        --on a.user_userattachment_id = c.user_userattachment_id
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
               d.FirstApproverEmployeeID, d.FirstApproverFullname, d.FirstApproverUsername, d.SecondApproverEmployeeID, d.SecondApproverFullname, d.SecondApproverUsername,
               rejecter_id,
               rejecter_name = (select concat(FirstName, ' ', LastName) from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = rejecter_id)
        from [MBGSPMainDB].[dbo].CommonRequests a
        inner join [MBGSPMainDB].[dbo].[TKRequestsOvertime] b
        on a.module_id = b.user_overtime_id and a.request_type = 2
        left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c 
        on a.employee_id = c.Employee_ID
        left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] d 
        on c.AreaID = d.AreaID
        WHERE a.employee_id = @EmployeeId AND a.user_requests_id = @requestID
    end
	else if(@requestType = 3) 
    begin
        SELECT a.user_requests_id, 
			   a.userrequestsid, 
			   a.date_created, 
			   a.employee_id ,  
               (select concat(FirstName, ' ', LastName) from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = a.employee_id) as requestor_fullname, 
			   a.request_type, 
			   a.module_id, 
			   a.user_userattachment_id, 
			   a.is_delete, 
			   a.is_status, 
			   a.a1_approvedDate, 
			   a.a2_approvedDate, 
			   a.date_mod, 
			   a.remarks,
			   a.rejecter_id,
               rejecter_name = (select concat(FirstName, ' ', LastName) from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = a.rejecter_id),
               b.request_detailed_desc,
               c.TravellerName,
			   c.CostCenter,
			   c.id as travel_detail_id,
			   (select top 1 FDestination from [MBGSPMainDB].[dbo].[RequestTravelFlightDetail] where c.id = request_id_temp order by FDate desc, FTime desc) as destination,
			   cast(c.selectTypes as int) as traveltype
        from [MBGSPMainDB].[dbo].[CommonRequests] a
		left join [MBGSPMainDB].[dbo].[RequestTravelManagement] b
		on a.user_requests_id = b.request_id
        left join [MBGSPMainDB].[dbo].[RequestTravelDetail] c
        on a.user_requests_id = c.request_id
		WHERE a.employee_id = @EmployeeId AND a.user_requests_id = @requestID
    end
	 --else if(@requestType = 3) --officeManagement
  --  begin
  --      SELECT a.user_requests_id, a.userrequestsid, a.date_created, a.employee_id ,  
  --             concat(c.FirstName, ' ', c.LastName) as requestor_fullname, a.request_type, a.is_delete, a.is_status, a.a1_approvedDate, a.a2_approvedDate, a.date_mod, a.remarks,
               
  --             d.FirstApproverEmployeeID, d.FirstApproverFullname, d.FirstApproverUsername, d.SecondApproverEmployeeID, d.SecondApproverFullname, d.SecondApproverUsername,
  --             rejecter_id,
  --             rejecter_name = (select concat(FirstName, ' ', LastName) from [MBGSPMainDB].[dbo].[CommonEmployeesActive] where Employee_ID = rejecter_id)
  --      from [MBGSPMainDB].[dbo].CommonRequests a
  --      inner join [MBGSPMainDB].[dbo].[RequestOfficeManagement] b
  --      on a.user_requests_id = b.request_id and a.request_type = @requestType
  --      left join [MBGSPMainDB].[dbo].[CommonEmployeesActive] c 
  --      on a.employee_id = c.Employee_ID
  --      left join [MBGSPMainDB].[dbo].[CommonAreaApprovers] d 
  --      on c.AreaID = d.AreaID
  --      WHERE a.employee_id = @EmployeeId AND a.user_requests_id = @requestID
  --  end
END

 


/*
exec [dbo].[SPApprovalsGetRequest]
@requestID = 62,
@requestType = 3,
@EmployeeId = '20169690'

 

{
"requestID" : "33",
"requestType" : "2",
"EmployeeID" : "20169690"
}
*/

 

 





GO
/****** Object:  StoredProcedure [dbo].[SPTKGetEmployeeTimelogs]    Script Date: 30/11/2023 4:07:15 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
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

/*
exec [dbo].[SPTKGetEmployeeTimelogs]
@EmployeeId = '20169690',
@datefrom = '2023-01-01',
@dateto = '2023-05-31'

exec [dbo].[SPTKGetEmployeeTimelogs]
@EmployeeId = '20146334',
@datefrom = '2023-01-01',
@dateto = '2023-05-31'

{
   EmployeeId : "20169690",
   dateFrom : "2023-02-01",
   dateTo : "2023-02-28"
}
*/

GO
/****** Object:  StoredProcedure [dbo].[SPTKGetOTLILORequest]    Script Date: 30/11/2023 4:07:15 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPTKGetOTLILORequestPerID]    Script Date: 30/11/2023 4:07:15 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPTKGetOTLILOSingleRequest]    Script Date: 30/11/2023 4:07:15 pm ******/
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
/****** Object:  StoredProcedure [dbo].[SPTKInsertLILORequest]    Script Date: 30/11/2023 4:07:15 pm ******/
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
