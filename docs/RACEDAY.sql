CREATE DATABASE RACEDAYDB;
GO
USE RACEDAYDB;
GO

CREATE TABLE [USER]
(
USERID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR (60) NOT NULL UNIQUE,
PasswordHash VARCHAR (250) NOT NULL,
Role VARCHAR(20) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT CK_USER_Role
CHECK (Role IN('Organiser', 'Participant'))

);
GO

CREATE TABLE EVENT
(
EVENTID INT IDENTITY (1,1) PRIMARY KEY,
OrganiserID INT NOT NULL,
EventName VARCHAR (100) NOT NULL,
Description VARCHAR(300) NOT NULL,
Location VARCHAR(100) NOT NULL,
Province VARCHAR (50) NOT NULL,
RaceDate DATE NOT NULL,
RegistrationDeadline DATE NOT NULL,

CONSTRAINT FK_EVENT_USER
FOREIGN KEY (OrganiserID)
REFERENCES [USER] (USERID)

);
GO

CREATE TABLE ROUTE 
(
RouteID INT IDENTITY(1,1) PRIMARY KEY,
EventID INT NOT NULL,
RouteName VARCHAR(100) NOT NULL,
Distance DECIMAL(8,2) NOT NULL,
MapURL VARCHAR(500),
ElevationGain DECIMAL(8,2),

CONSTRAINT FK_ROUTE_EVENT
FOREIGN KEY (EventID)
REFERENCES EVENT(EventID),

CONSTRAINT UQ_ROUTE_EVENT
UNIQUE (EventID)

);
GO

CREATE TABLE CATEGORIES(

CategoryID INT IDENTITY(1,1) PRIMARY KEY,
EventID INT NOT NULL,
CategoryName VARCHAR(100) NOT NULL,
Distance DECIMAL(8,2) NOT NULL,
EntryFee DECIMAL (10,2) NOT NULL,
MaximumParticipants INT NOT NULL,

CONSTRAINT FK_CATEGORIES_EVENT
FOREIGN KEY (EventID)
REFERENCES EVENT(EventID),

CONSTRAINT CK_CATEGORIES_EntryFee
CHECK (EntryFee>=0),

CONSTRAINT CL_CATEGORIES_MaxParticipants
CHECK (MaximumParticipants>0)
);
GO

CREATE TABLE ENROLMENTS
(
EnrolmentID INT IDENTITY(1,1)PRIMARY KEY,
ParticipantID INT NOT NULL,
CategoryID INT NOT NULL,
RegistrationDaate DATETIME NOT NULL DEFAULT GETDATE(),
Status VARCHAR(20) NOT NULL DEFAULT 'Active',

CONSTRAINT FK_ENROLMENTS_USER
FOREIGN KEY (ParticipantID)
REFERENCES[USER](UserID),


CONSTRAINT FK_ENROLMENTS_CATEGORY
FOREIGN KEY (CategoryID)
REFERENCES[CATEGORIES](CategoryID),

CONSTRAINT CK_ENROLMENTS_Status
CHECK (Status IN ('Active','Cancelled','Completed')),

CONSTRAINT UQ_ENROLMENTS_PARTICIPANT_CATEGORY
UNIQUE (ParticipantID, CategoryID)
);


CREATE TABLE RESULTS(

ResultID INT IDENTITY(1,1) PRIMARY KEY,
EnrolmentID INT NOT NULL,
FinishTime TIME NOT NULL,
Position INT NOT NULL,
AveragePace DECIMAL(6,2) NOT NULL,

CONSTRAINT FK_RESULTS_ENROLMENT
FOREIGN KEY (EnrolmentID)
REFERENCES ENROLMENTS(EnrolmentID),

CONSTRAINT UQ_RESULTS_ENROLMENT
UNIQUE (EnrolmentID),

CONSTRAINT CK_RESULTS_Position
CHECK(Position> 0),

CONSTRAINT CK_RESULTS_AveragePace
CHECK (AveragePace > 0)
);
GO

INSERT INTO [USER]
(FirstName, LastName, Email, PasswordHash,Role, PhoneNumber)
VALUES
('Thabang', 'Mokoena', 'thabo.mokoena@raceday.co.za',
'HASHED_PASSWORD_001', 'Organiser', '0712345678'),

('Moganedi','Tema', 'moganedi.tema@raceday.co.za',
'HASHED_PASSWORD_001','Organiser','0723456789'),

('Kabelo', 'Dlamini', 'kabelo.dlamini@email.com',
'HASHED_PASSWORD_003','Participant','0734567890'),


('Joyce', 'Hlungwani','joyce.hlugwani@email.com',
'HASHED_PASSWORD_004','Participant','0665569952');


INSERT INTO EVENT
(OrganiserID, EventName, Description,Location,Province,
RaceDate, RegistrationDeadline)
VALUES

(1, ' Polokwane City Run',
'A community road running event for athletes of different abilitird.',
'Polokwane','Limpopo',
'2026-10-18','2026-10-10'),

(2, ' Soweto Community Marathon',
'A road running event celebrating the spirit and community of Soweto',
'Soweto','Gauteng',
'2026-11-08','2026-10-31'),

(1,'Cape Town Coastal Cycle',
'A scenic cycling event along the Cape Town coastline.',
'Cape Town','Wesntern Cape',
'2026-12-06','2026-11-28');
GO

INSERT INTO ROUTE
(EventID,RouteName,Distance,MapURL,ElevationGain)
VALUES

(1,'Polokwane 10K Route',
10.00,
'https://example.com/routes/polokwane-10k',
85.00),

(2,'Soweto Marathon',
42.20,
'https://example.com/routes/soweto-marathon',
420.00),

(3, 'Cape Town Coastal Cycle Route',
60.00,
'https://example.com/routes/cape-town-cycle',
650.00);
GO

INSERT INTO CATEGORIES
(EventID,CategoryName,Distance,EntryFee,MaximumParticipants)
VALUES
(1,'10 KM Run',10.00,150.00,500),
(1, '5 KM Fun Run',5.00,80.00 ,300),

(2,'42.2 KM Marathon',42.20,350.00,1000),
(2,'10 KM Run',10.00,150.00,700),

(3,'60 KM Cycle',60.00,300.00,800),
(3,'30K KM Cycle',30.00,200.00,500);



INSERT INTO ENROLMENTS
(ParticipantID,CategoryID,RegistrationDaate,Status)
VALUES
(3,1,'2026-09-01','Active'),
(3,3,'2026-09-02','Active'),
(4,2,'2026-09-01','Active'),
(4,5,'2026-09-03','Active');
GO

INSERT INTO RESULTS
(EnrolmentID,FinishTime,Position,AveragePace)
VALUES
(1,'00:52:34',18,5.25),
(3,'00:31:45',12,6.25);
GO

\
