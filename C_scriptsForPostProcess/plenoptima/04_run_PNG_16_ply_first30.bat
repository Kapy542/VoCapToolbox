@echo off
SETLOCAL EnableDelayedExpansion 
Rem EnableExtensions
Rem %var% uses old value, !var! if var changes in a loop???

cd C:\ring_it\builds\MVAgent.11-07-2022_743a889.Windows.Release

Rem set directory=E:\plenoptima_ws2\WS2_Body
Rem set directory=F:\plenoptima_ws2\WS2_Body
Rem set directory=C:\storage
set directory=F:\plenoptima_ws2\WS2_Vr

Rem # Loop through takes #
for /f "tokens=1,2 delims=;" %%x in (C:\Users\Civit\Desktop\plenoptima\take_names.txt) do (
	Rem Start of take
	set take_name=%%x
	echo Take = !take_name!
	md %directory%\!take_name!\pngs30\
	md %directory%\!take_name!\plys30\
	
	
	Rem Produce rgbs for cam 16 in this take (2 pngs per camera)
	.\XmlGraphRunner.exe ^
		"C:\Users\Civit\Desktop\plenoptima\04_exportPNG_16_first30.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\pngs30" ^
		--end 30
		
	Rem Now delete second stream
	del %directory%\!take_name!\pngs30\16\*_01.png
	
	
	Rem Produce plys
	.\XmlGraphRunner.exe ^
		"C:\Users\Civit\Desktop\plenoptima\04_exportPLY_first30.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\plys30\!take_name!" ^
		--end 30
)
