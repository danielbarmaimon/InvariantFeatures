% clear workspace
clc; clear all; close all;

% path where are original images
pathIm = 'sequence3';

% get image names
imageNames = dir(fullfile(pathIm, '*a.png'));

for ii=1: numel(imageNames)
    % read orig image
    fileOrig = imageNames(ii).name;
    imOrig = imread(fullfile(pathIm, fileOrig));
    
    % mean m and variance v for noise
    m = 0; v1= (3/255)^2; v2= (6/255)^2; v3= (18/255)^2;

    
    % add noise to images
    imNoisy1 = imnoise( imOrig,'gaussian', m, v1);
    imNoisy2 = imnoise( imOrig,'gaussian', m, v2);
    imNoisy3 = imnoise( imOrig,'gaussian', m, v3);
    
    % create output file names
    fileOut1 = fileOrig;
    fileOut2 = fileOrig;
    fileOut3 = fileOrig;
    
    fileOut1(9) = 'b';
    fileOut2(9) = 'c';
    fileOut3(9) = 'd';
    
    %save images
    imwrite(imNoisy1, fullfile(pathIm, fileOut1));
    imwrite(imNoisy2, fullfile(pathIm, fileOut2));
    imwrite(imNoisy3, fullfile(pathIm, fileOut3));
end

