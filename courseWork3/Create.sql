create database Je
go
use Je
CREATE TABLE AuthorPublication(
    AuthorPublicationId INT identity(1,1) NOT NULL,
    AuthorId INT NOT NULL,
    PublicationId INT NOT NULL,
    СoАuthor BIT NOT NULL
);
ALTER TABLE
    AuthorPublication ADD CONSTRAINT authorpublication_authorpublicationid_primary PRIMARY KEY(AuthorPublicationId);
CREATE TABLE ОrganizationRepresentative(
    ОrganizationRepresentativeId INT identity(1,1) NOT NULL,
    ОrganizationId INT NOT NULL,
    RepresentativeId INT NOT NULL
);
ALTER TABLE
    ОrganizationRepresentative ADD CONSTRAINT Оrganizationrepresentative_Оrganizationrepresentativeid_primary PRIMARY KEY(ОrganizationRepresentativeId);
CREATE TABLE AuthorRepresentative(
    AuthorRepresentativeId INT identity(1,1) NOT NULL,
    AuthorId INT NOT NULL,
    RepresentativeId INT NOT NULL
);
ALTER TABLE
    AuthorRepresentative ADD CONSTRAINT authorrepresentative_authorrepresentativeid_primary PRIMARY KEY(AuthorRepresentativeId);
CREATE TABLE City(
    CityId INT identity(1,1) NOT NULL,
    Name NVARCHAR(30) NOT NULL
);
ALTER TABLE
    City ADD CONSTRAINT city_cityid_primary PRIMARY KEY(CityId);
CREATE TABLE StatusOrders(
    StatusOrderssId INT identity(1,1) NOT NULL,
    Name NVARCHAR(30) NOT NULL
);
ALTER TABLE
    StatusOrders ADD CONSTRAINT statusOrders_statusOrderssid_primary PRIMARY KEY(StatusOrderssId);
CREATE TABLE OrdersLines(
    OrdersLinesId INT identity(1,1) NOT NULL,
    OrdersId INT NOT NULL,
    PublicationId INT NOT NULL,
    PrintingHouseId INT NOT NULL,
    Quantity INT NOT NULL,
    Price FLOAT NOT NULL
);
ALTER TABLE
    OrdersLines ADD CONSTRAINT Orderslines_Orderslinesid_primary PRIMARY KEY(OrdersLinesId);
CREATE TABLE Orders(
    OrdersId INT identity(1,1) NOT NULL,
    DateAdmission DATE NOT NULL,
    RepresentativeId INT NOT NULL,
    DateCompiction DATE NOT NULL,
    StatusOrderssId INT NOT NULL,
    StatusDate DATE NOT NULL
);
ALTER TABLE
    Orders ADD CONSTRAINT Orders_Ordersid_primary PRIMARY KEY(OrdersId);
CREATE TABLE PrintingHouse(
    PrintingHouseId INT identity(1,1) NOT NULL,
    Name NVARCHAR(30) NOT NULL,
    CityId int NOT NULL,
    Street NVARCHAR(30) NOT NULL,
    NumberHouse NVARCHAR(30) NOT NULL
);
ALTER TABLE
    PrintingHouse ADD CONSTRAINT printinghouse_printinghouseid_primary PRIMARY KEY(PrintingHouseId);
CREATE TABLE Representative(
    RepresentativeId INT identity(1,1) NOT NULL,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NULL,
    PhoneNumber BIGINT NOT NULL,
    fax BIGINT NOT NULL,
    IsОrganization BIT NOT NULL
);
ALTER TABLE
    Representative ADD CONSTRAINT representative_representativeid_primary PRIMARY KEY(RepresentativeId);
CREATE TABLE Оrganization(
    ОrganizationId INT identity(1,1) NOT NULL,
    Name NVARCHAR(30) NOT NULL,
    CityId int NOT NULL,
    Street NVARCHAR(30) NOT NULL,
    NumberHouse NVARCHAR(30) NOT NULL
);
ALTER TABLE
    Оrganization ADD CONSTRAINT Оrganization_Оrganizationid_primary PRIMARY KEY(ОrganizationId);
CREATE TABLE Author(
    AuthorId INT identity(1,1) NOT NULL,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NULL,
    PhoneNumber BIGINT NOT NULL,
    CityId INT NOT NULL,
    Street NVARCHAR(30) NOT NULL,
    NumberHouse NVARCHAR(30) NOT NULL
);
ALTER TABLE
    Author ADD CONSTRAINT author_authorid_primary PRIMARY KEY(AuthorId);
CREATE TABLE ProductType(
    ProductTypeId INT identity(1,1) NOT NULL,
    Name NVARCHAR(30) NOT NULL
);
ALTER TABLE
    ProductType ADD CONSTRAINT producttype_producttypeid_primary PRIMARY KEY(ProductTypeId);
CREATE TABLE Publication(
    PublicationId INT identity(1,1) NOT NULL,
    Name NVARCHAR(30) NOT NULL,
    VolumeList INT NOT NULL,
    ProductTypeId INT NOT NULL
);
ALTER TABLE
    Publication ADD CONSTRAINT publication_publicationid_primary PRIMARY KEY(PublicationId);
ALTER TABLE
    ОrganizationRepresentative ADD CONSTRAINT Оrganizationrepresentative_representativeid_foreign FOREIGN KEY(RepresentativeId) REFERENCES Representative(RepresentativeId);
ALTER TABLE
    Orders ADD CONSTRAINT Orders_representativeid_foreign FOREIGN KEY(RepresentativeId) REFERENCES Representative(RepresentativeId);
ALTER TABLE
    AuthorRepresentative ADD CONSTRAINT authorrepresentative_representativeid_foreign FOREIGN KEY(RepresentativeId) REFERENCES Representative(RepresentativeId);
ALTER TABLE
    AuthorPublication ADD CONSTRAINT authorpublication_publicationid_foreign FOREIGN KEY(PublicationId) REFERENCES Publication(PublicationId);
ALTER TABLE
    OrdersLines ADD CONSTRAINT Orderslines_publicationid_foreign FOREIGN KEY(PublicationId) REFERENCES Publication(PublicationId);
ALTER TABLE
    OrdersLines ADD CONSTRAINT Orderslines_printinghouseid_foreign FOREIGN KEY(PrintingHouseId) REFERENCES PrintingHouse(PrintingHouseId);
ALTER TABLE
    AuthorPublication ADD CONSTRAINT authorpublication_authorid_foreign FOREIGN KEY(AuthorId) REFERENCES Author(AuthorId);
ALTER TABLE
    AuthorRepresentative ADD CONSTRAINT authorrepresentative_authorid_foreign FOREIGN KEY(AuthorId) REFERENCES Author(AuthorId);
ALTER TABLE
    OrdersLines ADD CONSTRAINT Orderslines_Ordersid_foreign FOREIGN KEY(OrdersId) REFERENCES Orders(OrdersId);
ALTER TABLE
    ОrganizationRepresentative ADD CONSTRAINT Оrganizationrepresentative_Оrganizationid_foreign FOREIGN KEY(ОrganizationId) REFERENCES Оrganization(ОrganizationId);
ALTER TABLE
    Orders ADD CONSTRAINT Orders_statusOrderssid_foreign FOREIGN KEY(StatusOrderssId) REFERENCES StatusOrders(StatusOrderssId);
ALTER TABLE
    Publication ADD CONSTRAINT publication_producttypeid_foreign FOREIGN KEY(ProductTypeId) REFERENCES ProductType(ProductTypeId);
ALTER TABLE
    PrintingHouse ADD CONSTRAINT printinghouse_cityid_foreign FOREIGN KEY(CityId) REFERENCES City(CityId);
ALTER TABLE
    Author ADD CONSTRAINT author_cityid_foreign FOREIGN KEY(CityId) REFERENCES City(CityId);
ALTER TABLE
    Оrganization ADD CONSTRAINT Оrganization_cityid_foreign FOREIGN KEY(CityId) REFERENCES City(CityId);
go 
alter table
Representative ADD CONSTRAINT Representative_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
alter table
Author ADD CONSTRAINT Author_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
alter table
Representative ADD CONSTRAINT Representative_check_fax CHECK (DATALENGTH(CAST(fax AS varchar(10))) = 10)
alter table
OrdersLines ADD CONSTRAINT OrdersLines_check_Quantity CHECK (Quantity > 0)
alter table
OrdersLines ADD CONSTRAINT OrdersLines_check_Price CHECK (Price > 0)
alter table
Publication ADD CONSTRAINT Publication_check_Price CHECK (VolumeList > 0)
go
Create PROCEDURE CityAction (
@Action tinyint,
@CityId INT,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete City where CityId = @CityId
else
	if(@Action = 2)
		insert City (Name)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[City]
		    SET Name = @Name
			where CityId = @CityId
end
go
execute CityAction 2, 0, 'Астрахань'
go
Create PROCEDURE StatusOrdersAction (
@Action tinyint,
@StatusOrderssId INT,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete StatusOrders where StatusOrderssId = @StatusOrderssId
else
	if(@Action = 2)
		insert StatusOrders (Name)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[StatusOrders]
		    SET Name = @Name
			where StatusOrderssId = @StatusOrderssId
end
go
execute StatusOrdersAction 2, 0, 'Выполнен'
execute StatusOrdersAction 2, 0, 'Отменён'
execute StatusOrdersAction 2, 0, 'В процессе'
go
Create PROCEDURE PrintingHouseAction (
@Action tinyint,
@PrintingHouseId INT ,
@Name NVARCHAR(30) ,
@CityId int ,
@Street NVARCHAR(30),
@NumberHouse NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete PrintingHouse where PrintingHouseId = @PrintingHouseId
else
	if(@Action = 2)
		insert PrintingHouse (Name,CityId,Street,NumberHouse)
		values (@Name,@CityId,@Street,@NumberHouse)
	else
		if(@Action = 3)
			UPDATE [dbo].[PrintingHouse]
		    SET Name = @Name
			,CityId = @CityId
			,Street = @Street
			,NumberHouse = @NumberHouse
			where PrintingHouseId = @PrintingHouseId
end
go
execute PrintingHouseAction 2, 0, 'Издательство',1,'Савушкина','12бд'
execute PrintingHouseAction 2, 0, 'Издательство2',1,'28 армии','12'
go
Create PROCEDURE RepresentativeAction (
@Action tinyint,
@RepresentativeId INT ,
@FirstName NVARCHAR(30),
@MiddleName NVARCHAR(30),
@LastName NVARCHAR(30),
@PhoneNumber BIGINT,
@fax BIGINT,
@IsОrganization BIT
)
As
Begin
if(@Action = 1)
	delete Representative where RepresentativeId = @RepresentativeId
else
	if(@Action = 2)
		insert Representative (FirstName,MiddleName,LastName,PhoneNumber,fax,IsОrganization)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber,@fax,@IsОrganization)
	else
		if(@Action = 3)
			UPDATE [dbo].[Representative]
		    SET FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			,fax = @fax
			,IsОrganization = @IsОrganization
			where RepresentativeId = @RepresentativeId
end
go
execute RepresentativeAction 2, 0, 'Иван','Иванович',null,9170865455,9170865455,1
execute RepresentativeAction 2, 0, 'Степан','Степанович',null,9170865455,9170865455,0
go
Create PROCEDURE ОrganizationAction (
@Action tinyint,
@ОrganizationId INT ,
@Name NVARCHAR(30),
@CityId int,
@Street NVARCHAR(30),
@NumberHouse NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete Оrganization where ОrganizationId = @ОrganizationId
else
	if(@Action = 2)
		insert Оrganization (Name,CityId,Street,NumberHouse)
		values (@Name,@CityId,@Street,@NumberHouse)
	else
		if(@Action = 3)
			UPDATE [dbo].[Оrganization]
		    SET Name = @Name
			,CityId = @CityId
			,Street = @Street
			,NumberHouse = @NumberHouse
			where ОrganizationId = @ОrganizationId
end
go
execute ОrganizationAction 2, 0, 'Организация',1,'Смоляной','13'
execute ОrganizationAction 2, 0, 'Организация2',1,'Смоляной','15'
go
Create PROCEDURE AuthorAction (
@Action tinyint,
@AuthorId INT ,
@FirstName NVARCHAR(30),
@MiddleName NVARCHAR(30),
@LastName NVARCHAR(30),
@PhoneNumber BIGINT,
@CityId INT,
@Street NVARCHAR(30),
@NumberHouse NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete Author where AuthorId = @AuthorId
else
	if(@Action = 2)
		insert Author (FirstName,MiddleName,LastName,PhoneNumber,CityId,Street,NumberHouse)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber,@CityId,@Street,@NumberHouse)
	else
		if(@Action = 3)
			UPDATE [dbo].[Author]
		    SET FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			,CityId = @CityId
			,Street = @Street
			,NumberHouse = @NumberHouse
			where AuthorId = @AuthorId
end
go
execute AuthorAction 2, 0, 'Евгений','Дмитриевич',null,9170865455,1,'Татищева','1'
execute AuthorAction 2, 0, 'Игорь','Игоревич',null,9170865455,1,'Татищева','2'
go
Create PROCEDURE ProductTypeAction (
@Action tinyint,
@ProductTypeId INT,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete ProductType where ProductTypeId = @ProductTypeId
else
	if(@Action = 2)
		insert ProductType (Name)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[ProductType]
		    SET Name = @Name
			where ProductTypeId = @ProductTypeId
end
go
execute ProductTypeAction 2, 0, 'Книга'
execute ProductTypeAction 2, 0, 'Листовка'
go
Create PROCEDURE PublicationAction (
@Action tinyint,
@PublicationId INT,
@Name NVARCHAR(30),
@VolumeList INT ,
@ProductTypeId INT
)
As
Begin
if(@Action = 1)
	delete Publication where PublicationId = @PublicationId
else
	if(@Action = 2)
		insert Publication (Name,VolumeList,ProductTypeId)
		values (@Name,@VolumeList,@ProductTypeId)
	else
		if(@Action = 3)
			UPDATE [dbo].[Publication]
		    SET Name = @Name
			,VolumeList= @VolumeList
			,ProductTypeId= @ProductTypeId
			where PublicationId = @PublicationId
end
go
execute PublicationAction 2, 0, 'Крутая Книга',1000,1
execute PublicationAction 2, 0, 'Крутая Листовка',1,2
go
Create PROCEDURE OrdersAction (
@Action tinyint,
@OrdersId INT ,
@DateAdmission DATE ,
@RepresentativeId INT ,
@DateCompiction DATE ,
@StatusOrderssId INT ,
@StatusDate DATE
)
As
Begin
if(@Action = 1)
	delete Orders where OrdersId = @OrdersId
else
	if(@Action = 2)
		insert Orders (DateAdmission,RepresentativeId,DateCompiction,StatusOrderssId,StatusDate)
		values (@DateAdmission,@RepresentativeId,@DateCompiction,@StatusOrderssId,@StatusDate)
	else
		if(@Action = 3)
			UPDATE [dbo].[Orders]
		    SET DateAdmission = @DateAdmission
			,RepresentativeId = @RepresentativeId
			,DateCompiction = @DateCompiction
			,StatusOrderssId = @StatusOrderssId
			,StatusDate = @StatusDate
			where OrdersId = @OrdersId
end
go
execute OrdersAction 2, 0, '14.05.2014',1,'14.06.2014',1,'03.06.2014'
execute OrdersAction 2, 0, '14.09.2014',1,'14.10.2014',2,'03.10.2014'
go
Create PROCEDURE OrdersLinesAction (
@Action tinyint,
@OrdersLinesId INT ,
@OrdersId INT ,
@PublicationId INT ,
@PrintingHouseId INT ,
@Quantity INT ,
@Price FLOAT 
)
As
Begin
if(@Action = 1)
	delete OrdersLines where OrdersLinesId = @OrdersLinesId
else
	if(@Action = 2)
		insert OrdersLines (OrdersId,PublicationId,PrintingHouseId,Quantity,Price)
		values (@OrdersId,@PublicationId,@PrintingHouseId,@Quantity,@Price)
	else
		if(@Action = 3)
			UPDATE [dbo].[OrdersLines]
		    SET OrdersId = @OrdersId
			,PublicationId = @PublicationId
			,PrintingHouseId = @PrintingHouseId
			,Quantity = @Quantity
			,Price = @Price
			where OrdersLinesId = @OrdersLinesId
end
go
execute OrdersLinesAction 2, 0, 1,1,1,100,1200
execute OrdersLinesAction 2, 0, 2,2,2,200,2200
go
Create PROCEDURE AuthorPublicationAction (
@Action tinyint,
@AuthorPublicationId INT,
@AuthorId INT,
@PublicationId INT,
@СoАuthor BIT = 0 
)
As
Begin
if(@Action = 1)
	delete AuthorPublication where AuthorPublicationId = @AuthorPublicationId
else
	if(@Action = 2)
		insert AuthorPublication (AuthorId,PublicationId ,СoАuthor)
		values (@AuthorId,@PublicationId ,@СoАuthor)
	else
		if(@Action = 3)
			UPDATE [dbo].[AuthorPublication]
		    SET AuthorId = @AuthorId,
			PublicationId = @PublicationId,
			СoАuthor = @СoАuthor
			where AuthorPublicationId = @AuthorPublicationId
end
go
execute AuthorPublicationAction 2, 0, 1,1,1
execute AuthorPublicationAction 2, 0, 1,2,0
execute AuthorPublicationAction 2, 0, 2,1,0
go
Create PROCEDURE ОrganizationRepresentativeAction (
@Action tinyint,
@ОrganizationRepresentativeId INT,
@ОrganizationId INT,
@RepresentativeId INT
)
As
Begin
if(@Action = 1)
	delete ОrganizationRepresentative where ОrganizationRepresentativeId = @ОrganizationRepresentativeId
else
	if(@Action = 2)
		insert ОrganizationRepresentative (ОrganizationId,RepresentativeId)
		values (@ОrganizationId,@RepresentativeId)
	else
		if(@Action = 3)
			UPDATE [dbo].[ОrganizationRepresentative]
		    SET ОrganizationId = @ОrganizationId,
			RepresentativeId = @RepresentativeId
			where ОrganizationRepresentativeId = @ОrganizationRepresentativeId
end
go
execute ОrganizationRepresentativeAction 2, 0, 1,1
go
Create PROCEDURE AuthorRepresentativeAction (
@Action tinyint,
@AuthorRepresentativeId INT,
@AuthorId INT,
@RepresentativeId INT
)
As
Begin
if(@Action = 1)
	delete AuthorRepresentative where AuthorRepresentativeId = @AuthorRepresentativeId
else
	if(@Action = 2)
		insert AuthorRepresentative (AuthorId,RepresentativeId)
		values (@AuthorId,@RepresentativeId)
	else
		if(@Action = 3)
			UPDATE [dbo].[AuthorRepresentative]
		    SET AuthorId = @AuthorId,
			RepresentativeId = @RepresentativeId
			where AuthorRepresentativeId = @AuthorRepresentativeId
end
go
execute AuthorRepresentativeAction 2, 0, 1,2
execute AuthorRepresentativeAction 2, 0, 2,2
go
create trigger checkInsertOreders on Orders
for insert, update
as
declare @DateAdmission date, @DateCompiction date
Select 
	@DateAdmission=DateAdmission, 
	@DateCompiction=DateCompiction
from inserted
if (@DateCompiction >= @DateAdmission)
Begin
	print 'Необходимо правильно указать дату!'
	ROLLBACK TRANSACTION
End
go
create PROCEDURE RepresentativeInfo (
@Representative int
)
as
begin
select r.*, CountOrders from Representative r
inner join (select RepresentativeId, count(OrdersId) as CountOrders 
			from Orders
			where RepresentativeId = @Representative group by RepresentativeId) o on r.RepresentativeId = o.RepresentativeId 
end
go
execute RepresentativeInfo 1
go
create PROCEDURE OrdersInfo (
@Orders int
)
as
begin
select o.*, CountOrdersLines, SumPrice, tp.Name from Orders o
inner join (select OrdersId, count(OrdersLinesId) as CountOrdersLines, sum(Price) as SumPrice
			from OrdersLines
			where OrdersId = @Orders group by OrdersId) oq on o.RepresentativeId = o.RepresentativeId
inner join OrdersLines ol on ol.OrdersId=o.OrdersId
inner join Publication p on p.PublicationId = ol.PublicationId
inner join ProductType tp on tp.ProductTypeId = p.ProductTypeId
end
go
execute OrdersInfo 2
go
create PROCEDURE PublicationInfo (
@Publication int
)
as
begin
select p.*, MiddleName ,OrdersId, Quantity from Publication p
inner join OrdersLines ol on ol.PublicationId=p.PublicationId
inner join AuthorPublication ap on ap.PublicationId = p.PublicationId
inner join Author a on a.AuthorId = ap.AuthorId
where p.PublicationId = @Publication
end
go
execute PublicationInfo 1
go