Rem TODO: Switch to ps

@echo off

Rem update to latest build
cd C:\ring_it\builds\MVAgent.05-09-2022_60ce56b.Windows.Release

set directory=C:\storage
set graph_directory=C:\Users\Civit\Desktop\process_demo\Graphs
set take_directory=%directory%\%take_name%

set take_name=%1

if EXIST %take_directory%\%take_name%_joined.mvx (
	echo Process: %take_directory%\%take_name%_joined.mvx
) else (
	echo %take_directory%\%take_name%_joined.mvx ... DOES NOT EXIST
	GOTO End
)

Rem Produce RGBs for cam 16 in this take (2 pngs per camera)
.\XmlGraphRunner.exe "%graph_directory%\03_exportPNGs.xml" ^
	--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
	--output "%directory%\!take_name!\pngs" ^
	--end 1

Rem Produce plys
.\XmlGraphRunner.exe "%graph_directory%\04_exportPLYs.xml" ^
	--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
	--output "%directory%\!take_name!\plys\!take_name!" ^
	--end 1
	
Rem Produce 1 ply containing everything
.\XmlGraphRunner.exe "%graph_directory%\05_exportPLY.xml" ^
	--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
	--output "%directory%\!take_name!\plys\!take_name!" ^
	--end 1		

Rem Run poisson for first frame
.\XmlGraphRunner.exe "%graph_directory%\01_joined_to_mesh_poission_runner.xml" ^
	--start 0 ^
	--end 1 ^
	--input "%take_directory%\!take_name!_joined.mvx" ^
	--output "%take_directory%\!take_name!_mesh.mvx"		

Rem export .obj
.\XmlGraphRunner.exe "%graph_directory%\02_readTOobj.xml" ^
	--input "%take_directory%\!take_name!_mesh.mvx" ^
	--output "%take_directory%\meshes\!take_name!"

:End