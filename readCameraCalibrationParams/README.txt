readCameraPositions.mat

Descripes how to read and work with camera positions

Data is saved into rotation matrix (R) and translation vector (t). Convert to transformation matrices (T) such as there are 4 matrices per module
Depth (or IR) is given in global coordinate frame and RGBs in corresponding depth camera's coordinate frame.
Torigo_to_depth (Module 1 is the origo) (Transformation to IR camera)
Tdepth_to_RGB1 
Tdepth_to_RGB2
Torigo_to_RGB1 = Torigo_to_depth * Tdepth_to_RGB1 ... etc.

% transform.txt: Describes transformation of specific module's IR camera (Torigo_to_depth)
% CameraParams_Primary.json: Transformations of RGB_1 in corresponding module's coordinate frame (in transform.txt) + other information
% CameraParams_Secondary.json: Transformation of RGB_2 in corresponding module's coordinate frame (in transform.txt) + other information