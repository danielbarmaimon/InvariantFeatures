function [imOutput, homoMat] = makeProjectiveHomography(imInput, udata, vdata, reqSizeRow, reqSizeCol, position, stretch)
% position = 'left', 'rigth', 'top', 'bottom'
% udata, vdata - two-element, real vectors that combined
% specifies the spatial location of image A in the 2-D input space U-V. 
% The two elements of 'UData' give the u-coordinates (horizontal) 
% of the first and last columns of A, respectively.

% stretch - offset in pixels
% position - offset direction
% imInput - big original image
% reqSizeRow, reqSizeCol - image size from big image imInput

    %corner positions
    imCornerCol1 = 1;
    imCornerCol2 = reqSizeCol;

    imCornerRow1 = 1; 
    imCornerRow2 = reqSizeRow;
    %input corners
    imInputPoints = [imCornerCol1 imCornerRow1
                     imCornerCol2 imCornerRow1
                     imCornerCol1 imCornerRow2
                     imCornerCol2 imCornerRow2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4 output cases
    if strcmp(position, 'top')
        imOutputPoints = [imCornerCol1+stretch imCornerRow1
                          imCornerCol2-stretch imCornerRow1
                          imCornerCol1 imCornerRow2
                          imCornerCol2 imCornerRow2];
    end
    if strcmp(position, 'bottom')
        imOutputPoints = [imCornerCol1 imCornerRow1
                          imCornerCol2 imCornerRow1
                          imCornerCol1+stretch imCornerRow2
                          imCornerCol2-stretch imCornerRow2];
    end
    if strcmp(position, 'left')
        imOutputPoints = [imCornerCol1 imCornerRow1+stretch
                          imCornerCol2 imCornerRow1
                          imCornerCol1 imCornerRow2-stretch
                          imCornerCol2 imCornerRow2];
    end
    if strcmp(position, 'right')
        imOutputPoints = [imCornerCol1 imCornerRow1
                          imCornerCol2 imCornerRow1+stretch
                          imCornerCol1 imCornerRow2
                          imCornerCol2 imCornerRow2-stretch];
    end
    %create transform
    prTransform = maketform('projective', imInputPoints, imOutputPoints);
    % make transformed image
    [imTransformed, xdata, ydata] = imtransform(imInput, prTransform,...
        'udata', udata, 'vdata', vdata, 'FillValues',0);

    % xdata -columns
    % ydata -rows
    
    % transformed corner positions
    imTrCornerRow1 = 1 - round(ydata(1));
    imTrCornerRow2 = reqSizeRow - round(ydata(1)); 

    imTrCornerCol1 = 1 - round(xdata(1));
    imTrCornerCol2 = reqSizeCol - round(xdata(1));
    
   % return results
   imOutput = imTransformed(imTrCornerRow1:imTrCornerRow2, ...
                            imTrCornerCol1:imTrCornerCol2, :);
   homoMat = prTransform.tdata.T';  
end