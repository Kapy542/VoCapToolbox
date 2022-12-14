Rem TODO: Switch to ps

@echo off

Rem Update to latest build
cd C:\ring_it\builds\MVAgent.05-09-2022_60ce56b.Windows.Release

set directory=C:\storage
set graph_directory=C:\Users\Civit\Desktop\process_demo\Graphs
set take_directory=%directory%\%take_name%

Rem Parse arguments --------- TODO: Argument error
set take_name=%1
set pngs=1
set plys=1
set ply=1
set mesh=1
set start=0
set end=-1
SHIFT

:loop
IF NOT "%1"=="" (
    IF "%1"=="-pngs" (
        SET pngs=%2
        SHIFT
    )
    IF "%1"=="-plys" (
        SET plys=%2
        SHIFT
    )
	IF "%1"=="-ply" (
        SET ply=%2
        SHIFT
    )
	IF "%1"=="-mesh" (
        SET mesh=%2
        SHIFT
    )
	IF "%1"=="-start" (
        SET start=%2
        SHIFT
    )
	IF "%1"=="-end" (
        SET end=%2
        SHIFT
    )
	SHIFT
    GOTO :loop
)
echo %take_name%
echo %pngs%
echo %plys%
echo %ply%
echo %mesh%
echo %start%
echo %end%
goto End
Rem -------------------------

if EXIST %take_directory%\%take_name%_joined.mvx (
	echo Process: %take_directory%\%take_name%_joined.mvx
) else (
	echo %take_directory%\%take_name%_joined.mvx ... DOES NOT EXIST
	GOTO End
)

if %pngs%=="1" (
	Rem Produce RGBs for cam 16 in this take (2 pngs per camera)
	.\XmlGraphRunner.exe "%graph_directory%\03_exportPNGs.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\pngs" ^
		--start %start% ^
		--end %end%
)

if %plys%=="1" (
	Rem Produce plys
	.\XmlGraphRunner.exe "%graph_directory%\04_exportPLYs.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\plys\!take_name!" ^
		--start %start% ^
		--end %end%
)

if %ply%=="1" (
	Rem Produce 1 ply containing everything
	.\XmlGraphRunner.exe "%graph_directory%\05_exportPLY.xml" ^
		--input "%directory%\!take_name!\!take_name!_joined.mvx" ^
		--output "%directory%\!take_name!\plys\!take_name!" ^
		--start %start% ^
		--end %end%		
)

if %mesh%=="1" (
	Rem Run poisson for first frame
	.\XmlGraphRunner.exe "%graph_directory%\01_joined_to_mesh_poission_runner.xml" ^
		--input "%take_directory%\!take_name!_joined.mvx" ^
		--output "%take_directory%\!take_name!_mesh.mvx" ^
		--start %start% ^
		--end %end%

	Rem export .obj
	.\XmlGraphRunner.exe "%graph_directory%\02_readTOobj.xml" ^
		--input "%take_directory%\!take_name!_mesh.mvx" ^
		--output "%take_directory%\meshes\!take_name!"
)

:End