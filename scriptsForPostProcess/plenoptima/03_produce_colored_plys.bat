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
	
	Rem Loop through 32 different streams
	for /l %%y in (1, 1, 32) do (
	   echo %%y
	   
		Rem Process one stream
		Rem .\XmlGraphRunner.exe C:\Users\Civit\Desktop\exportPNG.xml --input F:\plenoptima_ws2\WS2_Body\%%x_joined.mvx --output F:\plenoptima_ws2\WS2_Body\%%x_png --end -1
		Rem .\XmlGraphRunner.exe ^
		Rem 	"C:\ring_it\Graphs\xml6\readtoPLY.xml" ^
		Rem 	--input "%directory%\split_stream_3fps\!take_name!_stream_%%y.mvx" ^
		Rem 	--export "%directory%\split_stream_3fps\plys\!take_name!_stream_%%y"
			
		.\XmlGraphRunner.exe ^
			"C:\Users\Civit\Desktop\plenoptima\04_exportPLY_first30.xml" ^
			--input "%directory%\split_stream_3fps\!take_name!\!take_name!_stream_%%y.mvx" ^
			--output "%directory%\split_stream_3fps\plys\!take_name!\!take_name!_stream_%%y"
	)
)