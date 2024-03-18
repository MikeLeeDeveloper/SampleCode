Created By: Mike Lee
Created On: 2021-02-08
Description: 
	Mobile carriers use TTL (Time To Live) to assess what is connecting through their network.
	Each time your packets travel through a node, such as a mobile hotspot or router, the number 
	decrements. Modifying your TTL, also known as Hop Limit, will make your network traffic 
	appear as standard mobile traffic and bypass mobile hotspot limits/throttling.

Instructions:
	1. Right click MobileHotspotHopLimit.bat and run as administrator.
	2. Input y or n to change hop limit to mobile limit or windows default.
	3. Be sure to revert back when no longer on hot spot for more stable connectivity.

Note:
	If you are using your computer as a wifi repeater:
		1. Open MobileHotspotHopLimit.bat in a text editor
		2. Change:
			hHopLimit=65 to hHopLimit=64