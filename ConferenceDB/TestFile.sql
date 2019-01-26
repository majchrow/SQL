USE CONFERENCE

-- FILE TO TEST BASICS PRODECURES/VIEWS -- CREATED EMPTY CONFERENCE DATABASE REQUIRED (JUST RUN whole ConferenceDB.sql and don't run Generator.sql)
-- UNCOMMENT SELECTS TO CHECK PROCEDURES RESULTS
-- UNCOMMENT COMMENTED EXEC TO SEE IF THE PROCEDURES FAILS DUO TO WRONG INPUT

-- ADDING Individual and Cooperate Client
EXEC AddCompany '1084839208','Goyette-Beer','Belarus','Korolëv Stan','51-671','Beilfuss','90','78','179282284','comprsheffield0@weather.com' -- Company Client
EXEC AddIndividualClient 'Sybila','Borham','China','Zhonglong','91-872','Crowley','18','55','807315243','sborham4o@sakura.ne.jp' -- IndividualClient

-- this one will fail due to wrong e-mail adress
-- EXEC AddCompany 	'3896700436','Davis LLC','Mexico','Tierra y Libertad','34-641','Eastlawn','21','2','953748183','compnogorman2@furlnet'
-- SELECT * from Client

-- ADDING STUDENTS AND NONSTUDENTS PARTICIPATS
EXEC AddParticipant	 2,'Marget','Kleynermans','Peru','Tiabaya','28-281','Anniversary','98','60','481124716','stumkleynermans1@etsy.com',7395 -- student
EXEC AddParticipant	 1,'Britteny','Reveland','Philippines','Marihatag','77-051','Hagan','33','16','049458380','stubreveland5@usda.gov',NULL -- nonstudent
EXEC AddParticipant	 2,'Lina','Yerrell','Canada','Spirit River','04-062','Texas','26','89','888076148','stulyerrell1p@webmd.com', NULL -- nonstudent

-- this one will fail due to non-unique StudentCardID
-- EXEC AddParticipant	 1,'Hamish','Dawley','Ukraine','Zvenyhorodka','21-753','School','53','6','761567826','stuhdawley9@hostgator.com',7395
-- SELECT * from Participant
-- SELECT * from Student


-- ADDING CONFERENCE
EXEC AddConference 'OurConference', 'Poland','Jastrzębia Góra','64-533','Esch','35', NULL, 0.95, 0.1

-- this one will fail due to not null values of conferencePrices
-- EXEC AddConference 'OurConference', 'Poland','Jastrzębia Góra','64-533','Esch','35', null, 0.95, null
-- this one will fail due to Check PriceRate not between 0 and 1
-- EXEC AddConference 'OurConference', 'Poland','Jastrzębia Góra','64-533','Esch','35', null, 1.95, 0.1
-- SELECT * from Conference
-- SELECT * from ConferencePrices


-- ADDING CONFERENCEDAY
EXEC AddConferenceDay 1,'3-21-2019',14,15

-- this one will fail because we assume that there can't be more than one conference per day
-- EXEC AddConferenceDay 1,'3-21-2019',150,122
-- SELECT * from ConferenceDay

-- ADDING CONFERENCEDAYRESERVATION
EXEC AddConferenceDayReservation 2, 1, 2 , 7 -- Tiger set ReservationDate for today and CancelDate 14 days after that for Reservations
EXEC AddConferenceDayReservation 1, 1, 1 , 2

-- this one will fail due to limited number of seats per conference - see the reason in ConferenceParticipant below
-- EXEC AddConferenceDayReservation 2, 1, 13 , 2
-- SELECT * from ConferenceParticipant -- First view used for procedures
-- SELECT * from ConferenceDayReservation

-- ADDING CONFERENCEDAYREGISTRATION
EXEC RegisterConferenceDay 1,1
EXEC RegisterConferenceDay 2,2

-- this one will fail due to exceeded NumberOfNonStudents for ReservationID2 - see the reason in ConferenceDayRegistrationParticipants below
-- EXEC RegisterConferenceDay 3,2
-- SELECT * from ConferenceDayRegistrationParticipants -- Second view used for procedures

-- ADDING WORKSHOPS
EXEC AddWorkshop 1, 'Workshop1', 15, 9.25, '9:15', '10:45'
EXEC AddWorkshop 1, 'Workshop2', 2, 12.25, '10:30', '11:45'
EXEC AddWorkshop 1, 'Workshop3', 2, 10.5, '12:30', '13:45'

-- this one will fail due to TimeCheck we assume EndingTime > StartingTime
-- EXEC AddWorkshop 1, 'Workshop2', 15, 12, '11:30', '10:45'
-- SELECT * from Workshop
-- SELECT * from AllWorkshops -- Third view used

-- ADDING WORKSHOPRESERVATION
EXEC AddWorkshopReservation 1, 1, 2, 4 -- Tiger set ReservationDate for today and CancelDate 14 days after that for Reservations
EXEC AddWorkshopReservation 1, 2, 0, 1
EXEC AddWorkshopReservation 1, 3, 0, 1

-- this one will fail because you can't reserve more students or not students seats if there is less placed reserved for given day
-- EXEC AddWorkshopReservation 1, 2, 3, 10
-- this one will fail because you can't reserve more place that seats left for given workshop
-- EXEC AddWorkshopReservation 2, 2, 1, 2
-- SELECT * from WorkshopReservation

EXEC RegisterWorkshop 1, 1
EXEC RegisterWorkshop 3, 1

-- this one will fail because Workshop1 and Workshop2 has overlapping times for Participant = 1 (ConferenceDayRegistration = 1)
-- EXEC RegisterWorkshop 1, 2
-- SELECT * from ParticipantsCurrentWorkshop -- Fourth view used for checking overlaping
-- SELECT * from dbo.ReservationTimes -- Fifth view used for checking overlaping



