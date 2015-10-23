
USE [LDWhitney]
GO
SET IDENTITY_INSERT [dbo].[APIGroupMethodMapping] ON
INSERT INTO [dbo].[APIGroupMethodMapping]([APIGroupMethodMappingId],[APIGroupId],[APIMethodId],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy],[Status])
     VALUES (6,2,6,GetDate(),1,GetDate(),1,1)
GO
INSERT INTO [dbo].[APIGroupMethodMapping]([APIGroupMethodMappingId],[APIGroupId],[APIMethodId],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy],[Status])
     VALUES (7,2,7,GetDate(),1,GetDate(),1,1)
GO
INSERT INTO [dbo].[APIGroupMethodMapping]([APIGroupMethodMappingId],[APIGroupId],[APIMethodId],[CreatedOn],[CreatedBy],[UpdatedOn],[UpdatedBy],[Status])
     VALUES (8,2,8,GetDate(),1,GetDate(),1,1)
GO
SET IDENTITY_INSERT [dbo].[APIGroupMethodMapping] OFF