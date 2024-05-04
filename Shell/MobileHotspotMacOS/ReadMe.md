Created By: Mike Lee<br />
Created On: 2024-05-03<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Mobile carriers use TTL (Time To Live) to assess what is connecting through their network.<br />
&nbsp;&nbsp;&nbsp;&nbsp;Each time your packets travel through a node, such as a mobile hotspot or router, the number<br />
&nbsp;&nbsp;&nbsp;&nbsp;decrements. Modifying your TTL, also known as Hop Limit, will make your network traffic<br />
&nbsp;&nbsp;&nbsp;&nbsp;appear as standard mobile traffic and bypass mobile hotspot limits/throttling.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Right click MobileHotspotHopLimit.bat and run as administrator.<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. Input y or n to change hop limit to mobile limit or windows default.<br />
&nbsp;&nbsp;&nbsp;&nbsp;3. Be sure to revert back when no longer on hot spot for more stable connectivity.
<br /><br />
Note:<br />
&nbsp;&nbsp;&nbsp;&nbsp;If you are using your computer as a wifi repeater:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Open MobileHotspotHopLimit.bat in a text editor<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. Change:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hHopLimit=65 to hHopLimit=64