create database qwerB2
go
use qwerB2

CREATE TABLE Injury(
    InjuryID INT identity(1,1) NOT NULL,
    InjuryName NVARCHAR(30) NOT NULL
);
ALTER TABLE
    Injury ADD CONSTRAINT injury_injuryid_primary PRIMARY KEY(InjuryID);
CREATE TABLE TopPleces(
    TopPlecesID INT identity(1,1) NOT NULL,
    TopPlecesName NVARCHAR(30) NOT NULL
);
ALTER TABLE
    TopPleces ADD CONSTRAINT toppleces_topplecesid_primary PRIMARY KEY(TopPlecesID);
CREATE TABLE Status(
    StatusID INT identity(1,1) NOT NULL,
    StatusName NVARCHAR(30) NOT NULL
);
ALTER TABLE
    Status ADD CONSTRAINT status_status_primary PRIMARY KEY(StatusID);
CREATE TABLE Trainer(
    TrainerID INT identity(1,1) NOT NULL,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NULL,
    Birthday DATE NOT NULL
);
ALTER TABLE
    Trainer ADD CONSTRAINT trainer_trainerid_primary PRIMARY KEY(TrainerID);
CREATE TABLE TrainerPlayer(
    TrainerPlayerID INT identity(1,1) NOT NULL,
    TrainerID INT NOT NULL,
    PlayerID INT NOT NULL
);
ALTER TABLE
    TrainerPlayer ADD CONSTRAINT trainerplayer_trainerplayerid_primary PRIMARY KEY(TrainerPlayerID);
CREATE TABLE InjuryPlayer(
    InjuryPlayerID INT identity(1,1) NOT NULL,
    InjuryID INT NOT NULL,
    PlayerID INT NOT NULL,
    DateInjury DATE NOT NULL
);
ALTER TABLE
    InjuryPlayer ADD CONSTRAINT injuryplayer_injuryplayerid_primary PRIMARY KEY(InjuryPlayerID);
CREATE TABLE Player(
    FIDEID INT NOT NULL,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30) NOT NULL,
    LastName NVARCHAR(30) NULL,
    Birthday DATE NOT NULL,
    ELORating INT NOT NULL default 1000
);
ALTER TABLE
    Player ADD CONSTRAINT player_fideid_primary PRIMARY KEY(FIDEID);
CREATE TABLE TopPlecesEvent(
    TopPlecesEventID INT identity(1,1) NOT NULL,
    TopPlecesID INT NOT NULL,
    EventID INT NOT NULL,
    PlayerID INT NOT NULL
);
ALTER TABLE
    TopPlecesEvent ADD CONSTRAINT topplecesevent_toppleceseventid_primary PRIMARY KEY(TopPlecesEventID);
CREATE TABLE EventPlayer(
    EventPlayerID INT identity(1,1) NOT NULL,
    EventID INT NOT NULL,
    PlayerID INT NOT NULL
);
ALTER TABLE
    EventPlayer ADD CONSTRAINT eventplayer_eventplayerid_primary PRIMARY KEY(EventPlayerID);
CREATE TABLE Event(
    EventID INT identity(1,1) NOT NULL,
    NameEvent NVARCHAR(30) NOT NULL,
    PrizeFund INT NOT NULL,
    DataStart DATE NOT NULL,
    DataFinish DATE NOT NULL,
    StatusID INT NOT NULL
);
ALTER TABLE
    Event ADD CONSTRAINT event_eventid_primary PRIMARY KEY(EventID);
CREATE TABLE Consignment(
    ConsignmentID INT identity(1,1) NOT NULL,
    DateStart DATE NOT NULL,
	DateFinish DATE NOT NULL,
    EventID INT NOT NULL
);
ALTER TABLE
    Consignment ADD CONSTRAINT consignment_consignmentid_primary PRIMARY KEY(ConsignmentID);
CREATE TABLE ConsignmentPlayer(
    ConsignmentPlayerID INT identity(1,1) NOT NULL,
    ConsignmentID INT NOT NULL,
    PlayerID INT NOT NULL,
    IsWhile BIT NOT NULL,
    Result FLOAT NOT NULL,
    Score INT NOT NULL
);
ALTER TABLE
    ConsignmentPlayer ADD CONSTRAINT consignmentplayer_consignmentplayerid_primary PRIMARY KEY(ConsignmentPlayerID);
CREATE TABLE TopPlecesEventTrainer(
    TopPlecesEventTrainerID INT identity(1,1) NOT NULL,
    TrainerId INT NOT NULL,
    TopPlecesEventID INT NOT NULL
);
ALTER TABLE
    TopPlecesEventTrainer ADD CONSTRAINT toppleceseventtrainer_toppleceseventtrainerid_primary PRIMARY KEY(TopPlecesEventTrainerID);
ALTER TABLE
    Event ADD CONSTRAINT event_statusid_foreign FOREIGN KEY(StatusID) REFERENCES Status(StatusID);
ALTER TABLE
    InjuryPlayer ADD CONSTRAINT injuryplayer_injuryid_foreign FOREIGN KEY(InjuryID) REFERENCES Injury(InjuryID);
ALTER TABLE
    TopPlecesEvent ADD CONSTRAINT topplecesevent_topplecesid_foreign FOREIGN KEY(TopPlecesID) REFERENCES TopPleces(TopPlecesID);
ALTER TABLE
    TrainerPlayer ADD CONSTRAINT trainerplayer_trainerid_foreign FOREIGN KEY(TrainerID) REFERENCES Trainer(TrainerID);
ALTER TABLE
    TopPlecesEventTrainer ADD CONSTRAINT toppleceseventtrainer_trainerid_foreign FOREIGN KEY(TrainerId) REFERENCES Trainer(TrainerID);
ALTER TABLE
    EventPlayer ADD CONSTRAINT eventplayer_playerid_foreign FOREIGN KEY(PlayerID) REFERENCES Player(FIDEID);
ALTER TABLE
    TrainerPlayer ADD CONSTRAINT trainerplayer_playerid_foreign FOREIGN KEY(PlayerID) REFERENCES Player(FIDEID);
ALTER TABLE
    TopPlecesEvent ADD CONSTRAINT topplecesevent_playerid_foreign FOREIGN KEY(PlayerID) REFERENCES Player(FIDEID);
ALTER TABLE
    InjuryPlayer ADD CONSTRAINT injuryplayer_playerid_foreign FOREIGN KEY(PlayerID) REFERENCES Player(FIDEID);
ALTER TABLE
    ConsignmentPlayer ADD CONSTRAINT consignmentplayer_playerid_foreign FOREIGN KEY(PlayerID) REFERENCES Player(FIDEID);
ALTER TABLE
    TopPlecesEventTrainer ADD CONSTRAINT toppleceseventtrainer_toppleceseventid_foreign FOREIGN KEY(TopPlecesEventID) REFERENCES TopPlecesEvent(TopPlecesEventID);
ALTER TABLE
    EventPlayer ADD CONSTRAINT eventplayer_eventid_foreign FOREIGN KEY(EventID) REFERENCES Event(EventID);
ALTER TABLE
    Consignment ADD CONSTRAINT consignment_eventid_foreign FOREIGN KEY(EventID) REFERENCES Event(EventID);
ALTER TABLE
    TopPlecesEvent ADD CONSTRAINT topplecesevent_eventid_foreign FOREIGN KEY(EventID) REFERENCES Event(EventID);
ALTER TABLE
    ConsignmentPlayer ADD CONSTRAINT consignmentplayer_consignmentid_foreign FOREIGN KEY(ConsignmentID) REFERENCES Consignment(ConsignmentID);
go
alter table
ConsignmentPlayer ADD CONSTRAINT ConsignmentPlayer_check_Result CHECK (Result in (0, 0.5, 1))
alter table
Event ADD CONSTRAINT Event_check_PrizeFund CHECK (PrizeFund > 0)
alter table
Player ADD CONSTRAINT Player_check_ELORating CHECK (ELORating >= 0)
alter table
Player ADD CONSTRAINT Player_check_FIDEID CHECK (DATALENGTH(CAST(FIDEID AS varchar(7))) = 7)
go
create PROCEDURE StatusAction (
@Action tinyint,
@StatusID INT,
@StatusName NVARCHAR(30) 
)
As
Begin
if(@Action = 1)
	delete Status where StatusID = @StatusID
else
	if(@Action = 2)
		insert Status (StatusName)
		values (@StatusName)
	else
		if(@Action = 3)
			UPDATE [dbo].[Status]
		    SET StatusName = @StatusName
			where StatusID = @StatusID
end
go
execute StatusAction 2,0,'Проходит'
execute StatusAction 2,0,'Будет в будущем'
execute StatusAction 2,0,'Закончился'
go
create PROCEDURE InjuryAction (
@Action tinyint,
@InjuryID INT,
@InjuryName NVARCHAR(30) 
)
As
Begin
if(@Action = 1)
	delete Injury where InjuryID = @InjuryID
else
	if(@Action = 2)
		insert Injury (InjuryName)
		values (@InjuryName)
	else
		if(@Action = 3)
			UPDATE [dbo].[Injury]
		    SET InjuryName = @InjuryName
			where InjuryID = @InjuryID
end
go
execute InjuryAction 2,0,'Травма головы'
execute InjuryAction 2,0,'Травма руки'
go
create PROCEDURE TopPlecesAction (
@Action tinyint,
@TopPlecesID INT,
@TopPlecesName NVARCHAR(30) 
)
As
Begin
if(@Action = 1)
	delete TopPleces where TopPlecesID = @TopPlecesID
else
	if(@Action = 2)
		insert TopPleces (TopPlecesName)
		values (@TopPlecesName)
	else
		if(@Action = 3)
			UPDATE [dbo].[TopPleces]
		    SET TopPlecesName = @TopPlecesName
			where TopPlecesID = @TopPlecesID
end
go
execute TopPlecesAction 2,0,'1 место'
execute TopPlecesAction 2,0,'2 место'
go
create PROCEDURE TrainerAction (
@Action tinyint,
@TrainerID INT,
@FirstName NVARCHAR(30),
@MiddleName NVARCHAR(30),
@LastName NVARCHAR(30),
@Birthday DATE
)
As
Begin
if(@Action = 1)
	delete Trainer where TrainerID = @TrainerID
else
	if(@Action = 2)
		insert Trainer (FirstName,MiddleName,LastName,Birthday)
		values (@FirstName,@MiddleName,@LastName,@Birthday)
	else
		if(@Action = 3)
			UPDATE [dbo].[Trainer]
		    SET FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,Birthday = @Birthday
			where TrainerID = @TrainerID
end
go
execute TrainerAction 2,0,'Гарри','Каспаров','Кимович','12.02.1987'
execute TrainerAction 2,0,'Роберт','Фишер','Джеймс','12.02.1972'
go
create PROCEDURE PlayerAction (
@Action tinyint,
@FIDEID INT,
@FirstName NVARCHAR(30),
@MiddleName NVARCHAR(30),
@LastName NVARCHAR(30),
@Birthday DATE,
@ELORating INT
)
As
Begin
if(@Action = 1)
	delete Player where FIDEID = @FIDEID
else
	if(@Action = 2)
		insert Player (FIDEID,FirstName,MiddleName,LastName,Birthday,ELORating)
		values (@FIDEID,@FirstName,@MiddleName,@LastName,@Birthday,@ELORating)
	else
		if(@Action = 3)
			UPDATE [dbo].[Player]
		    SET FIDEID = @FIDEID
			,FirstName = @FirstName
			,MiddleName = @MiddleName
			,LastName = @LastName
			,Birthday = @Birthday
			,ELORating = @ELORating
			where FIDEID = @FIDEID
end
go
execute PlayerAction 2,1111111,'Ян','Дуда','Кшишстов','12.02.1997',2750 
execute PlayerAction 2,1111112,'Хикару','Накамура',null,'12.02.1990',2760 
go
create PROCEDURE EventAction (
@Action tinyint,
@EventID INT,
@NameEvent NVARCHAR(30),
@PrizeFund INT,
@DataStart DATE,
@DataFinish DATE,
@StatusID INT
)
As
Begin
if(@Action = 1)
	delete Event where EventID = @EventID
else
	if(@Action = 2)
		insert Event (NameEvent,PrizeFund,DataStart,DataFinish,StatusID)
		values (@NameEvent,@PrizeFund,@DataStart,@DataFinish,@StatusID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Event]
		    SET NameEvent = @NameEvent
			,PrizeFund = @PrizeFund
			,DataStart = @DataStart
			,DataFinish = @DataFinish
			,StatusID = @StatusID
			where EventID = @EventID
end
go
execute EventAction 2,0,'Norway Chess',150000,'12.02.2020','20.02.2020',1
execute EventAction 2,0,'Большая швейцарка',150000,'12.02.2021','20.02.2021',1
go
create PROCEDURE TrainerPlayerAction (
@Action tinyint,
@TrainerPlayerID INT,
@TrainerID INT,
@PlayerID INT
)
As
Begin
if(@Action = 1)
	delete TrainerPlayer where TrainerPlayerID = @TrainerPlayerID
else
	if(@Action = 2)
		insert TrainerPlayer (TrainerID,PlayerID)
		values (@TrainerID,@PlayerID)
	else
		if(@Action = 3)
			UPDATE [dbo].[TrainerPlayer]
		    SET TrainerID = @TrainerID
			,PlayerID = @PlayerID
			where TrainerPlayerID = @TrainerPlayerID
end
go
execute TrainerPlayerAction 2,0,1,1111111
execute TrainerPlayerAction 2,0,1,1111112
go
create PROCEDURE InjuryPlayerAction (
@Action tinyint,
@InjuryPlayerID INT,
@InjuryID INT,
@PlayerID INT,
@DateInjury DATE
)
As
Begin
if(@Action = 1)
	delete InjuryPlayer where InjuryPlayerID = @InjuryPlayerID
else
	if(@Action = 2)
		insert InjuryPlayer (InjuryID,PlayerID,DateInjury)
		values (@InjuryID,@PlayerID,@DateInjury)
	else
		if(@Action = 3)
			UPDATE [dbo].[InjuryPlayer]
		    SET InjuryID = @InjuryID
			,PlayerID = @PlayerID
			,DateInjury = @DateInjury
			where InjuryPlayerID = @InjuryPlayerID
end
go
execute InjuryPlayerAction 2,0,1,1111111,'12.02.2021'
execute InjuryPlayerAction 2,0,2,1111111,'13.02.2021'
go
create PROCEDURE TopPlecesEventAction (
@Action tinyint,
@TopPlecesEventID INT,
@TopPlecesID INT,
@EventID INT,
@PlayerID INT
)
As
Begin
if(@Action = 1)
	delete TopPlecesEvent where TopPlecesEventID = @TopPlecesEventID
else
	if(@Action = 2)
		insert TopPlecesEvent (TopPlecesID,EventID,PlayerID)
		values (@TopPlecesID,@EventID,@PlayerID)
	else
		if(@Action = 3)
			UPDATE [dbo].[TopPlecesEvent]
		    SET TopPlecesID = @TopPlecesID
			,EventID = @EventID
			,PlayerID = @PlayerID
			where TopPlecesEventID = @TopPlecesEventID
end
go
execute TopPlecesEventAction 2,0,1,1,1111111
execute TopPlecesEventAction 2,0,2,1,1111112
go
create PROCEDURE EventPlayerAction (
@Action tinyint,
@EventPlayerID INT,
@EventID INT,
@PlayerID INT
)
As
Begin
if(@Action = 1)
	delete EventPlayer where EventPlayerID = @EventPlayerID
else
	if(@Action = 2)
		insert EventPlayer (EventID,PlayerID)
		values (@EventID,@PlayerID)
	else
		if(@Action = 3)
			UPDATE [dbo].[EventPlayer]
		    SET EventID = @EventID
			,PlayerID = @PlayerID
			where EventPlayerID = @EventPlayerID
end
go
execute EventPlayerAction 2,0,1,1111112
execute EventPlayerAction 2,0,1,1111111
go
create PROCEDURE ConsignmentAction (
@Action tinyint,
@ConsignmentID INT,
@DateStart DATE,
@DateFinish DATE,
@EventID INT
)
As
Begin
if(@Action = 1)
	delete Consignment where ConsignmentID = @ConsignmentID
else
	if(@Action = 2)
		insert Consignment (DateStart,DateFinish,EventID)
		values (@DateStart,@DateFinish,@EventID)
	else
		if(@Action = 3)
			UPDATE [dbo].[Consignment]
		    SET DateStart = @DateStart
			,DateFinish = @DateFinish
			,EventID = @EventID
			where ConsignmentID = @ConsignmentID
end
go
execute ConsignmentAction 2,0,'12.02.2021','13.02.2021',1
go
create PROCEDURE ConsignmentPlayerAction (
@Action tinyint,
@ConsignmentPlayerID INT,
@ConsignmentID INT,
@PlayerID INT,
@IsWhile BIT,
@Result FLOAT,
@Score INT
)
As
Begin
if(@Action = 1)
	delete ConsignmentPlayer where ConsignmentPlayerID = @ConsignmentPlayerID
else
	if(@Action = 2)
		insert ConsignmentPlayer (ConsignmentID,PlayerID,IsWhile,Result,Score)
		values (@ConsignmentID,@PlayerID,@IsWhile,@Result,@Score)
	else
		if(@Action = 3)
			UPDATE [dbo].[ConsignmentPlayer]
		    SET ConsignmentID = @ConsignmentID
			,PlayerID = @PlayerID
			,IsWhile = @IsWhile
			,Result = @Result
			,Score = @Score
			where ConsignmentPlayerID = @ConsignmentPlayerID
end
go
execute ConsignmentPlayerAction 2,0,1,1111111,1,1,15
execute ConsignmentPlayerAction 2,0,1,1111112,0,0,-15
go
create PROCEDURE TopPlecesEventTrainerAction (
@Action tinyint,
@TopPlecesEventTrainerID INT,
@TrainerId INT,
@TopPlecesEventID INT
)
As
Begin
if(@Action = 1)
	delete TopPlecesEventTrainer where TopPlecesEventTrainerID = @TopPlecesEventTrainerID
else
	if(@Action = 2)
		insert TopPlecesEventTrainer (TrainerId,TopPlecesEventID)
		values (@TrainerId,@TopPlecesEventID)
	else
		if(@Action = 3)
			UPDATE [dbo].[TopPlecesEventTrainer]
		    SET TrainerId = @TrainerId
			,TopPlecesEventID = @TopPlecesEventID
			where TopPlecesEventTrainerID = @TopPlecesEventTrainerID
end
go
execute TopPlecesEventTrainerAction 2,0,1,1
execute TopPlecesEventTrainerAction 2,0,1,2
go
create trigger checkInsertConsignment on Consignment
for insert, update
as
declare @DateStart date, @DateFinish date
Select 
	@DateStart=DateStart, 
	@DateFinish=DateFinish
from inserted
if (@DateFinish >= @DateStart)
Begin
	print 'Необходимо правильно указать дату!'
	ROLLBACK TRANSACTION
End
go
create trigger checkInsertEvent on Event
for insert, update
as
declare @DateStart date, @DateFinish date
Select 
	@DateStart=DataStart, 
	@DateFinish=DataFinish
from inserted
if (@DateFinish >= @DateStart)
Begin
	print 'Необходимо правильно указать дату!'
	ROLLBACK TRANSACTION
End
go
create PROCEDURE TopTrainer 
As
Begin
select t.*,CountEvent from Trainer t
left join (select 
			TrainerID, 
			Count(TopPlecesEventID) as CountEvent 
		   from TopPlecesEventTrainer group by TrainerID) tce on t.TrainerID = tce.TrainerId
end
go
create PROCEDURE EventInfo 
As
Begin
select e.*,CountPlayers,PlayerID from Event e
inner join (select 
			EventID, 
			Count(PlayerID) as CountPlayers 
		   from EventPlayer group by EventID) tce on e.EventID = tce.EventID
inner join EventPlayer ep on e.EventID = ep.EventID
inner join Player p on ep.PlayerID = p.FIDEID
end

go
create PROCEDURE Condidate 
(
@YearStart int,
@YearFinish int,
@ELORating int
)
As
Begin
select FIDEID, ELORating, CountInjury from Player e
left join (select 
			PlayerID, 
			Count(PlayerID) as CountInjury 
		   from InjuryPlayer group by PlayerID) tce on e.FIDEID = tce.PlayerID
where Year(GETDATE())-Year(Birthday) >= @YearStart and Year(GETDATE())-Year(Birthday) <= @YearFinish and ELORating >= @ELORating
end
go
execute Condidate 18,25,2750

