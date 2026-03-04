--   CREATE DATABASE ----

CREATE DATABASE EventDb;
USE EventDb;



CREATE TABLE UserInfo (
    EmailId VARCHAR(100) PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    Password VARCHAR(20) NOT NULL,

    CONSTRAINT CHKUserNameLength CHECK (LEN(UserName) BETWEEN 1 AND 50),
    CONSTRAINT CHKRole CHECK (Role IN ('Admin', 'Participant')),
    CONSTRAINT CHKPassword_Length CHECK (LEN(Password) BETWEEN 6 AND 20)
);


CREATE TABLE EventDetails (
    EventId INT PRIMARY KEY,
    EventName VARCHAR(50) NOT NULL,
    EventCategory VARCHAR(50) NOT NULL,
    EventDate DATETIME NOT NULL,
    Description VARCHAR(255) NULL,
    Status VARCHAR(10) NOT NULL,

    CONSTRAINT CHKEventNameLength CHECK (LEN(EventName) BETWEEN 1 AND 50),
    CONSTRAINT CHKEventCategoryLength CHECK (LEN(EventCategory) BETWEEN 1 AND 50),
    CONSTRAINT CHKStatus CHECK (Status IN ('Active', 'In-Active'))
);


CREATE TABLE SpeakersDetails (
    SpeakerId INT PRIMARY KEY,
    SpeakerName VARCHAR(50) NOT NULL,

    CONSTRAINT CHKSpeakerName_Length 
        CHECK (LEN(SpeakerName) BETWEEN 1 AND 50)
);



CREATE TABLE SessionInfo (
    SessionId INT PRIMARY KEY,
    EventId INT NOT NULL,
    SessionTitle VARCHAR(50) NOT NULL,
    SpeakerId INT NOT NULL,
    Description VARCHAR(255) NULL,
    SessionStart DATETIME NOT NULL,
    SessionEnd DATETIME NOT NULL,
    SessionUrl VARCHAR(255) NULL,

FOREIGN KEY (EventId) REFERENCES EventDetails(EventId),
FOREIGN KEY (SpeakerId)REFERENCES SpeakersDetails(SpeakerId),
CONSTRAINT CHKSessionTitleLength CHECK (LEN(SessionTitle) BETWEEN 1 AND 50),
CONSTRAINT CHKTimeSlot CHECK (SessionEnd > SessionStart)
);



CREATE TABLE ParticipantEventDetails (
    Id INT PRIMARY KEY,
    ParticipantEmailId VARCHAR(100) NOT NULL,
    EventId INT NOT NULL,
    SessionId INT NOT NULL,
    IsAttended BIT NOT NULL,

FOREIGN KEY (ParticipantEmailId) REFERENCES UserInfo(EmailId),
FOREIGN KEY (EventId) REFERENCES EventDetails(EventId),
FOREIGN KEY (SessionId) REFERENCES SessionInfo(SessionId)
);
