Created By: Mike Lee
Created On: 2024-03-18
Description:
	This query removes consecutive door status events between 3 rooms with 2 doors each.
	It then calculates the duration the door was in its previous state. If there is no 
	subsequent event after the last event per room door pair, it will display a time 
	duration of 0. Also, durations spanning over 1 day will display days represented in 
	hours.

	Please note, SQL is not the most efficient way to remove duplicate / consecutive 
	records; however, it is an option with a small dataset.

Instructions:
	1. Open RoomDoorDataSet.txt and copy all 1000 rows into your clipboard
	2. In RemoveConsecutiveValuesCalculateTimeDifference.sql, replace sample
	   data on 11 and 12 with copied data.