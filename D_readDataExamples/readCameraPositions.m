% Data is saved into rotation matrix (R) and translation vector (t). Convert to transformation matrices (T) such as there are 4 matrices per module
% Depth (or IR) is given in global coordinate frame and RGBs in corresponding depth camera's coordinate frame.
% Torigo_to_depth (Module 1 is the origo) (Transformation to IR camera)
% Tdepth_to_RGB1 
% Tdepth_to_RGB2
% Torigo_to_RGB1 = Torigo_to_depth * Tdepth_to_RGB1 ... etc.

% transform.txt: Describes transformation of specific module's IR camera (Torigo_to_depth)
% CameraParams_Primary.json: Transformations of RGB_1 in corresponding module's coordinate frame (in transform.txt) + other information
% CameraParams_Secondary.json: Transformation of RGB_2 in corresponding module's coordinate frame (in transform.txt) + other information

% Path for pngs folder
path = "./before_plenoptima_transformations/pngs/"

%% Read transformations
for i=1:32

    % Cam 17 does not exist
    if i == 17
        continue
    end

    % Read IR camera transformations (RGBs are fixed to this)
    Torigo_to_depth(:,:,i) = readmatrix( strcat(path, num2str(i), "/transform.txt") );
    

    % Read RGB1 Transformation
    fid = fopen(strcat(path, num2str(i), "/CameraParams_Primary.json")); % Opening the file
    raw = fread(fid,inf); % Reading the contents
    str = char(raw'); % Transformation
    fclose(fid); % Closing the file
    data = jsondecode(str); % Using the jsondecode function to parse JSON from string
    % Add rotation and translation to Transformation matrix
    T = data.color.rotation;
    T(1:3,4) = data.color.translation;
    Tdepth_to_RGB1(:,:,i) = T;


    % Read RGB2 Transformation
    fid = fopen(strcat(path, num2str(i), "/CameraParams_Secondary.json")); % Opening the file
    raw = fread(fid,inf); % Reading the contents
    str = char(raw'); % Transformation
    fclose(fid); % Closing the file
    data = jsondecode(str); % Using the jsondecode function to parse JSON from string
    % Add rotation and translation to Transformation matrix
    T = data.color.rotation;
    T(1:3,4) = data.color.translation;
    Tdepth_to_RGB2(:,:,i) = T;

end


%% Calculate and save transformations from origo to every RGB camera

for i=1:32

    % Cam 17 does not exist
    if i == 17
        continue
    end

    % RGB1
    Torigo_to_RGB1(:,:,i) = Torigo_to_depth(:,:,i)*Tdepth_to_RGB1(:,:,i);
    t_RGB1(i,:) = Torigo_to_RGB1(1:3,4,i);

    % ... same for RGB2 ...
    Torigo_to_RGB2(:,:,i) = Torigo_to_depth(:,:,i)*Tdepth_to_RGB2(:,:,i);
    t_RGB2(i,:) = Torigo_to_RGB2(1:3,4,i);

    % ... and depth.
    t_depth(i,:) = Torigo_to_depth(1:3,4,i);

end

save('./outs/transformations.mat','Torigo_to_RGB1','Torigo_to_RGB2','Torigo_to_depth')

writematrix(t_RGB1,'./outs/RGB1_locations.txt','Delimiter',',')
writematrix(t_RGB2,'./outs/RGB2_locations.txt','Delimiter',',')
writematrix(t_depth,'./outs/depth_locations.txt','Delimiter',',')


%% Visualize camera locations and orientations
% Green dot: Global origo
% Red circle: 1 Depth/IR camera per module
% Blue circle: 2 RGB cameras per module

% Homogeneous end points of a vector that points from camera to the scene (+z-axis)
% Helps to visualize camera angles
line = [0,0;0,0;0,100;1,1];

% Bottom cylinder/floor is located "roughly" here TODO:read cylinder params to be exact
cylinder_origo = [1500,0,1000];
r = 2500/2;
teta = -pi:0.01:pi;
x = zeros(1,numel(teta)) + cylinder_origo(1);
y = r*cos(teta) + cylinder_origo(2);
z = r*sin(teta) + cylinder_origo(3);


figure;
hold on
axis equal
grid on

% Plot cam1 (Origo)
t = Torigo_to_depth(1:3,4,1);
plot3(t(1),t(2),t(3),"g.");

% Plot cylinder
plot3(cylinder_origo(1),cylinder_origo(2),cylinder_origo(3),"r.");
plot3(x,y,z,"r")

for i=1:32

    % Cam 17 does not exist
    if i == 17
        continue
    end
    
    % Cam of interest
    if i == 29
        plot3(t_depth(i,1),t_depth(i,2),t_depth(i,3),"r.",'MarkerSize', 20); % Cam center
    end
    
    % Rotate, translate and plot line from RGB1-coordinates to World-coordinates
    % Torigo_to_cam = Torigo_to_module * Tmodule_to_cam  ...  etc.
    transformed_line = Torigo_to_depth(:,:,i)*Tdepth_to_RGB1(:,:,i)*line;
    plot3(transformed_line(1,:),transformed_line(2,:),transformed_line(3,:), "b");
    plot3(t_RGB1(i,1),t_RGB1(i,2),t_RGB1(i,3),"bo"); % Cam center

    % ... same for RGB2 ...
    transformed_line = Torigo_to_depth(:,:,i)*Tdepth_to_RGB2(:,:,i)*line;
    plot3(transformed_line(1,:),transformed_line(2,:),transformed_line(3,:), "b");
    plot3(t_RGB2(i,1),t_RGB2(i,2),t_RGB2(i,3),"bo"); % Cam center

    % and for depth (also module origo).
    transformed_line = Torigo_to_depth(:,:,i)*line;
    plot3(transformed_line(1,:),transformed_line(2,:),transformed_line(3,:), "r");    
    plot3(t_depth(i,1),t_depth(i,2),t_depth(i,3),"ro"); % Cam center

end
drawnow();


%% Nuc 1 dists

td = zeros(3,1); % In module coordinate frame's origo

T1 = Tdepth_to_RGB1(:,:,1);
T2 = Tdepth_to_RGB2(:,:,1);
t1 = T1(1:3,4);
t2 = T2(1:3,4);

distance_between_RGBs = norm(t1-t2)
distance_between_depthRGB1 = norm(td-t1)
distance_between_depthRGB2 = norm(td-t2)


%% Nuc 16 dists

td = zeros(3,1); % In module coordinate frame's origo

T1 = Tdepth_to_RGB1(:,:,16);
T2 = Tdepth_to_RGB2(:,:,16);
t1 = T1(1:3,4);
t2 = T2(1:3,4);

distance_between_RGBs = norm(t1-t2)
distance_between_depthRGB1 = norm(td-t1)
distance_between_depthRGB2 = norm(td-t2)


%% Plenoptima: Distances between Nucs 1 and 30 

t_1_RGB1 = Torigo_to_RGB1(1:3,4,1);
t_30_RGB1 = Torigo_to_RGB1(1:3,4,30);

t_1_d = Torigo_to_depth(1:3,4,1);
t_30_d = Torigo_to_depth(1:3,4,30);

% Distance between RGB1s in Nucs 1 and 30
distance_between_RGBs = norm(t_1_RGB1 - t_30_RGB1)

% Distance between depths in Nucs 1 and 30
distance_between_depths = norm(t_1_d - t_30_d)

writematrix(distance_between_RGBs,'./outs/distance_Nuc1_Nuc30_RGB1.txt','Delimiter',',')
writematrix(distance_between_depths,'./outs/distance_Nuc1_Nuc30_depth.txt','Delimiter',',')
