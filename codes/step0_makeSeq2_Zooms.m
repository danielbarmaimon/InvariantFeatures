% clear workspace
clc; clear all; close all; format shortG
%axis tight, iptsetpref('ImshowBorder','tight')
%STEP 0, sequence 1


% Create the directory to save the output images
pathOut = 'sequence2';
if ~exist(pathOut, 'dir')
  mkdir(pathOut);
end

% load image
imOrig = imread('Image_base.jpg');
% required image size
reqSizeRow = 499; reqSizeCol = 749;

%prepare image position for projective transforms
imRows = size(imOrig, 1); imCols = size(imOrig, 2);
imCenRow = round(imRows./2); imCenCol = round(imCols./2);

%corner positions
imCornerRow1 = imCenRow-floor(reqSizeRow/2); 
imCornerRow2 = imCenRow+floor(reqSizeRow/2);

imCornerCol1 = imCenCol-floor(reqSizeCol/2);
imCornerCol2 = imCenCol+floor(reqSizeCol/2);

% window on which we going to work
imBRows = imCornerRow1:imCornerRow2;
imBCols = imCornerCol1:imCornerCol2;

%zoom scales
zoomArray = 1.1:0.05:1.5;
numOfTransforms = numel(zoomArray);

% initialize homographies output
Sequence2Homographies(1:numOfTransforms) = struct('H', []);

for ii=1:numOfTransforms
    % make current Homography matrix
    H = [zoomArray(ii) 0 0
         0 zoomArray(ii) 0
         0 0             1];
    % convert it to transform object
    zoomTrans = maketform('affine', H); 
    % apply transform to image
    imOutputFull = imtransform(imOrig,zoomTrans);
    % find output image center
    imOutRows = size(imOutputFull, 1); imOutCols = size(imOutputFull, 2);
    imOutCenRow = round(imOutRows./2); imOutCenCol = round(imOutCols./2);
    % find corner positions on ouput image
    imOutCornerRow1 = imOutCenRow-floor(reqSizeRow/2);
    imOutCornerRow2 = imOutCenRow+floor(reqSizeRow/2);

    imOutCornerCol1 = imOutCenCol-floor(reqSizeCol/2);
    imOutCornerCol2 = imOutCenCol+floor(reqSizeCol/2);
    
    % extract final output image from center
    imOutput = imOutputFull(imOutCornerRow1:imOutCornerRow2, imOutCornerCol1:imOutCornerCol2, :);
    % save homography to output structure
    Sequence2Homographies(ii).H = H;
    if ii<10
        imOutName = strcat('Image_0', num2str(ii),'a.png');
    else
        imOutName = strcat('Image_', num2str(ii),'a.png');
    end
    imwrite(imOutput, fullfile(pathOut, imOutName) );
end

imwrite(imOrig(imBRows, imBCols,: ), fullfile(pathOut, 'Image_00a.png') );
save(fullfile(pathOut, 'Sequence2Homographies.mat'), 'Sequence2Homographies');

