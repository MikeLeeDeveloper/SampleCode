@echo off

rem 128 is default Windows hop limit
set dHopLimit=128

rem Use 65 when using hotspot from computer.
rem Use 64 when using computer as wifi repeater.
set hHopLimit=65

echo Modify computer's hop limit to bypass mobile hotspot restrictions.
set /p lmtNetsh=Are you using a mobile hotspot? [y/n]:

if %lmtNetsh%==y (^
echo Hop limit set to mobile hotspot: %hHopLimit%) ^
& (netsh int ipv4 set glob defaultcurhoplimit=%hHopLimit%) ^
& (netsh int ipv6 set glob defaultcurhoplimit=%hHopLimit%) ^
else (^
echo Hop limit set to Windows default: %dHopLimit%) ^
& (netsh int ipv4 set glob defaultcurhoplimit=%dHopLimit%) ^
& (netsh int ipv6 set glob defaultcurhoplimit=%dHopLimit%)

timeout /t 2