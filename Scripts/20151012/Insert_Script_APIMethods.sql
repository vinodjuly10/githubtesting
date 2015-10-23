USE [LDWhitney]
GO
SET IDENTITY_INSERT [dbo].[APIMethods] ON
 
INSERT INTO [dbo].[APIMethods]
           ([APIMethodId],[APIMethodName],[APIMethodDescription],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy],[Status])     
		   VALUES (6,'GetPricingQuote','Get Pricing Quote',GetDate(),1 ,GetDate(),1,1)
GO
INSERT INTO [dbo].[APIMethods]
           ([APIMethodId],[APIMethodName],[APIMethodDescription],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy],[Status])     
		   VALUES (7,'ConvertQuotetoApplication','Convert Quoteto Application',GetDate(),1 ,GetDate(),1,1)
GO
INSERT INTO [dbo].[APIMethods]
           ([APIMethodId],[APIMethodName],[APIMethodDescription],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy],[Status])     
		   VALUES (8,'GetCallBackURL','Get Call Back URL By Loan Number',GetDate(),1 ,GetDate(),1,1)
GO
SET IDENTITY_INSERT [dbo].[APIMethods] OFF

