from datetime import datetime, timezone, timedelta
import random

# Object
class RoomDoorStatus:
    def __init__(self, roomNum, doorNum, status, dts):
        self.roomName = "Room " + str(roomNum)
        self.doorName = "Door " + str(doorNum)
        self.doorStatus = status
        self.createdDTS = dts

# Variables
randomNum = random.SystemRandom()               # Initialize random number
currentDateTime = datetime.now(timezone.utc)    # Get current DateTime in UTC
doorStatus = ["Open","Closed"]                  # Door Values
counter = 0                                     # Counter for looping 
maxRecords = 1000                               # SQL allows max insert statement of 1000 row values
room = [1,2,3]                                  # Rooms to track
door = [1,2]                                    # Doors to track
roomDoorStatusList = []                         # List of objects to return

# Insert random variables into roomDoorStatusList
while counter < maxRecords:
    roomChoice = randomNum.choice(room)
    doorChoice = randomNum.choice(door)
    statusChoice = randomNum.choice(doorStatus)
    currentDateTime = (currentDateTime 
                       + timedelta(minutes=random.randint(1,10))
                       + timedelta(seconds=random.randint(1,59))
                       )

    roomDoorStatusList.append(RoomDoorStatus(
        roomChoice,
        doorChoice,
        statusChoice,
        currentDateTime.strftime('%Y-%m-%d %H:%M:%S')
        ))
    
    # Increment Counter
    counter += 1

# Reset Counter    
counter = 0

# Write roomDoorStatusList to file
with open('RoomDoorDataSet.txt','w') as file:
    for roomDoorStatus in roomDoorStatusList:
        file.write(
            "('" + 
            roomDoorStatus.roomName + "','" +
            roomDoorStatus.doorName + "','" +
            roomDoorStatus.doorStatus + "','" +
            str(roomDoorStatus.createdDTS) + 
            "')"
        )

        # Provision next record if not last record
        if counter < maxRecords - 1:
            file.write(",\n")
        
        # Increment Counter
        counter += 1

# Test Code
"""
# Print roomDoorStatusList values (Use small maxRecords number)
for roomDoorStatus in roomDoorStatusList:
    print(
        roomDoorStatus.roomName + '\n' +
        roomDoorStatus.doorName + '\n' +
        roomDoorStatus.doorStatus + '\n' +
        str(roomDoorStatus.createdDTS)
    )
"""