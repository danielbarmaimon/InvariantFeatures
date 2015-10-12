function point2dOut = project2Points(projectMat, point2dIn)
% project3to2 - function to project 2D points to 2D points
% using provided projection matrix
%
% Input: projectMat projection matrix of size 3x3
% Input: point3d - 2D points, in form of n x 2 matrix
    % bind vector of ones
    nPoints = size(point2dIn, 1);
    point2d1 = [point2dIn, ones(nPoints,1)];
    % project
    point2ds = projectMat*point2d1';
    %divide points by scale s
    point2dX = point2ds(1,:)./point2ds(3,:);
    point2dY = point2ds(2,:)./point2ds(3,:);
    % save final points
    point2dOut= [point2dX; point2dY]';
end