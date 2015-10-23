/****** Object:  StoredProcedure [dbo].[ConvertQuoteToApplication]    Script Date: 10/10/2015 7:05:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		KAMAL
-- Create date: 09-OCT-2015
-- Description:	Convert quote to application
-- =============================================
ALTER PROCEDURE [dbo].[ConvertQuoteToApplication] 
	-- Add the parameters for the stored procedure here
		@QuoteId bigint,
		@QuoteOfferId bigint,
		@FirstName varchar(50),
        @MiddleInitial varchar(50),        
        @LastName varchar(50),
        @Email varchar(100),
        @SSN varchar(32),
        @PhoneNumber varchar(15),        
        @DateOfBirth varchar(64),        
        @HomeAddress varchar(300),        
        @City varchar(50),        
        @State varchar(50),        
        @ZipCode varchar(10),
        @PromoCode varchar(64),        
        @FicoScore int,
        @TermsOfUseConsentTime datetime,
        @CreditReportConsentTime datetime,
        @ClientIPAddress varchar(30) = null,
        @MarketingChannel int,            
		@I3Identity bigint,
		@SubscriberId bigint,            
		@EmailToken varchar(100),
		@LoanApplicationId bigint = 0 OUTPUT,
		@LoanNumber bigint = 0 OUTPUT,
		@LoanAmount decimal(18,2) = 0  OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @QuoteLoanAmount decimal(18,2)
	DECLARE	@LoanTerm int
	DECLARE @EquifaxFicoScore int
	DECLARE	@PuposeOfLoan int
	DECLARE @YearlyIncome decimal(18,2)
	DECLARE @AuthenticatedConsumerId bigint
	DECLARE @LeadId bigint
	DECLARE @ConsumerAccountId bigint	
	DECLARE	@MonthlyIncome decimal(18,2)
	DECLARE @Iterator int = 1

    -- Insert statements for procedure here
	SELECT @QuoteLoanAmount = [LoanAmount]
      ,@YearlyIncome=[YearlyIncome]
      ,@PuposeOfLoan=[PurposeOfLoan]
      ,@EquifaxFicoScore= [EquifaxFicoScore]
  FROM [LDWhitneyQuotes].[dbo].[Quotes] where QuoteId= @QuoteId

  SET @LoanAmount = @QuoteLoanAmount

  INSERT INTO [LDWhitneyAuthentication].[dbo].[AuthenticatedConsumer]
           ([EmailAddress]
           ,[Password]
		   ,[EmailToken]
           ,[CreatedOn]
           ,[UpdatedOn])
     VALUES
           (@Email
           ,''
		   ,@EmailToken
           ,GETUTCDATE()
           ,GETUTCDATE())

SET @AuthenticatedConsumerId =  @@IDENTITY

INSERT INTO [dbo].[Leads]
           ([AuthenticatedConsumerId]           
           ,[FirstName]
           ,[MiddleInitial]
           ,[LastName]
		   ,[Email]
           ,[PhoneNumber]
           ,[DateOfBirth]
           ,[HomeAddress]
           ,[City]
           ,[State]
           ,[ZipCode]
           ,[LeadSourceId]
           ,[LoanAmount]
           ,[LoanTerm]
		   ,[NetMonthlyIncome]
           ,[FicoScore]
           ,[AppliedOn]
           ,[CreatedOn]
           ,[PromoCode]
           ,[EquifaxFicoScore]
           ,[PuposeOfLoan]
           ,[ConsentTimeStamp2]
           ,[MarketingChannel]
		   ,IsHomeOwner
		   ,[IsLoanDepotCustomer]
		   ,[LoanDepotProdcutType])
     VALUES
           (@AuthenticatedConsumerId,
		    @FirstName ,
			@MiddleInitial ,        
			@LastName ,
			@Email ,
			@PhoneNumber ,        
			@DateOfBirth ,        
			@HomeAddress ,        
			@City ,        
			@State ,        
			@ZipCode ,            
			@I3Identity,
			@QuoteLoanAmount,
			@LoanTerm,
			@YearlyIncome,
			@FicoScore ,
			GETUTCDATE(),
			GETUTCDATE(),
			@PromoCode ,        
			@EquifaxFicoScore,
			@PuposeOfLoan,
			@CreditReportConsentTime,
			@MarketingChannel,
			0,
			0,
			1)

SET @LeadId =  @@IDENTITY

		 INSERT INTO [dbo].[ConsumerAccounts]
           ([AuthenticatedConsumerId]
           ,[FirstName]
           ,[MiddleInitial]
           ,[LastName]
           ,[PhoneNumber]
           ,[HomeAddress]
           ,[City]
           ,[State]
           ,[ZipCode]
           ,[CreatedOn]
           ,[UpdatedOn]
           ,[LeadId]
		   ,[LoginAttemptCount])
     VALUES
           (@AuthenticatedConsumerId
           ,@FirstName
           ,@MiddleInitial
           ,@LastName
           ,@PhoneNumber
           ,@HomeAddress
           ,@City
           ,@State
           ,@ZipCode
           ,GETUTCDATE()
           ,GETUTCDATE()
           ,@LeadId
		   ,0)

SET @ConsumerAccountId =  @@IDENTITY

EXEC proc_GetNextLoanNumber @LoanNumber OUT

INSERT INTO [dbo].[LoanApplication]
           ([LeadId]
           ,[Email]
           ,[FirstName]
           ,[MiddleInitial]
           ,[LastName]
           ,[EquifaxSSN]
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
           ,[PromoCode]
           ,[EquifaxFicoScore]
           ,[NetMonthlyIncome]
           ,[PuposeOfLoan]
           ,[ApplicationStatusId]
           ,[LoanNumber]
           ,[MarketingChannel]
           ,[RealIpAddress]
           ,[CurrentVersionNumber]
           ,[CurrentVersionReasonId]
           ,[SubscriberId]
		   ,[BankAccountType]
		   ,[IsHomeOwner]
		   ,[IsLoanCompleted]
		   ,[IsLoanDocumentSigned]
		   ,[IsLoanDepotCustomer]
		   ,[HomeType]
		   ,[CreditReportFileId]
		   ,[LoanAgreementFileId]
		   ,[PrivacyPolicyFileId]
		   ,[TermsOfUseFileId]
		   ,[BankConsentFileId]
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
		   ,[CreditReportAuthorizationFileId]
		   ,[IsCreatedBySMB]
		   ,[IsMovedToSales]
		   ,[HardPullDeclineStageId]
		   ,[EditAttempts]
		   ,[IsReviewEdit]
		   ,[CreditReportNoticeUWFileId]
		   ,[PLAIDPrivacyNoticeFileId]
		   ,TCPADisclosureFileId
		   )
     VALUES
           (@LeadId
           ,@Email
           ,@FirstName
           ,@MiddleInitial
           ,@LastName
           ,@SSN
           ,@PhoneNumber
           ,@DateOfBirth
           ,@HomeAddress
           ,@City
           ,@State
           ,@ZipCode
           ,@QuoteLoanAmount
           ,@LoanTerm
           ,@FicoScore
           ,@MonthlyIncome
           ,GETUTCDATE()
           ,GETUTCDATE()
           ,@PromoCode
           ,@EquifaxFicoScore
           ,@YearlyIncome
           ,@PuposeOfLoan
           ,1
		   ,@LoanNumber
           ,@MarketingChannel
           ,@ClientIPAddress
           ,1
           ,10
           ,@SubscriberId
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
           ,0
		   ,0
		   ,0
		   ,0
		   ,1
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0
		   ,0)
SET @LoanApplicationId=@@IDENTITY

INSERT INTO [dbo].[LoanApplicationVerision]
           ([LoanNumber]
           ,[LoanApplicationId]
           ,[VersionNumber]
           ,[VersionReasonId]
           ,[CreatedOn]
		   ,[LoanAgreementFileId]
		   ,[BorrowerAgreementFileId]
		   ,[PrivacyNoticeFileId]
		   ,[ElectronicSignatureFileId])
     VALUES
           (@LoanNumber
           ,@LoanApplicationId
           ,1
           ,10
           ,GETUTCDATE()
		   ,0
		   ,0
		   ,0
		   ,0)
		   

		   WHILE (@Iterator < 6)
			BEGIN
		     --  Loan Application Stipulation
			 INSERT INTO [dbo].[LoanApplicationStipulation]
					   ([LoanApplicationId]
					   ,[StipulationTypeId]
					   ,[CreatedOn]
					   ,[UpdatedOn])
				 VALUES
					   (@LoanApplicationId
					   ,@Iterator
					   ,GETUTCDATE()
					   ,GETUTCDATE())
				Set @Iterator = @Iterator + 1
			END 

		   Insert into [dbo].[LoanApplicationStage]  
		   (LoanApplicationId,
		   ApplicationStageId,
		   VersionNumber,
		   CreatedOn)
		   select 
		   @LoanApplicationId,
		   ApplicationStageId,
		   1,
		   GETUTCDATE() from ApplicationStage where IsDefault=1

		   Update LoanApplicationStage set ApplicationStageStatus=1, UpdatedOn=GETUTCDATE() 
				where LoanApplicationId=@LoanApplicationId and ApplicationStageId in (0,100,200,300)

		INSERT INTO [dbo].[LoanApplicationLastStage]
           ([LoanApplicationId]
           ,[ApplicationStageId]
           ,[CreatedOn]
		   ,[UpdatedOn])
		 VALUES
			   (@LoanApplicationId
			   ,300
			   ,GETUTCDATE()
			   ,GETUTCDATE())


			INSERT INTO [dbo].[ExtendedLoanApplication]
				   ([LoanApplicationId]
				   ,[FullyLoadedDTI]
				   ,[IsCDOverridden]
				   ,[OverriddenBy]
				   	,[SSNMatchAttempts]
					,[IsSSNMatched]

				   )
			 VALUES
				   (@LoanApplicationId,0,0,0,0,0)

				   
		INSERT INTO [dbo].[LoanApplicationTrack]
				   ([LoanApplicationId]
				   ,[CreatedOn]
				   ,[IsIovationVerified]
				   ,[IsNeustarVerified]
				   ,[IsEquifaxVerified]
				   ,[IsIdAnalyticsVerified]
				   ,[IsEidVerified]
				   ,[IsLoanOfferSelected]
					,[IsYodleeVerified]
					
			   )
			 VALUES
				   (@LoanApplicationId,
				   GETUTCDATE() ,0,0,0,0,0,0,0)

			INSERT INTO [dbo].[LeadOffers]
				   ([LoanApplicationId]
				   ,[LoanAmount]
				   ,[TakeHomeAmount]
				   ,[AnnualPercentageRate]
				   ,[InterestRate]
				   ,[MonthlyPayment]
				   ,[LoanTerm]
				   ,[OriginationFees]
				   ,[CreatedOn]
				   ,[IsSelected]
				   ,[IsEditedOffer]
				   ,[Acquisitionfee]
				   ,[OfferId]
				   ,[VersionNumber]
				   ,[RS03InterestRate]
				   ,[DTIValue]
				   ,[OfferType])
			 SELECT @LoanApplicationId
			  ,[LoanAmount]
			  ,[TakeHomeAmount]
			  ,[AnnualPercentageRate]
			  ,[InterestRate]
			  ,[MonthlyPayment]
			  ,[LoanTerm]
			  ,[OriginationFees]
			  ,[CreatedOn]
			  ,[IsSelected]
			  ,[IsEditedOffer]
			  ,[Acquisitionfee]
			  ,[OfferId]
			  ,[VersionNumber]
			  ,[RS03InterestRate]
			  ,[DTIValue]
			  ,[OfferType]
		  FROM [LDWhitneyQuotes].[dbo].[QuoteOffers] where QuoteId = @QuoteId and QuoteOfferId!=@QuoteOfferId

		  INSERT INTO [dbo].[LeadOffers]
				   ([LoanApplicationId]
				   ,[LoanAmount]
				   ,[TakeHomeAmount]
				   ,[AnnualPercentageRate]
				   ,[InterestRate]
				   ,[MonthlyPayment]
				   ,[LoanTerm]
				   ,[OriginationFees]
				   ,[CreatedOn]
				   ,[IsSelected]
				   ,[IsEditedOffer]
				   ,[Acquisitionfee]
				   ,[OfferId]
				   ,[VersionNumber]
				   ,[RS03InterestRate]
				   ,[DTIValue]
				   ,[OfferType])
			 SELECT @LoanApplicationId
			  ,[LoanAmount]
			  ,[TakeHomeAmount]
			  ,[AnnualPercentageRate]
			  ,[InterestRate]
			  ,[MonthlyPayment]
			  ,[LoanTerm]
			  ,[OriginationFees]
			  ,[CreatedOn]
			  ,1
			  ,[IsEditedOffer]
			  ,[Acquisitionfee]
			  ,[OfferId]
			  ,[VersionNumber]
			  ,[RS03InterestRate]
			  ,[DTIValue]
			  ,[OfferType]
		  FROM [LDWhitneyQuotes].[dbo].[QuoteOffers] where QuoteId = @QuoteId and QuoteOfferId=@QuoteOfferId

INSERT INTO ExtendedAttribute(Name,Value,Description,CreatedOn,LoanApplicationId,Category,InquiryType,CreatedBy,UpdatedBy, VersionNumber,VersionReasonId,DisplayOrder)
SELECT Name, Value, Name,GETUTCDATE(),@LoanApplicationId,1,'Softpull',0,0,1,10,1
FROM 
   (SELECT	RAW_NoInquIn3Months AS RAW_3000,
			RAW_OldestInstalAcct AS RAW_3116,
			RAW_NoAcctOpenedIn12Months AS RAW_3135,
			RAW_NoOpenSalesFinanAcct AS RAW_3147,
			RAW_TotBalOpenMortAcctIn3Months AS RAW_3165,
			RAW_TotPastDueAmtAcctUpdateIn3Months AS RAW_3236,
			RAW_NoAcctWorstRating120to180PastDueIn3Months AS RAW_3406,
			RAW_NoOpenCardAcctUpdateIn3MonthsHighCredit AS RAW_3726,
			RAW_PercentBalToHighCreditWithUpdateIn3Months AS RAW_3856,
			RAW_PercentTradesSatIn6Months AS RAW_3938,
			ADA_TotalRevolvingDebt AS 'ADA-3168',
			ADA_CreditInquiries AS 'ADA-3001',
			ADA_DQPast3Months AS 'ADA-3188',
			ADA_AcctOpenedPast12Months AS 'ADA-3136',
			ADA_OpenCreditLines AS 'ADA-3137',
			ADA_CollectionsExcludingMedical AS 'ADA-3976',
			ADA_PublicRecordsOnFile AS 'ADA-3807',
			ADA_AgeNewestTaxLienPubRecItem AS 'ADA-3812',
			RAW_TotBalOpenBankCardAcctsWithUpdateIn3Monts AS RAW_3161,
			RAW_TotCreditLimitOpenBankCardAcctWithUpdateIn3Months AS RAW_3204,
			RAW_NoRevolvingAccts AS RAW_3109,
			RAW_AgeNewestBankCardAcct AS RAW_3124,
			AMS_No30DaysPastDueOccurIn24Months AS 'AMS-3268',
			AMS_No3rdPartyCollectIn12Months AS 'AMS-3907',
			AMS_AgeOldestAcct AS 'AMS-3111',
			AMS_AgeOldestRevolvingAcct AS 'AMS-3120',
			AMS_NoInquiriesIn6Months AS 'AMS-3024',
			AMS_NoAccounts AS 'AMS-3100',
			AMS_AgeNewestDateLastActivityAccentsOthrThanPaidAsAgreed AS 'AMS-3759',
			CPMT_MG1_TotalCurrentDebtMonthlyPayment AS CPMT_MG1,
			Debt_Current_MonthlyCurrentDeptPymt AS DEBT_CURRENT,
			Equifax_PIM_M,
			MDI_Current_MonthlyDebtToIncomeRatio AS MDI_CURRENT,
			M_AMS3000,
			M_AMS3116,
			M_AMS3135,
			M_AMS3147,
			M_AMS3165,
			M_AMS3236,
			M_AMS3406,
			M_AMS3726,
			M_AMS3856,
			M_AMS3938,
			noMorg_dti,
			M_noMorg_dti,
			cal_xbeta,
			RS03_Prob,
			RS03_score,
			FICOBin,
			RS03Bin,
			CreditGrade,
			CreditSubGrade1,
			CreditSubGrade2,
			RequestedLoanAmount,
			CoreType,
			Req_Loan_Amt_Max,
			RS03_Loan_Max,
			IncomeCapRateFor36,
			Month_Income_Cap_For36,
			Loan_Product_Max_For36,
			Loan_Product_Min_For36,
			Min_Edit_Amount_For36,
			Max_Edit_Amount_For36,
			Offergiven_Min_For36,
			Incomecapratefor60,
			Month_Income_Cap_For60,
			Loan_Product_Max_For60,
			Loan_Product_Min_For60,
			Min_Edit_Amount_For60,
			Max_Edit_Amount_For60,
			Offergiven_Min_For60,
			PIM_M			
   FROM LDWhitneyQuotes.dbo.Quotes WHERE QuoteId = @QuoteId) p
		UNPIVOT
		(Value FOR Name IN 
		([RAW_3000],
		[RAW_3116],
		[RAW_3135],
		[RAW_3147],
		[RAW_3165],
		[RAW_3236],
		[RAW_3406],
		[RAW_3726],
		[RAW_3856],
		[RAW_3938],
		[ADA-3168],
		[ADA-3001],
		[ADA-3188],
		[ADA-3136],
		[ADA-3137],
		[ADA-3976],
		[ADA-3807],
		[ADA-3812],
		[RAW_3161],
		[RAW_3204],
		[RAW_3109],
		[RAW_3124],
		[AMS-3268],
		[AMS-3907],
		[AMS-3111],
		[AMS-3120],
		[AMS-3024],
		[AMS-3100],
		[AMS-3759],
		[CPMT_MG1],
		[DEBT_CURRENT],
		[Equifax_PIM_M],
		[MDI_CURRENT],
		[M_AMS3000],
		[M_AMS3116],
		[M_AMS3135],
		[M_AMS3147],
		[M_AMS3165],
		[M_AMS3236],
		[M_AMS3406],
		[M_AMS3726],
		[M_AMS3856],
		[M_AMS3938],
		[noMorg_dti],
		[M_noMorg_dti],
		[cal_xbeta],
		[RS03_Prob],
		[RS03_score],
		[FICOBin],
		[RS03Bin],
		[CreditGrade],
		[CreditSubGrade1],
		[CreditSubGrade2],
		[RequestedLoanAmount],
		[CoreType],
		[Req_Loan_Amt_Max],
		[RS03_Loan_Max],
		[IncomeCapRateFor36],
		[Month_Income_Cap_For36],
		[Loan_Product_Max_For36],
		[Loan_Product_Min_For36],
		[Min_Edit_Amount_For36],
		[Max_Edit_Amount_For36],
		[Offergiven_Min_For36],
		[Incomecapratefor60],
		[Month_Income_Cap_For60],
		[Loan_Product_Max_For60],
		[Loan_Product_Min_For60],
		[Min_Edit_Amount_For60],
		[Max_Edit_Amount_For60],
		[Offergiven_Min_For60],
		[PIM_M]
)
)AS unpvt


INSERT INTO ExtendedInterestRateAttributes
(LoanApplicationId,LoanOfferAmount,LoanOfferTerm, Name,Value,CreatedOn,InquiryType,CreatedBy,UpdatedBy, VersionNumber,VersionReasonId,DisplayOrder)
SELECT @LoanApplicationId, LoanAmount,LoanTerm, Name, Value, GETUTCDATE(), 'SoftPull',0,0,1,10,
	case	when name = 'PM1_Income' then 1
			when name = 'PM1_R_adti' then 2
			when name = 'PM1_M_adti' then 3
			when name = 'PM1_adtisd' then 4
			when name = 'PM1_pimsd' then 5
			when name = 'PM1_tot_rev_debt' then 6
			when name = 'PM1_R_rat1' then 7
			when name = 'PM1_rat1sd' then 8
			when name = 'PM1_rat2' then 9
			when name = 'PM1_rat2sd' then 10
			when name = 'PM1_perp' then 11
			when name = 'PM1_perp_ad' then 12
			when name = 'PM1_M_pr' then 13
			when name = 'perc_bal_hicrdt_3mos' then 14
			when name = 'PM1_M_AMS3001' then 15
			when name = 'PM1_R_inq6' then 16
			when name = 'PM1_M_inq6' then 17
			when name = 'PM1_xb' then 18
			when name = 'PM1_prob_co' then 19
			when name = 'PM1_cocat' then 20
			when name = 'PM1_CreditGrade' then 22
			when name = 'AcquisitionFees' then 23 end as DisplayOrder
FROM 
(
   SELECT
	LoanAmount,
	LoanTerm,
	PM1_Income,
	PM1_R_adti,
	PM1_M_adti,
	PM1_adtisd,
	PM1_pimsd,
	PM1_tot_rev_debt,
	PM1_R_rat1,
	PM1_rat1sd,
	PM1_rat2,
	PM1_rat2sd,
	PM1_perp,
	PM1_perp_ad,
	PM1_M_pr,
	perc_bal_hicrdt_3mos,
	PM1_M_AMS3001,
	PM1_R_inq6,
	PM1_M_inq6,
	PM1_xb,
	PM1_prob_co,
	PM1_cocat,
	PM1_CreditGrade,
	AcquisitionFees_attr as [AcquisitionFees]
   FROM LDWhitneyQuotes.dbo.QuoteOffers WHERE QuoteId = @QuoteId) p
		UNPIVOT
		(Value FOR Name IN 
		(
			PM1_Income,
			PM1_R_adti,
			PM1_M_adti,
			PM1_adtisd,
			PM1_pimsd,
			PM1_tot_rev_debt,
			PM1_R_rat1,
			PM1_rat1sd,
			PM1_rat2,
			PM1_rat2sd,
			PM1_perp,
			PM1_perp_ad,
			PM1_M_pr,
			perc_bal_hicrdt_3mos,
			PM1_M_AMS3001,
			PM1_R_inq6,
			PM1_M_inq6,
			PM1_xb,
			PM1_prob_co,
			PM1_cocat,
			PM1_CreditGrade,
			AcquisitionFees
		)
)AS unpvt
		
UPDATE	LDWhitneyQuotes.dbo.Quotes
SET		LoanNumber = @LoanNumber,
		QuoteConvertedOn = GETUTCDATE()
WHERE	QuoteId = @QuoteId
		  
END

GO
