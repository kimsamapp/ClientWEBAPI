  ALTER TABLE [MBGSPMainDB].[dbo].[CommonPreference]
  ADD specialdayoff int

  ALTER TABLE [MBGSPMainDB].[dbo].[SRFloor]
  ADD priorityid int

  CREATE TABLE [MBGSPMainDB].[dbo].[SRSpecialDayOffs](
	  SpecialDayOffId int identity(1,1) primary key,
	  [SpecialIDF]  AS (concat('SDOID-',[SpecialDayOffId])) PERSISTED NOT NULL,
	  IsActive int,
	  [Date] datetime,
	  [Username] varchar(max),
	  [Datestamp] datetime,
	  [PerformedBy] varchar(max)
  )

  CREATE TABLE [MBGSPMainDB].[dbo].[SRSpecialTelecomDates](
	  SRSpecialTelecomDatesId int identity(1,1) primary key,
	  [SpecialTeleIDF] AS (concat('STDID-',[SRSpecialTelecomDatesId])) PERSISTED NOT NULL,
	  IsActive int,
	  [FDate] datetime,
	  [TDate] datetime,
	  [Username] varchar(max),
	  [Datestamp] datetime,
	  [PerformedBy] varchar(max)
  )