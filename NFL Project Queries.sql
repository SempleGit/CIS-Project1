--Players and Position
Select 
	First_Name
	,Last_Name
	,Position_Name
	,Position_Unit
From dbo.Player As P Join
dbo.Position As Po
On P.Position_ID = Po.Position_ID;

--Players injured in 2018
Select First_Name
	,Last_Name
	,Year(Event_Date) As Year
From dbo.Injury_Event As IE Join
dbo.Player As P 
On P.Player_ID = IE.Player_ID
Where Event_Date Between '20180101' And '20181231';

--Players injured in 2018 and injury type
Select First_Name
	,Last_Name
	,Injury_Type
From dbo.Injury_Event As IE Join
dbo.Player As P 
On P.Player_ID = IE.Player_ID Join
dbo.Injury As I
ON IE.Injury_ID = I.Injury_ID
Where Event_Date Between '20180101' And '20181231';

--Players injured in 2018 and trainers
Select P.First_Name + ' ' + P.Last_Name As 'Player'
	,Injury_Type
	,T.First_Name + ' ' + T.Last_Name As Trainer
From dbo.Injury_Event As IE Join
dbo.Player As P 
On P.Player_ID = IE.Player_ID Join
dbo.Injury As I
ON IE.Injury_ID = I.Injury_ID Join
dbo.Rehab_Protocol As RP
On RP.Rehab_ID = I.Rehab_ID Join
dbo.Trainer As T
On T.Rehab_ID = I.Rehab_ID
Where Event_Date Between '20180101' And '20181231';

--Same query, but all trainers on 1 row

---------------------------
--Remove for presentation--
---------------------------

Select Distinct P.First_Name + ' ' + P.Last_Name As 'Player'
	,Injury_Type


		,(Select T1.First_Name + ' ' + T1.Last_Name As Trainer
			From dbo.Trainer As T1
			Where T1.Rehab_ID = I.Rehab_ID
			Order By T1.Trainer_ID
			Offset 0 Rows Fetch Next 1 Rows Only) As Trainer1
		,(Select T1.First_Name + ' ' + T1.Last_Name As Trainer
			From dbo.Trainer As T1
			Where T1.Rehab_ID = I.Rehab_ID
			Order By T1.Trainer_ID
			Offset 1 Rows Fetch Next 1 Rows Only) As Trainer2
		,(Select T1.First_Name + ' ' + T1.Last_Name As Trainer
			From dbo.Trainer As T1
			Where T1.Rehab_ID = I.Rehab_ID
			Order By T1.Trainer_ID
			Offset 2 Rows Fetch Next 1 Rows Only) As Trainer3
		,(Select T1.First_Name + ' ' + T1.Last_Name As Trainer
			From dbo.Trainer As T1
			Where T1.Rehab_ID = I.Rehab_ID
			Order By T1.Trainer_ID
			Offset 3 Rows Fetch Next 1 Rows Only) As Trainer4

From dbo.Injury_Event As IE Join
dbo.Player As P 
On P.Player_ID = IE.Player_ID Join
dbo.Injury As I
ON IE.Injury_ID = I.Injury_ID Join
dbo.Rehab_Protocol As RP
On RP.Rehab_ID = I.Rehab_ID Join
dbo.Trainer As T
On T.Rehab_ID = I.Rehab_ID
Where Event_Date Between '20180101' And '20181231'
Order By Player;

--Wide Receivers injured in 2019 and expected rehab time
Select First_Name
	,Last_Name
	,Position_Name
	,Injury_Type
	,Event_Date
	,TimeFrame As 'Rehab Weeks'
From dbo.Player As P Join
dbo.Position As PS
On PS.Position_ID = P.Position_ID Join
dbo.Injury_Event As IE
On IE.Player_ID = P.Player_ID Join
dbo.Injury As I
On IE.Injury_ID = I.Injury_ID Join
dbo.Rehab_Protocol As RP
On Rp.Rehab_ID = I.Rehab_ID
Where 
	Position_Name = 'Wide Receiver' 
	And Event_Date Between '20190101' And '20191231';

--Wide Receivers injured in 2019, expected rehab time, performance ratings, dates during rehab.
Select 
	First_Name
	,Last_Name
	,Position_Name
	,Injury_Type
	,Event_Date
	,TimeFrame As 'Rehab Weeks'
	,Energy_Rating
	,Fatigue_Rating
	,Stress_Rating
	,Mood_Rating
	,Soreness_Rating
	,(Energy_Rating+Fatigue_Rating+Stress_Rating+Mood_Rating+Soreness_Rating) As 'Overall Rating'
	,Prf.Performance_Date As 'Rating Date'
From dbo.Player As P Join
dbo.Position As PS
On PS.Position_ID = P.Position_ID Join
dbo.Injury_Event As IE
On IE.Player_ID = P.Player_ID Join
dbo.Injury As I
On IE.Injury_ID = I.Injury_ID Join
dbo.Rehab_Protocol As RP
On Rp.Rehab_ID = I.Rehab_ID Join
dbo.Performance As Prf
On Prf.Player_ID = P.Player_ID
Where
	Position_Name = 'Wide Receiver' 
	And Event_Date Between '20190101' And '20191231'
	And Prf.Performance_Date Between IE.Event_Date And DateAdd(Day,TimeFrame*7,IE.Event_Date)
Order By P.Player_ID;


--Performance, sleep, for players that had an injury
Select Distinct P.Player_ID
	,First_Name
	,Last_Name
	,(Energy_Rating+Fatigue_Rating+Stress_Rating+Mood_Rating+Soreness_Rating) As 'Overall Rating'
	,Performance_Date
	,Hours_Slept
	,Sleep_Rating
	,Sleep_Date
From dbo.Player As P Join
dbo.Performance As Prf 
On P.Player_ID = Prf.Player_ID Join
dbo.Sleep_Session As SS 
On P.Player_ID = SS.Player_ID Join
dbo.Injury_Event As IE
On P.Player_ID = IE.Player_ID
Where Performance_Date = Sleep_Date
Order By Last_Name, Performance_Date Asc;

--Players injured in 2018, but not 2019
Select First_Name
	,Last_Name
From dbo.Player As P Join
dbo.Injury_Event As IE
On P.Player_ID = IE.Player_ID
Where IE.Event_Date Between '20180101' And '20181231'

Except

Select First_Name
	,Last_Name
From dbo.Player As P Join
dbo.Injury_Event As IE
On P.Player_ID = IE.Player_ID
Where IE.Event_Date Between '20190101' And '20191231'

--Players injured in both 2018 and 2019
Select First_Name
	,Last_Name
From dbo.Player As P Join
dbo.Injury_Event As IE
On P.Player_ID = IE.Player_ID
Where IE.Event_Date Between '20180101' And '20181231'

Intersect

Select First_Name
	,Last_Name
From dbo.Player As P Join
dbo.Injury_Event As IE
On P.Player_ID = IE.Player_ID
Where IE.Event_Date Between '20190101' And '20191231'

--Update tables to cascade delete.
Alter Table dbo.Sleep_Session
	Add Foreign Key (Player_ID) references dbo.Player
	On Delete Cascade;

Alter Table dbo.Performance
	Add Foreign Key (Player_ID) references dbo.Player
	On Delete Cascade;

Alter Table dbo.Injury_Event
	Add Foreign Key (Player_ID) references dbo.Player
	On Delete Cascade;

--Remove Al Woods, ID 43 from roster
Delete 
From dbo.Player
Where Player_ID = 43;
