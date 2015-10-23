-- =============================================
-- Author:		 Sehul Soni
-- Updated date: 05-Oct-2015
-- Description:	 To see loan details
-- =============================================
IF EXISTS (
        SELECT type_desc, type FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'GetLoanDetails' AND type = 'P'
      )
     DROP PROCEDURE [dbo].[GetLoanDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLoanDetails] 
@LoanNumber AS BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @LeadID AS BIGINT
	DECLARE @LoanApplicationId AS BIGINT
	DECLARE @LoanAccountID AS BIGINT

	SELECT @LoanApplicationId=LoanApplicationId, 
		   @LeadID=LeadId 
		   FROM dbo.LoanApplication WITH (NOLOCK)
		   WHERE LoanNumber = @LoanNumber

	SELECT @LoanAccountID=LoanAccountID 
			FROM dbo.LoanAccounts WITH (NOLOCK)
			WHERE LoanApplicationId=@LoanApplicationId

	-- Borrower Personal Details
	SELECT * FROM vwApplicantPersonalDetails WHERE LoanApplicationId=@LoanApplicationId

	-- Offer generated for current loan
	SELECT LeadOfferId, LoanApplicationId, LoanAmount, TakeHomeAmount, AnnualPercentageRate, InterestRate, MonthlyPayment, LoanTerm, OriginationFees, Acquisitionfee, 
	RS03InterestRate, IsSelected, IsEditedOffer, VersionNumber, DTIValue, OfferType
	FROM  LeadOffers WITH (NOLOCK)
	WHERE LoanApplicationId = @LoanApplicationId

	-- Offer history for current loan
	SELECT LeadOfferId, LeadOfferId,LoanApplicationId, LoanAmount, TakeHomeAmount, AnnualPercentageRate, InterestRate, MonthlyPayment, LoanTerm, OriginationFees, Acquisitionfee, 
	RS03InterestRate, IsSelected, IsEditedOffer, VersionNumber, DTIValue, OfferType
	FROM  LeadOffersHistory WITH (NOLOCK)
	WHERE LoanApplicationId = @LoanApplicationId

	-- Applicant Loan and Selected Offer Details with Last Stage
	SELECT * FROM vwApplicantLoanDetails WITH (NOLOCK) WHERE LoanApplicationId=@LoanApplicationId

	-- Extended Loan Application Details
	SELECT * FROM vwExtendedLoanApplication WITH (NOLOCK) WHERE LoanApplicationId=@LoanApplicationId
	
	-- Uploaded Documents list
	SELECT * FROM vwDocumentUploaded WITH (NOLOCK) WHERE LoanAccountID = @LoanAccountID

	-- Loan Stages information with performed by and performed date details 
	SELECT * FROM vwLoanStages WITH (NOLOCK) WHERE LoanApplicationId=@LoanApplicationId

	-- Loan Assignment inforamation
	SELECT * FROM vwLoanAssignmentHistory WITH (NOLOCK)  WHERE LoanApplicationId=@LoanApplicationId

	-- Loan Application Version Details
	SELECT * FROM vwLoanApplicationVersionDetails WITH (NOLOCK) WHERE LoanApplicationID =  @LoanApplicationId

END