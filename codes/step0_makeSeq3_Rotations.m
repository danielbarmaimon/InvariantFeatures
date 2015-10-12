% clear workspace
clc; clear all; close all; format shortG
%axis tight, iptsetpref('ImshowBorder','tight')
%STEP 0


% Create the directory to save the output images
pathOut = 'sequence3';
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

%rot degrees
rotArray = [-45:5:-5, 5:5:45];

numOfTransforms = numel(rotArray);
% initialize homographies output
Sequence3Homographies(1:numOfTransforms) = struct('H', []);

for ii=1:numOfTransforms
    % convert degrees to radians
    radRot = deg2rad(rotArray(ii));
    % make current Homography matrix
    H = [cos(radRot) -sin(radRot) 0; sin(radRot) cos(radRot) 0; 0 0 1];
    %%% slow way to rotate image, unused
    % tform = maketform('affine', [cos(radRot) -sin(radRot) 0; sin(radRot) cos(radRot) 0; 0 0 1]);
    % imOutputFull = imtransform(imOrig, tform);
    
    % rotating image in fast way
    % -1 is needed since imrote rotates by counterclockwise direction!!
    imOutputFull = imrotate(imOrig,-1*rotArray(ii));
    
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
    
    % output file name
    if ii<10
        imOutName = strcat('Image_0', num2str(ii),'a.png');
    else
        imOutName = strcat('Image_', num2str(ii),'a.png');
    end
    % save image
    imwrite(imOutput, fullfile(pathOut, imOutName) );
    % save homography to output structure
    Sequence3Homographies(ii).H = H;
end

imwrite(imOrig(imBRows, imBCols,: ), fullfile(pathOut, 'Image_00a.png') );
save(fullfile(pathOut, 'Sequence3Homographies.mat'), 'Sequence3Homographies');
