Created By: Mike Lee<br />
Created On: 2024-03-18<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;This query removes consecutive door status events between 3 rooms with 2 doors each.<br />
&nbsp;&nbsp;&nbsp;&nbsp;It then calculates the duration the door was in its previous state. If there is no<br />
&nbsp;&nbsp;&nbsp;&nbsp;subsequent event after the last event per room door pair, it will display a time<br />
&nbsp;&nbsp;&nbsp;&nbsp;duration of 0. Also, durations spanning over 1 day will display days represented in<br /> 
&nbsp;&nbsp;&nbsp;&nbsp;hours.
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;Please note, SQL is not the most efficient way to remove duplicate / consecutive<br />
&nbsp;&nbsp;&nbsp;&nbsp;records; however, it is an option with a small dataset.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Open RoomDoorDataSet.txt and copy all 1000 rows into your clipboard<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. In RemoveConsecutiveValuesCalculateTimeDifference.sql, replace sample<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; data on 13 and 14 with copied data.
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;If you would like to create your own dataset, please reference my other project,<br />
&nbsp;&nbsp;&nbsp;&nbsp;Create Random Door Status Data<br />
&nbsp;&nbsp;&nbsp;&nbsp;https://github.com/MikeLeeDeveloper/SampleCode/tree/main/Python/CreateRandomDoorStatusData