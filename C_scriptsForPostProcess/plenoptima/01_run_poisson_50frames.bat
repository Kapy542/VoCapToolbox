@echo off
SETLOCAL EnableDelayedExpansion 
Rem EnableExtensions
Rem %var% uses old value, !var! if var changes in a loop???

cd C:\ring_it\builds\MVAgent.11-07-2022_743a889.Windows.Release

Rem set directory=F:\plenoptima_ws2\WS2_Body
set directory=C:\storage
Rem set directory=F:\plenoptima_ws2\WS2_Vr

Rem # Loop through takes #
for /f "tokens=1,2 delims=;" %%x in (C:\Users\Civit\Desktop\plenoptima\take_names.txt) do (
	Rem Start of take
	set take_name=%%x
	set/a  maxval=%%y-100
	set /a minval=100
	Rem Process from start to end in takes with few frames
	if %%y LSS 700 (
		set maxval=%%y
		set minval=1
	)
	echo Take = !take_name! !maxval! !minval!
	md %directory%\!take_name!\meshes\
		
	Rem loop until 50 random models	
	call :more_to_process		

	Rem Read files and convert to .obj
	for %%f in (%directory%\!take_name!\meshes\*.mvx) do (
		.\XmlGraphRunner.exe "C:\ring_it\Graphs\xml6\dev\readTOobj.xml" ^
		--input "%directory%\!take_name!\meshes\%%~nf.mvx" ^
		--export "%directory%\!take_name!\meshes\%%~nf"
	)
)
endlocal
pause
exit /b

:more_to_process (
	for /f %%a in ('2^>nul dir "%directory%\!take_name!\meshes\*.mvx" /a-d/b/-o/-p/s^|find /v /c ""') do set count_until_now=%%a
		
	Rem If we dont have 50 processed files
	if !count_until_now! LSS 1 (
		Rem Get random frame number
		set /a frame_start=!maxval! - !minval! + 1
		set /a frame_start=!frame_start! * %RANDOM% / 32768 + !minval!"
		set /a frame_end=!frame_start!+1		

		Rem Do poisson
		.\XmlGraphRunner.exe ^
		"C:\ring_it\Graphs\xml6\06_joined_to_mesh_poission_runner.xml" ^
		--start !frame_start! --end !frame_end! ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\meshes\!take_name!_frame_!frame_start!.mvx"			
			
		call :more_to_process
	)
)
exit /b