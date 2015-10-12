% This function reads two images, finds their VL_SIFT features, and
% returns matched keypoints

function [loc1, loc2] = getMatchesVL(im1Name, im2Name, geometry, binSize)
% read images and convert to single grayscale
im1 = imread(im1Name);
im1 = single(rgb2gray(im1));

im2 = imread(im2Name);
im2 = single(rgb2gray(im2));

% Find SIFT keypoints for each image
magnif = 1;

%   Each column of F is a feature frame and has the format [X;Y;S;TH], where X,Y
%   is the (fractional) center of the frame, S is the scale and TH is
%   the orientation (in radians).
im1Smooth = vl_imsmooth(im1, sqrt((binSize/magnif)^2 - .25)) ;
[~, d1] = vl_dsift(im1Smooth, 'Geometry', geometry, 'Size', binSize);

im2Smooth = vl_imsmooth(im2, sqrt((binSize/magnif)^2 - .25)) ;
[~, d2] = vl_dsift(im2Smooth, 'Geometry', geometry, 'Size', binSize);



% FIND matches
matches = vl_ubcmatch(d1, d2);

end




