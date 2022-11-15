@echo off
SETLOCAL EnableDelayedExpansion 

cd C:\ring_it\builds\MVAgent.05-09-2022_60ce56b.Windows.Release

set take_directory=C:\storage
set graph_directory=C:\Users\Civit\Desktop\process_demo\Graphs
set /a max_frames=400

Rem # Loop through takes #

for /f "tokens=1,2,3 delims=;" %%x in (C:\Users\Civit\Desktop\process_demo\violin_list.txt) do (
	
	echo --------------

	Rem Start of take
	set take_name=%%x
	set /a first_frame=%%y
	set /a frame_count=%%z
	
	Rem division and reminder to define batches
	set /a "d=(!frame_count!-!first_frame!) / !max_frames! - 1"
	set /a "r=(!frame_count!-!first_frame!) %% !max_frames!"	

	echo !take_name! !first_frame! !frame_count! !d! !r!
	md %take_directory%\!take_name!\meshes\
	
	Rem do in batcehs
	for /l %%a in (0, 1, !d!) do (
		set /a idx=%%a
		set /a first=!first_frame! + !idx!*!max_frames!
		set /a last=!first_frame! + !idx!*!max_frames! + !max_frames!

		echo Process from:!first! to:!last!
			   
		Rem Run poisson for this part
		.\XmlGraphRunner.exe ^
			"C:\ring_it\Graphs\xml6\06_joined_to_mesh_poission_runner.xml" ^
			--start !first! --end !last! ^
			--input "%take_directory%\!take_name!\!take_name!_joined.mvx" ^
			--output "%take_directory%\!take_name!\meshes\!take_name!_frames_!first!-!last!.mvx"
	)			
	
	Rem process remining frames
	set /a first=!last!
	set /a last=!last! + !r!
	echo Process from:!first! to:!last!
	.\XmlGraphRunner.exe ^
		"C:\ring_it\Graphs\xml6\06_joined_to_mesh_poission_runner.xml" ^
		--start !first! --end !last! ^
		--input "%take_directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%take_directory%\!take_name!\meshes\!take_name!_frames_!first!-!last!.mvx"	
)
echo --------------

endlocal
pause
exit /b