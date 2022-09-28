@echo off
SETLOCAL EnableDelayedExpansion 
Rem EnableExtensions
Rem %var% uses old value, !var! if var changes in a loop???

cd C:\ring_it\builds\MVAgent.11-07-2022_743a889.Windows.Release

set directory=E:\plenoptima_ws2\WS2_Body
Rem set directory=F:\plenoptima_ws2\WS2_Body
Rem set directory=C:\storage
Rem set directory=F:\plenoptima_ws2\WS2_Vr
Rem set directory=E:\WS2_Vr

Rem # Loop through takes #
for /f "tokens=1,2 delims=;" %%x in (C:\Users\Civit\Desktop\plenoptima\take_names.txt) do (
	Rem Start of take
	set take_name=%%x
	echo Take = !take_name!
	md %directory%\!take_name!\pngs20s\	
	
	Rem Produce rgbs for cam 16 in this take (2 pngs per camera)
	Rem 25 fps x 20s = 500 frames
	.\XmlGraphRunner.exe ^
		"C:\Users\Civit\Desktop\plenoptima\05_exportPNG_16_3fps.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\pngs20s" ^
		--end 500
		
	Rem Now delete second stream
	del %directory%\!take_name!\pngs20s\16\*_01.png
)
