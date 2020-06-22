--Create the database for NFL project
Drop Database if exists NFLProject
Create Database NFLProject;
Go

Use NFLProject;
Go

--Create Position table
Drop Table if exists Position
Create Table Position
(
	Position_ID int Not Null
		Constraint PK_Position Primary Key (Position_ID)
	,Position_Name varchar(45) Not Null
	,Position_Unit varchar(45) Not Null
);
Go

--Create Player table
Drop Table if exists Player

Create Table Player
(
	Player_ID int Not Null
		Constraint PK_Player Primary Key (Player_ID)
	,First_Name varchar(45) Not Null
	,Last_Name varchar(45) Not Null
	,Jersey_Num int Not Null
	,Position_ID int Not Null
		Foreign Key (Position_ID) References Position
);
Go

--Create Sleep table
Drop Table if exists Sleep_Session

Create Table Sleep_Session
(
	Sleep_ID int Not Null
		Constraint PK_Sleep Primary Key (Sleep_ID)
	,Sleep_Date Date Not Null
	,Hours_Slept int Not Null
	,Sleep_Rating varchar(45) Not Null
	,Player_ID int Not Null
		Foreign Key (Player_ID) References Player
);
Go

--Create Performance table
Drop Table if exists Performance

Create Table Performance
(
	Performance_ID int Not Null
		Constraint PK_Performance Primary Key (Performance_ID)
	,Performance_Date Date Not Null
	,Energy_Rating int Not Null
	,Fatigue_Rating int Not Null
	,Stress_Rating int Not Null
	,Mood_Rating int Not Null
	,Soreness_Rating int Not Null
	,Player_ID int Not Null
		Foreign Key (Player_ID) References Player
);
Go

--Create Rehab_Protocol table
Drop Table if exists Rehab_Protocol

Create Table Rehab_Protocol
(
	Rehab_ID int Not Null
		Constraint PK_Rehab Primary Key (Rehab_ID)
	,TimeFrame int Not Null
	,Rehab_Type varchar(45) Not Null
);
Go

--Create Injury table
Drop Table if exists Injury

Create Table Injury
(
	Injury_ID int Not Null
		Constraint PK_Injury Primary Key (Injury_ID)
	,Injury_Type varchar(45) Not Null
	,Rehab_ID int Not Null
		Foreign Key (Rehab_ID) References Rehab_Protocol
);
Go

--Create Injury_Event table
Drop Table if exists Injury_Event

Create Table Injury_Event
(
	Injury_Event_ID int Not Null
		Constraint PK_Injury_Event Primary Key (Injury_Event_ID)
	,Event_Date Date Not Null
	,Player_ID int Not Null
		Foreign Key (Player_ID) References Player
	,Injury_ID int Not Null
		Foreign Key (Injury_ID) References Injury
);
Go

--Create Trainer table
Drop Table if exists Trainer

Create Table Trainer
(
	Trainer_ID int Not Null
		Constraint PK_Trainer Primary Key (Trainer_ID)
	,First_Name varchar(45) Not Null
	,Last_Name varchar(45) Not Null
	,Specialty varchar(45) Not Null
	,Rehab_ID int Not Null
		Foreign Key (Rehab_ID) References Rehab_Protocol
);
Go