%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace 
% clear workspace
clc; clear all; close all; format shortG
% add path to sift demo
addpath('siftDemoV4');
% path of images
pathIm = 'Sequence3';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% intialize values
% distance thresholds:
threshDist = 1.5; 

% image sequence index, image index
imageIndex = 1;
noiseSequence = 'a';

% load homographies
nameHomoObj = [pathIm, 'Homographies.mat'];
load(fullfile(pathIm, nameHomoObj) );
allHomographies = Sequence3Homographies;

% read original image (reference image)
im1Name = fullfile(pathIm, 'Image_00a.png');
im1 = imread( im1Name);
% get original image size (for centering points)
im1SizeXY= [size(im1,2), size(im1,1)];
im1SizeXYHalf = round(im1SizeXY/2);

%rot degrees
rotArray = [-45:5:-5, 5:5:45];
numOfTransforms = numel(rotArray);

% initialize values for threshold checking results
locPercent = zeros(1,numOfTransforms);

imageIndex =1

% form transformed image filename for reading
if imageIndex<10
    im2FileName = strcat('Image_0', num2str(imageIndex), noiseSequence,'.png');
else
    im2FileName = strcat('Image_', num2str(imageIndex), noiseSequence,'.png');
end
im2Name = fullfile(pathIm, im2FileName);
%%
% LOWE implementation
im = imread(im1Name);
im = single(rgb2gray(im)) ;
binSize = 3;
geometry = [4 4 8];
magnif= 3;
Is = vl_imsmooth(im, sqrt((binSize/magnif)^2 - .25)) ;
[f_l, d_l] = vl_dsift(Is, 'Geometry', geometry, ...
                        'Size', binSize, ...
                        'step', 1, ...
                        'floatdescriptors');

% OUR CUSTOM implementation
binSize = 4;
magnif = 3;
geometry = [4 4 8];
Is = vl_imsmooth(im, sqrt((binSize/magnif)^2 - .25)) ;
[f_o, d_o] = vl_dsift(Is, 'Geometry', geometry, 'Size', binSize) ;


VL_UBCMATCH(DESCR1, DESCR2) 