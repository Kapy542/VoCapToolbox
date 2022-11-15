@echo off
SETLOCAL EnableDelayedExpansion 
Rem EnableExtensions
Rem %var% uses old value, !var! if var changes in a loop???

cd C:\ring_it\builds\MVAgent.11-07-2022_743a889.Windows.Release

Rem set directory=E:\plenoptima_ws2\WS2_Body
Rem set directory=F:\plenoptima_ws2\WS2_Body
set directory=C:\storage
Rem set directory=F:\plenoptima_ws2\WS2_Vr
Rem set directory=D:\plenoptima_dataset

Rem # Loop through takes #
for /f "tokens=1,2 delims=;" %%x in (C:\Users\Civit\Desktop\plenoptima\take_names.txt) do (
	Rem Start of take
	set take_name=%%x
	echo Take = !take_name!
	md %directory%\!take_name!\pngs\
	md %directory%\!take_name!\plys\
	
	
	Rem Produce rgbs for 2 cams (1,30) in this take (2 pngs per camera = 4 pngs)
	.\XmlGraphRunner.exe ^
		"C:\Users\Civit\Desktop\plenoptima\02_exportPNG_1_30_3fps.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\pngs" ^
		--end 8
		
	Rem Now delete second stream from both cam modules
	del %directory%\!take_name!\pngs\1\*_02.png
	del %directory%\!take_name!\pngs\30\*_02.png
	
	
	Rem Produce plys
	.\XmlGraphRunner.exe ^
		"C:\Users\Civit\Desktop\plenoptima\02_exportPLY_3fps.xml" ^
	 	--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
	 	--output "%directory%\!take_name!\plys\!take_name!" ^
	 	--end -1
)
