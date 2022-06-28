Create database ib
go
use ib
CREATE TABLE  Car (
     CarId  INT identity(1,1) NOT NULL,
     BrandId  INT NOT NULL,
     Model  NVARCHAR(30) NOT NULL,
     YearRelease  INT NOT NULL,
     Mileage  FLOAT NOT NULL,
     ClientId  INT NOT NULL,
     VIN  NVarchar(17) NOT NULL
);
ALTER TABLE
     Car  ADD CONSTRAINT  car_carid_primary  PRIMARY KEY( CarId );
CREATE UNIQUE INDEX  car_vin_unique  ON Car ( VIN );
CREATE TABLE  Client (
     ClientId  INT identity(1,1) NOT NULL,
     FirstName  NVARCHAR(30) NOT NULL,
     MIddleName  NVARCHAR(30) NOT NULL,
     LastName  NVARCHAR(30) NOT NULL,
     PhoneNumber  BIGINT NOT NULL,
     CityId  INT NOT NULL,
     Street  NVARCHAR(30) NOT NULL,
     NumberHouse  NVARCHAR(30) NOT NULL
);
ALTER TABLE
     Client  ADD CONSTRAINT  client_clientid_primary  PRIMARY KEY( ClientId );
CREATE TABLE  Dealer (
     DealerId  INT identity(1,1) NOT NULL,
     FirstName  NVARCHAR(30) NOT NULL,
     MiddleName  NVARCHAR(30) NOT NULL,
     LastName  NVARCHAR(30) NOT NULL,
     PhoneNumber  BIGINT NOT NULL,
     CityId  INT NOT NULL,
     Street  NVARCHAR(30) NOT NULL,
     NumberHouse  NVARCHAR(30) NOT NULL,
     Image  VARBINARY(MAX) NOT NULL
);
ALTER TABLE
     Dealer  ADD CONSTRAINT  dealer_dealerid_primary  PRIMARY KEY( DealerId );
CREATE TABLE  CarDocument (
     CarDocumentId  INT identity(1,1) NOT NULL,
     CarId  INT NOT NULL,
     PTS  NVARCHAR(10) NOT NULL,
     OSAGO  NVARCHAR(13) NOT NULL,
     SOP  NVARCHAR(8) NOT NULL,
     DKP VARBINARY(MAX) NOT NULL
);
ALTER TABLE
     CarDocument  ADD CONSTRAINT  cardocument_cardocumentid_primary  PRIMARY KEY( CarDocumentId );
CREATE UNIQUE INDEX  cardocument_pts_unique  ON
     CarDocument ( PTS );
CREATE UNIQUE INDEX  cardocument_osago_unique  ON
     CarDocument ( OSAGO );
CREATE UNIQUE INDEX  cardocument_sop_unique  ON
     CarDocument ( SOP );
CREATE TABLE  ClientDocument (
     ClientDocumentId  INT identity(1,1) NOT NULL,
     ClientId  INT NOT NULL,
     Passport  INT NOT NULL,
     INN  BIGINT NOT NULL
);
ALTER TABLE
     ClientDocument  ADD CONSTRAINT  clientdocument_clientdocumentid_primary  PRIMARY KEY( ClientDocumentId );
CREATE UNIQUE INDEX  clientdocument_passport_unique  ON
     ClientDocument ( Passport );
CREATE TABLE  Сontract (
     СontractId  INT identity(1,1) NOT NULL,
     CarId  INT NOT NULL,
     DealerId  INT NOT NULL,
     Commission  INT NOT NULL,
     Note  NVARCHAR(Max) NOT NULL,
     СontractFile  VARBINARY(MAX) NOT NULL,
     PriceContact  FLOAT NOT NULL,
     StatusId  INT NOT NULL,
     PriceSale  FLOAT default 0 NOT NULL,
     DateStatus  DATE NOT NULL,
     DateStartContract  DATE NOT NULL,
     DateFinishContract  DATE NOT NULL
);
ALTER TABLE
     Сontract  ADD CONSTRAINT  Сontract_Сontractid_primary  PRIMARY KEY( СontractId );
CREATE TABLE City (
     CityId  INT identity(1,1) NOT NULL,
     Name NVARCHAR(30) NOT NULL
);
ALTER TABLE
     City  ADD CONSTRAINT  city_cityid_primary  PRIMARY KEY( CityId );
CREATE TABLE  Brand (
     BrandId  INT identity(1,1) NOT NULL,
     Name  NVARCHAR(30) NOT NULL
);
ALTER TABLE
     Brand  ADD CONSTRAINT  brand_brandid_primary  PRIMARY KEY( BrandId );
CREATE TABLE  Status (
     StatusId INT identity(1,1) NOT NULL,
     NameStatus NVARCHAR(30) NOT NULL
);
ALTER TABLE
     Status  ADD CONSTRAINT  status_statusid_primary  PRIMARY KEY( StatusId );
ALTER TABLE
     Сontract  ADD CONSTRAINT  Сontract_carid_foreign  FOREIGN KEY( CarId ) REFERENCES  Car ( CarId );
ALTER TABLE
     CarDocument  ADD CONSTRAINT  cardocument_carid_foreign  FOREIGN KEY( CarId ) REFERENCES  Car ( CarId );
ALTER TABLE
     Car  ADD CONSTRAINT  car_clientid_foreign  FOREIGN KEY( ClientId ) REFERENCES  Client ( ClientId );
ALTER TABLE
     ClientDocument  ADD CONSTRAINT  clientdocument_clientid_foreign  FOREIGN KEY( ClientId ) REFERENCES  Client ( ClientId );
ALTER TABLE
     Сontract  ADD CONSTRAINT  Сontract_dealerid_foreign  FOREIGN KEY( DealerId ) REFERENCES  Dealer ( DealerId );
ALTER TABLE
     Client  ADD CONSTRAINT  client_cityid_foreign  FOREIGN KEY( CityId ) REFERENCES  City ( CityId );
ALTER TABLE
     Dealer  ADD CONSTRAINT  dealer_cityid_foreign  FOREIGN KEY( CityId ) REFERENCES  City ( CityId );
ALTER TABLE
     Сontract  ADD CONSTRAINT  Сontract_statusid_foreign  FOREIGN KEY( StatusId ) REFERENCES  Status ( StatusId );
ALTER TABLE
     Car  ADD CONSTRAINT  car_brandid_foreign  FOREIGN KEY( BrandId ) REFERENCES  Brand ( BrandId );

go

alter table
Client ADD CONSTRAINT Client_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)

alter table
Dealer ADD CONSTRAINT Dealer_check_phoheNumber CHECK (DATALENGTH(CAST(PhoneNumber AS varchar(10))) = 10)

alter table
ClientDocument ADD CONSTRAINT ClientDocument_check_Passport CHECK (DATALENGTH(CAST(Passport AS varchar(10))) = 10)

alter table
ClientDocument ADD CONSTRAINT ClientDocument_check_INN CHECK (DATALENGTH(CAST(INN AS varchar(12))) = 12)

alter table
Car ADD CONSTRAINT Car_check_YearRelease CHECK (YearRelease > 1970)

alter table
Car ADD CONSTRAINT Car_check_Mileage CHECK (Mileage > 0)

alter table
Car ADD CONSTRAINT Car_check_VIN CHECK (DATALENGTH(CAST(VIN AS varchar(17))) = 17)

alter table
Сontract ADD CONSTRAINT Сontract_check_Commission CHECK (Commission > 0)

alter table
Сontract ADD CONSTRAINT Сontract_check_PriceContact CHECK (PriceContact > 0)

alter table
Сontract ADD CONSTRAINT Сontract_check_PriceSale CHECK (PriceSale >= 0)

alter table
CarDocument ADD CONSTRAINT ClientDocument_check_PTS CHECK (PTS like '[0-9][0-9][А-Я][А-Я][0-9][0-9][0-9][0-9][0-9][0-9]')

alter table
CarDocument ADD CONSTRAINT ClientDocument_check_OSAGO CHECK (OSAGO like '[А-Я][А-Я][А-Я][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

alter table
CarDocument ADD CONSTRAINT ClientDocument_check_SOP CHECK (SOP like '[А-Я][0-9][0-9][0-9][А-Я][А-Я][0-9][0-9]')

go
Create PROCEDURE CityAction (
@Action tinyint,
@CityId  INT ,
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
execute CityAction 2, -1,'Москва'
go
Create PROCEDURE BrandAction (
@Action tinyint,
@BrandId  INT ,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete Brand where BrandId = @BrandId
else
	if(@Action = 2)
		insert Brand (Name)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[Brand]
		    SET Name = @Name
			where BrandId = @BrandId
end
go
execute BrandAction 2, -1,'BMW'
execute BrandAction 2, -1,'Mersedes'
go
Create PROCEDURE StatusAction (
@Action tinyint,
@StatusId  INT ,
@Name NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete Status where StatusId = @StatusId
else
	if(@Action = 2)
		insert Status (NameStatus)
		values (@Name)
	else
		if(@Action = 3)
			UPDATE [dbo].[Status]
		    SET NameStatus = @Name
			where StatusId = @StatusId
end
go
execute StatusAction 2, -1,'выполнен'
execute StatusAction 2, -1,'не выполнен'
execute StatusAction 2, -1,'выполняется'
go
create PROCEDURE ClientAction (
@Action tinyint,
@ClientId  INT ,
@FirstName  NVARCHAR(30),
@MIddleName  NVARCHAR(30),
@LastName  NVARCHAR(30),
@PhoneNumber  BIGINT,
@CityId  INT,
@Street  NVARCHAR(30),
@NumberHouse  NVARCHAR(30)
)
As
Begin
if(@Action = 1)
	delete Client where ClientId = @ClientId
else
	if(@Action = 2)
		insert Client (FirstName,MIddleName,LastName,PhoneNumber ,CityId ,Street,NumberHouse)
		values (@FirstName,@MIddleName,@LastName,@PhoneNumber ,@CityId ,@Street,@NumberHouse)
	else
		if(@Action = 3)
			UPDATE [dbo].[Client]
		    SET FirstName = @FirstName
			,MIddleName = @MIddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			,CityId = @CityId
			,Street = @Street
			,NumberHouse = @NumberHouse
			where ClientId = @ClientId

end
go
execute ClientAction 2, -1,'Сегрей','Астаховий','Астахович',9148675456,1,'Никольская','25'
execute ClientAction 2, -1,'Иван','Астаховий','Астахович',9158675456,1,'Никольская','27'
go
create PROCEDURE DealerAction (
@Action tinyint,
@DealerId  INT ,
@FirstName  NVARCHAR(30),
@MiddleName  NVARCHAR(30),
@LastName  NVARCHAR(30),
@PhoneNumber  BIGINT,
@CityId  INT,
@Street  NVARCHAR(30),
@NumberHouse  NVARCHAR(30),
@Image  VARBINARY(MAX)
)
As
Begin
if(@Action = 1)
	delete Dealer where DealerId = @DealerId
else
	if(@Action = 2)
		insert Dealer (FirstName,MiddleName,LastName,PhoneNumber,CityId,Street,NumberHouse,Image)
		values (@FirstName,@MiddleName,@LastName,@PhoneNumber,@CityId,@Street,@NumberHouse,@Image)
	else
		if(@Action = 3)
			UPDATE [dbo].[Dealer]
		    SET FirstName = @FirstName
			,MIddleName = @MIddleName
			,LastName = @LastName
			,PhoneNumber = @PhoneNumber
			,CityId = @CityId
			,Street = @Street
			,NumberHouse = @NumberHouse
			,Image = @Image
			where DealerId = @DealerId
end
go
execute DealerAction 2, -1,'Георгий','Васов','Васович',9158445456,1,'Никольская','60',0x12345
execute DealerAction 2, -1,'Василий','Васов','Васович',9222445456,1,'Никольская','90',0x1234566
go
create PROCEDURE CarAction (
@Action tinyint,
@CarId  INT ,
@BrandId  INT ,
@Model  NVARCHAR(30) ,
@YearRelease  INT ,
@Mileage  FLOAT ,
@ClientId  INT ,
@VIN  BIGINT 
)
As
Begin
if(@Action = 1)
	delete Car where CarId = @CarId
else
	if(@Action = 2)
		insert Car (BrandId,Model,YearRelease,Mileage,ClientId,VIN)
		values (@BrandId,@Model,@YearRelease,@Mileage,@ClientId,@VIN)
	else
		if(@Action = 3)
			UPDATE [dbo].[Car]
		    SET BrandId = @BrandId
			,Model = @Model
			,YearRelease = @YearRelease
			,Mileage = @Mileage
			,ClientId = @ClientId
			,VIN = @VIN
			where CarId = @CarId

end
go
execute CarAction 2, -1,1,'X5',2013,200,1,11111111111111112
execute CarAction 2, -1,2,'E3',2000,100,2,11111111111111111
go
create PROCEDURE CarDocumentAction (
@Action tinyint,
@CarDocumentId  INT ,
@CarId  INT,
@PTS  NVARCHAR(30),
@OSAGO  NVARCHAR(30),
@SOP  NVARCHAR(30),
@DKP  INT
)
As
Begin
if(@Action = 1)
	delete CarDocument where CarDocumentId = @CarDocumentId
else
	if(@Action = 2)
		insert CarDocument (CarId,PTS,OSAGO,SOP,DKP)
		values (@CarId,@PTS,@OSAGO,@SOP,@DKP)
	else
		if(@Action = 3)
			UPDATE [dbo].[CarDocument]
		    SET CarId = @CarId
			,PTS = @PTS
			,OSAGO = @OSAGO
			,SOP = @SOP
			,DKP = @DKP
			where CarDocumentId = @CarDocumentId

end
go
execute CarDocumentAction 2, -1,1,'11ЙЙ111111','ЙЦУ1234567890','Й111ЙЙ11',0x1234566
execute CarDocumentAction 2, -1,1,'11ЙЙ111112','ЙЦУ1234567891','Й111ЙЙ12',0x12345665
go
Create PROCEDURE ClientDocumentAction (
@Action tinyint,
@ClientDocumentId  INT ,
@ClientId  INT,
@Passport  INT,
@INN  BIGINT
)
As
Begin
if(@Action = 1)
	delete ClientDocument where ClientDocumentId = @ClientDocumentId
else
	if(@Action = 2)
		insert ClientDocument (ClientId,Passport,INN)
		values (@ClientId,@Passport,@INN)
	else
		if(@Action = 3)
			UPDATE [dbo].[ClientDocument]
		    SET ClientId = @ClientId
			,Passport = @Passport
			,INN = @INN
			where ClientDocumentId = @ClientDocumentId

end
go
execute ClientDocumentAction 2, -1,1,'1234567890','123456789012'
execute ClientDocumentAction 2, -1,1,'1234567891','123456789011'
go
Create PROCEDURE СontractAction (
@Action tinyint,
@СontractId  INT ,
@CarId  INT,
@DealerId  INT,
@Commission  INT,
@Note  NVARCHAR(Max),
@СontractFile  VARBINARY(MAX),
@PriceContact  FLOAT,
@StatusId  INT,
@PriceSale  FLOAT,
@DateStatus  DATE,
@DateStartContract  DATE,
@DateFinishContract  DATE
)
As
Begin
if(@Action = 1)
	delete Сontract where СontractId = @СontractId
else
	if(@Action = 2)
		insert Сontract (CarId,DealerId,Commission,Note,СontractFile,PriceContact,StatusId,PriceSale,DateStatus,DateStartContract,DateFinishContract)
		values (@CarId,@DealerId,@Commission,@Note,@СontractFile,@PriceContact,@StatusId,@PriceSale,@DateStatus,@DateStartContract,@DateFinishContract)
	else
		if(@Action = 3)
			UPDATE [dbo].[Сontract]
		    SET CarId = @CarId
			,DealerId = @DealerId
			,Commission = @Commission
			,Note = @Note
			,СontractFile = @СontractFile
			,PriceContact = @PriceContact
			,StatusId = @StatusId
			,PriceSale = @PriceSale
			,DateStatus = @DateStatus
			,DateStartContract = @DateStartContract
			,DateFinishContract = @DateFinishContract
			where СontractId = @СontractId

end
go
execute СontractAction 2, -1,1,1,1000,'РАНДОМНЫЙ ТЕКСТ',0x1234566,10000,1,100000,'16.05.2014','10.05.2014','21.05.2014'
execute СontractAction 2, -1,1,1,1000,'РАНДОМНЫЙ ТЕКСТ',0x1234566,10000,1,100000,'16.05.2014','10.05.2014','21.05.2014'
go
create trigger checkInsertСontract on Сontract
for insert, update
as
declare @DateStartContract date, @DateFinishContract date
Select 
	@DateStartContract=DateStartContract, 
	@DateFinishContract=DateFinishContract
from inserted
if (@DateFinishContract >= @DateStartContract)
Begin
	print 'Необходимо правильно указать дату!'
	ROLLBACK TRANSACTION
End
go
Create PROCEDURE ClientCountСar
As
Begin
select c.*,CountСar from Client c 
inner join (select 
				Car.ClientId, 
				Count(ct.CarId) as CountСar 
			from Car 
			inner join Сontract ct on Car.CarId = ct.CarId 
			group by Car.ClientId) a on a.ClientId = c.ClientId
end
go
Create PROCEDURE DealerCountСontract
As
Begin
select D.*,CountСontract from Dealer D 
left join (select 
				d.DealerId, 
				Count(ct.СontractId) as CountСontract 
			from Dealer d
			left join Сontract ct on d.DealerId = ct.DealerId
			where StatusId = 1
			group by d.DealerId
			) a on a.DealerId = D.DealerId
end
go
Create PROCEDURE DealerClient
As
Begin
select D.*, c.* from Dealer D 
inner join Сontract ct on ct.DealerId = D.DealerId
inner join Car on Car.CarId = ct.CarId
inner join Client c on c.ClientId = Car.ClientId  
order by D.DealerId
end
go
Create PROCEDURE СontractDealer
As
Begin
select D.DealerId, DateStartContract, c.*, StatusId from Dealer D 
inner join Сontract ct on ct.DealerId = D.DealerId
inner join Car on Car.CarId = ct.CarId
inner join Client c on c.ClientId = Car.ClientId
where DateStartContract between '' and ''
order by D.DealerId
end
