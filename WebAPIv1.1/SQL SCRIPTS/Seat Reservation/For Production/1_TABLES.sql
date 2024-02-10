USE [MBGSPMainDB]
GO
/****** Object:  Table [dbo].[CommonExternalType]    Script Date: 30/11/2023 3:46:04 pm ******/
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
/****** Object:  Table [dbo].[CommonExternalUsers]    Script Date: 30/11/2023 3:46:05 pm ******/
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
/****** Object:  Table [dbo].[SRSpecialDayOffs]    Script Date: 30/11/2023 3:46:05 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SRSpecialDayOffs](
	[SpecialDayOffId] [int] IDENTITY(1,1) NOT NULL,
	[SpecialIDF]  AS (concat('SDOID-',[SpecialDayOffId])) PERSISTED NOT NULL,
	[IsActive] [int] NULL,
	[Date] [datetime] NULL,
	[Username] [varchar](max) NULL,
	[Datestamp] [datetime] NULL,
	[PerformedBy] [varchar](max) NULL,
	[Day1] [varchar](10) NULL,
	[Day2] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[SpecialDayOffId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SRSpecialTelecomDates]    Script Date: 30/11/2023 3:46:05 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SRSpecialTelecomDates](
	[SRSpecialTelecomDatesId] [int] IDENTITY(1,1) NOT NULL,
	[SpecialTeleIDF]  AS (concat('STDID-',[SRSpecialTelecomDatesId])) PERSISTED NOT NULL,
	[IsActive] [int] NULL,
	[FDate] [datetime] NULL,
	[TDate] [datetime] NULL,
	[Username] [varchar](max) NULL,
	[Datestamp] [datetime] NULL,
	[PerformedBy] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SRSpecialTelecomDatesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
