-- =============================================
-- Author:		 Rita Patel
-- Updated date: 08-Oct-2015
-- Description:	 Insert script for ProductionSupport Role
-- =============================================



USE [LDWhitney]
GO

SET IDENTITY_INSERT [dbo].[Role] ON
INSERT INTO [dbo].[Role](RoleId, RoleName, CreatedOn) VALUES(27, 'ProductionSupport', GETDATE())
SET IDENTITY_INSERT [dbo].[Role] OFF
GO

SET IDENTITY_INSERT [dbo].[Department] ON
INSERT INTO [dbo].[Department](DepartmentId, DepartmentName, IsActive, CreatedOn) VALUES(7, 'ProductionSupport', 1, GETDATE())
SET IDENTITY_INSERT [dbo].[Department] OFF
GO

SET IDENTITY_INSERT [dbo].[DepartmentRole] ON
INSERT INTO [dbo].[DepartmentRole](DepartmentRoleId, DepartmentId, RoleId, IsActive, CreatedOn) VALUES(23, 7, 27, 1, GETDATE())
SET IDENTITY_INSERT [dbo].[DepartmentRole] OFF
GO