-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-06-10 16:31:45.456

go
create database Samp
go
use Samp
-- tables
-- Table: Department отдел
CREATE TABLE Department (
    DepartmentID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(30)  NOT NULL,
    CONSTRAINT Department_pk PRIMARY KEY  (DepartmentID)
);

-- Table: Employee сотрудник
CREATE TABLE Employee (
    EmployeeID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(30)  NOT NULL,
    MiddleName nvarchar(30)  NOT NULL,
    LastName nvarchar(30)  NULL,
    PhoneNumber bigint  NOT NULL,
    CONSTRAINT Employee_pk PRIMARY KEY  (EmployeeID)
);

-- Table: Products товар
CREATE TABLE Products (
    ProductsID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(30)  NOT NULL,
    Price money  NOT NULL,
    DepartmentID int  NOT NULL,
    CONSTRAINT Products_pk PRIMARY KEY  (ProductsID)
);

-- Table: Sale продажа
CREATE TABLE Sale (
    SaleID int  NOT NULL IDENTITY(1, 1),
    Date datetime  NOT NULL,
    EmployeeID int  NOT NULL,
    CONSTRAINT Sale_pk PRIMARY KEY  (SaleID)
);

-- Table: SaleLines строка продажи
CREATE TABLE SaleLines (
    SaleLinesID int  NOT NULL IDENTITY(1, 1),
    Quantity int  NOT NULL CHECK (Quantity > 0),
    SaleID int  NOT NULL,
    ProductsID int  NOT NULL,
    CONSTRAINT SaleLines_pk PRIMARY KEY  (SaleLinesID)
);

-- Table: Supplier поставщики
CREATE TABLE Supplier (
    supplierID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(30)  NOT NULL,
    CityID int  NOT NULL,
    Street nvarchar(50)  NOT NULL,
    NumberHouse nvarchar(15)  NOT NULL,
    CONSTRAINT Supplier_pk PRIMARY KEY  (supplierID)
);

-- Table: SupplierProducts поставки
CREATE TABLE SupplierProducts (
    SupplierProductsID int  NOT NULL IDENTITY(1, 1),
    Date datetime  NOT NULL,
    supplierID int  NOT NULL,
    ProductsID int  NOT NULL,
    Quantity int  NOT NULL CHECK (Quantity > 0),
    CONSTRAINT SupplierProducts_pk PRIMARY KEY  (SupplierProductsID)
);

CREATE TABLE City (
    CityID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(30) NOT NULL,
    CONSTRAINT City_pk PRIMARY KEY  (CityID)
);

-- foreign keys
-- Reference: Products_Department (table: Products) связь продукты-отдел
ALTER TABLE Products ADD CONSTRAINT Products_Department
    FOREIGN KEY (DepartmentID)
    REFERENCES Department (DepartmentID);

-- Reference: SaleLines_Products (table: SaleLines) связь строка продажи-продукт
ALTER TABLE SaleLines ADD CONSTRAINT SaleLines_Products
    FOREIGN KEY (ProductsID)
    REFERENCES Products (ProductsID);

-- Reference: SaleLines_Sale (table: SaleLines) связь строка продажи-продажа
ALTER TABLE SaleLines ADD CONSTRAINT SaleLines_Sale
    FOREIGN KEY (SaleID)
    REFERENCES Sale (SaleID);

-- Reference: Sale_Employee (table: Sale) связь продажа-сотрудник
ALTER TABLE Sale ADD CONSTRAINT Sale_Employee
    FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID);

-- Reference: SupplierProducts_Products (table: SupplierProducts) связь поставка-продукт
ALTER TABLE SupplierProducts ADD CONSTRAINT SupplierProducts_Products
    FOREIGN KEY (ProductsID)
    REFERENCES Products (ProductsID);

-- Reference: SupplierProducts_Supplier (table: SupplierProducts) связь поставка-поставщик
ALTER TABLE SupplierProducts ADD CONSTRAINT SupplierProducts_Supplier
    FOREIGN KEY (supplierID)
    REFERENCES Supplier (supplierID);

-- Reference: Supplier_City (table: Supplier) связь поставщики-города
ALTER TABLE Supplier ADD CONSTRAINT Supplier_City
    FOREIGN KEY (CityID)
    REFERENCES City (CityID);

go
-- начало однотипных процедур на удаление (pozition 0), добавление (pozition 1), обновление (pozition 2) на все таблицы базы
Create procedure DepartmentPro(
@pozition tinyint,
@DepartmentID int,
@Name nvarchar(30)
)
as
begin
if (@pozition = 0)
	Delete from Department where DepartmentID = @DepartmentID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[Department] ([Name])
		VALUES (@Name)
	else
		UPDATE [dbo].[Department]
		SET [Name] = @Name
		WHERE DepartmentID = @DepartmentID
end
go
Create procedure EmployeePro(
@pozition tinyint,
@EmployeeID int,
@FirstName nvarchar(30),
@MiddleName nvarchar(30),
@LastName nvarchar(30),
@PhoneNumber bigint
)
as
begin
if (@pozition = 0)
	Delete from Employee where EmployeeID = @EmployeeID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[Employee] (FirstName,MiddleName,LastName,PhoneNumber)
		VALUES (@FirstName,@MiddleName,@LastName,@PhoneNumber)
	else
		UPDATE [dbo].[Employee]
		SET FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		PhoneNumber = @PhoneNumber
		WHERE EmployeeID = @EmployeeID
end
go
Create procedure ProductsPro(
@pozition tinyint,
@ProductsID int,
@Name nvarchar(30),
@Price money,
@DepartmentID int
)
as
begin
if (@pozition = 0)
	Delete from Products where ProductsID = @ProductsID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[Products] (Name,Price,DepartmentID)
		VALUES (@Name,@Price,@DepartmentID)
	else
		UPDATE [dbo].[Products]
		SET Name = @Name,
		Price = @Price,
		DepartmentID = @DepartmentID
		WHERE ProductsID = @ProductsID
end
go
Create procedure SalePro(
@pozition tinyint,
@SaleID int,
@Date datetime,
@EmployeeID int
)
as
begin
if (@pozition = 0)
	Delete from Sale where SaleID = @SaleID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[Sale] (Date,EmployeeID)
		VALUES (@Date,@EmployeeID)
	else
		UPDATE [dbo].[Sale]
		SET Date = @Date,
		EmployeeID = @EmployeeID
		WHERE SaleID = @SaleID
end
go
Create procedure SaleLinesPro(
@pozition tinyint,
@SaleLinesID int,
@Quantity int,
@SaleID int,
@ProductsID int
)
as
begin
if (@pozition = 0)
	Delete from SaleLines where SaleLinesID = @SaleLinesID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[SaleLines] (Quantity,SaleID,ProductsID)
		VALUES (@Quantity,@SaleID,@ProductsID)
	else
		UPDATE [dbo].[SaleLines]
		SET Quantity = @Quantity,
		SaleID = @SaleID,
		ProductsID = @ProductsID
		WHERE SaleLinesID = @SaleLinesID
end
go
Create procedure SupplierPro(
@pozition tinyint,
@SupplierID int,
@Name nvarchar(30),
@CityID int,
@Street nvarchar(50),
@NumberHouse nvarchar(15)
)
as
begin
if (@pozition = 0)
	Delete from Supplier where SupplierID = @SupplierID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[Supplier] (Name,CityID,Street,NumberHouse)
		VALUES (@Name,@CityID,@Street,@NumberHouse)
	else
		UPDATE [dbo].[Supplier]
		SET Name = @Name,
		CityID = @CityID,
		Street = @Street,
		NumberHouse = @NumberHouse
		WHERE SupplierID = @SupplierID
end
go
Create procedure SupplierProductsPro(
@pozition tinyint,
@SupplierProductsID int,
@Date datetime,
@supplierID int,
@ProductsID int,
@Quantity int
)
as
begin
if (@pozition = 0)
	Delete from SupplierProducts where SupplierProductsID = @SupplierProductsID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[SupplierProducts] (Date,supplierID,ProductsID,Quantity)
		VALUES (@Date,@supplierID,@ProductsID,@Quantity)
	else
		UPDATE [dbo].[SupplierProducts]
		SET Date = @Date,
		supplierID = @supplierID,
		ProductsID = @ProductsID,
		Quantity = @Quantity
		WHERE SupplierProductsID = @SupplierProductsID
end
go
Create procedure CityPro(
@pozition tinyint,
@CityID int,
@Name nvarchar(30)
)
as
begin
if (@pozition = 0)
	Delete from City where CityID = @CityID
else
	if(@pozition = 1)
		INSERT INTO [dbo].[City] ([Name])
		VALUES (@Name)
	else
		UPDATE [dbo].[City]
		SET [Name] = @Name
		WHERE CityID = @CityID
end
-- конец однотипных процедур на удаление (pozition 0), добавление (pozition 1), обновление (pozition 2)
go
-- процедур по заданию
Create procedure DepartmentSale -- продажи отдела
as
begin
select d.DepartmentID, d.Name, sum(productQuantity*Price) as Summa from Department d
inner join Products p on p.DepartmentID = d.DepartmentID
inner join (select ProductsID, sum(Quantity) as productQuantity 
			from SaleLines group by ProductsID) pqt on pqt.ProductsID = p.ProductsID
group by d.DepartmentID, d.Name
order by Summa desc
end
go
Create procedure Remains --остаток
as
begin
select p.ProductsID, p.Name, (pqtsp.productQuantity - pqtsl.productQuantity) as remains from Products p
left join (select ProductsID, sum(Quantity) as productQuantity 
			from SupplierProducts group by ProductsID) pqtsp on pqtsp.ProductsID = p.ProductsID
left join (select ProductsID, sum(Quantity) as productQuantity 
			from SaleLines group by ProductsID) pqtsl on pqtsl.ProductsID = p.ProductsID
order by remains
end
go
Create procedure SaleDay -- общии продажи по дням
as
begin
select s.Date,sum(Price*Quantity) as sum from Department d
inner join Products p on p.DepartmentID = d.DepartmentID
inner join SaleLines sl on sl.ProductsID = p.ProductsID 
inner join Sale s on s.SaleID = sl.SaleID
group by s.Date
end
go
Create procedure SaleM -- общии продажи по месяцам
as
begin
select year(s.date), month(s.Date), sum(Price*Quantity) as sum from Department d
inner join Products p on p.DepartmentID = d.DepartmentID
inner join SaleLines sl on sl.ProductsID = p.ProductsID 
inner join Sale s on s.SaleID = sl.SaleID
group by  year(s.date),month(s.Date)
end
go
Create procedure SaleEmpo -- рейтинг сотрудников
as
begin
select e.EmployeeID, sum(Price*Quantity) as sum from Employee e
inner join Sale s on s.EmployeeID = e.EmployeeID
inner join SaleLines sl on sl.SaleID = s.SaleID
inner join Products p on p.ProductsID = sl.ProductsID
group by E.EmployeeID
order by sum desc
end
go 
-- тригер
create trigger checkSale on SaleLines -- проверка на количество остатка товара
for insert, update
as
declare @QuantitySale INT, @Quantity int, @id int
Select 
	@QuantitySale=Quantity,
	@id = ProductsID
from inserted
select 
	@Quantity = remains
	from (select p.ProductsID, p.Name, (pqtsp.productQuantity - pqtsl.productQuantity) as remains from Products p
			left join (select ProductsID, sum(Quantity) as productQuantity 
			from SupplierProducts group by ProductsID) pqtsp on pqtsp.ProductsID = p.ProductsID
			left join (select ProductsID, sum(Quantity) as productQuantity 
			from SaleLines group by ProductsID) pqtsl on pqtsl.ProductsID = p.ProductsID
			where p.ProductsID = @id) q
if (@QuantitySale > @Quantity)
Begin
	print 'Товара больше нет!'
	ROLLBACK TRANSACTION
End 
go
-- огрничение
alter table
Employee ADD CONSTRAINT Employee_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)