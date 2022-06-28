--drop database KursachMe
create database ASAF
go
USE ASAF

CREATE TABLE Owner(
    OwnerID INT identity(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NULL,
    PhoneNumber BIGINT NULL,
    Email NVARCHAR(100) NULL,
    INN BIGINT NOT NULL
);
ALTER TABLE
    Owner ADD CONSTRAINT owner_ownerid_primary PRIMARY KEY(OwnerID);

CREATE TABLE Region(
    RegionID INT identity(1,1) NOT NULL,
    NameRegion NVARCHAR(50) NOT NULL
);
ALTER TABLE
    Region ADD CONSTRAINT region_regionid_primary PRIMARY KEY(RegionID);

CREATE TABLE Farm(
	FarmID int IDENTITY(1,1) NOT NULL,
    codeUSRRE NVARCHAR(25) NOT NULL,
    NameFarm NVARCHAR(50) NULL,
    City NVARCHAR(50) NULL,
    Street NVARCHAR(100) NULL,
    NumberHouse NVARCHAR(10) NULL,
    PhoneNumber BIGINT NULL,
    Email NVARCHAR(100) NULL,
    OwnerID INT NOT NULL,
    RegionID INT NOT NULL
);
ALTER TABLE
    Farm ADD CONSTRAINT farm_FarmID_primary PRIMARY KEY(FarmID);
ALTER TABLE
	Farm ADD CONSTRAINT farm_codeUSRRE_UNIQUE  UNIQUE(codeUSRRE);

CREATE TABLE FarmSpecialization(
    FarmSpecializationID INT identity(1,1) NOT NULL,
    FarmID INT NOT NULL,
    SpecializationID INT NOT NULL
);
ALTER TABLE
    FarmSpecialization ADD CONSTRAINT farmspecialization_farmspecializationid_primary PRIMARY KEY(FarmSpecializationID);

CREATE TABLE Specialization(
    SpecializationID INT identity(1,1) NOT NULL,
    NameSpecialization NVARCHAR(50) NOT NULL
);
ALTER TABLE
    Specialization ADD CONSTRAINT specialization_specializationid_primary PRIMARY KEY(SpecializationID);

Create TABLE FarmProduct(
    FarmProductID INT identity(1,1) NOT NULL,
    FarmID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity FLOAT NOT NULL,
    UnitPrice FLOAT NOT NULL
);
ALTER TABLE
    FarmProduct ADD CONSTRAINT farmproduct_farmproductid_primary PRIMARY KEY(FarmProductID);

CREATE TABLE Product(
    ProductID INT identity(1,1) NOT NULL,
    NameProduct NVARCHAR(50) NOT NULL,
    Measure NVARCHAR(50) NOT NULL,
    TypeProductID INT NOT NULL
);
ALTER TABLE
    Product ADD CONSTRAINT product_productid_primary PRIMARY KEY(ProductID);

CREATE TABLE TypeProduct(
    TypeProductID INT identity(1,1) NOT NULL,
    NameTypeProduct NVARCHAR(50) NOT NULL
);
ALTER TABLE
    TypeProduct ADD CONSTRAINT typeproduct_typeproductid_primary PRIMARY KEY(TypeProductID);

CREATE TABLE TypeActivity(
    TypeActivityID INT identity(1,1) NOT NULL,
    NameTypeActivity NVARCHAR(50) NOT NULL
);
ALTER TABLE
    TypeActivity ADD CONSTRAINT typeactivity_typeactivityid_primary PRIMARY KEY(TypeActivityID);

CREATE TABLE FarmTypeActivity(
    FarmTypeActivityID  INT identity(1,1) NOT NULL,
    FarmID INT NOT NULL,
    TypeActivityID INT NOT NULL
);
ALTER TABLE
    FarmTypeActivity ADD CONSTRAINT farmtypeactivity_farmtypeactivityid_primary PRIMARY KEY(FarmTypeActivityID);

ALTER TABLE
    Farm ADD CONSTRAINT farm_regionid_foreign FOREIGN KEY(RegionID) REFERENCES Region(RegionID) on delete cascade on update cascade;
ALTER TABLE
    Farm ADD CONSTRAINT farm_ownerid_foreign FOREIGN KEY(OwnerID) REFERENCES Owner(OwnerID) on delete cascade on update cascade;
ALTER TABLE
    FarmSpecialization ADD CONSTRAINT farmspecialization_farmid_foreign FOREIGN KEY(FarmID) REFERENCES Farm(FarmID) on delete cascade on update cascade;
ALTER TABLE
    FarmTypeActivity ADD CONSTRAINT farmtypeactivity_farmid_foreign FOREIGN KEY(FarmID) REFERENCES Farm(FarmID) on delete cascade on update cascade;
ALTER TABLE
    FarmProduct ADD CONSTRAINT farmproduct_farmid_foreign FOREIGN KEY(FarmID) REFERENCES Farm(FarmID) on delete cascade on update cascade;
ALTER TABLE
    FarmSpecialization ADD CONSTRAINT farmspecialization_specializationid_foreign FOREIGN KEY(SpecializationID) REFERENCES Specialization(SpecializationID) on delete cascade on update cascade;
ALTER TABLE
    FarmProduct ADD CONSTRAINT farmproduct_productid_foreign FOREIGN KEY(ProductID) REFERENCES Product(ProductID);
ALTER TABLE
    Product ADD CONSTRAINT product_typeproductid_foreign FOREIGN KEY(TypeProductID) REFERENCES TypeProduct(TypeProductID);
ALTER TABLE
    FarmTypeActivity ADD CONSTRAINT farmtypeactivity_typeactivityid_foreign FOREIGN KEY(TypeActivityID) REFERENCES TypeActivity(TypeActivityID);
go
alter table
Farm ADD CONSTRAINT farm_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)

alter table
Farm ADD CONSTRAINT farm_check_Email CHECK (Email like '[^=-)(*&^%$#@!]%[^=-)(*&^%$#@!]@[^=-)(*&^%$#@!]%[^=-)(*&^%$#@!]%.%[^=-)(*&^%$#@!]%[^=-)(*&^%$#@!]%')

alter table
Farm ADD CONSTRAINT farm_check_codeUSRRE CHECK (codeUSRRE like '[0-9][0-9]-[0-9][0-9]-[0-9][0-9]/[0-9][0-9][0-9]/[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]')

alter table
FarmProduct ADD CONSTRAINT FarmProduct_check_Quantity CHECK (Quantity >= 0)

alter table
FarmProduct ADD CONSTRAINT FarmProduct_check_UnitPrice CHECK (UnitPrice >= 0)

alter table
Owner ADD CONSTRAINT Owner_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)

alter table
Owner ADD CONSTRAINT Owner_check_Email CHECK (Email like '[^=-)(*&^%$#@!]%[^=-)(*&^%$#@!]@[^=-)(*&^%$#@!]%[^=-)(*&^%$#@!].[^=-)(*&^%$#@!]%[^=-)(*&^%$#@!]')

alter table
Owner ADD CONSTRAINT Owner_check_INN CHECK (DATALENGTH(CAST(INN AS varchar(12))) = 12)

go
create trigger checkInsertOwner on Owner
for insert, update
as
declare @PhoneNumber BIGINT, @Email nvarchar(100)
Select 
	@PhoneNumber=PhoneNumber, 
	@Email=Email
from inserted
if (DATALENGTH(@Email) IS NULL and DATALENGTH(@PhoneNumber) IS NULL)
Begin
	print 'Необходимо указать либо номер телефона, либо email!'
	ROLLBACK TRANSACTION
End 

go
create trigger checkInsertFarm on Farm
for insert, update
as
declare @PhoneNumber BIGINT, @Email nvarchar(100)
Select 
	@PhoneNumber=PhoneNumber, 
	@Email=Email
from inserted
if (DATALENGTH(@Email) IS NULL and DATALENGTH(@PhoneNumber) IS NULL)
Begin
	print 'Необходимо указать либо номер телефона, либо email!'
	ROLLBACK TRANSACTION
End 
go
create procedure TypeProductInfo
as
begin
select 
	NameTypeProduct, 
	Count(p.ProductID) as [Количество товаров],
	DENSE_RANK() over (order by SumQuantity desc) as [Ранг продукта по количеству проданного],
	SumQuantity as [Общее количество проданного товара], 
	DENSE_RANK() over (order by SumQuantityUnitPrice desc) as [Ранг по общей сумме],
	SumQuantityUnitPrice as [Общаяя сумма проданного товара],
	AVG(UnitPrice) as [Средняя цена товара],
	Min(UnitPrice) as [Минимальная цена],
	Max(UnitPrice) as [Максимальная цена]
from TypeProduct tp 
Left join Product p on tp.TypeProductID = p.TypeProductID
Left join FarmProduct fp on fp.ProductID = p.ProductID
Left join (select 
				TypeProductID,
				sum(Quantity) as SumQuantity, 
				sum(Quantity * UnitPrice) as SumQuantityUnitPrice
			from FarmProduct fp Left join Product p on p.ProductID = fp.ProductID
			group by TypeProductID) 
			pp on pp.TypeProductID = p.TypeProductID
group by NameTypeProduct,SumQuantity,SumQuantityUnitPrice
end
go
create procedure ProductInfo
as
begin
select 
	NameProduct, 
	DENSE_RANK() over (order by SumQuantity desc) as [Ранг продукта по количеству проданного],
	SumQuantity as [Общее количество проданного товара], 
	DENSE_RANK() over (order by SumQuantityUnitPrice desc) as [Ранг по общей сумме],
	SumQuantityUnitPrice as [Общаяя сумма проданного товара],
	AVG(UnitPrice) as [Средняя цена товара],
	Min(UnitPrice) as [Минимальная цена],
	Max(UnitPrice) as [Максимальная цена]
from Product p 
Left join FarmProduct fp on p.ProductID = fp.ProductID
Left join (select 
				ProductID, 
				sum(Quantity) as SumQuantity, 
				sum(Quantity * UnitPrice) as SumQuantityUnitPrice
			from FarmProduct fp
			group by ProductID) 
			pp on pp.ProductID = p.ProductID
group by NameProduct,SumQuantity,SumQuantityUnitPrice
end
go
Create PROCEDURE FarmInfo (
@FarmID int
)
As
Begin
select 
	NameFarm, 
	SumQuantity as [Общее количество проданного товара], 
	SumQuantityUnitPrice as [Общаяя сумма проданного товара],
	NameProduct,
	DENSE_RANK() over (order by SumQuantityProduct desc) as [Ранг продукта по количеству проданного],
	SumQuantityProduct,
	DENSE_RANK() over (order by SumQuantityUnitPriceProduct desc) as [Ранг по общей сумме],
	SumQuantityUnitPriceProduct,
	AVGUnitPrice
from Farm f 
Left join FarmProduct fp on f.FarmID = fp.FarmID
Left join (select 
				FarmID, 
				sum(Quantity) as SumQuantity, 
				sum(Quantity * UnitPrice) as SumQuantityUnitPrice
			from FarmProduct fp
			group by FarmID) 
			fap on fap.FarmID = f.FarmID
Left join (select 
				ProductID, 
				sum(Quantity) as SumQuantityProduct, 
				sum(Quantity * UnitPrice) as SumQuantityUnitPriceProduct,
				AVG(UnitPrice) AS AVGUnitPrice
			from FarmProduct fp
			where FarmID = @FarmID
			group by ProductID) pap on pap.ProductID = fp.ProductID
Left join Product p on p.ProductID = fp.ProductID
			where f.FarmID = @FarmID
group by f.NameFarm,SumQuantity,SumQuantityUnitPrice,NameProduct,SumQuantityProduct,SumQuantityUnitPriceProduct,AVGUnitPrice
end
go
Create PROCEDURE RegionInsertUpdateDelete (
@Delete bit = 0,
@RegionID int = -1,
@NameRegion nvarchar(50)
)
As
Begin
if(@Delete = 1 and @RegionID in (select RegionID from Region))
	delete Region where RegionID = @RegionID
else
	if(@Delete = 0 and @RegionID not in (select RegionID from Region))
		insert Region (NameRegion)
		values (@NameRegion)
	else
		if(@Delete = 0 and @RegionID in (select RegionID from Region))
			UPDATE [dbo].[Region]
		    SET [NameRegion] = @NameRegion
			where RegionID = @RegionID
end
go
execute RegionInsertUpdateDelete 0,-1,'Республика Алтай'
execute RegionInsertUpdateDelete 0,-1,'Республика Дагестан'
go 
Create PROCEDURE OwnerInsertUpdateDelete (
@Delete bit = 0,
@OwnerID int = -1,
@FirstName nvarchar(50),
@MiddleName nvarchar(50),
@LastName nvarchar(50) = NULL,
@PhoneNumber BIGINT = NULL,
@Email nvarchar(100) = NULL,
@INN BIGINT
)
As
Begin
if(@Delete = 1 and @OwnerID in (select OwnerID from Owner))
	delete Owner where OwnerID = @OwnerID
else
	if(@Delete = 0 and @OwnerID not in (select OwnerID from Owner))
		insert Owner (FirstName,MiddleName,LastName,PhoneNumber,Email,INN)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber,@Email,@INN)
	else
		if(@Delete = 0 and @OwnerID in (select OwnerID from Owner))
			UPDATE [dbo].[Owner]
		   SET [FirstName] = @FirstName
			  ,[MiddleName] = @MiddleName
			  ,[LastName] = @LastName
			  ,[PhoneNumber] = @PhoneNumber
			  ,[Email] = @Email
			  ,[INN] = @INN
			where OwnerID = @OwnerID
end
go
execute OwnerInsertUpdateDelete 0,-1,'Иван','Ивонов','Иванович',9004010975,null,123456789123
execute OwnerInsertUpdateDelete 0,-1,'Сергеев','Сергей','Сергеевич',null,'re@gmil.ru',100000000000
execute OwnerInsertUpdateDelete 0,-1,'Алексеев','Алекс','Алексеевич',9334010975,'ree@gmrail.ru',432156789123
go
Create PROCEDURE SpecializationInsertUpdateDelete (
@Delete bit = 0,
@SpecializationID int = -1,
@NameSpecialization nvarchar(50)
)
As
Begin
if(@Delete = 1 and @SpecializationID in (select SpecializationID from Specialization))
	delete Specialization where SpecializationID = @SpecializationID
else
	if(@Delete = 0 and @SpecializationID not in (select SpecializationID from Specialization))
		insert Specialization (NameSpecialization)
		values (@NameSpecialization)
	else
		if(@Delete = 0 and @SpecializationID in (select SpecializationID from Specialization))
			UPDATE [dbo].[Specialization]
		    SET [NameSpecialization] = @NameSpecialization
			where SpecializationID = @SpecializationID
end
go
execute SpecializationInsertUpdateDelete 0,-1,'Зерновые культуры'
execute SpecializationInsertUpdateDelete 0,-1,'Свиноводство'
execute SpecializationInsertUpdateDelete 0,-1,'Коневодство'
go 
Create PROCEDURE TypeActivityInsertUpdateDelete (
@Delete bit = 0,
@TypeActivityID int = -1,
@NameTypeActivity nvarchar(50)
)
As
Begin
if(@Delete = 1 and @TypeActivityID in (select TypeActivityID from TypeActivity))
	delete TypeActivity where TypeActivityID = @TypeActivityID
else
	if(@Delete = 0 and @TypeActivityID not in (select TypeActivityID from TypeActivity))
		insert TypeActivity (NameTypeActivity)
		values (@NameTypeActivity)
	else
		if(@Delete = 0 and @TypeActivityID in (select TypeActivityID from TypeActivity))
			UPDATE [dbo].[TypeActivity]
		    SET [NameTypeActivity] = @NameTypeActivity
			where TypeActivityID = @TypeActivityID
end
go
execute TypeActivityInsertUpdateDelete 0,-1,'Зерноводство'
execute TypeActivityInsertUpdateDelete 0,-1,'Скотоводство'
go
Create PROCEDURE TypeProductInsertUpdateDelete (
@Delete bit = 0,
@TypeProductID int = -1,
@NameTypeProduct nvarchar(50)
)
As
Begin
if(@Delete = 1 and @TypeProductID in (select TypeProductID from TypeProduct))
	delete TypeProduct where TypeProductID = @TypeProductID
else
	if(@Delete = 0 and @TypeProductID not in (select TypeProductID from TypeProduct))
		insert TypeProduct (NameTypeProduct)
		values (@NameTypeProduct)
	else
		if(@Delete = 0 and @TypeProductID in (select TypeProductID from TypeProduct))
			UPDATE [dbo].[TypeProduct]
		    SET [NameTypeProduct] = @NameTypeProduct
			where TypeProductID = @TypeProductID
end
go
execute TypeProductInsertUpdateDelete 0,-1,'Овощные культуры'
execute TypeProductInsertUpdateDelete 0,-1,'Молочная продукция'
execute TypeProductInsertUpdateDelete 0,-1,'Мясная продукция'
go
Create PROCEDURE FarmInsertUpdateDelete (
@Delete bit = 0,
@FarmID int = -1,
@codeUSRRE nvarchar(50),
@NameFarm nvarchar(50),
@City nvarchar(50) = null,
@Street nvarchar(100) = null,
@NumberHouse nvarchar(10) = null,
@PhoneNumber BIGINT = null,
@Email nvarchar(100) = null,
@OwnerID int,
@RegionID int
)
As
Begin
if(@Delete = 1 and @FarmID in (select FarmID from Farm))
	delete Farm where FarmID = @FarmID
else
	if(@Delete = 0 and @FarmID not in (select FarmID from Farm))
		insert Farm (codeUSRRE,NameFarm,City,Street,NumberHouse,PhoneNumber,Email,OwnerID,RegionID)
		values (@codeUSRRE,@NameFarm,@City,@Street,@NumberHouse,@PhoneNumber,@Email,@OwnerID,@RegionID)
	else
		if(@Delete = 0 and @FarmID in (select FarmID from Farm))
			UPDATE [dbo].[Farm]
		   SET [codeUSRRE] = @codeUSRRE
				,[NameFarm] = @NameFarm
				,[City] = @City
				,[Street] = @Street
				,[NumberHouse] = @NumberHouse
				,[PhoneNumber] = @PhoneNumber
				,[Email] = @Email
				,[OwnerID] = @OwnerID
				,[RegionID] = @RegionID
			where FarmID = @FarmID
end
go
execute FarmInsertUpdateDelete 0,-1,'65-56-65/101/2022-423','Антоновка',null,null,null,'8324050875',null,1,1
execute FarmInsertUpdateDelete 0,-1,'65-00-65/101/2022-423','Верхнее','Махачкала','Верхнее',null,'8324950875',null,2,2
execute FarmInsertUpdateDelete 0,-1,'65-11-65/000/2022-423',null,null,null,null,'8323350875',null,1,1
go
Create PROCEDURE ProductInsertUpdateDelete (
@Delete bit = 0,
@ProductID int = -1,
@NameProduct nvarchar(50),
@Measure nvarchar(50),
@TypeProductID int
)
As
Begin
if(@Delete = 1 and @ProductID in (select ProductID from Product))
	delete Product where ProductID = @ProductID
else
	if(@Delete = 0 and @ProductID not in (select ProductID from Product))
		insert Product (NameProduct,Measure,TypeProductID)
		values (@NameProduct,@Measure,@TypeProductID)
	else
		if(@Delete = 0 and @ProductID in (select ProductID from Product))
			UPDATE [dbo].[Product]
		    SET [NameProduct] = @NameProduct,
				[Measure] = @Measure,
				[TypeProductID] = @TypeProductID
			where ProductID = @ProductID
end
go
execute ProductInsertUpdateDelete 0,-1,'Пшеница','киллограмм',2
execute ProductInsertUpdateDelete 0,-1,'Огурцы','киллограмм',3
execute ProductInsertUpdateDelete 0,-1,'Помидоры','киллограмм',3
go
Create PROCEDURE FarmProductInsertUpdateDelete (
@Delete bit = 0,
@FarmProductID int = -1,
@FarmID int,
@ProductID int,
@Quantity float,
@UnitPrice float
)
As
Begin
if(@Delete = 1 and @FarmProductID in (select FarmProductID from FarmProduct))
	delete FarmProduct where FarmProductID = @FarmProductID
else
	if(@Delete = 0 and @FarmProductID not in (select FarmProductID from FarmProduct))
		insert FarmProduct (FarmID,ProductID,Quantity,UnitPrice)
		values (@FarmID,@ProductID,@Quantity,@UnitPrice)
	else
		if(@Delete = 0 and @FarmProductID in (select FarmProductID from FarmProduct))
			UPDATE [dbo].[FarmProduct]
		    SET [FarmID] = FarmID,
				[ProductID] = ProductID,
				[Quantity] = Quantity, 
				[UnitPrice] = UnitPrice
			where FarmProductID = @FarmProductID
end
go
execute FarmProductInsertUpdateDelete 0,-1,1,1,3400,1200
execute FarmProductInsertUpdateDelete 0,-1,2,3,34000,120
execute FarmProductInsertUpdateDelete 0,-1,1,2,400,120
execute FarmProductInsertUpdateDelete 0,-1,2,1,44000,200
go
Create PROCEDURE FarmSpecializationInsertUpdateDelete (
@Delete bit = 0,
@FarmSpecializationID int = -1,
@FarmID int,
@SpecializationID int
)
As
Begin
if(@Delete = 1 and @FarmSpecializationID in (select FarmSpecializationID from FarmSpecialization))
	delete FarmSpecialization where FarmSpecializationID = @FarmSpecializationID
else
	if(@Delete = 0 and @FarmSpecializationID not in (select FarmSpecializationID from FarmSpecialization))
		insert FarmSpecialization (FarmID,SpecializationID)
		values (@FarmID,@SpecializationID)
	else
		if(@Delete = 0 and @FarmSpecializationID in (select FarmSpecializationID from FarmSpecialization))
			UPDATE [dbo].[FarmSpecialization]
		    SET [FarmID] = FarmID,
				[SpecializationID] = SpecializationID
			where FarmSpecializationID = @FarmSpecializationID
end
go
execute FarmSpecializationInsertUpdateDelete 0,-1,1,1
execute FarmSpecializationInsertUpdateDelete 0,-1,1,2
execute FarmSpecializationInsertUpdateDelete 0,-1,2,2
go
Create PROCEDURE FarmTypeActivityInsertUpdateDelete (
@Delete bit = 0,
@FarmTypeActivityID int = -1,
@FarmID int,
@TypeActivityID int
)
As
Begin
if(@Delete = 1 and @FarmTypeActivityID in (select FarmTypeActivityID from FarmTypeActivity))
	delete FarmTypeActivity where FarmTypeActivityID = @FarmTypeActivityID
else
	if(@Delete = 0 and @FarmTypeActivityID not in (select FarmTypeActivityID from FarmTypeActivity))
		insert FarmTypeActivity (FarmID,TypeActivityID)
		values (@FarmID,@TypeActivityID)
	else
		if(@Delete = 0 and @FarmTypeActivityID in (select FarmTypeActivityID from FarmTypeActivity))
			UPDATE [dbo].[FarmTypeActivity]
		    SET [FarmID] = FarmID,
				[TypeActivityID] = TypeActivityID
			where FarmTypeActivityID = @FarmTypeActivityID
end
go
execute FarmTypeActivityInsertUpdateDelete 0,-1,1,1
execute FarmTypeActivityInsertUpdateDelete 0,-1,1,2
execute FarmTypeActivityInsertUpdateDelete 0,-1,2,2
go
execute ProductInfo
execute TypeProductInfo
execute FarmInfo 1