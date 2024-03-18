Created By: Mike Lee<br />
Created On: 2024-03-18<br />
Description:<br />
	This query removes consecutive door status events between 3 rooms with 2 doors each.<br />
	It then calculates the duration the door was in its previous state. If there is no<br />
	subsequent event after the last event per room door pair, it will display a time<br />
	duration of 0. Also, durations spanning over 1 day will display days represented in<br /> 
	hours.
<br /><br />
	Please note, SQL is not the most efficient way to remove duplicate / consecutive<br />
	records; however, it is an option with a small dataset.
<br /><br />
Instructions:<br />
	1. Open RoomDoorDataSet.txt and copy all 1000 rows into your clipboard<br />
	2. In RemoveConsecutiveValuesCalculateTimeDifference.sql, replace sample<br />
	   data on 13 and 14 with copied data.