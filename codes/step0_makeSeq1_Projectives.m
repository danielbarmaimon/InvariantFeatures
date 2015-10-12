% clear workspace
clc; clear all; close all; format shortG
addpath('functions');
%axis tight, iptsetpref('ImshowBorder','tight')
%STEP 0, sequence 1

% Create the directory to save the output images
pathOut = 'sequence1';
if ~exist(pathOut, 'dir')
  mkdir(pathOut);
end

numOfHomographies = 16;
% initialize homographies output
Sequence1Homographies(1:numOfHomographies) = struct('H', []);

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

% column transform data
udata = [1, imCols] - imCornerCol1;
% row transform data
vdata = [1, imRows] - imCornerRow1;
%projective stretch

stretchArray = [25 50 75 100];
directions =  {'top'; 'bottom'; 'left'; 'right'};
%[imOutput, homoMat] = makeProjectiveHomography(imOrig(imBRows, :,: ), reqSizeRow, reqSizeCol, 'top', 100);
%[imOutput, homoMat] = makeProjectiveHomography(imOrig(:, imBCols,: ), reqSizeRow, reqSizeCol, 'right', 100);

for ii=1:numOfHomographies
    cIndexDirection = ceil(ii/4);
    cIndexStretch = mod(ii-1,4)+1;
    currentDirection = directions(cIndexDirection);
    currentStretch = stretchArray(cIndexStretch);

    [imOutput, homoMat] = makeProjectiveHomography(imOrig, udata, vdata, reqSizeRow, reqSizeCol, currentDirection, currentStretch);
    Sequence1Homographies(ii).H = homoMat;
    if ii<10
        imOutName = strcat('Image_0', num2str(ii),'a.png');
    else
        imOutName = strcat('Image_', num2str(ii),'a.png');
    end
    imwrite(imOutput, fullfile(pathOut, imOutName) );
end

imwrite(imOrig(imBRows, imBCols,: ), fullfile(pathOut, 'Image_00a.png') );
save(fullfile(pathOut, 'Sequence1Homographies.mat'), 'Sequence1Homographies');
