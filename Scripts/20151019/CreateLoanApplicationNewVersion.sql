/****** Object:  StoredProcedure [dbo].[CreateLoanApplicationNewVersion]    Script Date: 10/19/2015 17:14:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author		: Kamal
-- Created date	: 7-June-2015
-- Description	: Creates new application version from the given loan application id,
--				  copies the existing version into the corresponding history table
-- Version		: 3.0
-- updated date	: 24-Sepetember-2015
-- Updated By	: Bhushan Shah
-- updated date	: 19-Octomber-2015
-- Updated By	: Bharat Prajapati


-- =============================================
ALTER PROCEDURE [dbo].[CreateLoanApplicationNewVersion] 
	@LoanApplicationId bigint,
	@VersionReasonId int,
	@CreatedBy bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @intErrorCode INT
	DECLARE @CurrentVersionNumber int
	DECLARE @LoanAccountId bigint
	DECLARE @NewVersionNumber int
	DECLARE @MaxlimitperApplication int
	DECLARE @CountVersionReason int

	--SET XACT_ABORT ON;
	SET NOCOUNT ON;
	

	--Get Current version number and Account id
	select @LoanAccountId=LoanAccountId
		from LoanAccounts where LoanApplicationId=@LoanApplicationId

	select @CurrentVersionNumber=[CurrentVersionNumber]
		from LoanApplication where LoanApplicationId=@LoanApplicationId

	--Get the Max limit for the given application version reason
	select @MaxlimitperApplication=[MaxlimitperApplication] from [ApplicationVersionReason] where VersionReasonId = @VersionReasonId
		
	--Get the count of application version for the given version reason
	select @CountVersionReason=count(*) from [LoanApplicationVerision] where [VersionReasonId] = @VersionReasonId and LoanApplicationId=@LoanApplicationId

	set @CurrentVersionNumber =ISNULL(@CurrentVersionNumber,1) 

	--Checks the version number
		
	if(@CountVersionReason >=@MaxlimitperApplication)	
	BEGIN
		--PRINT 'Version Limit exceeded'	
		RETURN -1 -- Execeed Limit
	END

	BEGIN TRY
	BEGIN TRAN
		--create new version number
		SET @NewVersionNumber = @CurrentVersionNumber + 1 -- CONCAT('V',  CAST(REPLACE(@CurrentVersionNumber,'V','') as int)+1)

		IF @VersionReasonId = 50
		BEGIN

		INSERT INTO [dbo].[LoanApplicationHistory]
			([LoanApplicationId]
			,[LeadId]
			,[Email]
			,[FirstName]
			,[MiddleInitial]
			,[LastName]
			,[SSN]
			,[PhoneNumber]
			,[DateOfBirth]
			,[HomeAddress]
			,[City]
			,[State]
			,[ZipCode]
			,[LoanAmount]
			,[LoanTerm]
			,[FicoScore]
			,[MonthlyIncome]
			,[AppliedOn]
			,[CreatedOn]
			,[CreatedBy]
			,[UpdatedOn]
			,[UpdatedBy]
			,[PromoCode]
			,[EquifaxFicoScore]
			,[EquifaxDtiScore]
			,[NetMonthlyIncome]
			,[EmploymentStatusType]
			,[PuposeOfLoan]
			,[IsHomeOwner]
			,[BankName]
			,[OffExpDate]
			,[SaltedCode]
			,[ApplicationStatusId]
			,[AssignedTo]
			,[AssignedBy]
			,[AssignedOn]
			,[EquiFaxInquiryFactors]
			,[AccountNumber]
			,[RoutingNumber]
			,[BankAccountType]
			,[NameInBank]
			,[LoanNumber]
			,[IsLoanCompleted]
			,[IsLoanDocumentSigned]
			,[IsLoanDepotCustomer]
			,[HomeType]
			,[MonthlyRentalPayment]
			,[MonthlyMortgagePayment]
			,[Employer]
			,[Position]
			,[Tenure]
			,[WorkAddress]
			,[WorkCity]
			,[WorkState]
			,[WorkZip]
			,[WorkPhone]
			,[WorkWebsite]
			,[EquifaxSoftfullCreditCheckTime]
			,[ExpiredOn]
			,[CreditReportFileId]
			,[BankFirstName]
			,[BankLastName]
			,[MarketingChannel]
			,[ReferringAgent]
			,[BankLinkedTime]
			,[LoanAgreementFileId]
			,[PrivacyPolicyFileId]
			,[TermsOfUseFileId]
			,[BankConsentFileId]
			,[RealIpAddress]
			,[Longitude]
			,[Lattitude]
			,[EquifaxHardPullFicoScore]
			,[BorrowerAgreementFileId]
			,[PrivacyNoticeFileId]
			,[ElectronicSignatureFileId]
			,[ElectronicFundsTransferFileId]
			,[SoftPullTTYReportFileId]
			,[HardPullTTYReportFileId]
			,[ApplicationDetailFileId]
			,[FCRADeclinedLetterFileId]
			,[LoanDepotProdcutType]
			,[LeadSourceName]
			,[CreditReportAuthorizationFileId]
			,[IsCreatedBySMB]
			,[IsMovedToSales]
			,[HardPullDeclineStageId]
			,[EditAttempts]
			,[IsReviewEdit]
			,[ReviewEditOn]
			,[CurrentVersionNumber]
			,[CurrentVersionReasonId]
			,[SubscriberId]
			,[TCPADisclosureFileId]
			,[CreditReportNoticeUWFileId]
			,[PLAIDPrivacyNoticeFileId]
			,[EquifaxSSN]
			,[TenureStartDate])
     SELECT
			[LoanApplicationId]
			,[LeadId]
			,[Email]
			,[FirstName]
			,[MiddleInitial]
			,[LastName]
			,[SSN]
			,[PhoneNumber]
			,[DateOfBirth]
			,[HomeAddress]
			,[City]
			,[State]
			,[ZipCode]
			,[LoanAmount]
			,[LoanTerm]
			,[FicoScore]
			,[MonthlyIncome]
			,[AppliedOn]
			,[CreatedOn]
			,[CreatedBy]
			,[UpdatedOn]
			,[UpdatedBy]
			,[PromoCode]
			,[EquifaxFicoScore]
			,[EquifaxDtiScore]
			,[NetMonthlyIncome]
			,[EmploymentStatusType]
			,[PuposeOfLoan]
			,[IsHomeOwner]
			,[BankName]
			,[OffExpDate]
			,[SaltedCode]
			,[ApplicationStatusId]
			,[AssignedTo]
			,[AssignedBy]
			,[AssignedOn]
			,[EquiFaxInquiryFactors]
			,[AccountNumber]
			,[RoutingNumber]
			,[BankAccountType]
			,[NameInBank]
			,[LoanNumber]
			,[IsLoanCompleted]
			,[IsLoanDocumentSigned]
			,[IsLoanDepotCustomer]
			,[HomeType]
			,[MonthlyRentalPayment]
			,[MonthlyMortgagePayment]
			,[Employer]
			,[Position]
			,[Tenure]
			,[WorkAddress]
			,[WorkCity]
			,[WorkState]
			,[WorkZip]
			,[WorkPhone]
			,[WorkWebsite]
			,[EquifaxSoftfullCreditCheckTime]
			,[ExpiredOn]
			,[CreditReportFileId]
			,[BankFirstName]
			,[BankLastName]
			,[MarketingChannel]
			,[ReferringAgent]
			,[BankLinkedTime]
			,[LoanAgreementFileId]
			,[PrivacyPolicyFileId]
			,[TermsOfUseFileId]
			,[BankConsentFileId]
			,[RealIpAddress]
			,[Longitude]
			,[Lattitude]
			,[EquifaxHardPullFicoScore]
			,[BorrowerAgreementFileId]
			,[PrivacyNoticeFileId]
			,[ElectronicSignatureFileId]
			,[ElectronicFundsTransferFileId]
			,[SoftPullTTYReportFileId]
			,[HardPullTTYReportFileId]
			,[ApplicationDetailFileId]
			,[FCRADeclinedLetterFileId]
			,[LoanDepotProdcutType]
			,[LeadSourceName]
			,[CreditReportAuthorizationFileId]
			,[IsCreatedBySMB]
			,[IsMovedToSales]
			,[HardPullDeclineStageId]
			,[EditAttempts]
			,[IsReviewEdit]
			,[ReviewEditOn]
			,[CurrentVersionNumber]
			,[CurrentVersionReasonId]
			,[SubscriberId]
			,[TCPADisclosureFileId]
			,[CreditReportNoticeUWFileId]
			,[PLAIDPrivacyNoticeFileId]
			,[EquifaxSSN]
			,[TenureStartDate]
		   FROM LoanApplication with (nolock) WHERE LoanApplicationId = @LoanApplicationId
           
		END

		--PRINT 'LeadOffers History Created'

		--Creates Application Consent History for the given application id
		INSERT INTO [ApplicationConsentHistory]
				   ([Id]
				   ,[LoanApplicationId]
				   ,[ConsentTypeId]
				   ,[ConsentTimestamp]
				   ,[IPAddress]
				   ,[SessionId]
				   ,[CreatedBy]
				   ,[CreatedOn]
				   ,[VersionNumber])
			 SELECT [Id]
			  ,[LoanApplicationId]
			  ,[ConsentTypeId]
			  ,[ConsentTimestamp]
			  ,[IPAddress]
			  ,[SessionId]			 
			  ,[CreatedBy]
			  ,[CreatedOn]
			  ,[VersionNumber]
		  FROM [ApplicationConsent] with (nolock) where LoanApplicationId=@LoanApplicationId
		  		
		--PRINT 'ApplicationConsent History Created'
		
		--Creates Loan Application Stage History for the given application id
		INSERT INTO [LoanApplicationStageHistory]
           ([LoanApplicationStageId]
           ,[LoanApplicationId]
           ,[ApplicationStageId]
           ,[ApplicationStageStatus]
           ,[LoginHistoryID]
           ,[CreatedOn]
           ,[CreatedBy]
           ,[UpdatedOn]
           ,[UpdatedBy]
           ,[VersionNumber])
			 SELECT [LoanApplicationStageId]
			  ,[LoanApplicationId]
			  ,[ApplicationStageId]
			  ,[ApplicationStageStatus]
			  ,[LoginHistoryID]
			  ,[CreatedOn]
			  ,[CreatedBy]
			  ,[UpdatedOn]
			  ,[UpdatedBy]
			  ,[VersionNumber]
		  FROM [LoanApplicationStage] where [LoanApplicationId]=@LoanApplicationId
		
		--PRINT 'LoanApplicationStage History Created'
		INSERT INTO [LoanApplicationVerision]
           ([LoanNumber]
           ,[LoanApplicationId]
           ,[VersionNumber]
           ,[VersionReasonId]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[UpdatedBy]
           ,[UpdatedOn]
           ,[LoanAgreementFileId]
           ,[BorrowerAgreementFileId]
           ,[PrivacyNoticeFileId]
           ,[ElectronicSignatureFileId])
			SELECT  [LoanNumber]
				,@LoanApplicationId
				,@NewVersionNumber
				,@VersionReasonId
				,@CreatedBy
				,GETUTCDATE()
				,@CreatedBy
				,GETUTCDATE()
			    ,[LoanAgreementFileId]
			    ,[BorrowerAgreementFileId]
			    ,[PrivacyNoticeFileId]
			    ,[ElectronicSignatureFileId]
		  FROM [LoanApplication] with (nolock) where [LoanApplicationId]=@LoanApplicationId 

		--creates lead offer history for the given application id
		INSERT INTO [LeadOffersHistory]
					([LeadOfferId],
					[LoanApplicationId],
					[LoanAmount],
					[TakeHomeAmount],
					[AnnualPercentageRate],
					[InterestRate],
					[MonthlyPayment],
					[LoanTerm],
					[OriginationFees],
					[CreatedOn],
					[IsSelected],
					[IsEditedOffer],
					[Acquisitionfee],
					[OfferId],
					[VersionNumber],
					[RS03InterestRate],
					[DTIValue],
					[OfferType])
			SELECT [LeadOfferId],
					[LoanApplicationId],
					[LoanAmount],
					[TakeHomeAmount],
					[AnnualPercentageRate],
					[InterestRate],
					[MonthlyPayment],
					[LoanTerm],
					[OriginationFees],
					[CreatedOn],
					[IsSelected],
					[IsEditedOffer],
					[Acquisitionfee],
					[OfferId],
					[VersionNumber],
					[RS03InterestRate],
					[DTIValue],
					[OfferType]
			FROM [LeadOffers] with (nolock) where LoanApplicationId=@LoanApplicationId

		--creates ExtendedAttributeHistory for the given application id
		INSERT INTO [ExtendedAttributeHistory]
			([Name],
			[Value],
			[Description],
			[LoanApplicationId],
			[CreatedOn],
			[CreatedBy],
			[UpdatedOn],
			[UpdatedBy],
			[DisplayOrder],
			[InquiryType],
			[Category],
			[VersionNumber],
			[VersionReasonId],
			[InsertedOn]
			)
			SELECT 
			[Name],
			[Value],
			[Description],
			[LoanApplicationId],
			[CreatedOn],
			[CreatedBy],
			[UpdatedOn],
			[UpdatedBy],
			[DisplayOrder],
			[InquiryType],
			[Category],
			[VersionNumber],
			[VersionReasonId],
			GETUTCDATE()
		FROM ExtendedAttribute with (nolock)
		WHERE [LoanApplicationId]=@LoanApplicationId 
		
		--creates ExtendedInterestRateAttributesHistory for the given application id
		INSERT INTO [ExtendedInterestRateAttributesHistory]
				([LoanApplicationId],
				[LoanOfferAmount],
				[LoanOfferTerm],
				[Name],
				[Value],
				[Description],
				[DisplayOrder],
				[InquiryType],
				[CreatedOn],
				[CreatedBy],
				[UpdatedOn],
				[UpdatedBy],
				[VersionNumber],
				[VersionReasonId],
				[InsertedOn]
				)
				SELECT
				[LoanApplicationId],
				[LoanOfferAmount],
				[LoanOfferTerm],
				[Name],
				[Value],
				[Description],
				[DisplayOrder],
				[InquiryType],
				[CreatedOn],
				[CreatedBy],
				[UpdatedOn],
				[UpdatedBy],
				[VersionNumber],
				[VersionReasonId],
				GETUTCDATE()
				FROM ExtendedInterestRateAttributes
				WHERE LoanApplicationId = @LoanApplicationId 
		

		 --PRINT 'LoanApplication Version History Created'

		  Update LoanApplication set 
			  CurrentVersionNumber=@NewVersionNumber,
			  CurrentVersionReasonId=@VersionReasonId 
			  where LoanApplicationId=@LoanApplicationId

		  --PRINT 'LoanApplication version Updated'

		  Update LoanApplicationStage set 
			  VersionNumber=@NewVersionNumber
			  where LoanApplicationId=@LoanApplicationId
		  
		  --PRINT 'LoanApplicationStage version Updated'
		  
		  Update ApplicationConsent set 
			  VersionNumber=@NewVersionNumber
			  where LoanApplicationId=@LoanApplicationId

		  --PRINT 'ApplicationConsent version Updated'
		  
		  Update LeadOffers set 
			  VersionNumber=@NewVersionNumber
			  where LoanApplicationId=@LoanApplicationId

		  --PRINT 'LeadOffers Version Updated'

		  Update LoanApplicationDocType set 
			  VersionNumber=@NewVersionNumber
			  where LoanAccountId=@LoanAccountId
		  
		  --PRINT 'LoanApplicationDocType Version Updated'

		  UPDATE	ExtendedAttribute
			SET		VersionNumber = @NewVersionNumber,
					VersionReasonId = @VersionReasonId
			WHERE	LoanApplicationId = @LoanApplicationId
			AND		VersionNumber = @CurrentVersionNumber

			UPDATE	ExtendedInterestRateAttributes
			SET		VersionNumber = @NewVersionNumber,
					VersionReasonId = @VersionReasonId
			WHERE	LoanApplicationId = @LoanApplicationId
			AND		VersionNumber = @CurrentVersionNumber

	COMMIT TRAN
		
	--PRINT 'All Updated committed'
	RETURN 1 -- Completed successfully

	END TRY
	BEGIN CATCH
		--PRINT 'Error occurred!'
		--PRINT '*************Error Detail****************'
		--PRINT 'Error Number  :' + CAST(ERROR_NUMBER() AS VARCHAR)
		--PRINT 'Error Severity:' + CAST(ERROR_SEVERITY() AS VARCHAR)
		--PRINT 'Error State   :' + CAST(ERROR_STATE() AS VARCHAR)
		--PRINT 'Error Line    :' + CAST(ERROR_LINE() AS VARCHAR)
		--PRINT 'Error Message :' + ERROR_MESSAGE()
		ROLLBACK TRAN
		RETURN 0 -- Error Occured 
	END CATCH

END


