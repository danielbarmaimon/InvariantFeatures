% num = match(image1, image2)
%
% This function reads two images, finds their SIFT features, and
% returns matched keypoint positions

function [loc1, loc2] = getMatches(image1, image2)

% Find SIFT keypoints for each image
[~, des1, loc1] = sift(image1);
[~, des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
    distRatio = 0.6;   

    % For each descriptor in the first image, select its match to second image.
    des2t = des2';                          % Precompute matrix transpose
    disp('Finding matches...');
    
    for i = 1 : size(des1,1)
       dotprods = des1(i,:) * des2t;        % Computes vector of dot products
       [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

       % Check if nearest neighbor has angle less than distRatio times 2nd.
       if (vals(1) < distRatio * vals(2))
          match(i) = indx(1);
       else
          match(i) = 0;
       end
    end
    disp([ num2str(sum(match>0)) ' matches found.']);
    
% leave only matched points
loc1= loc1(match>0,:);
match = match(match>0);
loc2= loc2(match,:);
end




