TODO: Switch to ps

-------------------------------------------------

./run_one_frame.bat name_of_the_take

Processes quickly 1 frame in the demo session

Produces:
*_mesh.mvx
meshes\ .obj
plys\ .ply
pngs\ color.png
pngs\ depth.png
pngs\ calibration_parameters.txts

--------------------------------------------------

./run.bat name_of_the_take (-pngs 1/0 -plys 1/0 -ply 1/0 -mesh 1/0 -start 0-n -end -1-n)

./run.bat a20e515d-4971-11ed-b3b4-84144db0cd3f -pngs 0 -plys 1 -ply 0 -mesh 0 -start 368 -end 369

Processes quickly 1 frame in the demo session

Optional arguments - 1 process - 0 don't process:
-pngs: Images per camera in pngs\*_color.png, pngs\*_depth.png pngs\calibration_parameters.txts
-plys: Plys from each camera in plys\*.ply
-ply: One big ply per frame in ply\*.ply
-mesh: Does poisson and produces objs in meshes\*_.obj
-start: Process from index ... (default=0=first frame)
-end: ... to index (default=-1=last frame)
