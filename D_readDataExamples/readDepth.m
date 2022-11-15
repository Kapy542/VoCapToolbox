% Depth image is uint16
% Every incease in value is 1mm in real world

imgs = ["./imgs/00000_DepthMap16bit.png"]

img = imread( imgs(1) );

m = mean(mean(img(img>0))) % Mean value
tl = img(1,1) 		       % Top left pixel (nonzero! Why?)
max_val = max(max(img))    % max value
min_val = min(min(img>0))  % min nonzero value

% img(1,1) = 0;

% imagesc-function automatically scales the values to color range
figure; imagesc(img)         
% With imshow-function scaling is necessary
figure;  imshow(double(img)/double(max_val)) 