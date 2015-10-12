%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace 
% clear workspace
clc; clear all; close all; format shortG
% add path to sift demo
addpath('siftDemoV4');
addpath('functions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path of images
pathIm = 'Sequence3';
% image sequence index
%noiseSequence = 'a';
load paramNoiseSeq

% distance threshold
threshDist = 1; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load homographies
nameHomoObj = [pathIm, 'Homographies'];
load(fullfile(pathIm, [nameHomoObj, '.mat']) );
allHomographies = eval(nameHomoObj);
clear(nameHomoObj);

% read original image (reference image)
im1Name = fullfile(pathIm, 'Image_00a.png');
im1 = imread( im1Name);
% get original image size (for centering points)
im1SizeXY= [size(im1,2), size(im1,1)];
% taking floor half size for offset
im1SizeXYHalf = floor(im1SizeXY/2);

% extract features of original image
[~, im1d, im1l] = sift(im1Name);

%rot degrees
transformArray = [-45:5:-5, 5:5:45];
numOfTransforms = numel(transformArray);

% initialize values for thresholded distances
locPercent = zeros(1,numOfTransforms);

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
    % extract features of image im2
    [~, im2d, im2l] = sift(im2Name);

    % get matched locations of keypoints
    [loc1, loc2] = getMatches( im1d, im1l, im2d, im2l);
    numberOfMatches = size(loc1, 1);

    currentHomography = allHomographies(imageIndex).H;
    % take sift point coordinates
    pointIm1XY = loc1(:,2:-1:1);
    pointIm2XY = loc2(:,2:-1:1);
    % center points
    pointIm1XYCenter  = pointIm1XY - repmat(im1SizeXYHalf,  numberOfMatches, 1);
    %estimate and return back to same position
    pointIm2XYCenterEst = project2Points(currentHomography, pointIm1XYCenter);
    pointIm2XYEst = pointIm2XYCenterEst + repmat(im1SizeXYHalf,  size(loc1,1), 1);

     % compute Euclidean distance between original and estimated points
    estDiff = pointIm2XYEst- pointIm2XY;
    estDist = sqrt(estDiff(:,1).^2 + estDiff(:,2).^2);
    
    % save estimated distances
    estDistAll{imageIndex} = estDist;
    %print average distance
    disp(sprintf('Average dist: %.2f', mean(estDist)));
	
    % checking location threshold
    checkDist = (estDist < threshDist);
	% save in array
    locPercent(imageIndex) = sum(checkDist)/numberOfMatches;
	
	%estimate some points for plot
%     pointPlotIm1Cnt = [[0, 0]; [100 , 0]; [0 , 100]];
%     pointPlotIm2CntEst = project2Points(currentHomography, pointPlotIm1Cnt);
%     pointPlotIm1 = pointPlotIm1Cnt + repmat(im1SizeXYHalf,  3, 1);
%     pointPlotIm2Est = pointPlotIm2CntEst + repmat(im1SizeXYHalf,  3, 1);
% 
%     %plot some points
%     figure(1);
%     subplot(1,2,1), imshow(im1), hold on, plot(pointPlotIm1(1:3, 1), pointPlotIm1(1:3, 2), 'r*'), hold off;
%     title('GT image');
%     subplot(1,2,2), imshow(imread(im2Name)), hold on, plot(pointPlotIm2Est(1:3, 1), pointPlotIm2Est(1:3, 2), 'r*'), hold off;
%     title('Modified image');
end

save(fullfile('output', strcat('estDist_',pathIm, '_', noiseSequence)), 'estDistAll');
figure(2), cla,  line(transformArray, locPercent)
set(gca,'XTick',transformArray), grid on

