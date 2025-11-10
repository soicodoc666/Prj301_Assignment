USE [FALL25_Assignment2]
GO


-- ######################################################
-- 1. TẠO CẤU TRÚC BẢNG 
-- ######################################################

-- Bảng Division
CREATE TABLE [dbo].[Division](
	[did] [int] NOT NULL,
	[dname] [nvarchar](150) NOT NULL, -- SỬA: nvarchar
 CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED 
(
	[did] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng Employee
CREATE TABLE [dbo].[Employee](
	[eid] [int] NOT NULL,
	[ename] [nvarchar](150) NOT NULL, -- SỬA: nvarchar
	[did] [int] NOT NULL,
	[supervisorid] [int] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng Enrollment
CREATE TABLE [dbo].[Enrollment](
	[uid] [int] NOT NULL,
	[eid] [int] NOT NULL,
	[active] [bit] NOT NULL,
 CONSTRAINT [PK_Enrollment] PRIMARY KEY CLUSTERED 
(
	[uid] ASC,
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng Feature
CREATE TABLE [dbo].[Feature](
	[fid] [int] NOT NULL,
	[url] [varchar](max) NOT NULL, 
 CONSTRAINT [PK_Feature] PRIMARY KEY CLUSTERED 
(
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng RequestForLeave
CREATE TABLE [dbo].[RequestForLeave](
	[rid] [int] IDENTITY(1,1) NOT NULL,
	[created_by] [int] NOT NULL,
	[created_time] [datetime] NOT NULL,
	[from] [date] NOT NULL,
	[to] [date] NOT NULL,
	[reason] [nvarchar](max) NOT NULL, -- SỬA: nvarchar(max)
	[status] [int] NOT NULL,
	[processed_by] [int] NULL,
 CONSTRAINT [PK_RequestForLeave] PRIMARY KEY CLUSTERED 
(
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng Role
CREATE TABLE [dbo].[Role](
	[rid] [int] NOT NULL,
	[rname] [nvarchar](150) NOT NULL, -- SỬA: nvarchar
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng RoleFeature
CREATE TABLE [dbo].[RoleFeature](
	[rid] [int] NOT NULL,
	[fid] [int] NOT NULL,
 CONSTRAINT [PK_RoleFeature] PRIMARY KEY CLUSTERED 
(
	[rid] ASC,
	[fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng User
CREATE TABLE [dbo].[User](
	[uid] [int] NOT NULL,
	[username] [nvarchar](150) NOT NULL, -- SỬA: nvarchar
	[password] [nvarchar](150) NOT NULL, -- SỬA: nvarchar
	[displayname] [nvarchar](150) NOT NULL, -- SỬA: nvarchar
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng UserRole
CREATE TABLE [dbo].[UserRole](
	[uid] [int] NOT NULL,
	[rid] [int] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[uid] ASC,
	[rid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- ######################################################
-- 2. CHÈN DỮ LIỆU MẪU (14 Người dùng & Phân cấp)
-- ######################################################

-- Division
INSERT [dbo].[Division] ([did], [dname]) VALUES (1, N'Phòng Phát triển (IT)')
INSERT [dbo].[Division] ([did], [dname]) VALUES (2, N'Phòng Kiểm thử (QA)')
INSERT [dbo].[Division] ([did], [dname]) VALUES (3, N'Phòng Kinh doanh (Sale)')
GO

-- Role
INSERT [dbo].[Role] ([rid], [rname]) VALUES (1, N'Trưởng Bộ phận (IT Head)') -- Quản lý cấp cao
INSERT [dbo].[Role] ([rid], [rname]) VALUES (2, N'Quản lý Dự án/Trưởng phòng') -- Cấp quản lý trung gian
INSERT [dbo].[Role] ([rid], [rname]) VALUES (3, N'Chuyên viên/Nhân viên') -- Nhân viên
GO

-- Feature
INSERT [dbo].[Feature] ([fid], [url]) VALUES (1, N'/request/create')
INSERT [dbo].[Feature] ([fid], [url]) VALUES (2, N'/request/review')
INSERT [dbo].[Feature] ([fid], [url]) VALUES (3, N'/request/list')
INSERT [dbo].[Feature] ([fid], [url]) VALUES (4, N'/division/agenda')
GO

-- User & Employee (Mật khẩu mặc định là '123')
-- 1. IT Head
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (1, N'tqanh', N'123', N'Trần Quang Anh - Tổng Quản Lý')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (1, N'Trần Quang Anh', 1, NULL)
-- 2, 3. IT PM (Báo cáo cho 1)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (2, N'ltbinh', N'123', N'Lê Thị Bình - Trưởng Phòng A')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (2, N'Lê Thị Bình', 1, 1)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (3, N'pccuong', N'123', N'Phạm Văn Cường - Trưởng Phòng B')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (3, N'Phạm Văn Cường', 1, 1)
-- 4, 5. IT Employee (Báo cáo cho 2)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (4, N'nddung', N'123', N'Nguyễn Đình Dũng - Nhân Viên')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (4, N'Nguyễn Đình Dũng', 1, 2)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (5, N'hahai', N'123', N'Hoàng Anh Hải - Nhân Viên')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (5, N'Hoàng Anh Hải', 1, 2)
-- 6, 7. IT Employee (Báo cáo cho 3)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (6, N'dtgiang', N'123', N'Đỗ Thị Giang - Nhân Viên')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (6, N'Đỗ Thị Giang', 1, 3)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (7, N'vvkhai', N'123', N'Vũ Văn Khải - Nhân Viên')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (7, N'Vũ Văn Khải', 1, 3)
-- 8. Người Ngoại Bộ (QA) - giữ nguyên unassigned
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (8, N'ngoaibo', N'123', N'Người Ngoại Bộ - QC')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (8, N'Người Ngoại Bộ', 2, NULL)
-- 9, 10. QA PM & Employee (9 báo cáo cho 1)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (9, N'thkien', N'123', N'Trịnh Hữu Kiên - Trưởng Phòng QA')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (9, N'Trịnh Hữu Kiên', 2, 1)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (10, N'lmnguyet', N'123', N'Lâm Minh Nguyệt - Nhân Viên QA')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (10, N'Lâm Minh Nguyệt', 2, 9)
-- 11, 12. Sale PM & Employee (11 báo cáo cho 1)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (11, N'nvphat', N'123', N'Ngô Văn Phát - Trưởng Phòng Sale')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (11, N'Ngô Văn Phát', 3, 1)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (12, N'ttquynh', N'123', N'Trần Thu Quỳnh - Nhân Viên Sale')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (12, N'Trần Thu Quỳnh', 3, 11)
-- 13, 14. IT Employee bổ sung
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (13, N'dtson', N'123', N'Đinh Tiến Sơn - Nhân Viên IT')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (13, N'Đinh Tiến Sơn', 1, 2)
INSERT [dbo].[User] ([uid], [username], [password], [displayname]) VALUES (14, N'ptthuy', N'123', N'Phan Thị Thùy - Nhân Viên IT')
INSERT [dbo].[Employee] ([eid], [ename], [did], [supervisorid]) VALUES (14, N'Phan Thị Thùy', 1, 3)
GO

-- Enrollment
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (1, 1, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (2, 2, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (3, 3, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (4, 4, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (5, 5, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (6, 6, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (7, 7, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (8, 8, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (9, 9, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (10, 10, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (11, 11, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (12, 12, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (13, 13, 1)
INSERT [dbo].[Enrollment] ([uid], [eid], [active]) VALUES (14, 14, 1)
GO

-- UserRole
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (1, 1) -- IT Head
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (2, 2) -- IT PM
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (3, 2) -- IT PM
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (4, 3) -- IT Employee
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (5, 3) -- IT Employee
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (6, 3) -- IT Employee
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (7, 3) -- IT Employee
-- uid 8 (Ngoại Bộ) không có Role
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (9, 2) -- QA PM
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (10, 3) -- QA Employee
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (11, 2) -- Sale PM
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (12, 3) -- Sale Employee
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (13, 3) -- IT Employee
INSERT [dbo].[UserRole] ([uid], [rid]) VALUES (14, 3) -- IT Employee
GO

-- RoleFeature
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 1) -- Head có tất cả quyền
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 2)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 3)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (1, 4)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 1) -- PM có quyền tạo, duyệt, xem danh sách
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 2)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (2, 3)
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 1) -- Employee có quyền tạo, xem danh sách
INSERT [dbo].[RoleFeature] ([rid], [fid]) VALUES (3, 3)
GO

-- RequestForLeave (Đã sửa lý do để có dấu)
SET IDENTITY_INSERT [dbo].[RequestForLeave] ON 
INSERT [dbo].[RequestForLeave] ([rid], [created_by], [created_time], [from], [to], [reason], [status], [processed_by]) VALUES (1, 1, CAST(N'2025-10-21T00:00:00.000' AS DateTime), CAST(N'2025-10-22' AS Date), CAST(N'2025-10-24' AS Date), N'Nghỉ phép để kết hôn', 0, NULL)
INSERT [dbo].[RequestForLeave] ([rid], [created_by], [created_time], [from], [to], [reason], [status], [processed_by]) VALUES (2, 2, CAST(N'2025-10-21T00:00:00.000' AS DateTime), CAST(N'2025-10-22' AS Date), CAST(N'2025-10-24' AS Date), N'Việc gia đình khẩn cấp', 0, NULL)
INSERT [dbo].[RequestForLeave] ([rid], [created_by], [created_time], [from], [to], [reason], [status], [processed_by]) VALUES (11, 5, CAST(N'2025-10-21T00:00:00.000' AS DateTime), CAST(N'2025-10-22' AS Date), CAST(N'2025-10-24' AS Date), N'Nghỉ phép đã được Duyệt', 1, 1)
INSERT [dbo].[RequestForLeave] ([rid], [created_by], [created_time], [from], [to], [reason], [status], [processed_by]) VALUES (12, 5, CAST(N'2025-10-21T00:00:00.000' AS DateTime), CAST(N'2025-10-22' AS Date), CAST(N'2025-10-24' AS Date), N'Nghỉ phép đã bị Từ chối', 2, 1)
SET IDENTITY_INSERT [dbo].[RequestForLeave] OFF
GO

-- ######################################################
-- 3. TẠO CÁC KHÓA NGOẠI (FOREIGN KEYS)
-- ######################################################

ALTER TABLE [dbo].[Employee] WITH CHECK ADD CONSTRAINT [FK_Employee_Division] FOREIGN KEY([did])
REFERENCES [dbo].[Division] ([did])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Division]
GO

ALTER TABLE [dbo].[Employee] WITH CHECK ADD CONSTRAINT [FK_Employee_Employee] FOREIGN KEY([supervisorid])
REFERENCES [dbo].[Employee] ([eid])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Employee]
GO

ALTER TABLE [dbo].[Enrollment] WITH CHECK ADD CONSTRAINT [FK_Enrollment_Employee] FOREIGN KEY([eid])
REFERENCES [dbo].[Employee] ([eid])
GO
ALTER TABLE [dbo].[Enrollment] CHECK CONSTRAINT [FK_Enrollment_Employee]
GO

ALTER TABLE [dbo].[Enrollment] WITH CHECK ADD CONSTRAINT [FK_Enrollment_User] FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[Enrollment] CHECK CONSTRAINT [FK_Enrollment_User]
GO

ALTER TABLE [dbo].[RequestForLeave] WITH CHECK ADD CONSTRAINT [FK_RequestForLeave_Employee] FOREIGN KEY([created_by])
REFERENCES [dbo].[Employee] ([eid])
GO
ALTER TABLE [dbo].[RequestForLeave] CHECK CONSTRAINT [FK_RequestForLeave_Employee]
GO

ALTER TABLE [dbo].[RoleFeature] WITH CHECK ADD CONSTRAINT [FK_RoleFeature_Feature] FOREIGN KEY([fid])
REFERENCES [dbo].[Feature] ([fid])
GO
ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_RoleFeature_Feature]
GO

ALTER TABLE [dbo].[RoleFeature] WITH CHECK ADD CONSTRAINT [FK_RoleFeature_Role] FOREIGN KEY([rid])
REFERENCES [dbo].[Role] ([rid])
GO
ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_RoleFeature_Role]
GO

ALTER TABLE [dbo].[UserRole] WITH CHECK ADD CONSTRAINT [FK_UserRole_Role] FOREIGN KEY([rid])
REFERENCES [dbo].[Role] ([rid])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_Role]
GO

ALTER TABLE [dbo].[UserRole] WITH CHECK ADD CONSTRAINT [FK_UserRole_User] FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([uid])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_User]
GO
ALTER TABLE RequestForLeave ADD title NVARCHAR(255);

