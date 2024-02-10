ALTER TABLE [MBGSPMainDB].[dbo].[SRFloor]
ADD priorityid int

ALTER TABLE [MBGSPMainDB].[dbo].[TKTimelogs]
ADD BIT_TK_TYPE int

ALTER TABLE [MBGSPMainDB].[dbo].[SRReservation]
ADD teleCtr int

ALTER TABLE [MBGSPMainDB].[dbo].[CommonPreference]
ADD specialdayoff int

ALTER TABLE [MBGSPMainDB].[dbo].[TKRequestsLILO]
add BIT_TK_TYPE int 