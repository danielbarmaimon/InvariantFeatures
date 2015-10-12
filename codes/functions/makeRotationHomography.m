function H = makeRotationHomography(xPos, yPos, rotDegree)
    % generates homography matrix for image transformation 
    % origin_x = x coordinate center of rotation (center of image)
    % origin_y = y coordinate center of rotation (center of image)
    % rotation in degree 0..360 clockwise

    H_trans = eye(3);
    H_rot = eye(3);

    H_trans(1,3) = -xPos;
    H_trans(2,3) = -yPos;

    H_rot(1,1) = cos(deg2rad(rotDegree));
    H_rot(2,2) = H_rot(1,1);
    H_rot(1,2) = sin(deg2rad(rotDegree));
    H_rot(2,1) = -H_rot(1,2);

    H = inv(H_trans) * H_rot * H_trans; % from right to left
end

