readCameraPositions.mat

Descripes how to read and work with camera positions

Data is saved into rotation matrix (R) and translation vector (t). Convert to transformation matrices (T) such as there are 4 matrices per module
Torigo_to_module (Module 1 is the origo) (Transformation to projector)
Tmodule_to_RGB1
Tmodule_to_RGB2
Tmodule_to_depth
Torigo_to_RGB1 = Torigo_to_module * Tmodule_to_RGB1 ... etc.

transform.txt: Describes transformation of specific module (or projector) (Torigo_to_module)
CameraParams_Primary.json: Transformations of RGB_1 and depth camera in corresponding module's coordinate frame (in transform.txt) + other information
CameraParams_Secondary.json: Transformation of RGB_2 in corresponding module's coordinate frame (in transform.txt) + other information