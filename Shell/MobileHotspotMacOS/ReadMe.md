Created By: Mike Lee<br />
Created On: 2024-05-03<br />
Description:<br />
&nbsp;&nbsp;&nbsp;&nbsp;Mobile carriers use TTL (Time To Live) to assess what is connecting through their network.<br />
&nbsp;&nbsp;&nbsp;&nbsp;Each time your packets travel through a node, such as a mobile hotspot or router, the number<br />
&nbsp;&nbsp;&nbsp;&nbsp;decrements. Modifying your TTL, also known as Hop Limit, will make your network traffic<br />
&nbsp;&nbsp;&nbsp;&nbsp;appear as standard mobile traffic and bypass mobile hotspot limits/throttling.
<br /><br />
Instructions:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. In terminal, place shell script in your directory of choice.<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To download directly to your current directory, use command:<br />
```
wget https://github.com/MikeLeeDeveloper/SampleCode/blob/main/Shell/MobileHotspotMacOS/MobileHotspotMacOS.sh
```
&nbsp;&nbsp;&nbsp;&nbsp;2. Execute shell script using command:<br />
```
sh MobileHotspotMacOS.sh
```
&nbsp;&nbsp;&nbsp;&nbsp;3. Be sure to revert back when no longer on hot spot for more stable connectivity.
<br /><br />
Note:<br />
&nbsp;&nbsp;&nbsp;&nbsp;If you are using your computer as a wifi repeater:<br />
&nbsp;&nbsp;&nbsp;&nbsp;1. Open MobileHotspotMacOS.sh in a text editor<br />
&nbsp;&nbsp;&nbsp;&nbsp;2. Change:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hHopLimit=65 to hHopLimit=64