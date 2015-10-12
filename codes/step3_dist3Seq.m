%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace 
% clear workspace
clc; clear all; close all;
% add path to sift 
run('vlfeat/toolbox/vl_setup')
addpath('functions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path of images
pathIm = 'Sequence3';
% image sequence index
%noiseSequence = 'a';
%geometry = [4 4 8];
% posibility to load noiseSequence image sequence index from file
load paramNoiseSeq
load paramGeometry

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load homographies
nameHomoObj = [pathIm, 'Homographies'];
load(fullfile(pathIm, [nameHomoObj, '.mat']) );
allHomographies = eval(nameHomoObj);
clear(nameHomoObj);

% read original image (reference image)
im1Name = fullfile(pathIm, 'Image_00a.png');
im1 = imread( im1Name);
%convert to single grayscale
im1 = single(rgb2gray(im1));
% get original image size (for centering points)
im1SizeXY= [size(im1,2), size(im1,1)];
% taking floor half size for offset
im1SizeXYHalf = floor(im1SizeXY/2);

% setup descriptor Parameters
step = 7;
binSize = 4;
magnif = 1;

% smooth image
im1Smooth = vl_imsmooth(im1, sqrt((binSize/magnif)^2 - .25));
% extract features locations and descriptors
[im1l, im1d] = vl_dsift(im1Smooth, 'Geometry', geometry, 'Size', binSize, 'Step', step);

%rot degrees array
transformArray = [-45:5:-5, 5:5:45];
numOfTransforms = numel(transformArray);

imageIndex = 4;
for imageIndex =1:numOfTransforms

    % form transformed image filename for reading
    if imageIndex<10
        im2FileName = strcat('Image_0', num2str(imageIndex), noiseSequence,'.png');
    else
        im2FileName = strcat('Image_', num2str(imageIndex), noiseSequence,'.png');
    end
    im2Name = fullfile(pathIm, im2FileName);
	
    disp(sprintf('Working with: "%s" image, ii=%d/%d', im2Name, imageIndex, numOfTransforms));

    im2 = imread( im2Name);
    %convert to single grayscale
    im2 = single(rgb2gray(im2));
    
    % smooth image
    im2Smooth = vl_imsmooth(im2, sqrt((binSize/magnif)^2 - .25));
    % extract features locations and descriptors
    [im2l, im2d] = vl_dsift(im2Smooth, 'Geometry', geometry, 'Size', binSize, 'Step', step);
  
    disp(sprintf('Finding matches...'));
    % FIND matches, orig descriptor
    matchPos = vl_ubcmatch(im1d, im2d);
    numberOfMatches = size(matchPos,2);

    % get matched locations of keypoints, transpose
    loc1XY = im1l(:,matchPos(1,:))';
    loc2XY = im2l(:,matchPos(2,:))';
    % center points
    loc1XYC = loc1XY - repmat(im1SizeXYHalf,  numberOfMatches, 1);
	loc2XYC = loc2XY - repmat(im1SizeXYHalf,  numberOfMatches, 1);
    
    currentMatH = allHomographies(imageIndex).H;
    % estimate distances
    estDist = getDistEstimate(loc1XYC, loc2XYC, currentMatH);
    
    % save estimated distances
    estDistAll{imageIndex} = estDist;
    %print average distance
    disp(sprintf('Average dist orig: %.2f', mean(estDist)));
  
end

save(fullfile('output', strcat('estDist_',pathIm, '_', num2str(geometry, '%d'), '_', noiseSequence)), 'estDistAll');

