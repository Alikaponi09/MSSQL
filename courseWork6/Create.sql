-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-06-08 17:37:18.488
go
create database avto
go
use avto
-- tables
-- Table: Applications
CREATE TABLE Applications (
    ApplicationsID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(40)  NOT NULL,
    MiddleName nvarchar(40)  NOT NULL,
    LastName nvarchar(40)  NULL,
    PhoneNumber bigint  NOT NULL,
    Birthday date  NOT NULL,
    CONSTRAINT Applications_pk PRIMARY KEY  (ApplicationsID)
);

-- Table: Briefing
CREATE TABLE Briefing (
    BriefingID int  NOT NULL IDENTITY(1, 1),
    dateStart datetime  NOT NULL,
    dateFinish datetime  NOT NULL,
    MasterGroupsID int  NOT NULL,
    CONSTRAINT Briefing_pk PRIMARY KEY  (BriefingID)
);

-- Table: Categories
CREATE TABLE Categories (
    CategoriesID int  NOT NULL IDENTITY(1, 1),
    CategoriesName nvarchar(10)  NOT NULL,
    ExamsFile varbinary(max)  NOT NULL,
    MaxExamsScore int  NOT NULL,
    CONSTRAINT check_MaxExamsScore CHECK (MaxExamsScore > 0),
    CONSTRAINT Categories_pk PRIMARY KEY  (CategoriesID)
);

-- Table: ExamResults
CREATE TABLE ExamResults (
    ExamResultsID int  NOT NULL IDENTITY(1, 1),
    Score int  NOT NULL,
    PupilsGroupsID int  NOT NULL,
    CONSTRAINT check_Score CHECK (Score >= 0),
    CONSTRAINT ExamResults_pk PRIMARY KEY  (ExamResultsID)
);

-- Table: Groups
CREATE TABLE Groups (
    GroupsID int  NOT NULL IDENTITY(1, 1),
    CategoriesID int  NOT NULL,
    CONSTRAINT Groups_pk PRIMARY KEY  (GroupsID)
);

-- Table: Master
CREATE TABLE Master (
    MasterID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(40)  NOT NULL,
    MiddleName nvarchar(40)  NOT NULL,
    LastName nvarchar(40)  NULL,
    PhoneNumber bigint  NOT NULL,
    CONSTRAINT Master_pk PRIMARY KEY  (MasterID)
);

-- Table: MasterGroups
CREATE TABLE MasterGroups (
    MasterGroupsID int  NOT NULL IDENTITY(1, 1),
    MasterID int  NOT NULL,
    GroupsID int  NOT NULL,
    CONSTRAINT MasterGroups_pk PRIMARY KEY  (MasterGroupsID)
);

-- Table: Pupils
CREATE TABLE Pupils (
    PupilsID int  NOT NULL IDENTITY(1, 1),
    DateAdoption date  NOT NULL,
    ApplicationsID int  NOT NULL,
    Paid bit  NOT NULL,
    CONSTRAINT Pupils_pk PRIMARY KEY  (PupilsID)
);

-- Table: PupilsGroups
CREATE TABLE PupilsGroups (
    PupilsGroupsID int  NOT NULL IDENTITY(1, 1),
    DateStart date  NOT NULL,
    DateFinish date  NOT NULL,
    GroupsID int  NOT NULL,
    PupilsID int  NOT NULL,
    CONSTRAINT PupilsGroups_pk PRIMARY KEY  (PupilsGroupsID)
);

-- Table: Teacher
CREATE TABLE Teacher (
    TeacherID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(40)  NOT NULL,
    MiddleName nvarchar(40)  NOT NULL,
    LastName nvarchar(40)  NULL,
    PhoneNumber bigint  NOT NULL,
    CONSTRAINT Teacher_pk PRIMARY KEY  (TeacherID)
);

-- Table: TeacherGroups
CREATE TABLE TeacherGroups (
    TeacherGroupsID int  NOT NULL IDENTITY(1, 1),
    TeacherID int  NOT NULL,
    GroupsID int  NOT NULL,
    CONSTRAINT TeacherGroups_pk PRIMARY KEY  (TeacherGroupsID)
);

-- foreign keys
-- Reference: Briefing_MasterGroups (table: Briefing)
ALTER TABLE Briefing ADD CONSTRAINT Briefing_MasterGroups
    FOREIGN KEY (MasterGroupsID)
    REFERENCES MasterGroups (MasterGroupsID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: ExamResults_PupilsGroups (table: ExamResults)
ALTER TABLE ExamResults ADD CONSTRAINT ExamResults_PupilsGroups
    FOREIGN KEY (PupilsGroupsID)
    REFERENCES PupilsGroups (PupilsGroupsID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: Groups_Categories (table: Groups)
ALTER TABLE Groups ADD CONSTRAINT Groups_Categories
    FOREIGN KEY (CategoriesID)
    REFERENCES Categories (CategoriesID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: MasterGroups_Groups (table: MasterGroups)
ALTER TABLE MasterGroups ADD CONSTRAINT MasterGroups_Groups
    FOREIGN KEY (GroupsID)
    REFERENCES Groups (GroupsID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: MasterGroups_Master (table: MasterGroups)
ALTER TABLE MasterGroups ADD CONSTRAINT MasterGroups_Master
    FOREIGN KEY (MasterID)
    REFERENCES Master (MasterID);

-- Reference: PupilsGroups_Groups (table: PupilsGroups)
ALTER TABLE PupilsGroups ADD CONSTRAINT PupilsGroups_Groups
    FOREIGN KEY (GroupsID)
    REFERENCES Groups (GroupsID);

-- Reference: PupilsGroups_Pupils (table: PupilsGroups)
ALTER TABLE PupilsGroups ADD CONSTRAINT PupilsGroups_Pupils
    FOREIGN KEY (PupilsID)
    REFERENCES Pupils (PupilsID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: Pupils_Applications (table: Pupils)
ALTER TABLE Pupils ADD CONSTRAINT Pupils_Applications
    FOREIGN KEY (ApplicationsID)
    REFERENCES Applications (ApplicationsID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: TeacherGroups_Groups (table: TeacherGroups)
ALTER TABLE TeacherGroups ADD CONSTRAINT TeacherGroups_Groups
    FOREIGN KEY (GroupsID)
    REFERENCES Groups (GroupsID);

-- Reference: TeacherGroups_Teacher (table: TeacherGroups)
ALTER TABLE TeacherGroups ADD CONSTRAINT TeacherGroups_Teacher
    FOREIGN KEY (TeacherID)
    REFERENCES Teacher (TeacherID);

-- End of file.
go
Create PROCEDURE ApplicationsAction (
@Action tinyint,
@ApplicationsID  INT ,
@FirstName nvarchar(40),
@MiddleName nvarchar(40),
@LastName nvarchar(40),
@PhoneNumber bigint,
@Birthday date
	)
As
Begin
if(@Action = 1)
	delete Applications where ApplicationsID = @ApplicationsID
else
	if(@Action = 2)
		insert Applications (FirstName,MiddleName,LastName,PhoneNumber,Birthday)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber,@Birthday)
	else
		if(@Action = 3)
			UPDATE [dbo].[Applications]
		    SET FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			,Birthday = @Birthday
			where ApplicationsID = @ApplicationsID
end
go
Create PROCEDURE BriefingAction (
@Action tinyint,
@BriefingID  INT,
@dateStart datetime,
@dateFinish datetime,
@MasterGroupsID int
)
As
Begin
if(@Action = 1)
	delete Briefing where BriefingID = @BriefingID
else
	if(@Action = 2)
		insert Briefing (dateStart,dateFinish,MasterGroupsID)
		values (@dateStart,@dateFinish,@MasterGroupsID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Briefing]
		    SET dateStart = @dateStart
			,dateFinish = @dateFinish
			,MasterGroupsID = @MasterGroupsID
			where BriefingID = @BriefingID
end
go
Create PROCEDURE CategoriesAction (
@Action tinyint,
@CategoriesID INT,
@CategoriesName nvarchar(10),
@ExamsFile varbinary(max),
@MaxExamsScore int
)
As
Begin
if(@Action = 1)
	delete Categories where CategoriesID = @CategoriesID
else
	if(@Action = 2)
		insert Categories (CategoriesName,ExamsFile,MaxExamsScore)
		values (@CategoriesName,@ExamsFile,@MaxExamsScore)
	else
		if(@Action = 3)
			UPDATE [dbo].[Categories]
		    SET dateStart = @dateStart
			,dateFinish = @dateFinish
			,MasterGroupsID = @MasterGroupsID
			where CategoriesID = @CategoriesID
end
go
Create PROCEDURE ExamResultsAction (
@Action tinyint,
@ExamResultsID INT,
@Score int,
@PupilsGroupsID int
)
As
Begin
if(@Action = 1)
	delete ExamResults where ExamResultsID = @ExamResultsID
else
	if(@Action = 2)
		insert ExamResults (Score,PupilsGroupsID)
		values (@Score,@PupilsGroupsID)
	else
		if(@Action = 3)
			UPDATE [dbo].[ExamResults]
		    SET Score = @Score
			,PupilsGroupsID = @PupilsGroupsID
			where ExamResultsID = @ExamResultsID
end
go
Create PROCEDURE GroupsAction (
@Action tinyint,
@GroupsID INT,
@CategoriesID int
)
As
Begin
if(@Action = 1)
	delete Groups where GroupsID = @GroupsID
else
	if(@Action = 2)
		insert Groups (CategoriesID)
		values (@CategoriesID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Groups]
		    SET CategoriesID = @CategoriesID
			where GroupsID = @GroupsID
end
go
Create PROCEDURE MasterAction (
@Action tinyint,
@MasterID INT,
@FirstName nvarchar(40),
@MiddleName nvarchar(40),
@LastName nvarchar(40),
@PhoneNumber bigint
)
As
Begin
if(@Action = 1)
	delete Master where MasterID = @MasterID
else
	if(@Action = 2)
		insert Master (FirstName,MiddleName,LastName,PhoneNumber)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber)
	else
		if(@Action = 3)
			UPDATE [dbo].[Master]
		    SET FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			where MasterID = @MasterID
end
go
Create PROCEDURE MasterGroupsAction (
@Action tinyint,
@MasterGroupsID INT,
@MasterID int,
@GroupsID int 
)
As
Begin
if(@Action = 1)
	delete MasterGroups where MasterGroupsID = @MasterGroupsID
else
	if(@Action = 2)
		insert MasterGroups (MasterID,GroupsID )
		values (@MasterID,@GroupsID )
	else
		if(@Action = 3)
			UPDATE [dbo].[MasterGroups]
		    SET MasterID = @MasterID
			,GroupsID = @GroupsID
			where MasterGroupsID = @MasterGroupsID
end
go
Create PROCEDURE PupilsAction (
@Action tinyint,
@PupilsID INT,
@DateAdoption date,
@ApplicationsID int,
@Paid bit
)
As
Begin
if(@Action = 1)
	delete Pupils where PupilsID = @PupilsID
else
	if(@Action = 2)
		insert Pupils (DateAdoption,ApplicationsID,Paid)
		values (@DateAdoption,@ApplicationsID,@Paid)
	else
		if(@Action = 3)
			UPDATE [dbo].[Pupils]
		    SET DateAdoption = @DateAdoption
			,ApplicationsID = @ApplicationsID
			,Paid = @Paid
			where PupilsID = @PupilsID
end
go
Create PROCEDURE PupilsGroupsAction (
@Action tinyint,
@PupilsGroupsID INT,
@DateStart date,
@DateFinish date,
@GroupsID int,
@PupilsID int 
)
As
Begin
if(@Action = 1)
	delete PupilsGroups where PupilsGroupsID = @PupilsGroupsID
else
	if(@Action = 2)
		insert PupilsGroups (DateStart,DateFinish,GroupsID,PupilsID)
		values (@DateStart,@DateFinish,@GroupsID,@PupilsID)
	else
		if(@Action = 3)
			UPDATE [dbo].[PupilsGroups]
		    SET DateStart = @DateStart
			,DateFinish = @DateFinish
			,GroupsID = @GroupsID
			,PupilsID = @PupilsID
			where PupilsGroupsID = @PupilsGroupsID
end

go
Create PROCEDURE TeacherAction (
@Action tinyint,
@TeacherID INT,
@FirstName nvarchar(40),
@MiddleName nvarchar(40),
@LastName nvarchar(40),
@PhoneNumber bigint 
)
As
Begin
if(@Action = 1)
	delete Teacher where TeacherID = @TeacherID
else
	if(@Action = 2)
		insert Teacher (FirstName,MiddleName,LastName,PhoneNumber)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber)
	else
		if(@Action = 3)
			UPDATE [dbo].[Teacher]
		    SET FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			where TeacherID = @TeacherID
end
go
Create PROCEDURE TeacherGroupsAction (
@Action tinyint,
@TeacherGroupsID INT,
@TeacherID int,
@GroupsID int 
)
As
Begin
if(@Action = 1)
	delete TeacherGroups where TeacherGroupsID = @TeacherGroupsID
else
	if(@Action = 2)
		insert TeacherGroups (TeacherID,GroupsID)
		values (@TeacherID,@GroupsID)
	else
		if(@Action = 3)
			UPDATE [dbo].[TeacherGroups]
		    SET TeacherID = @TeacherID
			,GroupsID = @GroupsID
			where TeacherGroupsID = @TeacherGroupsID
end
go
create trigger checkInsertPupilsGroups on PupilsGroups
for insert, update
as
declare @DateStartContract date, @DateFinishContract date
Select 
	@DateStartContract=DateStart, 
	@DateFinishContract=DateFinish
from inserted
if (@DateFinishContract >= @DateStartContract)
Begin
	print 'Необходимо правильно указать дату!'
	ROLLBACK TRANSACTION
End
go
create trigger checkInsertBriefing on Briefing
for insert, update
as
declare @DateStartContract date, @DateFinishContract date
Select 
	@DateStartContract=dateStart, 
	@DateFinishContract=dateFinish
from inserted
if (@DateFinishContract >= @DateStartContract)
Begin
	print 'Необходимо правильно указать дату!'
	ROLLBACK TRANSACTION
End
go
alter table
Applications ADD CONSTRAINT Applications_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
alter table
Master ADD CONSTRAINT Master_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
alter table
Teacher ADD CONSTRAINT Master_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
go
Create PROCEDURE PupilsPaid
As
Begin
select * from Pupils
where Paid = 1
end
go
Create PROCEDURE PupilsInfo
As
Begin
select p.*, g.* from Pupils p
inner join PupilsGroups pg on pg.PupilsID = p.PupilsID
inner join Groups g on g.GroupsID = pg.GroupsID
end