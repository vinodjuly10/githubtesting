-- =============================================
-- Author:		 Sehul Soni
-- Updated date: 09-Oct-2015
-- Description:	 Script for views for Production Support
-- =============================================



USE [LDWhitney]
GO


CREATE VIEW [dbo].[vwApplicantLoanDetails]
AS
SELECT        LoanApplication.LoanApplicationId, LoanApplication.LeadId, LoanApplication.LoanNumber, LoanApplication.LoanDepotProdcutType, LoanApplication.MonthlyIncome, 
                         LoanApplication.NetMonthlyIncome, LoanApplication.PuposeOfLoan, PurposeOfLoan.PurposeOfLoanText, LoanApplication.FicoScore, 
                         LoanApplication.EquifaxFicoScore, LoanApplication.EquifaxDtiScore, LoanAccountStatus.LoanAccountStatusName, LoanAccounts.LoanStatus, 
                         LoanApplication.AppliedOn, LoanApplication.LoanTerm AS LoanApplicationTerm, LoanAccounts.LoanTerm AS LoanAccountsTerm, 
                         LoanApplication.LoanAmount AS LoanApplicationAmount, LoanAccounts.LoanAmount AS LoanAcountsAmount, LoanAccounts.TakeHomeAmount, 
                         LoanAccounts.AnnualPercentageRate, LoanAccounts.InterestRate, LoanAccounts.MonthlyPayment, LoanAccounts.OriginationFees, LoanApplication.CreatedOn, 
                         LoanApplication.CreatedBy, ApplicationStatus.ApplicationStatusName, LoanApplication.AssignedTo, [User].FirstName AS AssignedToFN, 
                         [User].LastName AS AssignedToLN, LoanApplication.AssignedBy, User_1.FirstName AS AssignedByFN, User_1.LastName AS AssignedByLN, 
                         LoanApplication.AssignedOn, LoanAccounts.BankName, LoanApplication.AccountNumber, LoanApplication.RoutingNumber, LoanApplication.BankAccountType, 
                         LoanApplication.CurrentVersionNumber, 
						 LoanApplicationLastStage.ApplicationStageId AS LastStageID,
						 (SELECT ApplicationStageName FROM dbo.ApplicationStage WITH (NOLOCK) WHERE ApplicationStageId = LoanApplicationLastStage.ApplicationStageId) AS LastApplicationStage,
						 LoanApplicationLastStage.CreatedOn AS LastStageCreatedOn, 
                         LoanApplicationLastStage.UpdatedOn AS LastStageUpdatedOn
FROM            LoanApplication INNER JOIN
                         LoanAccounts WITH (NOLOCK) ON LoanApplication.LoanApplicationId = LoanAccounts.LoanApplicationId INNER JOIN
                         ApplicationStatus WITH (NOLOCK) ON LoanApplication.ApplicationStatusId = ApplicationStatus.ApplicationStatusId INNER JOIN
                         PurposeOfLoan WITH (NOLOCK) ON LoanApplication.PuposeOfLoan = PurposeOfLoan.PurposeOfLoanId INNER JOIN
                         LoanAccountStatus WITH (NOLOCK) ON LoanAccounts.LoanAccountStatusId = LoanAccountStatus.LoanAccountStatusId INNER JOIN
                         LoanAccountStatus AS LoanAccountStatus_1 WITH (NOLOCK) ON LoanAccounts.LoanAccountStatusId = LoanAccountStatus_1.LoanAccountStatusId LEFT OUTER JOIN
                         LoanApplicationLastStage ON LoanApplication.LoanApplicationId = LoanApplicationLastStage.LoanApplicationId LEFT OUTER JOIN
                         [User] AS User_1 WITH (NOLOCK) ON LoanApplication.AssignedBy = User_1.UserId LEFT OUTER JOIN
                         [User] WITH (NOLOCK) ON LoanApplication.AssignedTo = [User].UserId


GO

CREATE VIEW [dbo].[vwApplicantPersonalDetails]
AS
SELECT dbo.LoanApplication.LoanApplicationId, dbo.LoanApplication.LoanNumber, dbo.LoanApplication.FirstName, dbo.LoanApplication.MiddleInitial, 
dbo.LoanApplication.LastName, dbo.LoanApplication.DateOfBirth, dbo.LoanApplication.SSN, dbo.LoanApplication.PhoneNumber, dbo.LoanApplication.Email, 
dbo.LoanApplication.HomeAddress, dbo.LoanApplication.City, dbo.LoanApplication.State, dbo.LoanApplication.ZipCode, 
dbo.EmploymentStatusType.EmploymentStatusTypeName, dbo.HomeType.HomeTypeName, dbo.ApplicationStatus.ApplicationStatusName, 
dbo.LoanApplication.LeadId, dbo.LoanApplication.MonthlyIncome, dbo.LoanApplication.Employer, dbo.LoanApplication.Position, dbo.LoanApplication.WorkAddress, 
dbo.LoanApplication.WorkCity, dbo.LoanApplication.WorkState, dbo.LoanApplication.WorkZip, dbo.LoanApplication.WorkPhone, 
dbo.LoanApplication.WorkWebsite
FROM dbo.LoanApplication WITH (NOLOCK) INNER JOIN
dbo.ApplicationStatus WITH (NOLOCK) ON dbo.LoanApplication.ApplicationStatusId = dbo.ApplicationStatus.ApplicationStatusId LEFT OUTER JOIN
dbo.HomeType WITH (NOLOCK) ON dbo.LoanApplication.HomeType = dbo.HomeType.HomeTypeId LEFT OUTER JOIN
dbo.EmploymentStatusType WITH (NOLOCK) ON dbo.LoanApplication.EmploymentStatusType = dbo.EmploymentStatusType.EmploymentStatusTypeId

GO

CREATE VIEW [dbo].[vwDocumentUploaded]
AS
SELECT dbo.LoanAppUploadedDocuments.LoanAppUploadedDocumentsID, dbo.LoanAppUploadedDocuments.DocumentTypeId, dbo.DocumentType.DocumentTypeName, 
dbo.LoanAppUploadedDocuments.DocumentId, dbo.DocumentType.IsDocument, dbo.DocumentType.IsDefault, dbo.LoanAppUploadedDocuments.IsSupportDocument, 
dbo.DocumentType.DocumentCategory, dbo.LoanAppUploadedDocuments.SubDocumentTypeId, dbo.SubDocumentType.SubDocumentTypeName, 
dbo.LoanAppUploadedDocuments.UploadedBy, dbo.[User].FirstName, dbo.[User].LastName, dbo.LoanAppUploadedDocuments.LoanAccountId
FROM dbo.LoanAppUploadedDocuments WITH (NOLOCK) INNER JOIN
dbo.DocumentType WITH (NOLOCK) ON dbo.LoanAppUploadedDocuments.DocumentTypeId = dbo.DocumentType.DocumentTypeId LEFT OUTER JOIN
dbo.[User] WITH (NOLOCK) ON dbo.LoanAppUploadedDocuments.UploadedBy = dbo.[User].UserId LEFT OUTER JOIN
dbo.SubDocumentType WITH (NOLOCK) ON dbo.LoanAppUploadedDocuments.SubDocumentTypeId = dbo.SubDocumentType.SubDocumentTypeId

GO

CREATE VIEW [dbo].[vwExtendedLoanApplication]
AS
SELECT        ExtendedLoanApplication.LoanApplicationId, ExtendedLoanApplication.AnnualIncome, ExtendedLoanApplication.PayCheckFrequency, 
                         ExtendedLoanApplication.PayCheckAmount, ExtendedLoanApplication.LastCallDispositionId, Disposition.DispositionName AS LastCallDisposition, 
                         ExtendedLoanApplication.LastCallDispositionReasonId, DispositionReason.DispositionReasonName AS LastCallDispositionReason, 
                         ExtendedLoanApplication.LastCallDispositionOn, ExtendedLoanApplication.LastVerifiedBy, User_1.FirstName AS LastVerifiedByFN, 
                         User_1.LastName AS LastVerifiedByLN, ExtendedLoanApplication.LastVerifiedOn, ExtendedLoanApplication.LastUnderWrittenBy, 
                         User_2.FirstName AS LastUnderWrittenByFN, User_2.LastName AS LastUnderWrittenByLN, ExtendedLoanApplication.LastUnderWrittenOn, 
                         ExtendedLoanApplication.LastActivityOn, ExtendedLoanApplication.LastCompletedApplicationStageId, ApplicationStage.ApplicationStageName, 
                         ExtendedLoanApplication.LastCompletedApplicationStageDate, ExtendedLoanApplication.UnderWrittenDispositionId, 
                         Disposition_1.DispositionName AS UWDisposition, ExtendedLoanApplication.UnderWrittenDispositionNotes, ExtendedLoanApplication.UnderWritingAgentId, 
                         User_3.FirstName AS UnderWritingAgentFN, User_3.LastName AS UnderWritingAgentLN, ExtendedLoanApplication.UnderWrittenOn, 
                         ExtendedLoanApplication.UnderWritingManagerId, User_4.FirstName AS UnderWritingManagerFN, User_4.LastName AS UnderWritingManagerLN, 
                         ExtendedLoanApplication.UnderWrittenReviewedOn, ExtendedLoanApplication.InFraudCheckState, ExtendedLoanApplication.FraudCheckDispositionId, 
                         Disposition_2.DispositionName AS FraudCheckDisposition, ExtendedLoanApplication.FraudCheckAgentId, User_5.FirstName AS FraudCheckAgentFN, 
                         User_5.LastName AS FraudCheckAgentLN, ExtendedLoanApplication.FraudCheckOn, ExtendedLoanApplication.EditOfferAttempted, 
                         ExtendedLoanApplication.EditedOfferSelected, ExtendedLoanApplication.PayThroughDate, ExtendedLoanApplication.W2MonthlyIncome, 
                         ExtendedLoanApplication.PayCheckMonthlyIncome, ExtendedLoanApplication.CDStartDate, ExtendedLoanApplication.CDStatus, 
                         ExtendedLoanApplication.CDCompletedDate, ExtendedLoanApplication.HardPullPerformedTime, ExtendedLoanApplication.FullyLoadedDTI, 
                         ExtendedLoanApplication.TaxAnnualIncome, ExtendedLoanApplication.TaxMonthlyIncome, ExtendedLoanApplication.ProofAnnualIncome, 
                         ExtendedLoanApplication.ProofMonthlyIncome, ExtendedLoanApplication.DispositionDate, ExtendedLoanApplication.IsCDOverridden, 
                         ExtendedLoanApplication.OverriddenBy, [User].FirstName AS CDOverriddenByFN, [User].LastName AS CDOverriddenByLN, ExtendedLoanApplication.OverriddenOn, 
                         ExtendedLoanApplication.OverrideNotes
FROM            ExtendedLoanApplication WITH (NOLOCK) LEFT OUTER JOIN
                         Disposition WITH (NOLOCK) ON ExtendedLoanApplication.LastCallDispositionId = Disposition.DispositionId LEFT OUTER JOIN
                         DispositionReason WITH (NOLOCK) ON ExtendedLoanApplication.LastCallDispositionReasonId = DispositionReason.DispositionReasonId LEFT OUTER JOIN
                         Disposition AS Disposition_2 WITH (NOLOCK) ON ExtendedLoanApplication.FraudCheckDispositionId = Disposition_2.DispositionId LEFT OUTER JOIN
                         Disposition AS Disposition_1 WITH (NOLOCK) ON ExtendedLoanApplication.UnderWrittenDispositionId = Disposition_1.DispositionId LEFT OUTER JOIN
                         ApplicationStage ON ExtendedLoanApplication.LastCompletedApplicationStageId = ApplicationStage.ApplicationStageId LEFT OUTER JOIN
                         [User] WITH (NOLOCK) ON ExtendedLoanApplication.OverriddenBy = [User].UserId LEFT OUTER JOIN
                         [User] AS User_5 WITH (NOLOCK) ON ExtendedLoanApplication.FraudCheckAgentId = User_5.UserId LEFT OUTER JOIN
                         [User] AS User_4 WITH (NOLOCK) ON ExtendedLoanApplication.UnderWritingManagerId = User_4.UserId LEFT OUTER JOIN
                         [User] AS User_3 WITH (NOLOCK) ON ExtendedLoanApplication.UnderWritingAgentId = User_3.UserId LEFT OUTER JOIN
                         [User] AS User_2 WITH (NOLOCK) ON ExtendedLoanApplication.LastUnderWrittenBy = User_2.UserId LEFT OUTER JOIN
                         [User] AS User_1 WITH (NOLOCK) ON ExtendedLoanApplication.LastVerifiedBy = User_1.UserId


GO

CREATE VIEW [dbo].[vwLoanApplicationVersionDetails]
AS
SELECT        dbo.LoanApplicationVerision.LoanApplicationId, dbo.LoanApplicationVerision.LoanNumber, dbo.LoanApplicationVerision.VersionNumber, 
                         dbo.LoanApplicationVerision.VersionReasonId, dbo.ApplicationVersionReason.VersionReasonDescription, dbo.LoanApplicationVerision.CreatedBy, 
                         User_1.FirstName, User_1.LastName, dbo.LoanApplicationVerision.CreatedOn, dbo.LoanApplicationVerision.UpdatedBy, dbo.[User].FirstName AS Expr1, 
                         dbo.[User].LastName AS Expr2, dbo.LoanApplicationVerision.UpdatedOn, dbo.LoanApplicationVerision.LoanAgreementFileId, 
                         dbo.LoanApplicationVerision.BorrowerAgreementFileId, dbo.LoanApplicationVerision.PrivacyNoticeFileId, dbo.LoanApplicationVerision.ElectronicSignatureFileId
FROM            dbo.LoanApplicationVerision INNER JOIN
                         dbo.ApplicationVersionReason ON dbo.LoanApplicationVerision.VersionReasonId = dbo.ApplicationVersionReason.VersionReasonID LEFT OUTER JOIN
                         dbo.[User] ON dbo.LoanApplicationVerision.UpdatedBy = dbo.[User].UserId LEFT OUTER JOIN
                         dbo.[User] AS User_1 ON dbo.LoanApplicationVerision.CreatedBy = User_1.UserId

GO

CREATE VIEW [dbo].[vwLoanAssignmentHistory]
AS
SELECT        TOP (100) PERCENT dbo.LoanAppAssignmentHistory.LoanApplicationId, dbo.LoanAppAssignmentHistory.ApplicationStateId, 
                         dbo.ApplicationState.ApplicationStateName, dbo.LoanAppAssignmentHistory.AssignedTo, User_1.FirstName AS AssignedToFN, User_1.LastName AS AssignedToLN, 
                         dbo.LoanAppAssignmentHistory.AssignedBy, dbo.[User].FirstName AS AssignedByFN, dbo.[User].LastName AS AssignedByLN, 
                         dbo.LoanAppAssignmentHistory.AssignedOn
FROM            dbo.[User] WITH (NOLOCK) RIGHT OUTER JOIN
                         dbo.LoanAppAssignmentHistory WITH (NOLOCK) INNER JOIN
                         dbo.ApplicationState WITH (NOLOCK) ON dbo.LoanAppAssignmentHistory.ApplicationStateId = dbo.ApplicationState.ApplicationStateId ON 
                         dbo.[User].UserId = dbo.LoanAppAssignmentHistory.AssignedTo LEFT OUTER JOIN
                         dbo.[User] AS User_1 WITH (NOLOCK) ON dbo.LoanAppAssignmentHistory.AssignedBy = User_1.UserId


GO


CREATE VIEW [dbo].[vwLoanStages]
AS
SELECT dbo.LoanApplicationStage.LoanApplicationId, dbo.LoanApplicationStage.ApplicationStageId, dbo.ApplicationStage.ApplicationStageName, 
dbo.ApplicationStage.ApplicationStateId, dbo.ApplicationState.ApplicationStateName, 
dbo.LoanApplicationStage.ApplicationStageStatus, dbo.LoanApplicationStage.UpdatedBy, 
dbo.[User].FirstName AS UpdatedByFN, dbo.[User].LastName AS UpdatedByLN,dbo.LoanApplicationStage.UpdatedOn 
FROM dbo.[User] WITH (NOLOCK) RIGHT OUTER JOIN
dbo.LoanApplicationStage  WITH (NOLOCK) ON dbo.[User].UserId = dbo.LoanApplicationStage.UpdatedBy LEFT OUTER JOIN
dbo.ApplicationState  WITH (NOLOCK) INNER JOIN
dbo.ApplicationStage  WITH (NOLOCK) ON dbo.ApplicationState.ApplicationStateId = dbo.ApplicationStage.ApplicationStateId ON 
dbo.LoanApplicationStage.ApplicationStageId = dbo.ApplicationStage.ApplicationStageId

GO



