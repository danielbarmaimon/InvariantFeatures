%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace 
% clear workspace
clc; clear all; close all; format shortG
% add path to sift demo
addpath('siftDemoV4');
addpath('functions');
run('VLFEATROOT/toolbox/vl_setup')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path of images
pathIm = 'Sequence1';
% image sequence index
noiseSequence = 'a';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read original image (reference image)
im1Name = fullfile(pathIm, 'Image_00a.png');
im1 = imread( im1Name);

im1 = single(rgb2gray(im1));
%%
% extract features of original image
[im1f, im1d] = vl_sift(im1);

%%
% transform indexes
transformArray = 1:16;
numOfTransforms = numel(transformArray);

% initialize values for thresholded distances
locPercent = zeros(1,numOfTransforms);


imageIndex =1;

    % form transformed image filename for reading
    if imageIndex<10
        im2FileName = strcat('Image_0', num2str(imageIndex), noiseSequence,'.png');
    else
        im2FileName = strcat('Image_', num2str(imageIndex), noiseSequence,'.png');
    end
    im2Name = fullfile(pathIm, im2FileName);
	
 


save(fullfile('output', strcat('estDist_',pathIm, '_', noiseSequence)), 'estDistAll');

figure(2), cla,  line(transformArray, locPercent)
set(gca,'XTick',transformArray), grid on

