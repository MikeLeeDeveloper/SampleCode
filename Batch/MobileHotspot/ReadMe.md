Created By: Mike Lee\
Created On: 2021-02-08\
Description:\
&nbsp;&nbsp;&nbsp;&nbsp;Mobile carriers use TTL (Time To Live) to assess what is connecting through their network.\
&nbsp;&nbsp;&nbsp;&nbsp;Each time your packets travel through a node, such as a mobile hotspot or router, the number\
&nbsp;&nbsp;&nbsp;&nbsp;decrements. Modifying your TTL, also known as Hop Limit, will make your network traffic\
&nbsp;&nbsp;&nbsp;&nbsp;appear as standard mobile traffic and bypass mobile hotspot limits/throttling.\
<br /><br />
Instructions:
&nbsp;&nbsp;&nbsp;&nbsp;1. Right click MobileHotspotHopLimit.bat and run as administrator.\
&nbsp;&nbsp;&nbsp;&nbsp;2. Input y or n to change hop limit to mobile limit or windows default.\
&nbsp;&nbsp;&nbsp;&nbsp;3. Be sure to revert back when no longer on hot spot for more stable connectivity.
<br /><br />
Note:\
&nbsp;&nbsp;&nbsp;&nbsp; If you are using your computer as a wifi repeater:
&nbsp;&nbsp;&nbsp;&nbsp; 1. Open MobileHotspotHopLimit.bat in a text editor
&nbsp;&nbsp;&nbsp;&nbsp; 2. Change:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hHopLimit=65 to hHopLimit=64