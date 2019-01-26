-- RUN WHOLE FILE TO CREATE EMPTY DATABASE CONFERENCE (WILL DROP OLD ONE IF EXISTS)

USE master;
GO

-- CREATING DATABASE CONFERENCE
IF EXISTS(SELECT * FROM sys.databases WHERE name = 'CONFERENCE')
  DROP DATABASE CONFERENCE;
  GO
CREATE DATABASE CONFERENCE;
GO

USE CONFERENCE;
GO

-- CREATING TABLE Client
  IF object_id('dbo.Client','U') IS NOT NULL
    DROP TABLE dbo.Client;
  CREATE TABLE dbo.Client(
  ClientID INT PRIMARY KEY IDENTITY(1,1),
  ClientType  NCHAR(1) NOT NULL
  );
GO

  -- CREATING TABLE CompanyDetails
  IF object_id('dbo.CompanyDetails','U') IS NOT NULL
    DROP TABLE dbo.CompanyDetails;
  CREATE TABLE dbo.CompanyDetails(
  ClientID INT PRIMARY KEY,
  NIP NVARCHAR(20) NOT NULL,
  CompanyName NVARCHAR(20) NOT NULL,
  Country NVARCHAR(20) NOT NULL,
  City NVARCHAR(20) NOT NULL,
  ZipCode NCHAR(6) NOT NULL,
  StreetName NVARCHAR(20) NOT NULL,
  StreetNumber NVARCHAR(6) NOT NULL,
  HouseNumber NVARCHAR(6) NULL,
  Phone NVARCHAR(10) NOT NULL,
  Email NVARCHAR(50) NOT NULL
  );
GO

  -- CREATING TABLE ClientDetails
  IF object_id('dbo.ClientDetails','U') IS NOT NULL
    DROP TABLE dbo.ClientDetails;
  CREATE TABLE dbo.ClientDetails(
  ClientID INT PRIMARY KEY,
  FirstName NVARCHAR(20) NOT NULL,
  LastName NVARCHAR(30) NOT NULL,
  Country NVARCHAR(20) NOT NULL,
  City NVARCHAR(20) NOT NULL,
  ZipCode NCHAR(6) NOT NULL,
  StreetName NVARCHAR(20) NOT NULL,
  StreetNumber NVARCHAR(6) NOT NULL,
  HouseNumber NVARCHAR(6) NULL,
  Phone NVARCHAR(10) NOT NULL,
  Email NVARCHAR(50) NOT NULL
  );
GO

  -- CREATING TABLE Participant
  IF object_id('dbo.Participant','U') IS NOT NULL
    DROP TABLE dbo.Participant;
  CREATE TABLE dbo.Participant(
  ParticipantID INT PRIMARY KEY IDENTITY(1,1),
  ClientID INT NOT NULL,
  FirstName NVARCHAR(20) NOT NULL,
  LastName NVARCHAR(30) NOT NULL,
  Country NVARCHAR(20) NOT NULL,
  City NVARCHAR(20) NOT NULL,
  ZipCode NCHAR(6) NOT NULL,
  StreetName NVARCHAR(20) NOT NULL,
  StreetNumber NVARCHAR(6) NOT NULL,
  HouseNumber NVARCHAR(6) NULL,
  Phone NVARCHAR(10) NOT NULL,
  Email NVARCHAR(50) NOT NULL
  );
GO

  -- CREATING TABLE Student
  IF object_id('dbo.Student','U') IS NOT NULL
    DROP TABLE dbo.Student;
  CREATE TABLE dbo.Student(
  ParticipantID INT PRIMARY KEY,
  StudentCardNumber INT NOT NULL
  );
GO

  -- CREATING TABLE Conference
  IF object_id('dbo.Conference','U') IS NOT NULL
    DROP TABLE dbo.Conference;
  CREATE TABLE dbo.Conference(
  ConferenceID INT PRIMARY KEY IDENTITY(1,1),
  ConferenceName NVARCHAR(50) NOT NULL,
  Country NVARCHAR(20) NOT NULL,
  City NVARCHAR(20) NOT NULL,
  ZipCode NCHAR(6) NOT NULL,
  StreetName NVARCHAR(20) NOT NULL,
  StreetNumber NVARCHAR(6) NOT NULL,
  HouseNumber NVARCHAR(6) NULL
  );
GO

  -- CREATING TABLE ConferencePrices
  IF object_id('dbo.ConferencePrices','U') IS NOT NULL
    DROP TABLE dbo.ConferencePrices;
  CREATE TABLE dbo.ConferencePrices(
  ConferenceID INT PRIMARY KEY,
  PriceRate NUMERIC(3,2) NOT NULL DEFAULT 1,
  StudentDiscount NUMERIC(3,2) NOT NULL DEFAULT 0
  );
GO

  -- CREATING TABLE ConferenceDay
  IF object_id('dbo.ConferenceDay','U') IS NOT NULL
    DROP TABLE dbo.ConferenceDay;
  CREATE TABLE dbo.ConferenceDay(
  ConferenceDayID INT PRIMARY KEY IDENTITY(1,1),
  ConferenceID INT NOT NULL,
  ConferenceDay DATE NOT NULL,
  NumberOfSeats INT NOT NULL,
  BasePrice MONEY NOT NULL DEFAULT 0
  );
GO

  -- CREATING TABLE Workshop
  IF object_id('dbo.Workshop','U') IS NOT NULL
    DROP TABLE dbo.Workshop;
  CREATE TABLE dbo.Workshop(
  WorkshopID INT PRIMARY KEY IDENTITY(1,1),
  ConferenceDayID INT NOT NULL,
  Topic NVARCHAR(50) NOT NULL,
  NumberOfSeats INT NOT NULL,
  Price MONEY NOT NULL DEFAULT 0,
  StartingTime TIME NOT NULL,
  EndingTime TIME NOT NULL
  );
GO

  -- CREATING TABLE ConferenceDayReservation
  IF object_id('dbo.ConferenceDayReservation','U') IS NOT NULL
    DROP TABLE dbo.ConferenceDayReservation;
  CREATE TABLE dbo.ConferenceDayReservation(
  ConferenceDayReservationID INT PRIMARY KEY IDENTITY(1,1),
  ClientID INT NOT NULL,
  ConferenceDayID INT NOT NULL,
  ReservationDate DATE NOT NULL,
  CancelDate DATE NULL,
  NumberOfNonStudents INT NOT NULL,
  NumberOfStudents INT NOT NULL
  );
GO

  -- CREATING TABLE ConferenceDayRegistration
  IF object_id('dbo.ConferenceDayRegistration','U') IS NOT NULL
    DROP TABLE dbo.ConferenceDayRegistration;
  CREATE TABLE dbo.ConferenceDayRegistration(
  ConferenceDayRegistrationID INT PRIMARY KEY IDENTITY(1,1),
  ConferenceDayReservationID INT NOT NULL,
  ParticipantID INT NOT NULL
  );
GO

  -- CREATING TABLE Payment
  IF object_id('dbo.Payment','U') IS NOT NULL
    DROP TABLE dbo.Payment;
  CREATE TABLE dbo.Payment(
  ConferenceDayReservationID INT PRIMARY KEY,
  PriceToPay MONEY NOT NULL,
  PricePaid MONEY NOT NULL DEFAULT 0,
  PaymentMethod NVARCHAR(20) NULL
  );
GO

  -- CREATING TABLE WorkshopReservation
  IF object_id('dbo.WorkshopReservation','U') IS NOT NULL
    DROP TABLE dbo.WorkshopReservation;
  CREATE TABLE dbo.WorkshopReservation(
  WorkshopReservationID INT PRIMARY KEY IDENTITY(1,1),
  WorkshopID INT NOT NULL,
  ConferenceDayReservationID INT NOT NULL,
  ReservationDate DATE NOT NULL,
  CancelDate DATE NULL,
  PriceToPay MONEY NOT NULL,
  PricePaid MONEY NOT NULL DEFAULT 0,
  NumberOfNonStudents INT NOT NULL,
  NumberOfStudents INT NOT NULL,
  );
GO

  -- CREATING TABLE WorkshopRegistration
  IF object_id('dbo.WorkshopRegistration','U') IS NOT NULL
    DROP TABLE dbo.WorkshopRegistration;
  CREATE TABLE dbo.WorkshopRegistration(
  WorkshopRegistrationID INT PRIMARY KEY IDENTITY(1,1),
  WorkshopReservationID INT NOT NULL,
  ConferenceDayRegistrationID INT NOT NULL
  );
GO

-- INTEGRITY CONDITIONS

-- Client Table
ALTER TABLE dbo.Client
  ADD
    CONSTRAINT ClientTypeIorC
      CHECK (ClientType IN ('C','I')) -- individual or corporate Client
GO

-- CompanyDetails Table
ALTER TABLE dbo.CompanyDetails
  ADD
    CONSTRAINT CompanyDetailsFK -- Foreign key to CompanyDetails
      FOREIGN KEY(ClientID)
      REFERENCES Client(ClientID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT UniqueNIP
      UNIQUE(NIP),
     CONSTRAINT UniqueCompanyEmail
      UNIQUE(Email),
     CONSTRAINT CompanyEmailLike
      CHECK(Email like '%@%.%')
GO

-- ClientDetails Table
ALTER TABLE dbo.ClientDetails
  ADD
    CONSTRAINT ClientDetailsFK -- Foreign key to ClientDetails
      FOREIGN KEY(ClientID)
      REFERENCES Client(ClientID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT UniqueClientEmail
      UNIQUE(Email),
    CONSTRAINT ClientEmailLike
      CHECK(Email like '%@%.%')
GO

-- Participant Table
ALTER TABLE dbo.Participant
  ADD
    CONSTRAINT ParticipantFK -- Foreign key to Participant
      FOREIGN KEY(ClientID)
      REFERENCES Client(ClientID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT UniqueParticipantEmail
      UNIQUE(Email),
    CONSTRAINT ParticipantEmailLike
      CHECK(Email like '%@%.%')
GO

-- Student Table
ALTER TABLE dbo.Student
  ADD
    CONSTRAINT StudentFK-- Foreign key to Student
      FOREIGN KEY(ParticipantID)
      REFERENCES Participant(ParticipantID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT UniqueStudentCard
      UNIQUE(StudentCardNumber)
GO

-- ConferencePrices Table
ALTER TABLE dbo.ConferencePrices
  ADD
    CONSTRAINT ConferencePricesFK -- Foreign key to ConferencePrices
      FOREIGN KEY(ConferenceID)
      REFERENCES Conference(ConferenceID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT PriceValueCheck
      CHECK (PriceRate BETWEEN 0 AND 1),
    CONSTRAINT StudentDiscountCheck
      CHECK (StudentDiscount BETWEEN 0 AND 1)
GO

-- ConferenceDay Table
ALTER TABLE dbo.ConferenceDay
  ADD
    CONSTRAINT ConferenceDayFK -- Foreign key to ConferenceDay
      FOREIGN KEY(ConferenceID)
      REFERENCES Conference(ConferenceID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT UniqueConferenceDay
      UNIQUE(ConferenceDay),
    CONSTRAINT NumberOfSeatsDay
      CHECK (NumberOfSeats > 0),
    CONSTRAINT ConferenceDayPrice
      CHECK (BasePrice >= 0),
    CONSTRAINT ConferenceDayDate
      CHECK (GETDATE() <= ConferenceDay AND DATEDIFF(DAY,GETDATE(),ConferenceDay) <= 730)
GO

-- Workshop Table
ALTER TABLE dbo.Workshop
  ADD
    CONSTRAINT WorkshopFK -- Foreign key to Workshop
      FOREIGN KEY(ConferenceDayID)
      REFERENCES ConferenceDay(ConferenceDayID)
      ON DELETE CASCADE
      ON UPDATE CASCADE ,
    CONSTRAINT CorrectTimeCheck
      CHECK (StartingTime < EndingTime), -- Zakladamy brak warsztatow trwajacych po polnocy
    CONSTRAINT NumberOfSeatsWorkshop
      CHECK (NumberOfSeats > 0),
    CONSTRAINT MoneyWorkshopCheck
        CHECK (Price >= 0)
GO

-- ConferenceDayReservation Table
ALTER TABLE dbo.ConferenceDayReservation
  ADD
    CONSTRAINT ConferenceDayReservationFK1 -- First Foreign key to ConferenceDayReservation
      FOREIGN KEY(ClientID)
      REFERENCES Client(ClientID),
    CONSTRAINT ConferenceDayReservationFK2 -- Second Foreign key to ConferenceDayReservation
      FOREIGN KEY(ConferenceDayID)
      REFERENCES ConferenceDay(ConferenceDayID),
    CONSTRAINT NumberOfParticipantDay
      CHECK (NumberOfNonStudents >= 0 AND NumberOfStudents >= 0 AND (NumberOfNonStudents + NumberOfStudents) > 0),
    CONSTRAINT CancelDateCheck
      CHECK(CancelDate IS NULL OR CancelDate > ReservationDate)
GO

-- Payment Table
ALTER TABLE dbo.Payment
  ADD
    CONSTRAINT PaymentFK -- Foreign key to Payment
      FOREIGN KEY(ConferenceDayReservationID)
      REFERENCES ConferenceDayReservation(ConferenceDayReservationID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT PaymentMoneyCheck
      CHECK (PricePaid >= 0 AND PriceToPay >= 0 AND PricePaid <= PriceToPay)
GO

-- WorkshopReservation Table
ALTER TABLE dbo.WorkshopReservation
  ADD
    CONSTRAINT WorkshopReservationFK1 -- First Foreign key to WorkshopReservation
      FOREIGN KEY(WorkshopID)
      REFERENCES Workshop(WorkshopID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT WorkshopReservationFK2 -- Second Foreign key to WorkshopReservation
      FOREIGN KEY(ConferenceDayReservationID)
      REFERENCES ConferenceDayReservation(ConferenceDayReservationID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT MoneyWorkshopReservationCheck
      CHECK (PricePaid >= 0 AND PriceToPay >= 0 AND PricePaid <= PriceToPay),
    CONSTRAINT NumberOfParticipantWorkshop
      CHECK (NumberOfNonStudents >= 0 AND NumberOfStudents >= 0 AND (NumberOfNonStudents + NumberOfStudents) > 0)
GO

-- ConferenceDayRegistration Table
ALTER TABLE dbo.ConferenceDayRegistration
  ADD
    CONSTRAINT ConferenceDayRegistrationFK1 -- First Foreign key to ConferenceDayRegistration
      FOREIGN KEY(ConferenceDayReservationID)
      REFERENCES ConferenceDayReservation(ConferenceDayReservationID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT ConferenceDayRegistrationFK2 -- Second Foreign key to ConferenceDayRegistration
      FOREIGN KEY(ParticipantID)
      REFERENCES Participant(ParticipantID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT OneParticipantPerDay
      UNIQUE(ParticipantID,ConferenceDayReservationID)
GO

-- WorkshopRegistration Table
ALTER TABLE dbo.WorkshopRegistration
  ADD
    CONSTRAINT WorkshopRegistrationFK1 -- First Foreign key to WorkshopRegistration
      FOREIGN KEY(WorkshopReservationID)
      REFERENCES WorkshopReservation(WorkshopReservationID)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    CONSTRAINT WorkshopRegistrationFK2 -- Second Foreign key to WorkshopRegistration
      FOREIGN KEY(ConferenceDayRegistrationID)
      REFERENCES ConferenceDayRegistration(ConferenceDayRegistrationID),
    CONSTRAINT OneParticipantPerWorkshop
      UNIQUE(ConferenceDayRegistrationID,WorkshopReservationID)
GO

-- VIEWS (ONLY THAT ARE NEEDED FOR PROCEDURES TO WORK)

-- WIDOK -> KonferencjaID -> Nazwa Konferencji -> Cena bazowa ->  Aktualna Cena -> Zniżka studencka
CREATE VIEW ConferenceWithPrices AS
 (SELECT C.ConferenceID,
         C.ConferenceName,
         CD.ConferenceDayID,
         CD.ConferenceDay AS 'FirstDay',
         CD.BasePrice * POWER(CP.PriceRate,DATEDIFF(WEEK,GETDATE(),MIN(CD.ConferenceDay))) AS 'CurrentPrice',
         CD.BasePrice,
         CP.StudentDiscount
 FROM Conference C
 JOIN ConferenceDay CD ON C.ConferenceID = CD.ConferenceID
 JOIN ConferencePrices CP ON C.ConferenceID = CP.ConferenceID
 GROUP BY C.ConferenceID, C.ConferenceName, CD.ConferenceDayID, CD.ConferenceDay, CD.BasePrice, CP.PriceRate, CP.StudentDiscount
 HAVING CD.ConferenceDay >= GETDATE()
)
GO

CREATE VIEW ConferenceDayRegistrationParticipants AS
  (
    SELECT CDRes.ConferenceDayReservationID,
           CDRes.NumberOfStudents                                         AS 'MaxStudentNumber',
           CDRes.NumberOfNonStudents                                      AS 'MaxNonStudentNumber',
           (SELECT COUNT(P.ParticipantID) FROM Participant P
           WHERE P.ParticipantID IN (SELECT ParticipantID FROM ConferenceDayRegistration)
             AND P.ParticipantID IN (SELECT ParticipantID FROM Student))  AS 'CurrentStudentsNumber',
           ((SELECT COUNT(P.ParticipantID) FROM Participant P
           WHERE P.ParticipantID IN (SELECT ParticipantID FROM ConferenceDayRegistration))
              -
            (SELECT COUNT(P.ParticipantID) FROM Participant P
           WHERE P.ParticipantID IN (SELECT ParticipantID FROM ConferenceDayRegistration)
             AND P.ParticipantID IN (SELECT ParticipantID FROM Student))) AS 'CurrentNonStudentsNumber'
    FROM ConferenceDayRegistration CDReg
    RIGHT JOIN ConferenceDayReservation CDRes
      ON CDRes.ConferenceDayReservationID = CDReg.ConferenceDayReservationID
    GROUP BY CDRes.ConferenceDayReservationID ,CDReg.ConferenceDayReservationID
           ,CDRes.NumberOfStudents ,CDRes.NumberOfNonStudents
  )
GO


-- WIDOK -> Workshop -> Nazwa warsztatu -> Max liczba miejsc -> Aktualna liczba miejsc(aktualnie zarezerwowanych lub oplaconych) -> Cena bazowa -> Cena dla studenta
CREATE VIEW WorkshopParticipants AS
  (SELECT WorkshopID,
          Topic,
          NumberOfSeats, -- Max number of seats
          ISNULL((SELECT SUM(NumberOfStudents + NumberOfNonStudents)
          FROM WorkshopReservation WR
          WHERE WR.WorkshopID = W.WorkshopID AND (CancelDate IS NULL OR CancelDate > ReservationDate)),0) AS 'CurrentNumberOfSeats', -- Current reserved number of seats
          Price,
          Price * (1-(SELECT StudentDiscount from ConferencePrices WHERE ConferenceID =
                                                                          (SELECT ConferenceID from ConferenceDay WHERE ConferenceDayID =
                                                                           (SELECT ConferenceDayID FROM Workshop W2 WHERE W2.WorkshopID = W.WorkshopID)))) AS 'StudentPrice'
  from Workshop W)
GO

-- WIDOK -> NazwaKonferencji -> Dzien Konferencji -> Max liczba miejsc -> Liczba aktualnie zajetych miejsc
CREATE VIEW ConferenceParticipant AS
  (SELECT (SELECT ConferenceName FROM Conference WHERE ConferenceID = CD.ConferenceID) AS 'ConferenceName',
          ConferenceDayID,
          ConferenceDay,
          NumberOfSeats, -- Max number of seats
          ISNULL((SELECT SUM(NumberOfStudents + NumberOfNonStudents)
          FROM ConferenceDayReservation CDR
          WHERE CDR.ConferenceDayID = CD.ConferenceDayID AND (CancelDate IS NULL OR CancelDate > ReservationDate)),0) AS 'CurrentNumberOfSeats' -- Current reserved number of seats
  FROM ConferenceDay CD)
GO

-- WIDOK -> Participant -> IDDnia -> Dzien konferencji -> Zapisane warsztaty
CREATE VIEW ParticipantsCurrentWorkshop AS
  (SELECT P.ParticipantID,
       CD.ConferenceDayID,
       CD.ConferenceDay,
       W.WorkshopID,
       W.Topic,
       StartingTime,
       EndingTime
FROM Participant P
LEFT JOIN ConferenceDayRegistration CDR ON CDR.ParticipantID = P.ParticipantID
LEFT JOIN WorkshopRegistration WRG ON WRG.ConferenceDayRegistrationID = CDR.ConferenceDayRegistrationID
LEFT JOIN WorkshopReservation WRS ON WRS.WorkshopReservationID = WRG.WorkshopReservationID
LEFT JOIN Workshop W ON W.WorkshopID = WRS.WorkshopID
LEFT JOIN ConferenceDay CD ON W.ConferenceDayID = CD.ConferenceDayID)
GO

-- WIDOK -> Wszystkie warsztaty
CREATE VIEW AllWorkshops AS
  (SELECT C.ConferenceID, C.ConferenceName, CD.ConferenceDayID, CD.ConferenceDay, WorkshopID, Topic, StartingTime, EndingTime
FROM Conference C
JOIN ConferenceDay CD on C.ConferenceID = CD.ConferenceID
JOIN Workshop W on W.ConferenceDayID = CD.ConferenceDayID)
GO

CREATE VIEW ReservationTimes AS
  (SELECT WorkshopReservationID, W.WorkshopID, StartingTime, EndingTime
  FROM WorkshopReservation WR
    JOIN Workshop W ON W.WorkshopID=WR.WorkshopID
    )
GO

-- TRIGGERS (NOT MUCH NEEDED BECAUSE ALL THE "BEFORE INSERT CONDITIONS ARE CHECKED IN THE PROCEDURES)

CREATE TRIGGER ConferenceDayReservationTrigger
ON ConferenceDayReservation
AFTER INSERT
AS
UPDATE ConferenceDayReservation
SET ConferenceDayReservation.CancelDate = DATEADD(DAY,14,ConferenceDayReservation.ReservationDate)
FROM inserted AS i
WHERE ConferenceDayReservation.ConferenceDayReservationID = i.ConferenceDayReservationID;
GO

CREATE TRIGGER WorkshopReservationTrigger
ON WorkshopReservation
AFTER INSERT
AS
UPDATE WorkshopReservation
SET WorkshopReservation.CancelDate = DATEADD(DAY,14,WorkshopReservation.ReservationDate)
FROM inserted AS i
WHERE WorkshopReservation.WorkshopReservationID = i.WorkshopReservationID;
GO

-- PROCEDURES

CREATE PROCEDURE dbo.AddClient( -- Adding Client to Client Table by given ClientType, returns ClientID
        @ClientType NCHAR(1),
        @ClientID INT OUTPUT
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          INSERT INTO Client (ClientType)
          VALUES (@ClientType)
          SET @ClientID = @@IDENTITY;
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddIndividualClient( -- Adding Individual Client to ClientDetails and Client Table
        @FirstName NVARCHAR(20),
        @LastName NVARCHAR(30),
        @Country NVARCHAR(20),
        @City NVARCHAR(20),
        @ZipCode NCHAR(6),
        @StreetName NVARCHAR(20),
        @StreetNumber NVARCHAR(6),
        @HouseNumber NVARCHAR(6),
        @Phone NVARCHAR(10),
        @Email NVARCHAR(50)
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        DECLARE @ClientID INT;
        BEGIN
          EXEC AddClient 'I', @ClientID = @ClientID OUTPUT
          INSERT INTO ClientDetails (ClientID, FirstName, LastName, Country, City, ZipCode, StreetName, StreetNumber, HouseNumber, Phone, Email)
          VALUES (@ClientID, @FirstName, @LastName, @Country, @City, @ZipCode, @StreetName, @StreetNumber, @HouseNumber, @Phone, @Email)
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddCompany( -- Adding Corporate Client to CompanyDetails and Client Table
        @NIP NVARCHAR(20),
        @CompanyName NVARCHAR(20),
        @Country NVARCHAR(20),
        @City NVARCHAR(20),
        @ZipCode NCHAR(6),
        @StreetName NVARCHAR(20),
        @StreetNumber NVARCHAR(6),
        @HouseNumber NVARCHAR(6),
        @Phone NVARCHAR(10),
        @Email NVARCHAR(50)
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        DECLARE @ClientID INT;
        BEGIN
          EXEC AddClient 'C', @ClientID = @ClientID OUTPUT
          INSERT INTO CompanyDetails (ClientID, NIP, CompanyName, Country, City, ZipCode, StreetName, StreetNumber, HouseNumber, Phone, Email)
          VALUES (@ClientID, @NIP, @CompanyName, @Country, @City, @ZipCode, @StreetName, @StreetNumber, @HouseNumber, @Phone, @Email)
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddStudent( -- Adding Student to Student Table
        @ParticipantID INT,
        @StudentCardID INT
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN
        INSERT INTO Student
        VALUES (@ParticipantID, @StudentCardID)
      END
    END TRY
    BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddParticipant( -- Adding Participant to Participant Table, if StudentCard is not null adding student also
        @ClientID INT,
        @FirstName NVARCHAR(20),
        @LastName NVARCHAR(30),
        @Country NVARCHAR(20),
        @City NVARCHAR(20),
        @ZipCode NCHAR(6),
        @StreetName NVARCHAR(20),
        @StreetNumber NVARCHAR(6),
        @HouseNumber NVARCHAR(6),
        @Phone NVARCHAR(10),
        @Email NVARCHAR(50),
        @StudentCardID INT
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          INSERT INTO Participant (ClientID, FirstName, LastName, Country, City, ZipCode, StreetName, StreetNumber, HouseNumber, Phone, Email)
          VALUES (@ClientID, @FirstName, @LastName, @Country, @City, @ZipCode, @StreetName, @StreetNumber, @HouseNumber, @Phone, @Email)
          IF(@StudentCardID IS NOT NULL)
            BEGIN
              EXEC AddStudent @@IDENTITY, @StudentCardID
            END
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddConferencePrice( -- Adding ConferencePrice to ConferencePrices table
        @ConferenceID INT,
        @PriceRate NUMERIC(3,2),
        @StudentDiscount NUMERIC(3,2)
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN
        INSERT INTO ConferencePrices
        VALUES (@ConferenceID, @PriceRate, @StudentDiscount)
      END
    END TRY
    BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddConference( -- Adding Conference to Conference Table and ConferencePrice to ConferencePrices
        @ConferenceName NVARCHAR(50),
        @Country NVARCHAR(20),
        @City NVARCHAR(20),
        @ZipCode NCHAR(6),
        @StreetName NVARCHAR(20),
        @StreetNumber NVARCHAR(6),
        @HouseNumber NVARCHAR(6),
        @PriceRate NUMERIC(3,2),
        @StudentDiscount NUMERIC(3,2)
        )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          INSERT INTO Conference (ConferenceName, Country, City, ZipCode, StreetName, StreetNumber, HouseNumber)
          VALUES (@ConferenceName, @Country, @City, @ZipCode, @StreetName, @StreetNumber, @HouseNumber)
          BEGIN
            EXEC AddConferencePrice @@IDENTITY, @PriceRate, @StudentDiscount
          END
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddConferenceDay( -- Adding ConferenceDay to ConferenceDay
        @ConferenceID INT,
        @ConferenceDay DATE,
        @NumberOfSeats INT,
        @BasePrice MONEY
  )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          INSERT INTO ConferenceDay (ConferenceID, ConferenceDay, NumberOfSeats, BasePrice)
          VALUES (@ConferenceID, @ConferenceDay, @NumberOfSeats, @BasePrice)
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddWorkshop( -- Adding Workshop to Workshop table
        @ConferenceDayID INT,
        @Topic NVARCHAR(50),
        @NumberOfSeats INT,
        @Price MONEY,
        @StartingTime TIME,
        @EndingTime TIME
  )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          INSERT INTO Workshop (ConferenceDayID, Topic, NumberOfSeats, Price, StartingTime, EndingTime)
          VALUES (@ConferenceDayID, @Topic, @NumberOfSeats, @Price, @StartingTime, @EndingTime)
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.GetReservationPrice( -- Geting reservation price
        @ConferenceDayID INT,
        @NumberOfParticipants INT,
        @NumberOfStudents INT,
        @PriceToPay MONEY OUTPUT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    SET @PriceToPay = (SELECT @NumberOfParticipants*CurrentPrice + @NumberOfStudents*CurrentPrice*(1-StudentDiscount)
                       FROM ConferenceWithPrices WHERE @ConferenceDayID = ConferenceDayID)
    print @PriceToPay
  END
GO

CREATE PROCEDURE dbo.AddConferenceDayReservation( -- Adding Reservation of given day
        @ClientID INT,
        @ConferenceDayID INT,
        @NumberOfNonStudents INT,
        @NumberOfStudents INT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    DECLARE @ErrorMessage NVARCHAR(4000);
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          DECLARE @PriceToPay MONEY
          IF(@NumberOfStudents + @NumberOfNonStudents <= (SELECT NumberOfSeats - CurrentNumberOfSeats from ConferenceParticipant WHERE @ConferenceDayID = ConferenceDayID))
            BEGIN
              EXEC GetReservationPrice @ConferenceDayID, @NumberOfNonStudents, @NumberOfStudents, @PriceToPay = @PriceToPay OUTPUT;
              INSERT INTO ConferenceDayReservation (ClientID, ConferenceDayID, ReservationDate, NumberOfNonStudents, NumberOfStudents)
              VALUES (@ClientID, @ConferenceDayID, GETDATE(), @NumberOfNonStudents, @NumberOfStudents)
              INSERT INTO Payment (ConferenceDayReservationID, PriceToPay)
              VALUES  (@@IDENTITY, @PriceToPay)
            END
          ELSE
            BEGIN
              SET @ErrorMessage = 'Number of seats exceeded'
              RAISERROR (@ErrorMessage,16,1)
            END
          END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.RegisterConferenceDay( -- Participant reserve given day
        @ParticipantID INT,
        @ConferenceDayReservationID INT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    DECLARE @ErrorMessage NVARCHAR(4000);
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          IF (EXISTS (SELECT * FROM Student WHERE @ParticipantID = ParticipantID) AND
             (SELECT MaxStudentNumber from ConferenceDayRegistrationParticipants CDRP WHERE @ConferenceDayReservationID = CDRP.ConferenceDayReservationID)
               > (SELECT CurrentStudentsNumber from ConferenceDayRegistrationParticipants CDRP WHERE @ConferenceDayReservationID = CDRP.ConferenceDayReservationID))
                OR
             (EXISTS (SELECT * FROM Participant WHERE @ParticipantID = ParticipantID) AND
             (SELECT MaxNonStudentNumber from ConferenceDayRegistrationParticipants CDRP WHERE @ConferenceDayReservationID = CDRP.ConferenceDayReservationID)
               > (SELECT CurrentNonStudentsNumber from ConferenceDayRegistrationParticipants CDRP WHERE @ConferenceDayReservationID = CDRP.ConferenceDayReservationID))
            BEGIN
              INSERT INTO ConferenceDayRegistration (ConferenceDayReservationID, ParticipantID)
              VALUES (@ConferenceDayReservationID,@ParticipantID)
            END
          ELSE
            BEGIN
              SET @ErrorMessage = 'No more place for given day avaliable';
              RAISERROR (@ErrorMessage,16,1)
            END
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.AddWorkshopReservation( -- Adding Reservation of given workshop
        @ConferenceDayReservationID INT,
        @WorkshopID INT,
        @NumberOfNonStudents INT,
        @NumberOfStudents INT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    DECLARE @ErrorMessage NVARCHAR(4000);
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          IF (@NumberOfStudents + @NumberOfNonStudents <=
            (SELECT NumberOfStudents + NumberOfNonStudents from ConferenceDayReservation where ConferenceDayReservationID = @ConferenceDayReservationID )) -- No more participants for workshop reservation than for day reservation
            BEGIN
            IF (@NumberOfNonStudents + @NumberOfStudents < (SELECT NumberOfSeats - CurrentNumberOfSeats FROM WorkshopParticipants WHERE WorkshopID = @WorkshopID)) -- Enough seats for reservation
              BEGIN
                DECLARE @PriceToPay MONEY = (SELECT @NumberOfStudents*StudentPrice + @NumberOfNonStudents*Price FROM WorkshopParticipants WHERE WorkshopID = @WorkshopID)
                INSERT INTO WorkshopReservation (WorkshopID, ConferenceDayReservationID, ReservationDate, PriceToPay, NumberOfNonStudents, NumberOfStudents)
                VALUES (@WorkshopID, @ConferenceDayReservationID, GETDATE(), @PriceToPay, @NumberOfNonStudents, @NumberOfStudents)
              END
            ELSE
             BEGIN
               SET @ErrorMessage = 'Number of available seats for given workshop exceeded';
               RAISERROR (@ErrorMessage,16,1)
             END
            END
           ELSE
            BEGIN
             SET @ErrorMessage = 'Tring to reserve more seats for Workshop than for Conference it is not allowed';
             RAISERROR (@ErrorMessage,16,1)
            END
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO


CREATE PROCEDURE dbo.RegisterWorkshop( -- Participant Register Given workshop if he registerd conference and there is no workshop that overlap this one
        @WorkshopReservationID INT,
        @ConferenceDayRegistrationID INT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    DECLARE @ErrorMessage NVARCHAR(4000);
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
            IF ((SELECT COUNT(WorkshopReservationID) FROM WorkshopRegistration
             JOIN AllWorkshops AW ON(
             (SELECT ConferenceDayReservationID FROM WorkshopReservation WHERE @WorkshopReservationID =  WorkshopReservationID AND WorkshopReservation.WorkshopReservationID
                IN (SELECT WorkshopReservationID FROM WorkshopRegistration WHERE @WorkshopReservationID = WorkshopReservationID )) = ConferenceDayID
              AND (SELECT StartingTime from ReservationTimes WHERE WorkshopReservationID = @WorkshopReservationID) BETWEEN AW.StartingTime AND AW.EndingTime
              AND (SELECT EndingTime from ReservationTimes WHERE WorkshopReservationID = @WorkshopReservationID) BETWEEN AW.StartingTime AND AW.EndingTime
             )) = 0 ) -- Times not oveplapping
          BEGIN
            INSERT INTO WorkshopRegistration (WorkshopReservationID, ConferenceDayRegistrationID)
            VALUES (@WorkshopReservationID,@ConferenceDayRegistrationID)
          END
          ELSE
            BEGIN
              SET @ErrorMessage = 'Participant has registered workshop that overlap current one';
              RAISERROR (@ErrorMessage,16,1)
            END
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.CancelDayReservation( -- CancelingDayReservation
    @ConferenceDayReservationID INT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          UPDATE ConferenceDayReservation
          SET CancelDate = GETDATE()
          WHERE ConferenceDayReservationID = @ConferenceDayReservationID
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.CancelWorkshopReservation( -- Canceling WorkshopReservation
    @WorkshopReservationID INT
  )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          UPDATE WorkshopReservation
          SET CancelDate = GETDATE()
          WHERE WorkshopReservationID = @WorkshopReservationID
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

CREATE PROCEDURE dbo.PickPaymentMethod( -- Canceling WorkshopReservation
    @ConferenceDayReservationID INT,
    @PaymentMethod NVARCHAR(20)
  )
AS
  BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
      BEGIN TRANSACTION
        BEGIN
          UPDATE Payment
          SET PaymentMethod = @PaymentMethod
          WHERE ConferenceDayReservationID = @ConferenceDayReservationID
        END
      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
      ROLLBACK TRANSACTION
      DECLARE @ErrorMessage NVARCHAR(4000);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR (@ErrorMessage,16,1)
    END CATCH
  END
GO

-- index
CREATE INDEX start_time ON Workshop(StartingTime)
GO
CREATE INDEX end_time ON Workshop(EndingTime)
GO

-- REST VIEWS (not needed for procedures)

--WIDOK DANYCH KLIENTÓW INDYWIDULANYCH
create view ShowIndividualCustomersInfo as
select ClientID, FirstName , LastName, Phone, Email from ClientDetails
go

--WIDOK DANYCH KLIENTÓW FIRMOWYCH
create view ShowCopanyCustomersInfo as
select ClientID, CompanyName, NIP from CompanyDetails
go

--WIDOK WSZYSTKICH KLIENTÓW
create view ShowAllCustomersInfo as
select a.ClientID, 'Company' as 'Customer Type', CompanyName as 'Customer Name', Email   from CompanyDetails a
union
select b.ClientID, 'Individual'as 'Customer Type', b.FirstName+' '+b.LastName as 'Customer Name', Email  from ClientDetails b
go

--WIDOK W JAkKICH DNIACH KONFERENCJI ILE OSÓB BRAŁO UDZIAŁ Z DANEJ FIRMY
create view ShowDetailedCustomersConferenceAttendance as
select a.ClientID, (select b.ConferenceID from ConferenceDay b where a.ConferenceDayID=b.ConferenceDayID) as ConferenceID, a.NumberOfNonStudents+a.NumberOfStudents as NumberOfParticipants from ConferenceDayReservation a
go

--WIDOK ILE OSÓB OD DANEGO KLIENTA BRAŁO UDZIAŁ  DANYCH KONFERENCJACH
create view ShowCustomersConferenceAttendance as
select a.ClientID, a.ConferenceID, sum(a.NumberOfParticipants) as NumberOfParticipants from ShowDetailedCustomersConferenceAttendance a
group by a.ConferenceID, a.ClientID
go

--WIDOK ULE ŁĄCZIE OSÓB OD DANEGO KLIENTA ŁĄCZNIE BRAŁO UDZIAŁ WE WSZYSTKICH KONFERENCJACH
create view ShowCustomersTotalAttendance as
select a.ClientID, sum(a.NumberOfParticipants) as NumberOfParticipants from ShowDetailedCustomersConferenceAttendance a
group by a.ClientID
go

-- WIDOK POKZUJĄCY INFORMACJE O WSZYSTKICH KONFERENCJACH + ILE TRWAJĄ DNI
create view ShowAllConferenceInfo as
select * ,(select count(*) from ConferenceDay b where a.ConferenceID=b.ConferenceID) as NumberOfDays  from Conference a
go

-- WIDOK POKAZUJĄZY ILE DANY KLIENT WPŁACIŁ ZA WSZYSTKIE KONFERENCJE  + ILE MA DO ZAPŁATY
create view ShowCustomersPayments as
select a.ClientID, sum(b.PricePaid) as MonneyPaid, sum(b.PriceToPay) as MoneyToPay from ConferenceDayReservation a
join Payment b on a.ConferenceDayReservationID = b.ConferenceDayReservationID
group by a.ClientID
go

-- WIDOK POKAZUJĄCY KLIENTÓW KTÓRZY JESZCZE NIE ZAPŁACILI ZA DNI kONFERENCJi + JAKA TO JEST KONFERENCJA
create view ShowCustomersWhoHaveToPay as
select a.ClientID, (select c.ConferenceID from ConferenceDay c where c.ConferenceDayID = a.ConferenceDayID) as Conference  from ConferenceDayReservation a
join Payment b on a.ConferenceDayReservationID = b.ConferenceDayReservationID
where b.PriceToPay >0
go

-- WIDOK POKAZUJĄCY KLIENTÓW  KÓRZY NIE ZAPŁACILI ZA DNI KOPNFERENCJI + ILE DNI TO TEGO DNIA ZOSTAŁO
create view ShowTimeToPayForConferenceDay as
select a.ClientID, datediff(dd,getdate(),(select d.ConferenceDay from ConferenceDay d where d.ConferenceDayID = a.ConferenceDayID )) as TimeToPAy from  ConferenceDayReservation a
join Payment b on a.ConferenceDayReservationID=b.ConferenceDayReservationID
where b.PriceToPay>0
go

-- WIDOK POKAZUJĄCY DNI KONDERENCJI I LISTĘ PARTICIPANTÓW NA TE DNI
create view ShowConferenceDayAndParticipants as
select a.ConferenceDayID, b.ParticipantID from ConferenceDayReservation a
join ConferenceDayRegistration b on a.ConferenceDayReservationID=b.ConferenceDayReservationID
go

--WIDOK POKAZUJĄCY ILE UCZESTNIKÓW JEST NA DZIEŃ KONFERENCJI
create view ShowNumberOfParticipantsPerConferenceDay as
select a.ConferenceDayID, NumberOfNonStudents+NumberOfStudents as NumberOfParticipants from ConferenceDayReservation a
go

--WIDOK POKAZUJĄCY ILE PRZEZ CAŁĄ KONFERENCJĘ BRAŁO W NIEJ OSÓB
create view ShowNumberOfParticipantsPerConference as
select a.ConferenceID, sum(c.NumberOfNonStudents+c.NumberOfStudents) as TotalNumberOfParticipants from Conference a
join ConferenceDay b on a.ConferenceID = b.ConferenceID
join ConferenceDayReservation c on b.ConferenceDayID = c.ConferenceDayID
group by a.ConferenceID
go

--WIDOK POKAZUJĄCY LISTĘ OSÓB NA DANY WARSZTAT
create view ShowWorkShopParticipants as
select a.WorkshopID, p.ParticipantID from Workshop a
join WorkshopReservation b on a.WorkshopID = b.WorkshopID
join WorkshopRegistration c on b.WorkshopReservationID=c.WorkshopReservationID
join ConferenceDayRegistration d on d.ConferenceDayReservationID = c.ConferenceDayRegistrationID
join Participant p on p.ParticipantID = d.ParticipantID
go

--WIDOK DZIEŃ -> ID DNIA -> IDPARTICIPANTA -> IMIE ->  NAZWISKO -> NAZWA KONFERENCJI
create view ShowDetailedConferenceParticipantsInfo as
select  b.ConferenceDay, b.ConferenceDayID, d.ParticipantID, e.FirstName, e.LastName, a.ConferenceName
from Conference a
join ConferenceDay b on a.ConferenceID=b.ConferenceID
join ConferenceDayReservation c on b.ConferenceDayID=c.ConferenceDayID
join ConferenceDayRegistration d on c.ConferenceDayReservationID=d.ConferenceDayReservationID
join Participant e on d.ParticipantID = e.ParticipantID
go

--WIDOK KLIENT -> REZERWACJA -> KWOTA DO ZAPŁATY
create view ShowUnpaidReservations as
select a.ClientID, b.ConferenceDayReservationID, c.PriceToPay from Client a
join ConferenceDayReservation b on a.ClientID=b.ClientID
join Payment c on b.ConferenceDayReservationID=c.ConferenceDayReservationID
where c.PriceToPay>0
go