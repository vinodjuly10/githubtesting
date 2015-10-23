-- =============================================
-- Author:		 Rita Patel
-- Updated date: 09-Oct-2015
-- Description:	 SP for Production Support to enable and re-enable link
-- =============================================

USE [LDWhitney]
IF EXISTS (
        SELECT type_desc, type FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'EnableBankLink' AND type = 'P'
      )
     DROP PROCEDURE [dbo].[EnableBankLink]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE EnableBankLink
@LoanNumber BIGINT,
@ReturnValue INT = 0 OUTPUT
AS
BEGIN
DECLARE @loanApplicationId BIGINT = (SELECT LoanApplicationId FROM LoanApplication WITH (NOLOCK) WHERE LoanNumber = @LoanNumber)
IF (@loanApplicationId > 0)
  BEGIN
      DELETE FROM CDVerificationAttempt WHERE LoanNumber = @LoanNumber   
	  UPDATE ExtendedLoanApplication SET CDStatus=NULL WHERE LoanApplicationId = @loanApplicationId
	  UPDATE LoanApplicationStage SET ApplicationStageStatus = NULL WHERE ApplicationStageId in(41600,41700,41200) 
	  AND LoanApplicationId = @loanApplicationId
	  SET @ReturnValue = 1
  END
ELSE
  BEGIN
    SET @ReturnValue = 0
  END
END
GO
IF EXISTS (
        SELECT type_desc, type FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'ReEnableInstantBankLink' AND type = 'P'
      )
     DROP PROCEDURE [dbo].ReEnableInstantBankLink
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ReEnableInstantBankLink
@LoanNumber BIGINT,
@ReturnValue INT = 0 OUTPUT
AS
BEGIN
DECLARE @loanApplicationId BIGINT = (SELECT LoanApplicationId FROM LoanApplication WITH (NOLOCK) WHERE LoanNumber = @LoanNumber)
IF (@loanApplicationId > 0)
  BEGIN     
	  UPDATE LoanApplicationStage SET ApplicationStageStatus = NULL WHERE LoanApplicationId = @loanApplicationId and ApplicationStageId=62600
	  SET @ReturnValue = 1
  END
ELSE
  BEGIN
    SET @ReturnValue = 0
  END
END
GO