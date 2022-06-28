-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-06-12 07:59:05.986

go  
create database Di
go
use Di
go
-- tables
-- Table: City
CREATE TABLE City (
    CityID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(40)  NOT NULL,
    CONSTRAINT City_pk PRIMARY KEY  (CityID)
);

-- Table: Customer
CREATE TABLE Customer (
    CustomerID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(40)  NOT NULL,
    Street nvarchar(40)  NOT NULL,
    NumberHouse nvarchar(10)  NOT NULL,
    PhoneNumber bigint  NOT NULL,
    CityID int  NOT NULL,
    CONSTRAINT Customer_pk PRIMARY KEY  (CustomerID)
);

-- Table: Deal
CREATE TABLE Deal (
    DealID int  NOT NULL IDENTITY(1, 1),
    Date date  NOT NULL,
    CustomerID int  NOT NULL,
    CONSTRAINT Deal_pk PRIMARY KEY  (DealID)
);

-- Table: DealLines
CREATE TABLE DealLines (
    DealLinesID int  NOT NULL IDENTITY(1, 1),
    Quantity int  NOT NULL CHECK (Quantity > 0),
    UnitPrice money  NOT NULL CHECK (UnitPrice > 0),
    DealID int  NOT NULL,
    StockItemID int  NOT NULL,
    CONSTRAINT DealLines_pk PRIMARY KEY  (DealLinesID)
);

-- Table: Deliveries
CREATE TABLE Deliveries (
    DeliveriesID int  NOT NULL IDENTITY(1, 1),
    Quantity int  NOT NULL CHECK (Quantity > 0),
    UnitPrice money  NOT NULL CHECK (UnitPrice > 0),
    SupplierID int  NOT NULL,
    StockItemID int  NOT NULL,
	DateDeliveries date NOT NULL,
    CONSTRAINT Deliveries_pk PRIMARY KEY  (DeliveriesID)
);

-- Table: StockItem
CREATE TABLE StockItem (
    StockItemID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(40)  NOT NULL,
    Quantity int  NOT NULL CHECK (Quantity >= 0),
    UnitMeasurementID int  NOT NULL,
    CONSTRAINT StockItem_pk PRIMARY KEY  (StockItemID)
);

-- Table: Supplier
CREATE TABLE Supplier (
    SupplierID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(40)  NOT NULL,
    Street nvarchar(40)  NOT NULL,
    NumberHouse nvarchar(10)  NOT NULL,
    PhoneNumber bigint  NOT NULL,
    CityID int  NOT NULL,
    CONSTRAINT Supplier_pk PRIMARY KEY  (SupplierID)
);

-- Table: UnitMeasurement
CREATE TABLE UnitMeasurement (
    UnitMeasurementID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(40) NOT NULL,
    CONSTRAINT UnitMeasurement_pk PRIMARY KEY  (UnitMeasurementID)
);

-- foreign keys
-- Reference: Customer_City (table: Customer)
ALTER TABLE Customer ADD CONSTRAINT Customer_City
    FOREIGN KEY (CityID)
    REFERENCES City (CityID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- Reference: DealLines_Deal (table: DealLines)
ALTER TABLE DealLines ADD CONSTRAINT DealLines_Deal
    FOREIGN KEY (DealID)
    REFERENCES Deal (DealID);

-- Reference: DealLines_StockItem (table: DealLines)
ALTER TABLE DealLines ADD CONSTRAINT DealLines_StockItem
    FOREIGN KEY (StockItemID)
    REFERENCES StockItem (StockItemID);

-- Reference: Deal_Customer (table: Deal)
ALTER TABLE Deal ADD CONSTRAINT Deal_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customer (CustomerID);

-- Reference: Deliveries_StockItem (table: Deliveries)
ALTER TABLE Deliveries ADD CONSTRAINT Deliveries_StockItem
    FOREIGN KEY (StockItemID)
    REFERENCES StockItem (StockItemID);

-- Reference: Deliveries_Supplier (table: Deliveries)
ALTER TABLE Deliveries ADD CONSTRAINT Deliveries_Supplier
    FOREIGN KEY (SupplierID)
    REFERENCES Supplier (SupplierID);

-- Reference: StockItem_UnitMeasurement (table: StockItem)
ALTER TABLE StockItem ADD CONSTRAINT StockItem_UnitMeasurement
    FOREIGN KEY (UnitMeasurementID)
    REFERENCES UnitMeasurement (UnitMeasurementID);

-- Reference: Supplier_City (table: Supplier)
ALTER TABLE Supplier ADD CONSTRAINT Supplier_City
    FOREIGN KEY (CityID)
    REFERENCES City (CityID)
    ON DELETE  CASCADE 
    ON UPDATE  CASCADE;

-- End of file.
go
Create PROCEDURE CityAction (
@Action tinyint,
@CityID  INT ,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete City where CityID = @CityID
else
	if(@Action = 2)
		insert City (Name)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[City]
		    SET Name = @Name
			where CityID = @CityID
end
go
execute CityAction 2,2,'Астрахань'
go
Create PROCEDURE UnitMeasurementAction (
@Action tinyint,
@UnitMeasurementID  INT ,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete UnitMeasurement where UnitMeasurementID = @UnitMeasurementID
else
	if(@Action = 2)
		insert UnitMeasurement (Name)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[UnitMeasurement]
		    SET Name = @Name
			where UnitMeasurementID = @UnitMeasurementID
end
go
execute UnitMeasurementAction 2,2,'тонны'
go
Create PROCEDURE CustomerAction (
@Action tinyint,
@CustomerID  INT ,
@Name nvarchar(40),
@Street nvarchar(40),
@NumberHouse nvarchar(10),
@PhoneNumber bigint,
@CityID int
)
As
Begin
if(@Action = 1)
	Delete Customer where CustomerID = @CustomerID
else
	if(@Action = 2)
		insert Customer (Name,Street,NumberHouse,PhoneNumber,CityID)
		values (@Name,@Street,@NumberHouse,@PhoneNumber,@CityID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Customer]
		    SET Name = @Name
			,Street = @Street
			,NumberHouse = @NumberHouse
			,PhoneNumber = @PhoneNumber
			,CityID = @CityID
			where CustomerID = @CustomerID
end
go
execute CustomerAction 2,2,'qwer','qwe','10',9324001222,1
execute CustomerAction 2,2,'aaaaa','qwe','110',9324001222,1
execute CustomerAction 2,2,'fffff','qwe','210',9324001222,1
go
Create PROCEDURE StockItemAction (
@Action tinyint,
@StockItemID  INT ,
@Name nvarchar(40),
@Quantity int,
@UnitMeasurementID int
)
As
Begin
if(@Action = 1)
	Delete StockItem where StockItemID = @StockItemID
else
	if(@Action = 2)
		insert StockItem (Name,Quantity,UnitMeasurementID)
		values (@Name,@Quantity,@UnitMeasurementID)
	else
		if(@Action = 3)
			UPDATE [dbo].[StockItem]
		    SET Name = @Name
			,Quantity = @Quantity
			,UnitMeasurementID = @UnitMeasurementID
			where StockItemID = @StockItemID
end
go
execute StockItemAction 2,2,'Меч',900,1
execute StockItemAction 2,2,'Мяч',9000,1
execute StockItemAction 2,2,'Мёд',1400,1
go
Create PROCEDURE SupplierAction (
@Action tinyint,
@SupplierID  INT ,
@Name nvarchar(40),
@Street nvarchar(40),
@NumberHouse nvarchar(10),
@PhoneNumber bigint,
@CityID int
)
As
Begin
if(@Action = 1)
	Delete Supplier where SupplierID = @SupplierID
else
	if(@Action = 2)
		insert Supplier (Name,Street,NumberHouse,PhoneNumber,CityID)
		values (@Name,@Street,@NumberHouse,@PhoneNumber,@CityID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Supplier]
		    SET Name = @Name
			,Street = @Street
			,NumberHouse = @NumberHouse
			,PhoneNumber = @PhoneNumber
			,CityID = @CityID
			where SupplierID = @SupplierID
end
go
execute SupplierAction 2,2,'qwer','qwe','10',9324001222,1
execute SupplierAction 2,2,'aaaaa','qwe','110',9324001222,1
execute SupplierAction 2,2,'fffff','qwe','210',9324001222,1
go
Create PROCEDURE DealAction (
@Action tinyint,
@DealID  INT ,
@Date date,
@CustomerID int
)
As
Begin
if(@Action = 1)
	Delete Deal where DealID = @DealID
else
	if(@Action = 2)
		insert Deal (Date,CustomerID)
		values (@Date,@CustomerID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Deal]
		    SET Date = @Date
			,CustomerID = @CustomerID
			where DealID = @DealID
end
go
execute DealAction 2,2,'23.01.2022',1
execute DealAction 2,2,'23.01.2021',1
execute DealAction 2,2,'23.01.2020',2
go
Create PROCEDURE DealLinesAction (
@Action tinyint,
@DealLinesID  INT ,
@Quantity int,
@UnitPrice money,
@DealID int,
@StockItemID int
)
As
Begin
if(@Action = 1)
	Delete DealLines where DealLinesID = @DealLinesID
else
	if(@Action = 2)
		insert DealLines (Quantity,UnitPrice,DealID,StockItemID)
		values (@Quantity,@UnitPrice,@DealID,@StockItemID)
	else
		if(@Action = 3)
			UPDATE [dbo].[DealLines]
		    SET Quantity = @Quantity
			,UnitPrice = @UnitPrice
			,DealID = @DealID
			,StockItemID = @StockItemID
			where DealLinesID = @DealLinesID
end
go
execute DealLinesAction 2,2,12,10,1,1
execute DealLinesAction 2,2,120,100,1,2
execute DealLinesAction 2,2,13,15,2,1
go
Create PROCEDURE DeliveriesAction (
@Action tinyint,
@DeliveriesID  INT ,
@Quantity int,
@UnitPrice money,
@SupplierID int,
@StockItemID int,
@DateDeliveries date
)
As
Begin
if(@Action = 1)
	Delete Deliveries where DeliveriesID = @DeliveriesID
else
	if(@Action = 2)
		insert Deliveries (Quantity,UnitPrice,SupplierID,StockItemID,DateDeliveries)
		values (@Quantity,@UnitPrice,@SupplierID,@StockItemID,@DateDeliveries)
	else
		if(@Action = 3)
			UPDATE [dbo].[Deliveries]
		    SET Quantity = @Quantity
			,UnitPrice = @UnitPrice
			,SupplierID = @SupplierID
			,StockItemID = @StockItemID
			where DeliveriesID = @DeliveriesID
end
go
execute DeliveriesAction 2,2,1200,9,1,1,'04.03.2002'
execute DeliveriesAction 2,2,12000,90,1,2,'04.03.2002'
execute DeliveriesAction 2,2,1300,14,2,1,'04.03.2002'
go
create trigger checkSale on DealLines -- проверка на количество остатка товара
for insert, update
as
declare @QuantitySale INT, @Quantity int, @id int
Select 
	@QuantitySale=Quantity,
	@id = StockItemID
from inserted
select 
	@Quantity = Quantity
	from StockItem
if (@QuantitySale > @Quantity)
Begin
	print 'Товара больше нет!'
	ROLLBACK TRANSACTION
End 
go
alter table
Customer ADD CONSTRAINT Customer_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
alter table
Supplier ADD CONSTRAINT Supplier_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)
GO
Create procedure StockItemSale -- самые популярные товары
as
begin
select si.StockItemID, si.Name, sum(productQuantity*UnitPrice) as TotalSumma, si.Quantity from StockItem si
left join DealLines dl on dl.StockItemID = si.StockItemID
left join (select StockItemID, sum(Quantity) as productQuantity 
			from DealLines group by StockItemID) siq on siq.StockItemID = si.StockItemID
group by si.StockItemID, si.Name, si.Quantity
order by TotalSumma desc, si.Quantity
end
go
Create procedure CustomerSale -- самые крутые покупатели
as
begin
select c.CustomerID, c.Name, sum(productQuantity*UnitPrice) as TotalSumma, sum(productQuantity) as TotalQuantity from Customer c
inner join Deal d on d.CustomerID = c.CustomerID
inner join DealLines dl on dl.DealID = d.DealID
inner join (select DealID, sum(Quantity) as productQuantity 
			from DealLines group by DealID) cq on cq.DealID = d.DealID
group by c.CustomerID, c.Name
order by TotalSumma desc, TotalQuantity desc
end