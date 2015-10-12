function distEst = getDistEstimate(pointIm1XY, pointIm2XY, Hmat)

    %estimate using homography
    pointIm2XYEst = project2Points(Hmat, pointIm1XY);

    % compute Euclidean distance between original and estimated points
    estDiff = pointIm2XYEst- pointIm2XY;
    distEst = sqrt(estDiff(:,1).^2 + estDiff(:,2).^2);

end