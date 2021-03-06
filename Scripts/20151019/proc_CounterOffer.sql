
/****** Object:  StoredProcedure [dbo].[proc_CounterOffer]    Script Date: 10/19/2015 17:05:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author		: Naresh Kriplani
-- Created date	: 7-June-2015
-- Updated date	: 24-June-2015
-- Description	: Counter Offer 
-- Version		: 1.0
-- updated date	: 8-June-2015
-- updated date	: 19-Oct-2015
-- updated by	: Bharat Prajapati
-- =============================================
ALTER PROCEDURE [dbo].[proc_CounterOffer] @LoanApplicationId BIGINT
	,@Notes NVARCHAR(max)
	,@DocumentTypeList NVARCHAR(300)
	,@SelectedOfferId BIGINT
	,@CreatedBy BIGINT
	,@LoanAmount DECIMAL(18, 4)
	,@AnnualPercentageRate DECIMAL(18, 4)
	,@InterestRate DECIMAL(18, 4)
	,@LoanTerm DECIMAL(18, 4)
	,@OriginationFees DECIMAL(18, 4)
	,@Acquisitionfee DECIMAL(18, 4)
	,@TakeHomeAmount DECIMAL(18, 4)
	,@MonthlyPayment DECIMAL(18, 4)
	,@IsEditCounterOffer BIT
	,@DTIValue DECIMAL(18, 4)
	,@RS03InterestRate DECIMAL(18, 4)
	,@OfferType DECIMAL(18, 4)
	,@returnValue INT OUTPUT
AS
BEGIN
	--SET XACT_ABORT ON;
	SET NOCOUNT ON;

	--Declare new Variable ReasonId and NewVersion number
	DECLARE @VersionReasonId BIGINT
	DECLARE @NewVersionNumber NVARCHAR(50)

	-- Set Counter Offer ReasonId
	SET @VersionReasonId = 90

	--Declare @returnValue int
	BEGIN TRY
		BEGIN TRANSACTION

		IF @IsEditCounterOffer = 0
			BEGIN
		-- Call Procedure to set the New Version
		EXEC @returnValue = CreateLoanApplicationNewVersion @LoanApplicationId
			,@VersionReasonId
			,@CreatedBy
			END
		ELSE
			BEGIN
				SET @returnValue = 1
			END

		IF (@returnValue = 1)
		BEGIN
			-- Get New Versionnumber from LoanApplication Table
			SELECT @NewVersionNumber = CurrentVersionNumber
			FROM LoanApplication with (nolock)
			WHERE LoanApplicationId = @LoanApplicationId

			IF @Notes ! = ''
			BEGIN
				-- Create new Call and Add the Call notes for Counter offer
				DECLARE @CallId BIGINT

				INSERT INTO [dbo].[Call] (
					[LoanApplicationId]
					,[CallDuration]
					,[CallType]
					,[AttendedBy]
					,[AttendedOn]
					)
				VALUES (
					@LoanApplicationId
					,0
					,1
					,@CreatedBy
					,GETUTCDATE()
					)

				SELECT @CallId = SCOPE_IDENTITY()

				-- TBD : Add New Notes type
				INSERT INTO [dbo].[CallNotes] (
					[CallId]
					,[LoanApplicationId]
					,[Notes]
					,[NoteType]
					,[CreatedOn]
					,[CreatedBy]
					)
				VALUES (
					@CallId
					,@LoanApplicationId
					,@Notes
					,1
					,GETUTCDATE()
					,@CreatedBy
					)
			END

			UPDATE LeadOffers
					SET IsSelected = 0
						,IsEditedOffer = 0
					WHERE LoanApplicationId = @LoanApplicationId

			IF @IsEditCounterOffer = 0
			BEGIN
				-- Delete old Leadoffers for current LoanApplication
				DELETE
				FROM LeadOffers
				WHERE LoanApplicationId = @LoanApplicationId

				-- Insert Hardpull offers in Softpull Offers
				INSERT INTO [dbo].[LeadOffers] (
					[LoanApplicationId]
					,[LoanAmount]
					,[TakeHomeAmount]
					,[AnnualPercentageRate]
					,[InterestRate]
					,[MonthlyPayment]
					,[LoanTerm]
					,[OriginationFees]
					,[CreatedOn]
					,[IsSelected]
					,[Acquisitionfee]
					,[VersionNumber]
					,[DTIValue]
					,[OfferType]
					,[RS03InterestRate]
					)
				SELECT [LoanApplicationId]
					,[LoanAmount]
					,[TakeHomeAmount]
					,[AnnualPercentageRate]
					,[InterestRate]
					,[MonthlyPayment]
					,[LoanTerm]
					,[OriginationFees]				
					,GETUTCDATE()
					,CASE 
						WHEN LeadOfferHardPullId = @SelectedOfferId
							THEN 1
						ELSE 0
						END
					,[Acquisitionfee]
					,@NewVersionNumber
					,[DTIValue]
					,[OfferType]
					,[RS03InterestRate]
				FROM [LeadOffersHardPull] with (nolock)
				WHERE LoanApplicationId = @LoanApplicationId
			END
			ELSE
			BEGIN
				IF @SelectedOfferId > 0
				BEGIN				

					UPDATE LeadOffers
					SET IsSelected = 1
						,IsEditedOffer = 1
					WHERE LeadOfferId = @SelectedOfferId
				END
			END

			-- Insert edited loan amount to soft pull
			IF @SelectedOfferId = 0
			BEGIN
				INSERT INTO [dbo].[LeadOffers] (
					[LoanApplicationId]
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
					,[VersionNumber]
					,[DTIValue]
					,[OfferType]
					,[RS03InterestRate]
					)
				SELECT @LoanApplicationId
					,@LoanAmount
					,@TakeHomeAmount
					,@AnnualPercentageRate
					,@InterestRate
					,@MonthlyPayment
					,@LoanTerm
					,@OriginationFees
					,GETUTCDATE()
					,1
					,1
					,@Acquisitionfee
					,@NewVersionNumber
					,@DTIValue
					,@OfferType
					,@RS03InterestRate
					
			END

			-- Set Last Application Stage as Loan Document Preseneted
			UPDATE LoanApplicationLastStage
			SET ApplicationStageId = 600
				,UpdatedOn = GETUTCDATE()
			WHERE LoanApplicationId = @LoanApplicationId

			DECLARE @LoanAccountId BIGINT

			SELECT @LoanAccountId = LoanAccountId
			FROM LoanAccounts
			WHERE LoanApplicationId = @LoanApplicationId

			DECLARE @pos INT
			DECLARE @len INT
			DECLARE @value VARCHAR(50)

			SET @pos = 0
			SET @len = 0

			WHILE CHARINDEX(',', @DocumentTypeList, @pos + 1) > 0
			BEGIN
				SET @len = CHARINDEX(',', @DocumentTypeList, @pos + 1) - @pos
				SET @value = SUBSTRING(@DocumentTypeList, @pos, @len)

				--SELECT @pos, @len, @value /*this is here for debugging*/
				PRINT @value

				INSERT INTO [dbo].[LoanApplicationDocType] (
					[LoanAccountId]
					,[DocumentTypeId]
					,[IsVerified]
					,[CreatedOn]
					,[CreatedBy]
					,VerificationNoteId
					,UnderWriterNoteId
					,VerificationDispostion
					,IsUnderWritten
					,UnderWrittenBy
					,UnderWrittenDispostion
					,UnderWrittenStatus
					,NoOfDocumentsReceived
					,VerificationStatus
					,IsUploaded
					,[VersionNumber]
					)
				VALUES (
					@LoanAccountId
					,Cast(@value AS INT)
					,0
					,GETUTCDATE()
					,@CreatedBy
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
					,@NewVersionNumber
					)

				SET @pos = CHARINDEX(',', @DocumentTypeList, @pos + @len) + 1
			END

			IF (len(@DocumentTypeList) > 0)
			BEGIN
				UPDATE LoanApplicationStage
				SET ApplicationStageStatus = 0
				WHERE LoanApplicationId = @LoanApplicationId
					AND ApplicationStageId IN (
						40100
						,41100
						,60100
						)
			END

			--Loan Doc Sign Stage
			UPDATE LoanApplicationStage
			SET ApplicationStageStatus = 0
			WHERE LoanApplicationId = @LoanApplicationId
				AND ApplicationStageId = 700

			UPDATE LoanApplication
			SET AssignedTo = NULL
				,AssignedBy = NULL
				,AssignedOn = NULL
			WHERE LoanApplicationId = @LoanApplicationId

			SET @returnValue = 1
		END
		ELSE
		BEGIN
			--SELECT @returnValue AS Result
			IF (@returnValue = - 1)
			BEGIN
				SET @returnValue = - 1
			END
			ELSE IF (@returnValue = 0)
			BEGIN
				SET @returnValue = 0
			END
		END

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION

		SET @returnValue = 0 -- Error Occured 
	END CATCH
END
