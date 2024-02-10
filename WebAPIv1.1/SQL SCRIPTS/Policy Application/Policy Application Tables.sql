USE [MBGSPMainDB]
GO
/****** Object:  Table [dbo].[AGAApplications]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AGAApplications](
	[AGAApplication_Id] [int] IDENTITY(1,1) NOT NULL,
	[AGAApplicationId]  AS (concat('AGAPID-',[AGAApplication_Id])) PERSISTED NOT NULL,
	[Name] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[CreatedBy] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[ApplicationType] [int] NULL,
	[URL] [varchar](max) NULL,
	[IsActive] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AGAApplicationType]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AGAApplicationType](
	[AGAApplicationType_Id] [int] IDENTITY(1,1) NOT NULL,
	[AGAApplicationTypeId]  AS (concat('AGAPPTPID-',[AGAApplicationType_Id])) PERSISTED NOT NULL,
	[Name] [varchar](max) NULL,
	[IsActive] [int] NULL,
	[UpdatedBy] [varchar](max) NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AGAUsers]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AGAUsers](
	[AGAUser_Id] [int] IDENTITY(1,1) NOT NULL,
	[AGAUserId]  AS (concat('AGAUser-',[AGAUser_Id])) PERSISTED NOT NULL,
	[AGAApplication_Id] [int] NULL,
	[UpdatedBy] [varchar](max) NULL,
	[UpdatedDate] [datetime] NULL,
	[EmployeeId] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CommonNotification]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CommonNotification](
	[CommonNotification_Id] [int] IDENTITY(1,1) NOT NULL,
	[CommonNotificationId]  AS (concat('N',[CommonNotification_Id])) PERSISTED NOT NULL,
	[Name] [varchar](max) NULL,
	[AppType] [int] NULL,
	[AppTypeId] [int] NULL,
	[SystemModification] [datetime] NULL,
	[IsActive] [int] NULL,
	[EmployeeId] [varchar](max) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[CommonNotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[CommonNotification_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PAAttachments]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PAAttachments](
	[PAAttachments_Id] [int] IDENTITY(1,1) NOT NULL,
	[PAAttachmentsId]  AS (concat('PATTACHMENT',[PAAttachments_Id])) PERSISTED NOT NULL,
	[Policy_Id] [int] NULL,
	[PAPolicyType] [int] NULL,
	[PAAttachmentName] [varchar](max) NULL,
	[PAAttachmentURL] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[IsActive] [int] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[PAAttachmentsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[PAAttachments_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PAPolicy]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PAPolicy](
	[Policy_Id] [int] IDENTITY(1,1) NOT NULL,
	[PolicyId]  AS (concat('POLICY',[Policy_Id])) PERSISTED NOT NULL,
	[PolicyName] [varchar](200) NULL,
	[PolicyDescription] [varchar](max) NULL,
	[VersionControl] [varchar](100) NULL,
	[Questionnaire_Id] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[SysModificationDate] [datetime] NULL,
	[IsActive] [int] NULL,
	[PublishedBy] [varchar](max) NULL,
	[PublishedDate] [datetime] NULL,
	[PolicyExpiryDate] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[PolicyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[Policy_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PAPolicyByJobLevel]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PAPolicyByJobLevel](
	[PAPolicyByJobLevel_Id] [int] IDENTITY(1,1) NOT NULL,
	[Policy_Id] [int] NULL,
	[JobLevelId] [varchar](5) NULL,
	[SysModificationDate] [datetime] NULL,
	[IsActive] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PAPolicyByUser]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PAPolicyByUser](
	[PAPolicyByUser_Id] [int] IDENTITY(1,1) NOT NULL,
	[PAPolicyByUserId]  AS (concat('PAU',[PAPolicyByUser_Id])) PERSISTED NOT NULL,
	[Policy_Id] [int] NULL,
	[Employee_Id] [varchar](max) NULL,
	[Due_Date] [datetime] NULL,
	[IsStatus] [int] NULL,
	[SysModificationDate] [datetime] NULL,
	[DateCompleted] [datetime] NULL,
	[AcknowledgeForm] [varchar](max) NULL,
	[Bit_Email] [bit] NULL,
	[BitEmailDate] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[PAPolicyByUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[PAPolicyByUser_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QMQuestion]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QMQuestion](
	[Question_Id] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId]  AS (concat('Q',[Question_Id])) PERSISTED NOT NULL,
	[Question_Title] [varchar](100) NULL,
	[Question_Text] [varchar](1000) NULL,
	[QuestionType_Id] [int] NULL,
	[Questionnaire_Id] [int] NULL,
	[Score] [int] NULL,
	[ChoiceA] [varchar](max) NULL,
	[ChoiceB] [varchar](max) NULL,
	[ChoiceC] [varchar](max) NULL,
	[ChoiceD] [varchar](max) NULL,
	[ChoiceE] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[SysModificationDate] [datetime] NULL,
	[IsActive] [int] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[Question_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QMQuestionCorrectAnswer]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QMQuestionCorrectAnswer](
	[QuestionCorrectAnswer_Id] [int] IDENTITY(1,1) NOT NULL,
	[QuestionCorrectAnswerId]  AS (concat('QCA',[QuestionCorrectAnswer_Id])) PERSISTED NOT NULL,
	[Question_Id] [int] NULL,
	[QuestionCorrectAnswer] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[SysModificationDate] [datetime] NULL,
	[IsActive] [int] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[QuestionCorrectAnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[QuestionCorrectAnswer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QMQuestionnaire]    Script Date: 18/08/2023 10:29:04 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QMQuestionnaire](
	[Questionnaire_Id] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireId]  AS (concat('QRE',[Questionnaire_Id])) PERSISTED NOT NULL,
	[Module_Type] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[SysModificationDate] [datetime] NULL,
	[IsActive] [int] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[QuestionnaireId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE CLUSTERED 
(
	[Questionnaire_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
